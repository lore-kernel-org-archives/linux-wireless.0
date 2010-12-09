Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:60501 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0LIQRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 11:17:32 -0500
Received: by bwz16 with SMTP id 16so2839291bwz.4
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 08:17:28 -0800 (PST)
Message-ID: <4D010114.5020604@gmail.com>
Date: Thu, 09 Dec 2010 17:17:24 +0100
From: Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org>	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>	 <4CE4D41F.1080005@kernel.org>	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>	 <4CE68AF4.8060507@kernel.org>	 <1290189452.3768.3.camel@jlt3.sipsolutions.net>	 <4CE6E430.6080804@candelatech.com>	 <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com>	 <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com>	 <4CFFCE47.8040305@candelatech.com>  <4D00E8E2.1030201@kernel.org> <1291905750.3540.14.camel@jlt3.sipsolutions.net> <4D00EBD8.4090805@kernel.org>
In-Reply-To: <4D00EBD8.4090805@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2010 03:46 PM, Tejun Heo wrote:
>> Right, so we're flushing here under RTNL ... I believe this is the one
>> that Ben hacked up to not flush or so?
> 
> He made it to cancel instead of flush.

This makes me think that it's more likely to be a problem in the
flush_work() implementation.  I went over the code carefully again but
couldn't find anything suspicious.  Plus, most of the implementation
is shared between cancel and flush.

I'm gonna write some test code and see whether the flush code behaves
as expected but in the mean time can you please apply the following
patch, trigger the problem and report the kernel log?  Also, please
include the sysrq task dump.  Let's see whether the worker is always
stuck at the same spot.

Thanks.

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..0ebc386 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -933,6 +933,10 @@ struct ieee80211_local {
 	struct net_device napi_dev;

 	struct napi_struct napi;
+
+	struct timer_list iface_work_timer;
+	unsigned long iface_work_tstmp;
+	unsigned int iface_work_runcnt;
 };

 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa8559..074d5bd 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -715,6 +715,14 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = free_netdev;
 }

+static void dbg_watchdog_timer(unsigned long __arg)
+{
+	struct ieee80211_local *local = (void *)__arg;
+
+	pr_warning("ieee80211_iface_work ran for > 5secs, processed %u\n",
+		   local->iface_work_runcnt);
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -738,10 +746,21 @@ static void ieee80211_iface_work(struct work_struct *work)
 		 "interface work scheduled while going to suspend\n"))
 		return;

+	local->iface_work_tstmp = jiffies;
+	local->iface_work_runcnt = 0;
+
+	init_timer(&local->iface_work_timer);
+	local->iface_work_timer.function = dbg_watchdog_timer;
+	local->iface_work_timer.data = (unsigned long)local;
+	local->iface_work_timer.expires = local->iface_work_tstmp + 5 * HZ;
+	add_timer(&local->iface_work_timer);
+
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;

+		local->iface_work_runcnt++;
+
 		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
 			ra_tid = (void *)&skb->cb;
 			ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra,
@@ -843,6 +862,12 @@ static void ieee80211_iface_work(struct work_struct *work)
 	default:
 		break;
 	}
+
+	del_timer_sync(&local->iface_work_timer);
+	if (time_after(jiffies, local->iface_work_tstmp + 4 * HZ))
+		pr_warning("iee80211_iface_work ran for %lu seconds, runcnt=%u\n",
+			   (jiffies - local->iface_work_tstmp) / HZ,
+			   local->iface_work_runcnt);
 }



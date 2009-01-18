Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57274 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835AbZARQFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 11:05:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 08:05:22 -0800
Date: Sun, 18 Jan 2009 08:04:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: do not TX injected frames when not allowed
Message-ID: <20090118160450.GX29609@tesla> (sfid-20090118_170528_497767_58ED7DD0)
References: <1232131932-25044-1-git-send-email-lrodriguez@atheros.com> <1232268339.3877.5.camel@johannes> <20090118153243.GU29609@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090118153243.GU29609@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 07:32:43AM -0800, Luis Rodriguez wrote:
> On Sun, Jan 18, 2009 at 12:45:39AM -0800, Johannes Berg wrote:
> > On Fri, 2009-01-16 at 10:52 -0800, Luis R. Rodriguez wrote:
> > > Monitor mode is able to TX by using injected frames. We should
> > > not allow injected frames to be sent unless allowed by regulatory rules.
> > > Since AP mode uses a monitor interfaces to transmit management frames
> > > we have to take care to not break AP mode as well. Since hostapd
> > > respects 'no-ibss|radar' flags we can make use of the same policy
> > > statically for checking when to disable injected frames. Once AP
> > > mode supports radar detection we should somehow distinguish a
> > > regular monitor mode from an AP's monitor interface.
> >
> > Any proposal for "somehow"? I'm not all that worried about packet
> > injection here.
> 
> I'll send a patch instead. Keep in mind by not applying this you are
> allowing devices to not respect regulatory rules.

How about a monitor flag? Although I am not sure where we'd use this
except if we'd want to change assumptions on regulatory rules for
the interface.

  Luis

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4e7a798..7f65d7e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -683,6 +683,8 @@ enum nl80211_reg_rule_flags {
  * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
  * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
  *	overrides all other flags.
+ * @NL80211_MNTR_FLAG_AP_MGT: this monitor interface is used for AP mode
+ * 	to be able to inject management frames.
  *
  * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
  * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
@@ -694,6 +696,7 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_CONTROL,
 	NL80211_MNTR_FLAG_OTHER_BSS,
 	NL80211_MNTR_FLAG_COOK_FRAMES,
+	NL80211_MNTR_FLAG_AP_MGT,
 
 	/* keep last */
 	__NL80211_MNTR_FLAG_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6bab7a1..4b85a20 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -255,6 +255,9 @@ struct station_info {
  * @MONITOR_FLAG_CONTROL: pass control frames
  * @MONITOR_FLAG_OTHER_BSS: disable BSSID filtering
  * @MONITOR_FLAG_COOK_FRAMES: report frames after processing
+ * @MONITOR_FLAG_AP_MGT: informs us this monitor interface is
+ *	used by an driver for AP mode to be able to inject management
+ * 	frames.
  */
 enum monitor_flags {
 	MONITOR_FLAG_FCSFAIL		= 1<<NL80211_MNTR_FLAG_FCSFAIL,
@@ -262,6 +265,7 @@ enum monitor_flags {
 	MONITOR_FLAG_CONTROL		= 1<<NL80211_MNTR_FLAG_CONTROL,
 	MONITOR_FLAG_OTHER_BSS		= 1<<NL80211_MNTR_FLAG_OTHER_BSS,
 	MONITOR_FLAG_COOK_FRAMES	= 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
+	MONITOR_FLAG_AP_MGT		= 1<<NL80211_MNTR_FLAG_AP_MGT,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2e7f9eb..90e276c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -533,6 +533,7 @@ static const struct nla_policy mntr_flags_policy[NL80211_MNTR_FLAG_MAX + 1] = {
 	[NL80211_MNTR_FLAG_CONTROL] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_OTHER_BSS] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_COOK_FRAMES] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_AP_MGT] = { .type = NLA_FLAG },
 };
 
 static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)

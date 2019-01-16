Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E11C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB92120657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389691AbfAPLLe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:11:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389685AbfAPLLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:11:34 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BEA3E2544;
        Wed, 16 Jan 2019 11:11:33 +0000 (UTC)
Received: from localhost (unknown [10.40.205.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA5FB5D779;
        Wed, 16 Jan 2019 11:11:32 +0000 (UTC)
Date:   Wed, 16 Jan 2019 12:11:31 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jeroen Roovers <jer@airfi.aero>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
Message-ID: <20190116111131.GA5234@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
 <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com>
 <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
 <20190109113320.GA15658@redhat.com>
 <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
 <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 16 Jan 2019 11:11:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2019 at 03:29:44PM +0100, Jeroen Roovers wrote:
> Aaaaaaand the results are in.
> 
> On Thu, 10 Jan 2019 at 08:49, Jeroen Roovers <jer@airfi.aero> wrote:
> >
> >      Hi Stanislaw,
> >
> > On Wed, 9 Jan 2019 at 12:33, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > > So would be below patch (on top of this set) be a solution for at
> > > least to not kill the kernel. Or we looking for something better
> > > i.e. watchdog ?
> >
> > I'll give it a spin. Thanks!
> 
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> kernel: [  500.782266] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x07 failed for offset 0x6888 with error -110
> kernel: [  500.912237] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x6888 with error -110
> kernel: [  501.042235] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x6110 with error -110
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> kernel: [  501.772201] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x07 failed for offset 0x1018 with error -110
> kernel: [  501.902177] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x1018 with error -110
> kernel: [  501.972186] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x1910 with error -110
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> 
> rt2x00usb_check_usb_error in your patch is set to
> clearDEVICE_STATE_PRESENT after ten errors, but in this case only 6
> errors were seen. Maybe I should set it to 1 as I have never seen an
> RT5592 recover from this.

I know cases where we have only single USB error and device work after
that. But if I remember correctly it was only for EPROTO not ETIMEDOUT.

> The system remained relatively stable until after I tried forcibly
> removing and then loading the rt2800usb module. A simple `ifconfig`
> then triggered a kernel panic. Sadly I couldn't capture it in time but
> I did spot that more phyN (up to phy4) devices had been added.

Apparently we should not crash and that should be fixed, but without
logs there is nothing we can do.

Let try to attack problem from other side. RT5592 mises TSSI
calibration, so perhaps device overheat for you because of that.
Please apply attached patch which fixes txpower setting in mac80211
then set some low txpower value i.e:

iw dev wlan0 set txpower fixed 1500

and check if device still stop working with USB errors.

Regards
Stanislaw


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mac80211_fix_set_txpower_for_no_chanctx.patch"

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 818aa0060349..ca513e94be9e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2415,6 +2415,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	bool update_txp_type = false;
 	bool has_monitor = false;
 
+	printk("%s mbm %d\n", __func__, mbm);
+
 	if (wdev) {
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3a0171a65db3..022874bf49f3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -49,19 +49,23 @@ static void ieee80211_iface_work(struct work_struct *work);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int power;
 
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
+	if (local->use_chanctx) {
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf) {
+			rcu_read_unlock();
+			return false;
+		}
+		power = ieee80211_chandef_max_power(&chanctx_conf->def);
 		rcu_read_unlock();
-		return false;
+	} else {
+		power = ieee80211_chandef_max_power(&local->hw.conf.chandef);
 	}
 
-	power = ieee80211_chandef_max_power(&chanctx_conf->def);
-	rcu_read_unlock();
-
 	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
 		power = min(power, sdata->user_power_level);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7b8320d4a8e4..6005c5e09be6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -144,10 +144,14 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
-			continue;
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
+		if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+			power = min(power, sdata->user_power_level);
+		if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
+			power = min(power, sdata->ap_power_level);
+		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
+			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
 	}
 	rcu_read_unlock();

--GvXjxJ+pjyke8COw--

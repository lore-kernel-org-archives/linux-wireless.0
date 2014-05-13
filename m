Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41017 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760468AbaEMKlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 06:41:14 -0400
Date: Tue, 13 May 2014 16:11:43 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: David Herrmann <dh.herrmann@gmail.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
Message-ID: <20140513104141.GA14670@qca.qualcomm.com> (sfid-20140513_124124_230082_DF98A505)
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
 <20140507195435.GF20432@tuxdriver.com>
 <536A9479.8010201@openwrt.org>
 <20140512174910.GM17022@tuxdriver.com>
 <53711646.1030909@openwrt.org>
 <CANq1E4Seak3MoBVdQTV7afFHQWmir14DJCQe_knjhC8szp4EhA@mail.gmail.com>
 <20140513090056.GA31546@qca.qualcomm.com>
 <CANq1E4QY+mSeMJx0ctWvAdmrsONCFaD+6268HnuowMKOM2FdFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
In-Reply-To: <CANq1E4QY+mSeMJx0ctWvAdmrsONCFaD+6268HnuowMKOM2FdFQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, May 13, 2014 at 11:09:48AM +0200, David Herrmann wrote:
> Hi
> 
> On Tue, May 13, 2014 at 11:00 AM, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
> > On Tue, May 13, 2014 at 08:50:00AM +0200, David Herrmann wrote:
> >> Hi
> >>
> >> On Mon, May 12, 2014 at 8:43 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> > I looked into it again, the scenario where I assumed that this problem
> >> > could occur didn't turn out to be true. I have no idea how this crash
> >> > can occur.
> >>
> >> The only path that can set ah->caldata to NULL is through:
> >>
> >> ieee80211_hw_config()
> >>   ath9k_htc_config()
> >>     ath9k_htc_set_channel()
> >>       ath9k_hw_reset()
> >>
> >> This happens whenever IEEE80211_CONF_OFFCHANNEL is set.
> >>
> >> Now mac80211 is way to big for me to review right now and
> >> ieee80211_hw_config() is used quite often. Given that the described
> >> call-path does no synchronization against ath9k_htc_ani_work(), all
> >> the callers of mac80211_hw_config(OFFCHANNEL) must guarantee that no
> >> ani-work is running. Is that intentional? I cannot see any of those
> >> functions calling into ath9k_htc_stop_ani(). This might of course be
> >> implicit.
> >>
> >> One call-path I see is:
> >> ieee80211_scan_cancel()
> >>   cancel_delayed_work()
> >>
> >> We cannot use cancel_delayed_work_sync() here due to locking issues.
> >> However, this obviously races against any following
> >> set_channel(OFFCHANNEL) request.
> >>
> >> If there's anything I can do to debug this, let me know. I tried
> >> adding some printk()'s into the hot-path and it turns out to no longer
> >> fail then. So this really seems to be a quite small race (given that a
> >> bunch of simple printk()s is slow enough to work around it).
> >
> > David,
> >
> > Are you using USB devices? What is the PID/VID? I have not looked at
> > HTC driver perspective.
> 
> Yes, I'm using the htc driver. I thought that was clear by pointing at
> ar9002, but I was wrong, sorry. lsusb information is:
>   'Bus 003 Device 056: ID 0411:017f BUFFALO INC. (formerly MelCo.,
> Inc.) Sony UWA-BR100 802.11abgn Wireless Adapter [Atheros
> AR7010+AR9280]'
>
Unlike ath9k driver, the ani work is stopped in sw_scan_start callback
for htc driver. So during scan process, ani work is stopped well before
calling set_channel. But in case of p2p_listen operation, set_channel can be
called by sw_roc without stopping ani.

Can you please test with attached change?

-Rajkumar

--fdj2RfSjLxBAspz7
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment; filename="ani.patch"

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f46cd02..5627917 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -95,8 +95,10 @@ static void ath9k_htc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	if ((vif->type == NL80211_IFTYPE_AP ||
 	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
-	    bss_conf->enable_beacon)
+	    bss_conf->enable_beacon) {
 		priv->reconfig_beacon = true;
+		priv->rearm_ani = true;
+	}
 
 	if (bss_conf->assoc) {
 		priv->rearm_ani = true;
@@ -257,6 +259,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	ath9k_htc_ps_wakeup(priv);
 
+	ath9k_htc_stop_ani(priv);
 	del_timer_sync(&priv->tx.cleanup_timer);
 	ath9k_htc_tx_drain(priv);
 

--fdj2RfSjLxBAspz7--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64895 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAFSCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 13:02:47 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so3140091wid.17
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 10:02:45 -0800 (PST)
Date: Mon, 6 Jan 2014 19:01:50 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
Message-ID: <20140106180150.GB5358@magnum.frso.rivierawaves.com> (sfid-20140106_190251_029751_C04F683A)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
 <874n67eabn.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <874n67eabn.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 06:01:00PM +0200, Kalle Valo wrote:
> Karl Beldan <karl.beldan@gmail.com> writes:
> 
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> >
> > This assigns the channel_switch_beacon op.
> > For hwsim, it comes down to calling ieee80211_csa_finish once
> > ieee80211_csa_is_complete is true.
> > Since channel_switch_beacon is not called if CSA count starts @ 0 or 1,
> > the check for ieee80211_csa_is_complete can be done after getting the
> > beacon (and this way it might trigger helpful warnings).
> >
> > This adds a per vif bool csa_finished that is set after a call to
> > ieee80211_csa_finish() and used to skip beaconing while csa_active is
> > set in case a beacon is scheduled prior to csa_finalize_work completion.
> > This bool and the number of beacons transmitted during the CSA up to the
> > call to ieee80211_csa_finish() are reset in channel_switch_beacon op.
> >
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> 
> What are we going to do with this patch? It would be convenient to get
> hwsim support CSA as it would help working with DFS issues.
> 
> Was the issue blocking this patch the race when transmitting beacons?
> IMHO we can live with that and fix it properly later. It's not the only
> bug in DFS code right now ;)
> 

Hi,

Sorry for the delay.
I am under the impression ppl who have expressed themselves would
prefer something like: {{{

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9c0cc8d..b76de14 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -169,6 +169,8 @@ struct hwsim_vif_priv {
 	bool assoc;
 	bool bcn_en;
 	u16 aid;
+	int csa_bcn_cnt;
+	bool csa_finished;
 };
 
 #define HWSIM_VIF_MAGIC	0x69537748
@@ -1032,6 +1034,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct mac80211_hwsim_data *data = arg;
 	struct ieee80211_hw *hw = data->hw;
 	struct ieee80211_tx_info *info;
@@ -1066,6 +1069,19 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
+
+	if (vif->csa_active) {
+		vp->csa_bcn_cnt++;
+		if (vp->csa_finished) {
+			wiphy_debug(hw->wiphy,"%s extra CSA-beacon\n", __func__);
+		} else if (ieee80211_csa_is_complete(vif)) {
+			wiphy_debug(hw->wiphy,
+				    "%s CSA complete after %d beacons\n",
+				    __func__, vp->csa_bcn_cnt);
+			ieee80211_csa_finish(vif);
+			vp->csa_finished = true;
+		}
+	}
 }
 
 static enum hrtimer_restart
@@ -1700,6 +1716,20 @@ static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	hwsim_check_chanctx_magic(ctx);
 }
 
+static void mac80211_hwsim_channel_switch_beacon(struct ieee80211_hw *hw,
+						 struct ieee80211_vif *vif,
+						 struct cfg80211_chan_def *chandef)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
+	hwsim_check_magic(vif);
+	vp->csa_finished = false;
+	vp->csa_bcn_cnt = 0;
+	wiphy_debug(hw->wiphy, "%s (freq=%d(%d - %d)/%s)\n", __func__,
+		    chandef->chan->center_freq, chandef->center_freq1,
+		    chandef->center_freq2, hwsim_chanwidths[chandef->width]);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -1724,6 +1754,7 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.flush = mac80211_hwsim_flush,
 	.get_tsf = mac80211_hwsim_get_tsf,
 	.set_tsf = mac80211_hwsim_set_tsf,
+	.channel_switch_beacon = mac80211_hwsim_channel_switch_beacon,
 };
 
 
@@ -2366,7 +2397,9 @@ static int __init init_mac80211_hwsim(void)
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-				    WIPHY_FLAG_AP_UAPSD;
+				    WIPHY_FLAG_AP_UAPSD |
+				    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
 		hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
 		/* ask mac80211 to reserve space for magic */
}}}

I understand having this is convenient for DFS so feel free to
adjust/submit this patch as you see fit.


> > @@ -1058,6 +1067,17 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
> >  
> >  	mac80211_hwsim_tx_frame(hw, skb,
> >  				rcu_dereference(vif->chanctx_conf)->def.chan);
> > +
> > +	if (vif->csa_active) {
> > +		vp->csa_bcn_cnt++;
> > +		if (ieee80211_csa_is_complete(vif)) {
> > +			wiphy_debug(hw->wiphy,
> > +				    "%s CSA complete after %d beacons\n",
> > +				    __func__, vp->csa_bcn_cnt);
> > +			ieee80211_csa_finish(vif);
> > +			vp->csa_finished = 1;
> > +		}
> > +	}
> 
> csa_finished is a bool so 'true' should be used here.
> 
Thanks,
 
Karl

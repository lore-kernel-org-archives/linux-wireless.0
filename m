Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab0CPAi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 20:38:59 -0400
Date: Mon, 15 Mar 2010 20:38:56 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
Message-ID: <20100316003856.GL8069@bombadil.infradead.org>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com> <20100315214338.GB4000@tux> <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com> <20100315234909.GA2662@tux> <4B9EC85B.8070800@openwrt.org> <43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com> <4B9ECB3E.3010802@openwrt.org> <43e72e891003151709r42745e27q6e42c131d202a4cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e891003151709r42745e27q6e42c131d202a4cb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 05:09:04PM -0700, Luis R. Rodriguez wrote:
> On Mon, Mar 15, 2010 at 5:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> > On 2010-03-16 12:55 AM, Luis R. Rodriguez wrote:
> >> On Mon, Mar 15, 2010 at 4:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> >>> On 2010-03-16 12:49 AM, Luis R. Rodriguez wrote:
> >>>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> >>>> index 00570fb..867cfaf 100644
> >>>> --- a/drivers/net/wireless/ath/ath9k/hw.c
> >>>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> >>>> @@ -807,6 +804,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
> >>>>               acktimeout += 64 - sifstime - ah->slottime;
> >>>>
> >>>>       ath9k_hw_setslottime(ah, slottime);
> >>>> +
> >>>> +     if (AR_SREV_9271(ah))
> >>>> +             return;
> >>>> +
> >>>>       ath9k_hw_set_ack_timeout(ah, acktimeout);
> >>>>       ath9k_hw_set_cts_timeout(ah, acktimeout);
> >>>>       if (ah->globaltxtimeout != (u32) -1)
> >>>
> >>> Why leave out the ACK/CTS timeout setting? How does the hw handle ACK
> >>> and CTS timeouts?
> >>
> >> Right, so that's why I originally removed this hunk completely, I was
> >> under the impression you latest fix would have addressed any issues
> >> but it does not, we get association time outs. I think we'll have to
> >> review this further in order to support coverage class.
> > Are you sure the slot time was set properly by the callback?
> 
> Well ath9k_htc did not have it implemented, I just added the code for
> it, you know what.. I did not test modifying the ACK/CTS timeout *and*
> with the new slot time code I added to ath9k_htc, let me try that.

Hah, yeah that fixed this work around, it works fine with the below
patch, I went ahead and added the coverage class calllback while
at it.

John this means I don't have to resend this series out, we can just
skip patch #4, that's all. I'll do one more review with our team and
get back to you on a final ACK for this series.

Sujith, please review and consider integration of the below changes
on the ath9k_htc front.

  Luis

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 3b4c636..e501599 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1438,6 +1438,14 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_beacon_config(priv, vif, bss_conf);
 	}
 
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (bss_conf->use_short_slot)
+			ah->slottime = 9;
+		else
+			ah->slottime = 20;
+		ath9k_hw_init_global_settings(ah);
+	}
+
 	if (changed & BSS_CHANGED_BEACON)
 		ath9k_htc_beacon_update(priv, vif);
 
@@ -1567,6 +1575,18 @@ static int ath9k_htc_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return 0;
 }
 
+static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
+					 u8 coverage_class)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+
+	mutex_lock(&priv->mutex);
+	ah->coverage_class = coverage_class;
+	ath9k_hw_init_global_settings(ah);
+	mutex_unlock(&priv->mutex);
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1587,4 +1607,5 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.sw_scan_complete   = ath9k_htc_sw_scan_complete,
 	.set_rts_threshold  = ath9k_htc_set_rts_threshold,
 	.rfkill_poll        = ath9k_htc_rfkill_poll_state,
+	.set_coverage_class = ath9k_htc_set_coverage_class,
 };

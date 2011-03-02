Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab1CBJSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:18:45 -0500
Subject: Re: [PATCH] hostapd: Don't force HT Mixed Mode for non-GF STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: hostap@lists.shmoo.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201103021013.05798.helmut.schaa@googlemail.com>
References: <1299055031-25080-1-git-send-email-helmut.schaa@googlemail.com>
	 <201103020953.17701.helmut.schaa@googlemail.com>
	 <1299056258.4076.8.camel@jlt3.sipsolutions.net>
	 <201103021013.05798.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 10:18:41 +0100
Message-ID: <1299057521.4076.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 10:13 +0100, Helmut Schaa wrote:

> iwlwifi/iwllegacy seems correct (as long as the fw is doing the right thing):
> 
> 560 void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
> 561                              struct ieee80211_vif *vif,
> 562                              struct ieee80211_bss_conf *bss_conf,
> 563                              u32 changes)
> 564 {
> ...
> 608                 ctx->ht.protection = bss_conf->ht_operation_mode &
> 609                                         IEEE80211_HT_OP_MODE_PROTECTION;
> 610                 ctx->ht.non_gf_sta_present = !!(bss_conf->ht_operation_mode &
> 611                                         IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);

Well, you forgot to quote this from iwl-agn-rs.c:

static bool rs_use_green(struct ieee80211_sta *sta)
{
        struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;   
        struct iwl_rxon_context *ctx = sta_priv->common.ctx;
  
        return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
                !(ctx->ht.non_gf_sta_present);
} 

But it looks like it's doing the right thing.

johannes


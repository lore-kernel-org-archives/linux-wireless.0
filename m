Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36963 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab1CBJWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:22:34 -0500
Received: by bwz15 with SMTP id 15so5394256bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 01:22:33 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] hostapd: Don't force HT Mixed Mode for non-GF STAs
Date: Wed, 2 Mar 2011 10:20:54 +0100
Cc: hostap@lists.shmoo.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
References: <1299055031-25080-1-git-send-email-helmut.schaa@googlemail.com> <201103021013.05798.helmut.schaa@googlemail.com> <1299057521.4076.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1299057521.4076.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103021020.54806.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 2. März 2011 schrieb Johannes Berg:
> On Wed, 2011-03-02 at 10:13 +0100, Helmut Schaa wrote:
> 
> > iwlwifi/iwllegacy seems correct (as long as the fw is doing the right thing):
> > 
> > 560 void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
> > 561                              struct ieee80211_vif *vif,
> > 562                              struct ieee80211_bss_conf *bss_conf,
> > 563                              u32 changes)
> > 564 {
> > ...
> > 608                 ctx->ht.protection = bss_conf->ht_operation_mode &
> > 609                                         IEEE80211_HT_OP_MODE_PROTECTION;
> > 610                 ctx->ht.non_gf_sta_present = !!(bss_conf->ht_operation_mode &
> > 611                                         IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
> 
> Well, you forgot to quote this from iwl-agn-rs.c:
> 
> static bool rs_use_green(struct ieee80211_sta *sta)
> {
>         struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;   
>         struct iwl_rxon_context *ctx = sta_priv->common.ctx;
>   
>         return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
>                 !(ctx->ht.non_gf_sta_present);
> } 

Hmm, that looks a bit fishy as well. iwlagn should be allowed to use GF
in that case, it just needs to protect it.

> But it looks like it's doing the right thing.

>From a protection POV, yes.

Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1CBJOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:14:49 -0500
Received: by fxm17 with SMTP id 17so5687125fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 01:14:48 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] hostapd: Don't force HT Mixed Mode for non-GF STAs
Date: Wed, 2 Mar 2011 10:13:05 +0100
Cc: hostap@lists.shmoo.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
References: <1299055031-25080-1-git-send-email-helmut.schaa@googlemail.com> <201103020953.17701.helmut.schaa@googlemail.com> <1299056258.4076.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1299056258.4076.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103021013.05798.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC'ing linux-wireless

Am Mittwoch, 2. März 2011 schrieb Johannes Berg:
> On Wed, 2011-03-02 at 09:53 +0100, Helmut Schaa wrote:
> > Am Mittwoch, 2. März 2011 schrieb Johannes Berg:
> > > On Wed, 2011-03-02 at 09:37 +0100, Helmut Schaa wrote:
> > > > Currently hostapd will force HT Mixed Mode if at least one non-GF STA is
> > > > associated. This will force _all_ HT transmissions to be protected.
> > > > 
> > > > 802.11n-2009 doesn't require HT Mixed Mode to be used in case of non-GF
> > > > STAs but instead the HT information element contains a flag if non-GF
> > > > STAs are present. All STAs are required to protect GF transmissions in
> > > > that case. Hence, setting HT Mixed mode if non-GF STAs are present is
> > > > superfluous.
> > > 
> > > It seems like this would still be relevant for the AP's TX?
> > 
> > Why? hostapd will configure the new ht_opmode (including the non-GF-STA flag)
> > to the driver. And the driver should do the right thing and enable protection only
> > for GF transmissions in that case, no?

Ok, doing a quick grep through drivers/net/wireless/*:


wl1271 doesn't honor this flag right now but seems trivial to fix:

1347 int wl1271_acx_set_ht_information(struct wl1271 *wl,
1348                                    u16 ht_operation_mode)
1349 {
...
1361         acx->ht_protection =
1362                 (u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
1363         acx->rifs_mode = 0;
1364         acx->gf_protection = 0;
1365         acx->ht_tx_burst_limit = 0;
1366         acx->dual_cts_protection = 0;


rt2800 does the right thing:

1240 static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,                    
1241                                     struct rt2x00lib_erp *erp)                       
1242 {
1243         bool any_sta_nongf = !!(erp->ht_opmode &
1244                                 IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);   
...
1310         /* check for STAs not supporting greenfield mode */
1311         if (any_sta_nongf)
1312                 gf20_mode = gf40_mode = 2;


mwl8k also doesn't honor it, no idea how to fix it:

2603 static int
2604 mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
2605                   struct ieee80211_vif *vif, u32 legacy_rate_mask)
2606 {
...
2623                 switch (vif->bss_conf.ht_operation_mode &
2624                         IEEE80211_HT_OP_MODE_PROTECTION) {
2625                 case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
2626                         prot_mode = MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY;
2627                         break;
2628                 case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
2629                         prot_mode = MWL8K_FRAME_PROT_11N_HT_ALL;
2630                         break;
2631                 default:
2632                         prot_mode = MWL8K_FRAME_PROT_DISABLED;
2633                         break;
2634                 }
2635         }
2636         cmd->protection_mode = cpu_to_le16(prot_mode);


iwlwifi/iwllegacy seems correct (as long as the fw is doing the right thing):

560 void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
561                              struct ieee80211_vif *vif,
562                              struct ieee80211_bss_conf *bss_conf,
563                              u32 changes)
564 {
...
608                 ctx->ht.protection = bss_conf->ht_operation_mode &
609                                         IEEE80211_HT_OP_MODE_PROTECTION;
610                 ctx->ht.non_gf_sta_present = !!(bss_conf->ht_operation_mode &
611                                         IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
612                 iwlagn_check_needed_chains(priv, ctx, bss_conf);
613                 iwl_set_rxon_ht(priv, &priv->current_ht_config);



Helmut

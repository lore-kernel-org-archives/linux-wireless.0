Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:44463 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaAGK2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 05:28:50 -0500
Received: by mail-we0-f182.google.com with SMTP id q59so17000513wes.13
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 02:28:46 -0800 (PST)
Date: Tue, 7 Jan 2014 11:27:46 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state
 machine
Message-ID: <20140107102746.GA20561@magnum.frso.rivierawaves.com> (sfid-20140107_112901_042626_4DBF3C33)
References: <529CF2D6.1080008@gmail.com>
 <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
 <20140106150716.GA5358@magnum.frso.rivierawaves.com>
 <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
In-Reply-To: <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Jan 06, 2014 at 08:04:03PM +0200, Eyal Shapira wrote:
> On Mon, Jan 6, 2014 at 5:07 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> > On Mon, Dec 02, 2013 at 10:59:24PM +0200, Emmanuel Grumbach wrote:
> >> From: Eyal Shapira <eyal@wizery.com>
> >>
> >> Rewrite the search cycle state machine to use a more data
> >> oriented approach where the different Tx columns (configs)
> >> limitations and next columns to search are reprsented in
> >> tables which are easy to change. This overhaul also includes
> >> several major fixes:
> >>
> >> 1. Prevent going back to a specific Tx column in a search
> >> cycle if it was already explored.
> >>
> >> 2. Avoid switching to a Tx column that doesn't have any chance
> >> if it performs perfectly to beat the current throughput we're
> >> getting.
> >>
> >> These issues were degrading throughput as they were causing
> >> switching to "bad" Tx columns.
> >>
> >> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> >> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >> ---
> >>  drivers/net/wireless/iwlwifi/mvm/rs.c |  921 +++++++++++++++------------------
> >>  drivers/net/wireless/iwlwifi/mvm/rs.h |   64 +--
> >>  2 files changed, 458 insertions(+), 527 deletions(-)
> >>
> >> @@ -1772,7 +1712,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
> > [...]
> >> -     if (done_search && !lq_sta->stay_in_tbl) {
> >> +     if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
> >>               /* If the "active" (non-search) mode was legacy,
> > [...]
> >
> > Hi,
> >
> > Trying -testing right now on my laptop and this commit broke aggregation.
> >
> 
> Thanks Karl for the report.
> I'm seeing Tx aggregation. Note that it doesn't start off immediately
> but only after enough traffic went through for us to explore different
> Tx configurations.
> 
> Some questions:
> 1. How do you see aggregation is broken ? sniffer or just lower
> throughput you're getting ?
It doesn't send any addBA action frame and traffic is not aggregated.

> 2. What's the chip ?
AC 7260, REV=0x144

> 3. Do you connect in 11n or 11ac ?
Tried both

> 4. Any chance you can set module parameter debug=0x04100000 and send the logs ?
> Configuring IWLWIFI_DEBUG is required.
Here you are. 

 
Karl

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="iwlwifi-11n-5180_40MHz.txt"

Jan  7 11:16:59 magnum kernel: [82719.667574] Intel(R) Wireless WiFi driver for Linux, in-tree:d
Jan  7 11:16:59 magnum kernel: [82719.667580] Copyright(c) 2003- 2014 Intel Corporation
Jan  7 11:16:59 magnum kernel: [82719.667887] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
Jan  7 11:16:59 magnum kernel: [82719.668546] iwlwifi 0000:02:00.0: loaded firmware version 22.15.8.0 op_mode iwlmvm
Jan  7 11:16:59 magnum kernel: [82719.679949] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
Jan  7 11:16:59 magnum kernel: [82719.680026] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:16:59 magnum kernel: [82719.680207] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:16:59 magnum kernel: [82719.884719] ieee80211 phy8: Selected rate control algorithm 'iwl-mvm-rs'
Jan  7 11:17:26 magnum kernel: [82719.658547] waiting module removal not supported: please upgrade
Jan  7 11:17:26 magnum kernel: [82746.736646] waiting module removal not supported: please upgrade<6>[82746.870666] Intel(R) Wireless WiFi driver for Linux, in-tree:d
Jan  7 11:17:26 magnum kernel: [82746.870673] Copyright(c) 2003- 2014 Intel Corporation
Jan  7 11:17:26 magnum kernel: [82746.871001] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
Jan  7 11:17:26 magnum kernel: [82746.871805] iwlwifi 0000:02:00.0: loaded firmware version 22.15.8.0 op_mode iwlmvm
Jan  7 11:17:26 magnum kernel: [82746.884338] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
Jan  7 11:17:26 magnum kernel: [82746.884414] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:17:26 magnum kernel: [82746.884605] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:17:26 magnum kernel: [82747.083562] ieee80211 phy9: Selected rate control algorithm 'iwl-mvm-rs'
Jan  7 11:17:28 magnum kernel: [82749.289819] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:17:28 magnum kernel: [82749.290038] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
Jan  7 11:17:28 magnum kernel: [82749.302688] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.302934] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.303041] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.303318] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jan  7 11:17:28 magnum kernel: [82749.348752] wlan0: authenticate with 3a:bb:cc:dd:ee:ff
Jan  7 11:17:28 magnum kernel: [82749.348767] iwlwifi 0000:02:00.0: U rs_alloc_sta create station rate scale window
Jan  7 11:17:28 magnum kernel: [82749.349716] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.350717] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.351020] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.352483] wlan0: send auth to 3a:bb:cc:dd:ee:ff (try 1/3)
Jan  7 11:17:28 magnum kernel: [82749.353304] wlan0: authenticated
Jan  7 11:17:28 magnum kernel: [82749.353958] wlan0: associate with 3a:bb:cc:dd:ee:ff (try 1/3)
Jan  7 11:17:28 magnum kernel: [82749.355768] wlan0: RX AssocResp from 3a:bb:cc:dd:ee:ff (capab=0x1 status=0 aid=1)
Jan  7 11:17:28 magnum kernel: [82749.355955] iwlwifi 0000:02:00.0: U iwl_mvm_rs_rate_init LQ: *** rate scale station global init for station 1 ***
Jan  7 11:17:28 magnum kernel: [82749.355998] iwlwifi 0000:02:00.0: U iwl_mvm_rs_rate_init SISO-RATE=1FD0 MIMO2-RATE=0 VHT=0
Jan  7 11:17:28 magnum kernel: [82749.356315] wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
Jan  7 11:17:28 magnum kernel: [82749.356321] wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
Jan  7 11:17:28 magnum kernel: [82749.356325] wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=93 uapsd=0
Jan  7 11:17:28 magnum kernel: [82749.356329] wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=46 uapsd=0
Jan  7 11:17:28 magnum kernel: [82749.356338] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.356747] wlan0: associated
Jan  7 11:17:28 magnum kernel: [82749.356792] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jan  7 11:17:28 magnum kernel: [82749.362332] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 1 total 1
Jan  7 11:17:28 magnum kernel: [82749.472674] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 0
Jan  7 11:17:28 magnum kernel: [82749.473241] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 2 total 2
Jan  7 11:17:28 magnum kernel: [82749.473936] iwlwifi 0000:02:00.0: U iwl_mvm_mac_ctxt_cmd_common use_cts_prot 0, ht_operation_mode 4
Jan  7 11:17:28 magnum kernel: [82749.489649] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 3 total 3
Jan  7 11:17:29 magnum kernel: [82749.723836] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 4 total 4
Jan  7 11:17:29 magnum kernel: [82749.734614] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 5 total 5
Jan  7 11:17:29 magnum kernel: [82749.975026] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 6 total 6
Jan  7 11:17:29 magnum kernel: [82750.058805] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): Test Window: succ 7 total 7
Jan  7 11:17:29 magnum kernel: [82750.170912] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 4): cur_tpt 4000 SR 12800 low 15 high 5 low_tpt -1 high_tpt -1
Jan  7 11:17:29 magnum kernel: [82750.170918] iwlwifi 0000:02:00.0: I rs_get_rate_action Good SR and no high rate measurement. Increase rate
Jan  7 11:17:29 magnum kernel: [82750.175190] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 1 total 1
Jan  7 11:17:29 magnum kernel: [82750.608412] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 2 total 2
Jan  7 11:17:30 magnum kernel: [82750.735208] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 3 total 3
Jan  7 11:17:30 magnum kernel: [82750.735451] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 4 total 4
Jan  7 11:17:30 magnum kernel: [82750.743198] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 5 total 5
Jan  7 11:17:30 magnum kernel: [82750.819255] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 6 total 6
Jan  7 11:17:30 magnum kernel: [82750.903464] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): Test Window: succ 7 total 7
Jan  7 11:17:30 magnum kernel: [82750.904468] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 5): cur_tpt 5700 SR 12800 low 4 high 6 low_tpt 4000 high_tpt -1
Jan  7 11:17:30 magnum kernel: [82750.904475] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:30 magnum kernel: [82750.905161] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 1 total 1
Jan  7 11:17:30 magnum kernel: [82750.920282] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 2 total 2
Jan  7 11:17:30 magnum kernel: [82751.154510] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 3 total 3
Jan  7 11:17:30 magnum kernel: [82751.154972] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 4 total 4
Jan  7 11:17:30 magnum kernel: [82751.292626] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 5 total 5
Jan  7 11:17:30 magnum kernel: [82751.327576] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 6 total 6
Jan  7 11:17:30 magnum kernel: [82751.405479] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): Test Window: succ 7 total 7
Jan  7 11:17:30 magnum kernel: [82751.405749] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 6): cur_tpt 7200 SR 12800 low 5 high 7 low_tpt 5700 high_tpt -1
Jan  7 11:17:30 magnum kernel: [82751.405755] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:30 magnum kernel: [82751.407335] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 2 does not match 3 (0x4007)
Jan  7 11:17:30 magnum kernel: [82751.605941] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 1 total 1
Jan  7 11:17:30 magnum kernel: [82751.607004] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 1 total 2
Jan  7 11:17:31 magnum kernel: [82752.038522] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 2 total 3
Jan  7 11:17:32 magnum kernel: [82752.723508] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 3 total 4
Jan  7 11:17:32 magnum kernel: [82752.724533] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 4 total 5
Jan  7 11:17:32 magnum kernel: [82753.411718] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 5 total 6
Jan  7 11:17:33 magnum kernel: [82753.893858] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 6 total 7
Jan  7 11:17:33 magnum kernel: [82753.897253] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): Test Window: succ 7 total 8
Jan  7 11:17:33 magnum kernel: [82753.897272] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 7): cur_tpt 8711 SR 11377 low 6 high 8 low_tpt 7200 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.897279] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.897316] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 3 does not match 4 (0x4009)
Jan  7 11:17:33 magnum kernel: [82753.899531] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 3 does not match 4 (0x4009)
Jan  7 11:17:33 magnum kernel: [82753.899541] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 3 does not match 4 (0x4009)
Jan  7 11:17:33 magnum kernel: [82753.899548] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 3 does not match 4 (0x4009)
Jan  7 11:17:33 magnum kernel: [82753.901915] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.901927] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.901934] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.903669] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.903681] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.903688] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.905509] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.905525] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 8): cur_tpt 12100 SR 12800 low 7 high 9 low_tpt 8711 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.905530] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.905558] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 4 does not match 5 (0x400b)
Jan  7 11:17:33 magnum kernel: [82753.906944] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 4 does not match 5 (0x400b)
Jan  7 11:17:33 magnum kernel: [82753.906957] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 4 does not match 5 (0x400b)
Jan  7 11:17:33 magnum kernel: [82753.906965] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 4 does not match 5 (0x400b)
Jan  7 11:17:33 magnum kernel: [82753.909002] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.909026] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.909038] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.909049] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.911096] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.911110] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.911122] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.911137] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 9): cur_tpt 15400 SR 12800 low 8 high 10 low_tpt 12100 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.911144] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.911178] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.912945] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.912957] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.912979] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.912996] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.913012] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4001)
Jan  7 11:17:33 magnum kernel: [82753.915041] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.915052] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.915060] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.915067] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.915073] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.915080] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.917056] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.917073] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 10): cur_tpt 17700 SR 12800 low 9 high 11 low_tpt 15400 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.917077] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.917103] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.917110] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.917115] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.918557] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.918568] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.918575] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.918581] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.918587] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4003)
Jan  7 11:17:33 magnum kernel: [82753.920555] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.920569] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.920578] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.920587] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.920595] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.920608] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.922398] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.922414] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (LEGACY_A: 11): cur_tpt 18600 SR 12800 low 10 high 15 low_tpt 17700 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.922420] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.922424] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.922429] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 8
Jan  7 11:17:33 magnum kernel: [82753.922435] iwlwifi 0000:02:00.0: I rs_get_next_column Skip column 1: can't beat current TPT. Max expected 186 current 186
Jan  7 11:17:33 magnum kernel: [82753.922440] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 2
Jan  7 11:17:33 magnum kernel: [82753.922445] iwlwifi 0000:02:00.0: I rs_switch_to_column Switched to column 2: Index 9
Jan  7 11:17:33 magnum kernel: [82753.922451] iwlwifi 0000:02:00.0: I rs_dump_rate Switch to SEARCH TABLE:: (HT SISO: 9) ANT: A BW: 2048 SGI: 0
Jan  7 11:17:33 magnum kernel: [82753.922478] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.922485] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.922492] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.922499] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924224] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924236] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924244] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924251] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924258] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.924265] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 5 (0x4904)
Jan  7 11:17:33 magnum kernel: [82753.926122] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.926138] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.926150] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.926161] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.926172] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.926184] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.926194] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.927966] iwlwifi 0000:02:00.0: I rs_rate_scale_perform SWITCHING TO NEW TABLE SR: 12800 cur-tpt 22000 old-tpt 18600
Jan  7 11:17:33 magnum kernel: [82753.927979] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 9): cur_tpt 22000 SR 12800 low 8 high 10 low_tpt -1 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.927984] iwlwifi 0000:02:00.0: I rs_get_rate_action Good SR and no high rate measurement. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.928010] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.928017] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.928024] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.928030] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.928036] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929795] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929806] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929812] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929818] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929824] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929830] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929836] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.929842] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 5 does not match 6 (0x4905)
Jan  7 11:17:33 magnum kernel: [82753.931788] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.931800] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.931807] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.931814] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.931821] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.931827] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.931834] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.931842] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 10): cur_tpt 24200 SR 12800 low 9 high 11 low_tpt 22000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.931847] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.931873] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4906)
Jan  7 11:17:33 magnum kernel: [82753.932737] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4906)
Jan  7 11:17:33 magnum kernel: [82753.932746] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4906)
Jan  7 11:17:33 magnum kernel: [82753.932753] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4906)
Jan  7 11:17:33 magnum kernel: [82753.932760] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 6 does not match 7 (0x4906)
Jan  7 11:17:33 magnum kernel: [82753.934640] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.934652] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.934660] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.934668] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.934676] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.934684] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.934691] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.934701] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 11): cur_tpt 25000 SR 12800 low 10 high 12 low_tpt 24200 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.934706] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.934725] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.935649] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.935659] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.935666] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.935673] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.935680] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 7 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.937870] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.937881] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.937888] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.937895] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.937901] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.937908] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.937914] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.937922] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.937926] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.937929] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.937933] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 8
Jan  7 11:17:33 magnum kernel: [82753.937937] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 3
Jan  7 11:17:33 magnum kernel: [82753.937940] iwlwifi 0000:02:00.0: I rs_switch_to_column Switched to column 3: Index 12
Jan  7 11:17:33 magnum kernel: [82753.937945] iwlwifi 0000:02:00.0: I rs_dump_rate Switch to SEARCH TABLE:: (HT SISO: 12) ANT: B BW: 2048 SGI: 0
Jan  7 11:17:33 magnum kernel: [82753.937970] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.937976] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.938913] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.938924] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.938931] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.938937] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.938943] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x8907)
Jan  7 11:17:33 magnum kernel: [82753.940758] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 1 total 1
Jan  7 11:17:33 magnum kernel: [82753.940769] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 2 total 2
Jan  7 11:17:33 magnum kernel: [82753.940777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 3 total 3
Jan  7 11:17:33 magnum kernel: [82753.940783] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 4 total 4
Jan  7 11:17:33 magnum kernel: [82753.940790] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 5 total 5
Jan  7 11:17:33 magnum kernel: [82753.940796] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 6 total 6
Jan  7 11:17:33 magnum kernel: [82753.940803] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): Test Window: succ 7 total 7
Jan  7 11:17:33 magnum kernel: [82753.940809] iwlwifi 0000:02:00.0: I rs_rate_scale_perform GOING BACK TO THE OLD TABLE: SR 12800 cur-tpt 25700 old-tpt 25700
Jan  7 11:17:33 magnum kernel: [82753.940835] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.942855] iwlwifi 0000:02:00.0: I rs_tx_status initial rate 8 does not match 8 (0x4907)
Jan  7 11:17:33 magnum kernel: [82753.942869] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.942874] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.942878] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.942883] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 9
Jan  7 11:17:33 magnum kernel: [82753.942887] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.942891] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.942896] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.942906] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.942910] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.942914] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.942919] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 10
Jan  7 11:17:33 magnum kernel: [82753.942923] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.942927] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.942932] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.942941] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.942945] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.942949] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.942954] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 11
Jan  7 11:17:33 magnum kernel: [82753.942958] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.942962] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.942966] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.942975] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.942979] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.942983] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.942988] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 12
Jan  7 11:17:33 magnum kernel: [82753.942992] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.942996] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.943000] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.943009] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.943013] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.943017] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.943022] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 13
Jan  7 11:17:33 magnum kernel: [82753.943026] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.943030] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.943034] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.943042] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.943046] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.943050] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.943055] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 14
Jan  7 11:17:33 magnum kernel: [82753.943059] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.943063] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.943067] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.943075] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.943079] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.943083] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.943088] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 15
Jan  7 11:17:33 magnum kernel: [82753.943092] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.943096] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.943100] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.943108] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.943113] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.943117] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.943121] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 16
Jan  7 11:17:33 magnum kernel: [82753.943125] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.943129] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.943133] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.944877] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.944882] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.944886] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.944891] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 17
Jan  7 11:17:33 magnum kernel: [82753.944895] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.944899] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.944904] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.944915] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.944920] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.944924] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.944928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 18
Jan  7 11:17:33 magnum kernel: [82753.944932] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.944936] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.944941] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.944950] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.944954] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.944958] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.944963] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 19
Jan  7 11:17:33 magnum kernel: [82753.944967] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.944971] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.944975] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.944984] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945002] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945007] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945012] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 20
Jan  7 11:17:33 magnum kernel: [82753.945016] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945020] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945024] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945049] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945064] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945076] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945088] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 21
Jan  7 11:17:33 magnum kernel: [82753.945099] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945109] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945120] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945135] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945144] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945148] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945152] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 22
Jan  7 11:17:33 magnum kernel: [82753.945156] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945160] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945165] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945177] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945183] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945188] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945195] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 23
Jan  7 11:17:33 magnum kernel: [82753.945201] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945207] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945213] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945228] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945234] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945241] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945248] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 24
Jan  7 11:17:33 magnum kernel: [82753.945255] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945261] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945267] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945280] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945287] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945293] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945300] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 25
Jan  7 11:17:33 magnum kernel: [82753.945306] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945313] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945320] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945334] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945340] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945348] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945364] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 26
Jan  7 11:17:33 magnum kernel: [82753.945380] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945395] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945411] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.945439] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.945453] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.945463] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.945470] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 27
Jan  7 11:17:33 magnum kernel: [82753.945476] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.945482] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.945489] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947237] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947245] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947249] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947254] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 28
Jan  7 11:17:33 magnum kernel: [82753.947259] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947263] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947268] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947280] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947285] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947289] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947294] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 29
Jan  7 11:17:33 magnum kernel: [82753.947298] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947302] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947306] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947315] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947319] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947323] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947328] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 30
Jan  7 11:17:33 magnum kernel: [82753.947332] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947336] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947340] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947349] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947353] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947357] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947362] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 31
Jan  7 11:17:33 magnum kernel: [82753.947366] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947370] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947375] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947383] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947388] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947392] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947396] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 32
Jan  7 11:17:33 magnum kernel: [82753.947400] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947404] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947408] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947417] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947421] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947425] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947430] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 33
Jan  7 11:17:33 magnum kernel: [82753.947434] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947438] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947442] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947450] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947455] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947458] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947463] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 34
Jan  7 11:17:33 magnum kernel: [82753.947467] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947471] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947475] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947483] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947487] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947491] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947496] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 35
Jan  7 11:17:33 magnum kernel: [82753.947500] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947504] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947508] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947516] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947520] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947524] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947529] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 36
Jan  7 11:17:33 magnum kernel: [82753.947533] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947537] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947541] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947549] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947553] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947557] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947562] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 37
Jan  7 11:17:33 magnum kernel: [82753.947566] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947570] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947574] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947582] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947586] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947589] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947594] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 38
Jan  7 11:17:33 magnum kernel: [82753.947598] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947602] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947606] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.947614] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.947618] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.947622] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.947626] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 39
Jan  7 11:17:33 magnum kernel: [82753.947631] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.947635] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.947639] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949331] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949339] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949345] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949352] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 40
Jan  7 11:17:33 magnum kernel: [82753.949358] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949364] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949369] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949380] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949385] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949389] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949393] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 41
Jan  7 11:17:33 magnum kernel: [82753.949397] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949401] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949406] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949414] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949418] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949421] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949426] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 42
Jan  7 11:17:33 magnum kernel: [82753.949430] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949434] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949438] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949446] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949450] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949454] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949458] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 43
Jan  7 11:17:33 magnum kernel: [82753.949463] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949467] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949471] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949479] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949483] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949487] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949492] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 44
Jan  7 11:17:33 magnum kernel: [82753.949496] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949500] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949504] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949512] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949516] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949520] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949524] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 45
Jan  7 11:17:33 magnum kernel: [82753.949528] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949532] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949536] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949544] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949548] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949552] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949557] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 46
Jan  7 11:17:33 magnum kernel: [82753.949560] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949564] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949569] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949577] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949581] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949585] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949590] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 47
Jan  7 11:17:33 magnum kernel: [82753.949594] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949598] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949602] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949610] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949614] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949618] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949623] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 48
Jan  7 11:17:33 magnum kernel: [82753.949627] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949631] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949635] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949643] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949647] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949651] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949655] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 49
Jan  7 11:17:33 magnum kernel: [82753.949659] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949663] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949667] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.949675] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.949679] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.949683] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.949687] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 50
Jan  7 11:17:33 magnum kernel: [82753.949691] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.949695] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.949699] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951434] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951440] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951444] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951449] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 51
Jan  7 11:17:33 magnum kernel: [82753.951453] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951458] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951462] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951474] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951478] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951482] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951487] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 52
Jan  7 11:17:33 magnum kernel: [82753.951491] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951495] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951499] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951508] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951512] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951516] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951521] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 53
Jan  7 11:17:33 magnum kernel: [82753.951525] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951529] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951533] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951542] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951546] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951550] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951554] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 54
Jan  7 11:17:33 magnum kernel: [82753.951558] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951562] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951567] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951575] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951579] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951583] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951588] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 55
Jan  7 11:17:33 magnum kernel: [82753.951592] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951596] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951600] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951608] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951612] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951616] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951621] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 56
Jan  7 11:17:33 magnum kernel: [82753.951625] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951628] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951633] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951640] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951644] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951648] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951653] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 57
Jan  7 11:17:33 magnum kernel: [82753.951657] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951660] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951665] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951676] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951680] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951685] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 58
Jan  7 11:17:33 magnum kernel: [82753.951689] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951692] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951697] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951705] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951709] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951712] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951717] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 59
Jan  7 11:17:33 magnum kernel: [82753.951721] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951725] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951729] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951737] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951741] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951745] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951750] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 60
Jan  7 11:17:33 magnum kernel: [82753.951754] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951757] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951762] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.951770] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.951774] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.951777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.951782] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 61
Jan  7 11:17:33 magnum kernel: [82753.951786] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.951790] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.951794] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953479] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953486] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953492] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953500] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953506] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953513] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953520] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953536] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953543] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953549] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953557] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953563] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953569] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953576] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953596] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953602] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953609] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953616] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953623] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953629] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953636] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953650] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953655] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953659] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953663] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953667] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953671] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953676] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953685] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953689] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953693] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953697] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953701] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953705] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953710] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953718] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953722] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953726] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953730] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953736] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953740] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953744] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953752] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953756] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953760] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953765] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953769] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953773] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953777] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953785] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953789] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953793] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953797] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953801] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953805] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953809] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953817] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953821] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953825] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953830] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953834] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953838] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953842] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.953849] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.953853] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.953857] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.953862] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.953866] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.953870] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.953874] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955643] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955650] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955655] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955660] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955664] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955669] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955674] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955686] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955690] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955694] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955703] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955707] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955711] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955721] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955725] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955729] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955734] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955738] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955742] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955746] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955754] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955759] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955762] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955767] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955771] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955775] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955780] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955788] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955792] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955796] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955801] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955805] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955809] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955813] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955821] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955825] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955829] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955834] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955838] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955842] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955846] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955854] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955858] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955862] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955867] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955871] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955875] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955879] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955887] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955891] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955895] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955899] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955903] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955908] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955912] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955920] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955925] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955933] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955937] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955941] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955945] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955953] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955957] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955961] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955966] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.955970] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.955974] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.955978] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.955986] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.955990] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.955994] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.955999] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.956003] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.956007] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.956011] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957706] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957714] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957719] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957727] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957733] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957740] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957747] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957765] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957772] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957778] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957785] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957792] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957798] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957805] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957819] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957826] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957832] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957839] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957846] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957852] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957859] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957873] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957880] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957886] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957893] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957899] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957906] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957912] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957933] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957937] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957942] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957946] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957950] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957954] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957963] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.957967] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.957971] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.957976] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.957980] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.957984] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.957988] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.957996] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.958000] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.958004] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.958009] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.958013] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.958017] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.958021] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.958029] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.958033] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.958037] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.958041] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.958045] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.958049] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.958053] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.958061] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.958065] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.958069] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.958074] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.958078] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.958082] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.958086] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.958094] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.958098] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.958102] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.958107] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.958111] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.958115] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.958119] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.958127] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.958131] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.958135] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.958139] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.958143] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.958147] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.958151] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.959886] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.959892] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.959896] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.959901] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.959905] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.959909] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.959914] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.959925] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.959930] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.959934] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.959938] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.959942] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.959947] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.959951] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.959960] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.959964] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.959968] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.959973] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.959977] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.959981] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.959985] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.959994] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.959998] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960002] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960007] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960011] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960015] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960019] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960027] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960031] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960035] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960040] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960044] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960048] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960052] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960060] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960064] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960068] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960073] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960077] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960081] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960085] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960093] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960097] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960101] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960106] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960110] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960114] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960118] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960126] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960130] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960134] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960138] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960142] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960146] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960150] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960159] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960164] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960167] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960172] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960176] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960180] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960184] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960192] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960196] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960200] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960205] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960209] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960213] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960217] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.960225] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.960229] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.960233] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.960238] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.960242] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.960246] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.960250] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.961984] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.961990] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.961994] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.961999] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962003] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962007] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962012] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962024] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962028] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962032] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962037] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962041] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962045] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962049] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962058] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962062] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962066] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962071] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962075] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962078] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962083] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962092] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962096] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962100] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962105] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962109] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962113] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962117] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962125] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962129] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962133] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962138] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962142] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962146] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962150] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962158] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962162] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962166] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962170] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962174] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962178] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962182] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962190] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962194] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962198] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962202] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962206] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962210] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962214] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962223] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962227] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962231] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962236] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962240] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962243] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962248] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962256] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962260] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962264] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962269] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962273] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962277] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962281] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962289] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962293] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962297] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962302] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962306] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962310] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962314] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.962322] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.962326] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.962330] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.962334] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.962338] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.962342] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.962346] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964103] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964110] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964115] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964120] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964124] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964129] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964134] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964145] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964150] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964154] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964159] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964163] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964167] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964171] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964181] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964185] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964189] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964194] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964198] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964202] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964206] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964221] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964226] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964230] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964235] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964239] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964243] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964247] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964257] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964261] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964265] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964270] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964274] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964278] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964282] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964291] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964295] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964299] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964304] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964308] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964312] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964316] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964324] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964328] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964332] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964337] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964341] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964345] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964349] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964357] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964361] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964365] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964370] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964374] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964377] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964382] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964390] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964394] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964398] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964402] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964406] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964410] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964415] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964424] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964428] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964432] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964441] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964444] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964449] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.964457] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.964461] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.964465] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.964470] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.964474] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.964478] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.964482] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966189] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966197] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966202] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966210] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966217] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966223] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966230] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966247] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966254] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966260] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966268] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966274] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966281] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966288] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966302] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966308] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966315] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966322] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966328] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966335] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966341] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966356] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966363] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966369] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966374] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966378] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966382] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966386] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966396] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966400] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966404] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966409] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966413] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966417] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966421] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966429] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966433] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966442] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966446] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966450] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966454] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966462] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966466] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966470] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966474] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966478] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966482] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966487] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966494] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966498] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966502] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966507] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966511] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966515] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966519] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966527] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966531] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966535] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966540] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966544] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966548] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966552] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.966560] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.966564] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.966568] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.966573] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.966577] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.966581] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.966585] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968309] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968315] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968319] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968324] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968328] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968332] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968337] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968348] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968353] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968357] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968361] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968365] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968370] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968374] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968383] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968387] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968391] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968396] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968400] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968404] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968409] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968417] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968422] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968426] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968430] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968435] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968439] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968443] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968451] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968456] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968459] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968464] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968468] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968472] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968476] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968484] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968489] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968493] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968497] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968501] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968505] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968509] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968517] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968521] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968525] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968530] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968534] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968538] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968542] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968550] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968554] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968558] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968563] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968567] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968571] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968575] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968582] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968587] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968590] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968595] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968599] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968603] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968607] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968615] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968619] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968622] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968627] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968631] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968635] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968639] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.968647] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.968651] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.968654] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.968659] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.968663] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.968667] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.968671] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970427] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970433] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970442] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970447] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970451] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970456] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970467] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970472] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970475] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970480] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970484] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970488] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970493] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970505] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970509] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970512] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970516] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970520] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970524] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970528] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970536] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970540] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970543] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970548] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970551] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970555] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970559] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970567] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970571] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970574] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970579] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970582] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970586] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970590] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970597] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970601] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970605] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970609] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970612] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970616] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970620] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970627] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970631] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970635] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970643] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970646] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970650] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970657] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970661] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970664] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970668] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970672] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970675] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970679] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970686] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970690] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970693] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970698] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970701] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970705] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970709] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970716] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970720] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970723] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970728] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970731] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970735] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970739] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.970746] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.970750] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.970753] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.970757] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.970761] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.970764] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.970768] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972525] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972532] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972536] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972541] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972546] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972550] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972555] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972567] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972572] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972576] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972580] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972584] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972589] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972596] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972605] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972609] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972613] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972617] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972621] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972624] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972628] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972636] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972640] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972644] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972648] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972652] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972655] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972659] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972667] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972671] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972674] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972678] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972682] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972686] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972690] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972697] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972701] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972704] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972708] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972712] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972716] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972720] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972727] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972730] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972734] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972738] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972742] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972745] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972749] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972756] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972760] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972763] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972768] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972771] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972775] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972778] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.972786] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.972790] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.972793] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.972798] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.972801] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.972805] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.972809] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974519] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974525] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974529] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974534] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974538] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974543] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974548] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974559] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974564] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974568] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974572] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974576] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974580] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974585] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974597] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974601] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974605] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974609] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974613] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974616] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974620] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974628] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974632] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974635] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974640] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974643] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974647] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974651] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974660] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974664] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974667] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974675] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974679] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974682] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974690] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974693] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974697] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974701] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974705] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974708] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974712] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974724] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974728] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974732] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974736] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974740] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974743] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974747] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974755] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974758] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974762] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974766] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974769] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974773] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974777] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974784] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974788] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974792] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974796] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974800] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974803] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974807] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.974814] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.974818] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.974821] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.974826] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.974829] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.974833] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.974837] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976598] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976605] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976609] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976615] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976619] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976623] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976628] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976641] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976645] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976649] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976654] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976662] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976665] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976669] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976678] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976682] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976686] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976690] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976694] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976697] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976701] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976709] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976713] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976716] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976721] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976724] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976728] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976732] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976739] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976743] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976747] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976751] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976754] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976758] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976762] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976769] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976773] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976776] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976781] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976784] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976788] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976792] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976799] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976802] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976806] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976810] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976814] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976817] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976821] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976829] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976832] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976836] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976840] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976844] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976847] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976851] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976858] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976862] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976865] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976869] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976873] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976876] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976880] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976887] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976891] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976894] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976898] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976902] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976905] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976909] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.976916] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.976920] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.976923] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.976928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.976931] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.976935] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.976939] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978630] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978636] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978644] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978648] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978652] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978656] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978665] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978669] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978677] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978680] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978684] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978688] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978695] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978699] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978702] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978707] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978710] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978714] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978718] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978725] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978728] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978732] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978736] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978740] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978743] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978747] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978754] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978758] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978762] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978766] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978769] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978773] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978777] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978784] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978788] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978791] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978795] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978799] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978802] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978806] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978813] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978817] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978820] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978824] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978828] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978831] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978835] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978842] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978846] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978849] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978853] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978857] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978861] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978864] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978872] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978875] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978879] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978883] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978886] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978890] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978894] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.978901] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.978904] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.978908] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.978912] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.978915] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.978919] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.978923] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980683] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980690] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980695] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980700] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980704] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980708] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980713] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980725] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980729] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980734] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980738] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980742] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980747] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980751] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980764] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980768] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980771] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980775] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980779] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980783] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980787] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980794] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980798] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980802] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980806] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980810] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980813] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980817] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980825] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980829] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980832] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980837] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980840] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980844] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980848] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980855] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980859] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980863] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980867] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980871] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980875] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980879] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980886] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980890] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980893] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980898] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980901] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980905] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980909] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980916] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980920] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980923] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980931] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980935] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980939] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980946] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980949] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980953] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980957] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980961] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980964] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980968] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.980975] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.980979] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.980983] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.980987] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.980991] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.980994] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.980998] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982688] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982694] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982698] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982703] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982708] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982712] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982717] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982727] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982731] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982735] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982740] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982744] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982748] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982753] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982764] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982769] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982772] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982781] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982785] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982789] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982799] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982803] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982807] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982811] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982815] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982819] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982824] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982832] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982836] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982839] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982844] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982848] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982852] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982856] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982864] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982868] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982872] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982876] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982880] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982884] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982888] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982896] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982900] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982904] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982909] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982913] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982916] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982921] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982928] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982932] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982936] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982941] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982945] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982949] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982953] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982961] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982966] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.982969] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.982974] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.982978] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.982982] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.982986] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.982994] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.982998] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.983002] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.983007] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.983010] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.983014] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.983019] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.983026] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.983030] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.983034] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.983039] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.983043] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.983047] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.983051] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.984888] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.984894] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.984898] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.984902] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.984906] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.984909] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.984913] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.984924] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.984927] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.984931] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.984935] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.984938] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.984941] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.984945] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.984953] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.984957] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.984960] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.984964] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.984967] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.984970] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.984974] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.984981] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.984985] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.984988] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.984992] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.984995] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.984999] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985002] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985009] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985026] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985030] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985034] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985038] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985041] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985045] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985060] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985064] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985069] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985074] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985079] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985090] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985103] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985123] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985135] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985147] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985158] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985164] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985168] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985172] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985184] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985188] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985192] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985198] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985203] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985208] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985213] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985225] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985231] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985236] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985242] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985247] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985253] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985258] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985271] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985276] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985281] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985288] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985293] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985299] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985305] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.985317] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.985323] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.985328] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.985335] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.985340] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.985345] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.985351] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987090] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987096] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987100] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987105] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987109] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987114] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987118] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987129] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987133] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987137] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987142] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987146] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987150] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987155] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987163] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987167] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987171] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987176] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987180] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987184] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987188] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987196] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987200] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987204] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987209] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987213] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987217] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987221] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987229] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987233] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987237] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987242] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987246] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987250] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987254] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987262] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987266] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987270] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987275] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987279] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987283] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987288] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987296] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987300] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987304] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987309] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987313] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987317] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987322] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987329] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987334] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987337] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987342] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987346] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987350] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987354] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987362] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987367] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987370] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987375] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987379] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987383] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987387] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987395] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987399] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987404] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987409] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987413] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987417] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987421] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.987429] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.987433] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.987437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.987442] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.987446] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.987450] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.987454] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989140] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989145] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989149] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989153] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989157] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989162] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989166] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989177] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989182] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989186] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989190] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989194] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989198] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989202] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989212] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989216] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989220] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989225] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989229] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989233] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989237] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989246] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989250] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989254] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989258] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989262] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989266] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989270] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989278] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989283] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989286] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989291] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989295] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989299] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989303] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989311] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989315] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989319] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989323] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989327] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989331] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989335] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989344] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989348] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989351] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989356] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989360] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989364] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989368] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989376] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989380] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989384] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989389] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989393] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989397] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989401] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989409] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989413] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989417] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989421] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989425] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989429] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989433] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989441] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989445] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989449] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989454] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989458] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989462] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989466] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.989474] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.989478] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.989482] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.989487] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.989491] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.989495] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.989499] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991259] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991265] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991269] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991274] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991278] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991283] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991287] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991299] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991303] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991307] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991312] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991316] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991320] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991324] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991333] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991337] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991342] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991347] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991351] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991355] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991359] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991368] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991372] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991376] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991381] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991385] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991389] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991393] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991402] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991406] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991410] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991415] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991419] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991422] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991427] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991434] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991438] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991442] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991447] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991451] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991455] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991459] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991467] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991471] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991475] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991480] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991484] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991488] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991492] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991500] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991504] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991508] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991513] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991517] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991521] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991525] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991533] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991537] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991541] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991546] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991549] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991553] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991557] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991565] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991569] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991573] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991578] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991582] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991585] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991590] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.991597] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.991602] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.991605] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.991610] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.991614] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.991618] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.991622] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993314] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993321] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993326] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993333] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993338] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993342] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993347] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993358] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993362] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993366] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993371] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993375] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993379] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993383] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993391] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993396] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993402] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993408] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993414] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993420] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993427] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993441] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993445] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993449] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993454] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993458] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993462] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993467] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993475] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993479] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993483] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993488] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993492] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993496] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993500] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993508] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993512] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993516] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993521] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993524] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993528] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993533] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993541] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993545] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993549] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993553] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993557] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993561] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993565] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993574] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993578] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993582] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993586] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993590] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993594] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993599] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993607] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993611] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993615] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993620] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993624] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993627] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993632] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.993639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.993643] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.993647] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.993652] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.993656] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.993659] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.993663] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995398] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995404] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995408] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995413] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995417] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995421] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995426] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995441] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995445] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995450] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995454] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995458] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995462] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995471] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995475] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995479] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995484] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995488] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995492] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995496] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995505] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995509] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995513] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995517] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995521] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995525] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995529] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995549] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995555] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995560] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995566] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995571] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995578] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995584] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995601] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995608] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995614] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995622] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995629] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995635] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995642] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995656] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995663] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995669] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995677] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995683] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995690] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995697] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995710] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995717] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995723] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995730] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995737] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995743] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995750] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995764] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995771] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995785] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995791] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995797] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995804] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995819] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995825] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995831] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995836] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995840] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995844] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995848] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.995858] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.995862] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.995866] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.995871] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.995875] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.995879] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.995883] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997574] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997581] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997587] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997594] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997600] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997607] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997613] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997629] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997635] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997641] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997648] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997654] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997661] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997667] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997680] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997686] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997692] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997705] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997712] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997718] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997732] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997739] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997745] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997752] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997757] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997763] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997767] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997782] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997785] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997790] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997794] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997798] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997802] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997810] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997815] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997818] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997823] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997827] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997831] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997835] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997847] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997854] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997859] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997866] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997873] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997879] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997885] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997896] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997900] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997904] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997909] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997913] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997917] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997921] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997930] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997934] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997938] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997942] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997946] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997950] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997954] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.997962] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.997966] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.997972] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.997979] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.997984] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.997991] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.997997] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.998012] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.998017] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.998021] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.998025] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.998030] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.998034] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.998038] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999776] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999781] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999786] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999791] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999795] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999799] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999804] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999814] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999818] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999822] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999827] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999831] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999835] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999839] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999848] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999852] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999856] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999861] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999865] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999869] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999873] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999881] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999885] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999889] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999894] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999897] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999901] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999905] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999913] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999917] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999921] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999926] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999930] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999934] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999938] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999947] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999951] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999954] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999959] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999963] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999967] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82753.999971] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82753.999978] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82753.999982] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82753.999986] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82753.999991] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82753.999995] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82753.999999] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.000003] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.000011] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.000015] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.000019] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.000023] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.000027] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.000031] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.000036] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.000044] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.000048] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.000051] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.000056] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.000060] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.000064] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.000068] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.000076] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.000080] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.000084] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.000089] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.000093] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.000097] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.000101] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.000109] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.000113] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.000117] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.000121] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.000125] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.000129] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.000133] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.001823] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.001831] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.001837] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.001845] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.001851] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.001856] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.001861] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.001873] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.001878] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.001881] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.001886] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.001890] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.001894] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.001899] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.001907] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.001911] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.001915] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.001920] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.001924] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.001928] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.001932] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.001940] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.001944] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.001948] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.001952] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.001956] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.001960] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.001964] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.001972] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.001976] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.001980] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.001984] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.001988] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.001992] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.001996] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002004] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002008] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002012] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002017] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002021] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002025] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002029] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002038] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002042] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002046] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002051] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002055] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002059] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002063] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002071] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002075] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002079] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002084] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002088] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002091] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002096] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002104] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002107] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002111] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002116] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002120] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002124] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002128] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002136] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002140] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002143] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002148] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002152] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002156] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002160] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.002168] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.002173] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.002176] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.002181] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.002185] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.002189] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.002193] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.003924] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.003928] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.003932] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.003936] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.003940] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.003944] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.003949] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.003958] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.003962] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.003966] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.003971] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.003975] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.003979] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.003983] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.003991] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.003995] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.003999] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004004] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004008] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004012] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004016] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004024] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004028] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004032] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004037] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004041] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004045] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004049] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004057] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004061] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004064] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004069] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004073] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004077] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004081] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004089] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004093] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004097] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004101] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004105] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004109] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004114] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004121] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004125] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004129] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004134] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004138] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004141] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004146] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004154] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004158] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004162] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004166] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004170] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004174] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004178] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004186] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004190] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004193] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004198] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004202] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004206] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004210] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.004218] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.004222] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.004226] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.004231] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.004235] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.004239] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.004243] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.005938] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.005945] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.005951] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.005958] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.005964] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.005971] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.005978] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.005990] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.005994] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.005998] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006003] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006007] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006011] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006015] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006023] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006027] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006031] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006036] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006040] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006044] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006048] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006056] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006060] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006064] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006068] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006072] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006076] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006080] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006088] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006092] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006096] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006100] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006104] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006108] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006112] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006121] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006125] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006128] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006133] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006137] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006141] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006145] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006153] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006157] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006160] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006165] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006169] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006173] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006177] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006185] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006189] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006193] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006197] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006201] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006205] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006209] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006218] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006222] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006226] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006230] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006234] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006238] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006242] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006251] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006255] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006258] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006263] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006267] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006271] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006275] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.006283] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.006287] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.006290] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.006295] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.006299] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.006303] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.006307] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008010] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008015] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008019] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008024] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008028] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008032] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008037] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008046] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008050] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008054] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008059] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008063] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008067] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008071] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008079] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008084] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008088] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008092] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008096] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008100] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008104] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008112] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008116] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008120] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008124] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008128] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008132] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008137] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008151] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008157] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008162] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008168] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008174] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008179] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008186] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008197] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008201] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008205] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008210] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008214] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008218] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008222] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008230] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008234] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008238] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008243] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008247] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008251] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008255] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008263] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008269] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008275] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008281] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008287] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008294] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008301] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008315] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008322] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008328] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008336] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008342] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008349] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008355] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.008369] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.008375] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.008382] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.008389] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.008396] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.008402] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.008409] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010097] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010102] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010106] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010111] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010115] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010119] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010124] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010134] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010138] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010142] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010147] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010151] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010154] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010159] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010167] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010171] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010175] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010179] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010183] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010187] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010191] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010199] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010203] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010207] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010211] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010215] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010219] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010224] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010232] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010236] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010240] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010244] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010248] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010252] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010256] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010264] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010268] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010272] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010276] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010280] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010284] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010288] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010296] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010300] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010304] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010308] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010312] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010316] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010320] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010328] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010332] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010336] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010341] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010344] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010348] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010352] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010360] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010364] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010368] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010373] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010377] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010381] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010385] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010393] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010397] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010400] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010405] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010409] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010413] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010417] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.010424] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.010428] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.010432] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.010437] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.010441] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.010444] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.010448] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012184] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012189] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012193] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012197] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012201] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012205] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012210] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012220] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012225] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012228] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012233] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012237] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012241] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012245] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012253] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012258] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012261] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012266] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012270] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012274] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012278] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012287] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012291] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012295] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012299] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012303] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012307] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012311] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012320] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012324] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012328] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012332] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012336] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012340] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012344] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012352] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012356] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012360] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012365] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012369] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012373] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012377] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012384] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012388] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012392] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012397] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012401] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012404] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012409] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012416] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012420] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012424] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012429] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012432] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012436] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012440] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012450] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012454] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012458] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012462] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012466] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012470] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012475] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012482] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012486] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012490] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012495] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012499] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012503] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012507] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.012515] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.012519] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.012522] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.012527] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.012531] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.012535] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.012539] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014232] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014239] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014245] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014252] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014259] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014265] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014272] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014284] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014288] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014292] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014297] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014301] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014305] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014309] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014318] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014323] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014326] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014331] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014335] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014339] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014343] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014351] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014355] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014359] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014364] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014368] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014372] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014376] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014384] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014388] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014392] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014396] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014400] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014404] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014408] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014416] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014420] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014424] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014429] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014433] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014437] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014441] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014449] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014453] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014457] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014462] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014465] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014469] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014474] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014481] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014485] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014489] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014494] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014498] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014502] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014506] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014514] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014518] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014522] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014527] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014531] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014535] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014539] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014547] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014551] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014554] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014559] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014563] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014567] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014571] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.014579] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.014584] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.014587] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.014592] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.014596] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.014600] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.014604] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016332] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016337] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016341] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016345] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016349] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016353] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016358] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016366] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016370] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016374] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016379] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016383] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016387] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016391] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016399] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016403] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016407] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016411] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016415] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016419] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016424] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016432] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016436] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016440] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016444] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016449] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016453] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016457] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016465] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016469] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016473] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016477] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016481] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016485] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016489] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016497] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016501] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016505] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016510] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016514] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016518] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016522] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016530] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016534] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016538] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016543] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016547] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016551] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016555] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016563] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016567] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016571] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016576] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016580] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016584] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016588] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016596] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016600] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016603] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016608] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016612] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016616] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016620] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.016628] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.016632] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.016636] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.016641] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.016645] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.016649] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.016653] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018345] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018350] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018354] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018359] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018363] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018367] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018372] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018382] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018387] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018390] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018395] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018399] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018403] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018407] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018415] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018419] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018423] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018428] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018431] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018435] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018439] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018447] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018451] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018455] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018460] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018463] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018467] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018471] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018486] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018492] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018497] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018503] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018509] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018515] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018522] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018536] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018543] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018549] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018557] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018564] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018570] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018577] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018592] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018598] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018605] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018612] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018617] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018623] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018630] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018645] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018652] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018658] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018665] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018671] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018678] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018685] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018706] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018712] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018719] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018726] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018732] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018740] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018754] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018760] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018766] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018774] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018781] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018787] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018794] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.018809] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.018816] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.018822] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.018829] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.018836] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.018842] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.018849] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020590] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020595] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020599] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020604] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020608] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020613] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020617] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020628] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020633] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020636] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020641] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020645] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020649] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020653] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020662] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020667] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020671] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020675] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020680] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020684] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020688] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020696] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020701] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020705] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020709] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020713] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020717] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020722] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020730] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020734] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020738] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020743] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020747] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020751] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020755] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020763] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020767] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020771] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020776] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020780] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020784] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020788] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020796] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020800] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020804] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020809] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020813] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020817] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020821] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020830] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020834] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020838] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020842] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020847] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020850] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020855] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020863] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020869] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020875] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020881] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020886] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020894] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020900] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020913] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020919] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020923] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020930] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020936] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020942] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.020948] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.020962] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.020968] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.020974] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.020981] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.020987] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.020994] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.021001] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022693] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022699] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022703] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022708] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022712] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022716] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022721] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022731] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022735] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022739] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022744] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022748] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022752] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022756] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022764] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022768] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022772] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022781] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022785] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022789] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022797] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022801] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022805] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022810] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022814] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022818] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022822] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022830] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022834] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022837] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022842] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022846] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022850] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022854] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022862] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022866] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022870] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022875] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022879] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022882] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022887] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022894] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022898] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022902] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022907] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022911] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022914] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022919] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022927] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022931] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022935] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022939] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022943] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022947] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022951] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022959] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022963] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022967] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.022971] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.022975] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.022979] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.022983] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.022991] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.022995] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.022999] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.023004] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.023008] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.023011] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.023016] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.023023] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.023027] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.023031] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.023036] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.023040] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.023044] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.023048] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024742] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024747] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024751] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024755] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024759] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024763] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024768] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024776] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024780] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024784] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024789] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024793] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024797] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024801] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024809] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024813] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024817] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024822] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024825] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024829] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024833] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024841] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024845] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024849] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024854] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024858] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024862] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024868] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024880] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024886] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024892] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024898] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024903] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024909] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024915] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024929] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024935] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024941] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.024948] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.024954] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.024960] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.024967] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.024980] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.024986] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.024992] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.025000] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.025006] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.025012] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.025019] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.025032] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.025038] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.025055] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.025063] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.025069] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.025075] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.025081] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.025112] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.025126] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.025140] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.025156] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.025168] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.025174] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.025178] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.025189] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.025193] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.025197] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.025202] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.025206] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.025210] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.025214] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.025222] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.025226] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.025230] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.025235] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.025239] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.025243] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.025247] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.026982] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.026988] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.026992] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.026997] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027001] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027005] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027010] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027021] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027026] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027030] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027035] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027039] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027043] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027047] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027056] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027060] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027064] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027069] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027073] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027077] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027081] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027090] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027094] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027098] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027103] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027108] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027112] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027116] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027125] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027129] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027133] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027138] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027142] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027146] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027150] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027158] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027163] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027167] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027171] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027175] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027179] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027183] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027191] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027195] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027199] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027204] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027208] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027212] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027216] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027224] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027229] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027232] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027237] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027241] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027245] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027249] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027257] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027262] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027265] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027270] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027274] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027278] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027283] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027292] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027297] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027301] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027305] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027309] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027313] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027318] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027325] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027330] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027333] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027338] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027342] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027346] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027350] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.027358] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.027362] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.027366] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.027371] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.027375] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.027379] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.027383] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029103] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029112] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029122] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029134] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029145] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029155] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029166] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029185] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029194] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029198] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029203] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029207] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029211] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029215] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029231] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029237] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029242] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029249] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029254] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029260] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029267] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029282] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029289] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029296] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029303] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029310] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029316] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029323] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029337] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029344] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029350] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029357] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029364] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029370] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029377] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029392] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029399] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029405] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029412] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029419] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029425] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029432] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029447] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029465] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029482] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029500] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029515] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029532] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029549] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029576] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029585] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029592] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029599] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029606] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029612] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029619] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029633] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029639] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029645] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029653] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029659] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029666] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029672] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.029686] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.029693] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.029699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.029707] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.029713] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.029719] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.029726] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031434] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031440] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031444] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031449] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031453] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031457] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031461] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031473] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031477] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031481] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031486] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031490] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031494] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031498] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031507] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031511] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031515] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031519] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031523] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031527] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031531] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031540] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031544] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031548] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031553] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031557] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031561] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031565] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031574] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031578] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031582] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031586] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031590] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031594] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031598] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031606] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031611] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031614] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031619] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031623] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031627] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031631] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031643] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031647] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031651] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031655] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031659] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031664] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031676] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031680] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031684] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031688] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031692] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031696] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031704] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031708] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031712] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031717] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031721] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031725] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031729] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031737] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031741] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031745] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031749] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031753] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031757] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031761] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031769] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031773] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031781] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031785] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031789] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031793] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.031801] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.031805] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.031809] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.031814] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.031818] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.031822] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.031826] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033512] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033519] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033525] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033532] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033539] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033544] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033549] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033561] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033565] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033569] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033574] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033578] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033582] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033586] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033594] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033598] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033602] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033607] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033611] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033615] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033619] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033627] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033631] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033635] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033643] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033647] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033652] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033659] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033663] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033667] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033676] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033680] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033684] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033692] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033696] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033704] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033708] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033712] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033716] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033724] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033728] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033732] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033736] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033740] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033744] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033748] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033756] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033761] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033764] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033769] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033773] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033777] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033781] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033789] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033793] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033797] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033801] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033805] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033809] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033813] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033821] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033825] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033829] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033833] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033837] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033841] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033845] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.033853] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.033857] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.033861] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.033866] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.033870] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.033874] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.033878] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035569] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035574] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035578] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035583] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035587] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035591] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035596] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035606] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035610] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035614] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035618] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035622] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035626] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035630] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035638] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035643] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035646] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035651] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035655] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035659] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035663] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035671] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035675] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035678] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035683] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035687] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035691] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035695] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035703] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035707] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035711] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035715] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035719] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035723] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035727] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035735] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035739] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035743] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035747] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035751] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035755] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035759] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035768] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035772] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035775] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035780] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035784] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035788] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035792] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035800] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035804] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035807] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035812] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035816] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035820] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035824] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035832] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035836] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035840] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035845] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035848] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035852] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035857] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.035865] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.035869] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.035872] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.035877] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.035881] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.035885] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.035889] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037579] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037584] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037588] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037593] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037597] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037601] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037605] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037616] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037620] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037624] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037631] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037636] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037643] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037649] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037664] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037670] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037675] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037679] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037683] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037688] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037692] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037701] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037706] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037709] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037714] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037718] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037722] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037726] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037734] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037738] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037742] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037747] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037751] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037755] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037759] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037767] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037771] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037775] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037780] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037784] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037788] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037792] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037800] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037804] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037808] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037813] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037817] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037821] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037825] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037833] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037837] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037840] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037845] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037849] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037853] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037857] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.037865] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.037869] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.037873] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.037877] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.037881] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.037885] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.037889] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039570] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039576] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039580] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039584] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039588] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039592] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039597] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039607] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039611] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039615] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039619] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039623] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039627] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039631] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039639] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039643] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039647] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039652] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039656] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039660] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039664] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039672] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039676] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039680] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039684] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039688] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039692] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039696] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039704] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039708] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039711] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039716] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039720] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039724] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039728] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039742] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039748] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039753] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039761] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039767] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039773] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039780] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039795] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039802] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039808] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039816] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039823] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039829] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039836] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039850] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039857] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039863] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039871] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039877] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039883] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039890] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039904] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039911] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039917] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039925] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039931] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039938] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039944] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.039957] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.039963] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.039967] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.039972] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.039976] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.039980] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.039984] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041678] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041686] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041692] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041699] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041704] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041710] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041717] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041734] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041740] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041746] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041753] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041757] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041761] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041766] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041777] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041783] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041788] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041795] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041800] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041806] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041813] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041828] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041832] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041836] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041841] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041845] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041849] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041853] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041863] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041867] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041871] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041876] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041880] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041884] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041888] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041896] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041900] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041904] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041910] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041917] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041922] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041929] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041942] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041948] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041954] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041959] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041963] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.041967] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.041971] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.041981] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.041985] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.041989] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.041994] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.041998] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.042002] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.042006] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.042013] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.042017] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.042021] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.042026] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.042030] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.042034] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.042040] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.042053] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.042059] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.042065] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.042072] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.042078] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.042084] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.042088] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.042098] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.042102] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.042106] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.042111] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.042115] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.042119] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.042123] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043828] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.043833] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.043837] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.043842] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.043846] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.043850] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.043855] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043866] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.043870] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.043873] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.043878] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.043882] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.043886] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.043890] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043898] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.043902] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.043906] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.043911] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.043915] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.043919] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.043923] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043931] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.043935] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.043939] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.043943] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.043947] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.043951] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.043955] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043963] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.043967] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.043971] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.043976] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.043980] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.043984] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.043988] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.043996] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044000] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044003] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044008] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044012] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044016] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044020] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.044028] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044032] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044036] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044040] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044044] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044048] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044052] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.044060] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044064] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044068] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044073] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044076] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044080] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044084] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.044092] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044096] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044100] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044105] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044109] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044113] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044117] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.044125] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044129] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044133] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044137] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044141] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044145] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044149] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.044158] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.044162] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.044166] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.044170] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.044174] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.044178] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.044182] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.045917] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.045923] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.045927] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.045932] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.045936] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.045941] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.045945] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.045957] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.045961] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.045965] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.045970] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.045974] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.045978] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.045982] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.045992] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.045996] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046000] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046005] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046009] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046013] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046017] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046026] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046030] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046034] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046039] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046043] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046046] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046051] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046059] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046064] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046068] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046072] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046077] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046080] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046085] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046093] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046097] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046101] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046105] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046109] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046113] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046118] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046126] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046130] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046134] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046139] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046143] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046147] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046151] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046159] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046163] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046167] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046172] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046176] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046180] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046184] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046192] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046196] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046200] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046205] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046209] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046213] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046217] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046225] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046229] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046233] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046238] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046242] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046246] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046250] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.046258] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.046262] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.046266] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.046270] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.046274] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.046278] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.046282] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.047997] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.048002] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.048006] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.048011] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.048015] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.048019] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.048023] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.048034] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.048038] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.048042] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.048047] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.048051] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.048055] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.048059] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.048067] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.048072] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate
Jan  7 11:17:33 magnum kernel: [82754.048076] iwlwifi 0000:02:00.0: I rs_rate_scale_perform At the top rate. Can't increase
Jan  7 11:17:33 magnum kernel: [82754.048080] iwlwifi 0000:02:00.0: I rs_rate_scale_perform Start Search: update_lq 0 done_search 0 rs_state 0 win->counter 62
Jan  7 11:17:33 magnum kernel: [82754.048084] iwlwifi 0000:02:00.0: I rs_get_next_column Skip already visited column 3
Jan  7 11:17:33 magnum kernel: [82754.048088] iwlwifi 0000:02:00.0: I rs_get_next_column Found potential column 6
Jan  7 11:17:33 magnum kernel: [82754.048092] iwlwifi 0000:02:00.0: I rs_switch_to_column can not switch with index 12 rate mask 0
Jan  7 11:17:33 magnum kernel: [82754.048101] iwlwifi 0000:02:00.0: I rs_rate_scale_perform (HT SISO: 12): cur_tpt 25700 SR 12800 low 11 high 15 low_tpt 25000 high_tpt -1
Jan  7 11:17:33 magnum kernel: [82754.048105] iwlwifi 0000:02:00.0: I rs_get_rate_action Lower rate isn't better and good SR. Increase rate

--45Z9DzgjV8m4Oswq--

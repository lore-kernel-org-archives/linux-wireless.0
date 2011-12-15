Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44672 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab1LOL3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:29:55 -0500
Date: Thu, 15 Dec 2011 14:29:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: brcm: list of smatch warnings
Message-ID: <20111215112947.GB3906@elgon.mountain> (sfid-20111215_122958_635075_104435C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch still complains about the brcm driver.  Could you take a look at
these messages?  It's mostly just cleanups like doing the correct cast
for min_t() or handling the default cases on switch statements etc or
verifying that we broke out of a loop instead of coming to the end
without finding what we were looking for.

regards,
dan carpenter

drivers/net/wireless/brcm80211/brcmsmac/main.c +2902 brcms_b_read_objmem(11) info: ignoring unreachable code.
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c +1146 brcms_suspend(8) error: we previously assumed 'wl' could be null (see line 1145)
drivers/net/wireless/brcm80211/brcmsmac/srom.c +641 _initvars_srom_pci(16) error: potential null dereference 'entry'.  (kzalloc returns null)
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +19651 wlc_phy_init_nphy(209) error: potential null derefence 'tx_pwrctrl_tbl'.
	To hit this we need !PHY_IPA(pi), NREV_GE(pi->pubpi.phy_rev, 7),
	pi->pubpi.radiorev != 5 and pi->pubpi.radiorev != 3.  I don't
	know if that's possible.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +20544 wlc_phy_chan2freq_nphy(72) error: potential null derefence 'chan_info_tbl_p_2'.
	To hit this pi->pubpi.radiover != 0x0 and pi->pubpi.radiover != 0x1.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +20560 wlc_phy_chan2freq_nphy(88) error: potential null derefence 'chan_info_tbl_p_0'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +20610 wlc_phy_chan2freq_nphy(138) error: potential null derefence 'chan_info_tbl_p_1'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +20833 wlc_phy_chanspec_radio2056_setup(112) error: potential null derefence 'regs_SYN_2056_ptr'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +23657 wlc_phy_iqcal_gainparams_nphy(47) error: buffer overflow 'tbl_iqcal_gainparams_nphy[band_idx]' 9 <= 9
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +27498 wlc_phy_rc_sweep_nphy(179) warn: assigning -8 to unsigned variable 'rccal_val'
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +28273 wlc_phy_txpwr_apply_nphy(124) error: potential null derefence 'pwr_offsets2'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c +28328 wlc_phy_txpwr_apply_nphy(179) error: potential null derefence 'tx_srom_max_rate'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1710 wlc_phy_txpower_reg_limit_calc(50) error: potential null derefence 'txpwr_ptr1'.
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1719 wlc_phy_txpower_reg_limit_calc(59) error: potential null derefence 'txpwr_ptr2'.
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c +1377 brcmf_cfg80211_connect(65) warn: min_t truncates here '(sme->ssid_len)' (4294967295 vs 9223372036854775807)
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c +1275 brcmf_sdbrcm_rxglom(156) warn: min_t truncates here '(pfirst->len)' (2147483647 vs 4294967295)
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c +1457 brcmf_sdbrcm_rxglom(338) warn: min_t truncates here '(pfirst->len)' (2147483647 vs 4294967295)
drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c +300 brcmf_sdioh_request_buffer(10) warn: variable dereferenced before check 'pkt' (see line 295)


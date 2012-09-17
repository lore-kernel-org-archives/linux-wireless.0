Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50409 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2IQDnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 23:43:18 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20566.39957.867109.459668@gargle.gargle.HOWL> (sfid-20120917_054322_762910_A98EE6D5)
Date: Mon, 17 Sep 2012 09:12:13 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 0/3] Patches for compat 3.6.y
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches are for the 3.6.y branch in compat-drivers.

Sujith

Sujith Manoharan (3):
  compat-drivers: Add pending stable patches
  compat-drivers: Add new cherry picked patches
  compat-drivers: Add linux-next pending patches

 ...ize-power-level-initialization-for-CTL_-2.patch |   36 +
 ...ndentation-in-ar9003_hw_set_power_per_rat.patch |  169 +++
 ...-ath9k-Simplify-rate-table-initialization.patch |  140 ++
 .../0005-ath9k-Cleanup-RC-init-API.patch           |  240 ++++
 .../0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch |   76 ++
 ...007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch |   47 +
 ...08-ath9k-Cleanup-index-retrieval-routines.patch |  137 ++
 .../0009-ath9k-Change-rateset-calculation.patch    |   87 ++
 ...10-ath9k-Remove-ath_rc_set_valid_rate_idx.patch |   54 +
 ...h9k-Unify-valid-rate-calculation-routines.patch |  124 ++
 ...ot-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch |   24 +
 .../0013-ath9k-Fix-RTS-CTS-rate-selection.patch    |   78 ++
 ...out-properly-before-calculating-rate-inde.patch |   55 +
 .../0015-ath9k-Cleanup-TX-status-API.patch         |  164 +++
 .../0016-ath9k-Remove-MIMO-PS-specific-code.patch  |   29 +
 .../0017-ath9k-Trim-rate-table.patch               |  600 +++++++++
 ...tune-rc_stats-to-display-only-valid-rates.patch |   34 +
 ...-not-enable-the-MIB-interrupt-in-the-inte.patch |   28 +
 ...h9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch |   61 +
 .../0030-ath9k_hw-small-optimization.patch         |   53 +
 .../0031-ath9k-Fix-TX-filter-usage.patch           |   42 +
 ...-Fix-invalid-MCI-GPM-index-access-caching.patch |   41 +
 ...k-Fix-BTCOEX-timer-triggering-comparision.patch |   46 +
 ...35-ath9k-Make-use-of-ath_stop_ani-wrapper.patch |   25 +
 ...9k-Cleanup-add-change_interface-callbacks.patch |  144 ++
 ...ad-and-apply-thermometer-settings-from-EE.patch |   78 ++
 ...w-Read-and-configure-thermocal-for-AR9462.patch |   65 +
 ...eneric-hardware-timer-interrupt-in-debugf.patch |   54 +
 ...hw-Add-version-revision-macros-for-AR9565.patch |   94 ++
 .../0046-ath9k_hw-Add-AR9565-initvals.patch        | 1405 ++++++++++++++++++++
 .../0047-ath9k_hw-Add-AR9565-HW-support.patch      |  269 ++++
 ...-ath9k-Set-correct-max-streams-for-AR9565.patch |   39 +
 ...9-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch |  165 +++
 ...k_hw-Program-correct-PLL-value-for-AR9565.patch |   23 +
 .../0051-ath9k-Add-PCI-ID-for-AR9565.patch         |   23 +
 ...-ath9k_hw-Wait-BT-calibration-to-complete.patch |   72 +
 ...0053-ath9k_hw-use-peak-detection-for-5GHz.patch |   22 +
 ...54-ath9k_hw-add-8-points-for-5G-temp-slop.patch |  112 ++
 ...k_hw-Handle-gentimer-termination-properly.patch |   30 +
 ...-ath9k_hw-Rename-antenna-diversity-macros.patch |  173 +++
 ...7-ath9k-Choose-correct-LED-pin-for-AR9565.patch |   22 +
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |   31 +
 ...002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |   37 +
 ...flush-bt-profile-whenever-it-is-requested.patch |   88 ++
 ...-move-coex-param-updation-within-mci-work.patch |   57 +
 .../0005-ath9k-fill-led_pin-before-drv_start.patch |  108 ++
 .../0006-ath9k-fix-queuing-MCI-work-twice.patch    |  109 ++
 .../0007-ath9k-Enable-SGI-correctly.patch          |   34 +
 ...k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch |   50 +
 ...th9k-Remove-redundant-variable-assignment.patch |  185 +++
 ...ath9k-Remove-a-couple-of-unused-variables.patch |   21 +
 ...hw-Add-antenna-diversity-group-for-AR9565.patch |   94 ++
 .../0012-ath9k_hw-Update-AR9565-initvals.patch     |  172 +++
 ...h9k_hw-Add-a-HW-callback-to-set-diversity.patch |  213 +++
 ...dd-a-module-parameter-to-enable-diversity.patch |   68 +
 ...9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch |   21 +
 .../0001-rt2x00-Identify-ASUS-USB-N53-device.patch |   40 +
 ...word-size-of-rt2500usb-MAC_CSR19-register.patch |   59 +
 ...x-rfkill-polling-prior-to-interface-start.patch |  272 ++++
 ...usb-Added-rx-packet-length-validity-check.patch |   61 +
 ...8192ce-Log-message-that-B_CUT-device-may-.patch |   82 ++
 ...006-brcmfmac-fix-big-endian-bug-in-i-scan.patch |   35 +
 ...ac-Fix-big-endian-host-configuration-data.patch |   93 ++
 63 files changed, 7110 insertions(+)
 create mode 100644 linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
 create mode 100644 linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
 create mode 100644 linux-next-cherry-picks/0004-ath9k-Simplify-rate-table-initialization.patch
 create mode 100644 linux-next-cherry-picks/0005-ath9k-Cleanup-RC-init-API.patch
 create mode 100644 linux-next-cherry-picks/0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch
 create mode 100644 linux-next-cherry-picks/0007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
 create mode 100644 linux-next-cherry-picks/0008-ath9k-Cleanup-index-retrieval-routines.patch
 create mode 100644 linux-next-cherry-picks/0009-ath9k-Change-rateset-calculation.patch
 create mode 100644 linux-next-cherry-picks/0010-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
 create mode 100644 linux-next-cherry-picks/0011-ath9k-Unify-valid-rate-calculation-routines.patch
 create mode 100644 linux-next-cherry-picks/0012-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
 create mode 100644 linux-next-cherry-picks/0013-ath9k-Fix-RTS-CTS-rate-selection.patch
 create mode 100644 linux-next-cherry-picks/0014-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
 create mode 100644 linux-next-cherry-picks/0015-ath9k-Cleanup-TX-status-API.patch
 create mode 100644 linux-next-cherry-picks/0016-ath9k-Remove-MIMO-PS-specific-code.patch
 create mode 100644 linux-next-cherry-picks/0017-ath9k-Trim-rate-table.patch
 create mode 100644 linux-next-cherry-picks/0018-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
 create mode 100644 linux-next-cherry-picks/0022-ath9k_hw-do-not-enable-the-MIB-interrupt-in-the-inte.patch
 create mode 100644 linux-next-cherry-picks/0028-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
 create mode 100644 linux-next-cherry-picks/0030-ath9k_hw-small-optimization.patch
 create mode 100644 linux-next-cherry-picks/0031-ath9k-Fix-TX-filter-usage.patch
 create mode 100644 linux-next-cherry-picks/0033-ath9k_hw-Fix-invalid-MCI-GPM-index-access-caching.patch
 create mode 100644 linux-next-cherry-picks/0034-ath9k-Fix-BTCOEX-timer-triggering-comparision.patch
 create mode 100644 linux-next-cherry-picks/0035-ath9k-Make-use-of-ath_stop_ani-wrapper.patch
 create mode 100644 linux-next-cherry-picks/0037-ath9k-Cleanup-add-change_interface-callbacks.patch
 create mode 100644 linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
 create mode 100644 linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
 create mode 100644 linux-next-cherry-picks/0043-ath9k-Add-Generic-hardware-timer-interrupt-in-debugf.patch
 create mode 100644 linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0046-ath9k_hw-Add-AR9565-initvals.patch
 create mode 100644 linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
 create mode 100644 linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0049-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0051-ath9k-Add-PCI-ID-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0052-ath9k_hw-Wait-BT-calibration-to-complete.patch
 create mode 100644 linux-next-cherry-picks/0053-ath9k_hw-use-peak-detection-for-5GHz.patch
 create mode 100644 linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
 create mode 100644 linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
 create mode 100644 linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
 create mode 100644 linux-next-cherry-picks/0057-ath9k-Choose-correct-LED-pin-for-AR9565.patch
 create mode 100644 linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 create mode 100644 linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 create mode 100644 linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 create mode 100644 linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch
 create mode 100644 linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch
 create mode 100644 linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch
 create mode 100644 linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch
 create mode 100644 linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
 create mode 100644 linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch
 create mode 100644 linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch
 create mode 100644 linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
 create mode 100644 linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch
 create mode 100644 linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
 create mode 100644 linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch
 create mode 100644 linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
 create mode 100644 pending-stable/0001-rt2x00-Identify-ASUS-USB-N53-device.patch
 create mode 100644 pending-stable/0002-rt2x00-Fix-word-size-of-rt2500usb-MAC_CSR19-register.patch
 create mode 100644 pending-stable/0003-rt2x00-Fix-rfkill-polling-prior-to-interface-start.patch
 create mode 100644 pending-stable/0004-rt2800usb-Added-rx-packet-length-validity-check.patch
 create mode 100644 pending-stable/0005-rtlwifi-rtl8192ce-Log-message-that-B_CUT-device-may-.patch
 create mode 100644 pending-stable/0006-brcmfmac-fix-big-endian-bug-in-i-scan.patch
 create mode 100644 pending-stable/0007-brcmfmac-Fix-big-endian-host-configuration-data.patch

-- 
1.7.12


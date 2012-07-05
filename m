Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22488 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2GEE4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 00:56:35 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20469.7733.613739.886141@gargle.gargle.HOWL> (sfid-20120705_065646_840196_61E89DA8)
Date: Thu, 5 Jul 2012 10:25:17 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Stable compat-wireless updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A pull request for the 3.5.y branch.

Sujith

The following changes since commit a1959d00333104cd58bd07741ef0c40766836a77:

  compat-wireless: skip forcing refresh on gen-stable-release.sh (2012-06-19 15:24:07 -0700)

are available in the git repository at:

  https://github.com/sujith/compat-wireless.git linux-3.5.y

for you to fetch changes up to 73df80f65d3ab2a83275e2ffcb54b64484cf3821:

  compat-wireless: Update offsets of the new patches (2012-07-04 23:06:29 +0530)

----------------------------------------------------------------
Sujith Manoharan (6):
      compat-wireless: Remove patches from linux-next-pending
      compat-wireless: Add pending stable patches (v3.5-rc5)
      compat-wireless: Remove a patch
      compat-wireless: Update patch offsets
      compat-wireless: Add cherry picked patches
      compat-wireless: Update offsets of the new patches

 .../0001-ath9k-Fix-modal-EEPROM-dump.patch         |   19 +-
 .../0002-ath9k-Support-ethtool-getstats-api.patch  |    9 +-
 .../0003-wireless-Remove-casts-to-same-type.patch  |   17 +-
 ...-ath9k-fix-add-bits-for-spectral-scanning.patch |    5 -
 ...e-a-fair-beacon-distribution-in-IBSS-mode.patch |    7 +-
 .../0006-ath9k-Prune-ath9k_init_device.patch       |   13 +-
 .../0007-ath9k-Handle-ASPM-properly.patch          |   21 +-
 .../0008-ath9k-Setup-MCI-interrupts-properly.patch |   13 +-
 ...0009-ath9k_hw-Fix-AR_RTC_KEEP_AWAKE-usage.patch |   15 +-
 .../0010-ath9k_hw-Fix-MCI-usage.patch              |   37 +-
 .../0011-ath9k_hw-Cleanup-power-mode-API.patch     |   63 +-
 ...k-Add-MCI-interrupt-to-debugfs-statistics.patch |   11 +-
 .../0013-ath9k_hw-Fix-variable-usage.patch         |    7 +-
 .../0014-ath9k-Remove-SC_OP_OFFCHANNEL.patch       |   21 +-
 ...Use-separate-operational-flags-for-BTCOEX.patch |   23 +-
 ..._hw-update-ar9462-initval-table-to-fix-rx.patch |    9 +-
 .../0017-ath9k-cleanup-MCI-indentation.patch       |  110 +-
 ...8-ath9k_hw-fix-IQ-calibration-chain-index.patch |   13 +-
 .../0019-ath9k_hw-program-BT-to-control-SPDT.patch |    7 +-
 ...k_hw-configure-ar9462-switching-regulator.patch |   11 +-
 .../0021-ath9k_hw-fix-BT-RF-performance.patch      |   15 +-
 ...h9k-BT-coex-performance-tuning-for-AR9462.patch |   13 +-
 ...not-update-cycle-counters-with-sleep-mode.patch |    7 +-
 .../0024-ath9k_hw-fix-power-state-for-MCI.patch    |   13 +-
 ...0025-ath9k-improve-BT-FTP-PAN-performance.patch |   25 +-
 .../0026-ath9k-Group-link-monitoring-logic.patch   |   28 +-
 .../0027-ath9k-Fix-work-handling.patch             |   21 +-
 .../0028-ath9k-Move-LNA-code-to-antenna.c.patch    |   24 +-
 .../0029-ath9k-Use-atomic-operations.patch         |   87 +-
 ...30-ath9k-Handle-fatal-interrupts-properly.patch |   11 +-
 .../0031-ath9k-Fix-powersave-locking.patch         |   29 +-
 .../0032-ath9k-Resync-beacons-properly.patch       |   13 +-
 ...e-incompatible-IBSS-interface-check-in-ch.patch |   45 -
 .../0035-ath9k_hw-Initvals-update-for-AR9462.patch |    7 +-
 .../0037-ath9k_hw-Update-initvals-for-AR9462.patch |    7 +-
 ...se-legacy-rate-as-last-rate-of-MRR-series.patch |   11 +-
 ...estore-power-state-on-set-channel-failure.patch |    7 +-
 ...x-AR9462-power-consumption-on-idle-associ.patch |   19 +-
 ...eck-GPM-HW-write-pointer-before-chip-rese.patch |   15 +-
 ...9k_hw-fix-incorrect-LNA-register-settings.patch |   19 +-
 ...ogram-OBS-register-only-when-MCI-is-disab.patch |    7 +-
 ...ocess-MCI-interrupts-only-when-btcoex-is-.patch |    7 +-
 ...-ath9k-simplify-btcoex-profile-management.patch |   15 +-
 ...-ath9k-keep-btcoex-period-in-milliseconds.patch |   11 +-
 .../0047-ath9k-defer-btcoex-scheme-update.patch    |   21 +-
 .../0048-ath9k-fix-btcoex-duty-cycle.patch         |    9 +-
 .../0049-ath9k-Fix-softlockup-in-AR9485.patch      |    7 +-
 ...050-ath9k_hw-cleanup-MCI-gpm-offset-state.patch |   33 +-
 ...hw-add-utility-function-to-set-BT-version.patch |   15 +-
 ...9k_hw-remove-MCI_STATE_SEND_WLAN_CHANNELS.patch |   17 +-
 ...9k_hw-remove-MCI_STATE_NEED_FLUSH_BT_INFO.patch |    9 +-
 ...move-p_data-argument-from-ar9003_mci_stat.patch |   23 +-
 .../0055-ath9k_hw-remove-MCI_STATE_BT.patch        |   13 +-
 ...056-ath9k_hw-remove-MCI_STATE_CONT_-state.patch |   13 +-
 ...57-ath9k_hw-remove-MCI_STATE_SET_BT_SLEEP.patch |   11 +-
 .../0058-ath9k_hw-remove-aniState-noiseFloor.patch |   34 +-
 ...w-fix-OFDM-weak-signal-detection-handling.patch |   32 +-
 ...move-confusing-logic-inversion-in-an-ANI-.patch |   70 +-
 ...ean-up-fix-ANI-mode-checks-related-to-bea.patch |   41 +-
 ...th9k_hw-remove-the-old-ANI-implementation.patch |   90 +-
 ...ean-up-defines-and-variables-from-the-ANI.patch |  102 +-
 .../0064-ath9k-remove-MIB-interrupt-support.patch  |   53 +-
 ...w-fix-setting-lower-noise-immunity-values.patch |   46 +-
 ...h9k_hw-clean-up-ANI-OFDM-trigger-handling.patch |   39 +-
 ...k-fix-incorrect-profile-type-manupulation.patch |   43 +
 .../0068-ath9k_hw-fix-BT-mute-at-hw-init.patch     |   46 +
 .../0069-ath9k-fix-mci_is_enabled-utility.patch    |   27 +
 ...k_hw-update-ar9462-dac_async_fifo-initval.patch |   22 +
 ...71-ath9k_hw-fix-LNA-control-on-WLAN-sleep.patch |   57 +
 ...t-sampling-on-ani-timer-when-chip-is-in-s.patch |   37 +
 ...hw-rename-mrcCCKOff-to-fix-smatch-warning.patch |  124 +
 ...x-smatch-warning-in-ar9003_hw_spur_mitiga.patch |   36 +
 ...aise-aggregation-limit-to-64k-for-HT-IBSS.patch |   92 +
 .../0077-ath9k-Fix-lockdep-splat.patch             |   63 +
 ...anic-caused-by-returning-a-descriptor-we-.patch |   61 +
 .../0083-ath9k-Fix-compilation-breakage.patch      |   27 +
 .../0084-ath9k-fix-ANI-operation-in-AP-mode.patch  |  140 +
 ...ke-use-of-the-wrapper-to-check-for-MCI-in.patch |   26 +
 ...h9k-Fix-signedness-in-a-MCI-debug-message.patch |   26 +
 ...-update-AR934x-initvals-to-latest-version.patch |  800 +++++
 .../0088-ath9k-de-duplicate-initvals.patch         | 3768 ++++++++++++++++++++
 .../0089-ath9k-Fix-clearing-of-BTCOEX-flags.patch  |   28 +
 ...g-register-bit-shift-values-of-control-pa.patch |   32 +
 ...fix-invalid-pointer-access-in-the-tx-path.patch |   90 -
 ...9k-fix-a-tx-rate-duration-calculation-bug.patch |   46 -
 ...fix-invalid-pointer-access-in-the-tx-path.patch |   87 -
 pending-stable/.ignore                             |    2 +-
 ...il-authentication-when-AP-denied-authenti.patch |    6 +-
 ...2-rt2800usb-2001-3c17-is-an-RT3370-device.patch |    6 +-
 ...Fix-a-WARNING-on-suspend-resume-with-IBSS.patch |   72 -
 .../0004-ath9k-Fix-softlockup-in-AR9485.patch      |   66 -
 ...ear-ifmgd-bssid-only-after-building-DELBA.patch |   77 +
 ...0005-mwifiex-fix-11n-rx-packet-drop-issue.patch |   86 +
 ...6-mwifiex-fix-WPS-eapol-handshake-failure.patch |   39 +
 ...-ath9k-fix-dynamic-WEP-related-regression.patch |   78 +
 ...-iwlwifi-fix-activating-inactive-stations.patch |   54 +
 .../0009-rtlwifi-rtl8192cu-New-USB-IDs.patch       |   43 +
 ...ble-serialize_regmode-for-non-PCIE-AR9287.patch |   32 +
 ...stroy-assoc_data-correctly-if-assoc-fails.patch |   48 +
 99 files changed, 6384 insertions(+), 1468 deletions(-)
 delete mode 100644 linux-next-cherry-picks/0034-ath9k-remove-incompatible-IBSS-interface-check-in-ch.patch
 rename linux-next-pending/0003-ath9k_hw-remove-aniState-noiseFloor.patch => linux-next-cherry-picks/0058-ath9k_hw-remove-aniState-noiseFloor.patch (63%)
 rename linux-next-pending/0005-ath9k_hw-fix-OFDM-weak-signal-detection-handling.patch => linux-next-cherry-picks/0059-ath9k_hw-fix-OFDM-weak-signal-detection-handling.patch (61%)
 rename linux-next-pending/0006-ath9k_hw-remove-confusing-logic-inversion-in-an-ANI-variable.patch => linux-next-cherry-picks/0060-ath9k_hw-remove-confusing-logic-inversion-in-an-ANI-.patch (72%)
 rename linux-next-pending/0007-ath9k_hw-clean-up-fix-ANI-mode-checks-related-to-beacon-RSSI.patch => linux-next-cherry-picks/0061-ath9k_hw-clean-up-fix-ANI-mode-checks-related-to-bea.patch (54%)
 rename linux-next-pending/0008-ath9k_hw-remove-the-old-ANI-implementation.patch => linux-next-cherry-picks/0062-ath9k_hw-remove-the-old-ANI-implementation.patch (86%)
 rename linux-next-pending/0009-ath9k_hw-clean-up-defines-and-variables-from-the-ANI-implementation-split.patch => linux-next-cherry-picks/0063-ath9k_hw-clean-up-defines-and-variables-from-the-ANI.patch (74%)
 rename linux-next-pending/0010-ath9k-remove-MIB-interrupt-support.patch => linux-next-cherry-picks/0064-ath9k-remove-MIB-interrupt-support.patch (62%)
 rename linux-next-pending/0011-ath9k_hw-fix-setting-lower-noise-immunity-values.patch => linux-next-cherry-picks/0065-ath9k_hw-fix-setting-lower-noise-immunity-values.patch (58%)
 rename linux-next-pending/0012-ath9k_hw-clean-up-ANI-OFDM-trigger-handling.patch => linux-next-cherry-picks/0066-ath9k_hw-clean-up-ANI-OFDM-trigger-handling.patch (54%)
 create mode 100644 linux-next-cherry-picks/0067-ath9k-fix-incorrect-profile-type-manupulation.patch
 create mode 100644 linux-next-cherry-picks/0068-ath9k_hw-fix-BT-mute-at-hw-init.patch
 create mode 100644 linux-next-cherry-picks/0069-ath9k-fix-mci_is_enabled-utility.patch
 create mode 100644 linux-next-cherry-picks/0070-ath9k_hw-update-ar9462-dac_async_fifo-initval.patch
 create mode 100644 linux-next-cherry-picks/0071-ath9k_hw-fix-LNA-control-on-WLAN-sleep.patch
 create mode 100644 linux-next-cherry-picks/0072-ath9k-do-not-sampling-on-ani-timer-when-chip-is-in-s.patch
 create mode 100644 linux-next-cherry-picks/0073-ath9k_hw-rename-mrcCCKOff-to-fix-smatch-warning.patch
 create mode 100644 linux-next-cherry-picks/0074-ath9k_hw-fix-smatch-warning-in-ar9003_hw_spur_mitiga.patch
 create mode 100644 linux-next-cherry-picks/0076-ath9k-raise-aggregation-limit-to-64k-for-HT-IBSS.patch
 create mode 100644 linux-next-cherry-picks/0077-ath9k-Fix-lockdep-splat.patch
 create mode 100644 linux-next-cherry-picks/0082-ath9k-fix-panic-caused-by-returning-a-descriptor-we-.patch
 create mode 100644 linux-next-cherry-picks/0083-ath9k-Fix-compilation-breakage.patch
 create mode 100644 linux-next-cherry-picks/0084-ath9k-fix-ANI-operation-in-AP-mode.patch
 create mode 100644 linux-next-cherry-picks/0085-ath9k_hw-make-use-of-the-wrapper-to-check-for-MCI-in.patch
 create mode 100644 linux-next-cherry-picks/0086-ath9k-Fix-signedness-in-a-MCI-debug-message.patch
 create mode 100644 linux-next-cherry-picks/0087-ath9k-update-AR934x-initvals-to-latest-version.patch
 create mode 100644 linux-next-cherry-picks/0088-ath9k-de-duplicate-initvals.patch
 create mode 100644 linux-next-cherry-picks/0089-ath9k-Fix-clearing-of-BTCOEX-flags.patch
 create mode 100644 linux-next-cherry-picks/0090-ath9k-fixing-register-bit-shift-values-of-control-pa.patch
 delete mode 100644 linux-next-pending/0001-ath9k-fix-invalid-pointer-access-in-the-tx-path.patch
 delete mode 100644 linux-next-pending/0002-ath9k-fix-a-tx-rate-duration-calculation-bug.patch
 delete mode 100644 linux-next-pending/0004-ath9k-fix-invalid-pointer-access-in-the-tx-path.patch
 delete mode 100644 pending-stable/0003-ath9k-Fix-a-WARNING-on-suspend-resume-with-IBSS.patch
 delete mode 100644 pending-stable/0004-ath9k-Fix-softlockup-in-AR9485.patch
 create mode 100644 pending-stable/0004-mac80211-clear-ifmgd-bssid-only-after-building-DELBA.patch
 create mode 100644 pending-stable/0005-mwifiex-fix-11n-rx-packet-drop-issue.patch
 create mode 100644 pending-stable/0006-mwifiex-fix-WPS-eapol-handshake-failure.patch
 create mode 100644 pending-stable/0007-ath9k-fix-dynamic-WEP-related-regression.patch
 create mode 100644 pending-stable/0008-iwlwifi-fix-activating-inactive-stations.patch
 create mode 100644 pending-stable/0009-rtlwifi-rtl8192cu-New-USB-IDs.patch
 create mode 100644 pending-stable/0010-ath9k-enable-serialize_regmode-for-non-PCIE-AR9287.patch
 create mode 100644 pending-stable/0011-mac80211-destroy-assoc_data-correctly-if-assoc-fails.patch

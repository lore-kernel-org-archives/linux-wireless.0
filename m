Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46159 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2I0Gva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:51:30 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20579.63245.869737.277139@gargle.gargle.HOWL> (sfid-20120927_085136_044096_29620C88)
Date: Thu, 27 Sep 2012 12:19:49 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 0/5] Patches for compat-drivers/linux-3.6.y
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches are for the linux-3.6.y branch and backports
various AR9565-related fixes.

Sujith

Sujith Manoharan (5):
  compat-drivers: Refresh patches for next-20120926
  compat-drivers: Add pending stable patches
  compat-drivers: Refresh cherry picked patches
  compat-drivers: Move patches to cherry-picks
  compat-drivers: Add a few pending patches for AR9565

 ...ize-power-level-initialization-for-CTL_-2.patch |   2 +-
 ...ndentation-in-ar9003_hw_set_power_per_rat.patch |   2 +-
 ...ad-and-apply-thermometer-settings-from-EE.patch |   6 +-
 ...w-Read-and-configure-thermocal-for-AR9462.patch |   4 +-
 ...hw-Add-version-revision-macros-for-AR9565.patch |   8 +-
 .../0047-ath9k_hw-Add-AR9565-HW-support.patch      |  34 ++--
 ...-ath9k-Set-correct-max-streams-for-AR9565.patch |   2 +-
 ...k_hw-Program-correct-PLL-value-for-AR9565.patch |   2 +-
 ...54-ath9k_hw-add-8-points-for-5G-temp-slop.patch |   4 +-
 ...k_hw-Handle-gentimer-termination-properly.patch |   2 +-
 ...-ath9k_hw-Rename-antenna-diversity-macros.patch |   4 +-
 .../0058-ath9k-Enable-SGI-correctly.patch          |  35 ++++
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |  32 +++
 ...060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |  38 ++++
 ...flush-bt-profile-whenever-it-is-requested.patch |  89 +++++++++
 ...-move-coex-param-updation-within-mci-work.patch |  58 ++++++
 .../0063-ath9k-fill-led_pin-before-drv_start.patch | 109 +++++++++++
 .../0064-ath9k-fix-queuing-MCI-work-twice.patch    | 110 +++++++++++
 ...e-hw_timer_enabled-to-false-when-we-stop-.patch |  55 ++++++
 ...k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch |  51 +++++
 ...th9k-Remove-redundant-variable-assignment.patch | 186 ++++++++++++++++++
 ...ath9k-Remove-a-couple-of-unused-variables.patch |  22 +++
 ...hw-Add-antenna-diversity-group-for-AR9565.patch |  95 +++++++++
 .../0071-ath9k_hw-Update-AR9565-initvals.patch     | 173 +++++++++++++++++
 ...h9k_hw-Add-a-HW-callback-to-set-diversity.patch | 214 +++++++++++++++++++++
 ...dd-a-module-parameter-to-enable-diversity.patch |  69 +++++++
 ...9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch |  22 +++
 ...th9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch |  34 ++++
 ...dle-errors-properly-in-MCI-initialization.patch | 128 ++++++++++++
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |  31 ---
 ...-debugfs-file-to-adjust-antenna-diversity.patch |  99 ++++++++++
 ...002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |  37 ----
 ...-ath9k-Fix-chainmask-selection-for-AR9462.patch |  43 +++++
 ...flush-bt-profile-whenever-it-is-requested.patch |  88 ---------
 .../0004-ath9k-Enable-MCI-for-AR9565.patch         |  63 ++++++
 ...-move-coex-param-updation-within-mci-work.patch |  57 ------
 .../0005-ath9k-fill-led_pin-before-drv_start.patch | 108 -----------
 .../0006-ath9k-fix-queuing-MCI-work-twice.patch    | 109 -----------
 .../0007-ath9k-Enable-SGI-correctly.patch          |  34 ----
 ...k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch |  50 -----
 ...th9k-Remove-redundant-variable-assignment.patch | 185 ------------------
 ...ath9k-Remove-a-couple-of-unused-variables.patch |  21 --
 ...hw-Add-antenna-diversity-group-for-AR9565.patch |  94 ---------
 .../0012-ath9k_hw-Update-AR9565-initvals.patch     | 172 -----------------
 ...h9k_hw-Add-a-HW-callback-to-set-diversity.patch | 213 --------------------
 ...dd-a-module-parameter-to-enable-diversity.patch |  68 -------
 ...9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch |  21 --
 patches/0001-netdev_ops.patch                      |   2 +-
 patches/04-netns.patch                             |   2 +-
 patches/11-dev-pm-ops.patch                        |  12 +-
 patches/14-device-type.patch                       |   2 +-
 patches/29-sdio_no_suspend.patch                   |   2 +-
 patches/62-usb_driver_lpm.patch                    |  10 +-
 ...h-mgmt-Fix-enabling-SSP-while-powered-off.patch |  43 +++++
 ...th-mgmt-Fix-enabling-LE-while-powered-off.patch |  46 +++++
 ...h-Fix-not-removing-power_off-delayed-work.patch |  76 ++++++++
 ...x-possible-circular-lock-on-reg_regdb_sea.patch | 129 +++++++++++++
 ...-t-double-free-the-interrupt-in-failure-p.patch |  33 ++++
 ...gmt-Implement-support-for-passkey-notific.patch | 214 +++++++++++++++++++++
 ...ooth-Update-management-interface-revision.patch |  36 ++++
 ...dd-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch |  31 +++
 .../0009-ath9k-Disable-ASPM-only-for-AR9285.patch  |  38 ++++
 62 files changed, 2421 insertions(+), 1338 deletions(-)
 create mode 100644 linux-next-cherry-picks/0058-ath9k-Enable-SGI-correctly.patch
 create mode 100644 linux-next-cherry-picks/0059-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 create mode 100644 linux-next-cherry-picks/0060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 create mode 100644 linux-next-cherry-picks/0061-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 create mode 100644 linux-next-cherry-picks/0062-ath9k-move-coex-param-updation-within-mci-work.patch
 create mode 100644 linux-next-cherry-picks/0063-ath9k-fill-led_pin-before-drv_start.patch
 create mode 100644 linux-next-cherry-picks/0064-ath9k-fix-queuing-MCI-work-twice.patch
 create mode 100644 linux-next-cherry-picks/0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch
 create mode 100644 linux-next-cherry-picks/0067-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
 create mode 100644 linux-next-cherry-picks/0068-ath9k-Remove-redundant-variable-assignment.patch
 create mode 100644 linux-next-cherry-picks/0069-ath9k-Remove-a-couple-of-unused-variables.patch
 create mode 100644 linux-next-cherry-picks/0070-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0071-ath9k_hw-Update-AR9565-initvals.patch
 create mode 100644 linux-next-cherry-picks/0072-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
 create mode 100644 linux-next-cherry-picks/0073-ath9k-Add-a-module-parameter-to-enable-diversity.patch
 create mode 100644 linux-next-cherry-picks/0074-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch
 create mode 100644 linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch
 delete mode 100644 linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 create mode 100644 linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
 delete mode 100644 linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 create mode 100644 linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch
 delete mode 100644 linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 create mode 100644 linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch
 delete mode 100644 linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch
 delete mode 100644 linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch
 delete mode 100644 linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch
 delete mode 100644 linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch
 delete mode 100644 linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
 delete mode 100644 linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch
 delete mode 100644 linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch
 delete mode 100644 linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
 delete mode 100644 linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch
 delete mode 100644 linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
 delete mode 100644 linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch
 delete mode 100644 linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
 create mode 100644 pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch
 create mode 100644 pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch
 create mode 100644 pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch
 create mode 100644 pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch
 create mode 100644 pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch
 create mode 100644 pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch
 create mode 100644 pending-stable/0007-Bluetooth-Update-management-interface-revision.patch
 create mode 100644 pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch
 create mode 100644 pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch

-- 
1.7.12.1


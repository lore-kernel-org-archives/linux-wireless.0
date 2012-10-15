Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29268 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2JONWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 09:22:44 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 0/3] Patches for compat-drivers/linux-3.6.y
Date: Mon, 15 Oct 2012 18:52:15 +0530
Message-ID: <1350307338-8133-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121015_152248_294214_63F31AB8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches are for linux-3.6.y branch and has BT coex
fixes for AR9565.

Bala Shanmugam (3):
  compat-drivers: Update pending stable patches.
  compat-drivers: Move next-pending patches to cherry-picks.
  compat-drivers: Add new cherry-pick and next-pending  patches

 ...dle-errors-properly-in-MCI-initialization.patch | 128 ++++++++++++
 ...-debugfs-file-to-adjust-antenna-diversity.patch |  99 ++++++++++
 ...-ath9k-Fix-chainmask-selection-for-AR9462.patch |  43 +++++
 .../0080-ath9k-Enable-MCI-for-AR9565.patch         |  63 ++++++
 ...81-ath9k-Fix-BTCOEX-weight-initialization.patch | 176 +++++++++++++++++
 ...dle-errors-properly-in-MCI-initialization.patch | 128 ------------
 ...01-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |  34 ++++
 ...-debugfs-file-to-adjust-antenna-diversity.patch |  99 ----------
 ...2-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |  28 +++
 ...-ath9k-Fix-chainmask-selection-for-AR9462.patch |  43 -----
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |  33 ++++
 .../0004-ath9k-Enable-MCI-for-AR9565.patch         |  63 ------
 ...off-RXIQ-calibration-while-re-calibrating.patch |  46 +++++
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |  34 ++++
 ...0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |  66 +++++++
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |  28 +++
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |  47 +++++
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |  21 ++
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |  21 ++
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |  44 +++++
 ...012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |  63 ++++++
 ...h-mgmt-Fix-enabling-SSP-while-powered-off.patch |  43 -----
 ...th-mgmt-Fix-enabling-LE-while-powered-off.patch |  46 -----
 ...h-Fix-not-removing-power_off-delayed-work.patch |  76 --------
 ...x-possible-circular-lock-on-reg_regdb_sea.patch | 129 -------------
 ...-t-double-free-the-interrupt-in-failure-p.patch |  33 ----
 ...gmt-Implement-support-for-passkey-notific.patch | 214 ---------------------
 ...ooth-Update-management-interface-revision.patch |  36 ----
 ...dd-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch |  31 ---
 .../0009-ath9k-Disable-ASPM-only-for-AR9285.patch  |  38 ----
 30 files changed, 974 insertions(+), 979 deletions(-)
 create mode 100644 linux-next-cherry-picks/0077-ath9k-Handle-errors-properly-in-MCI-initialization.patch
 create mode 100644 linux-next-cherry-picks/0078-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
 create mode 100644 linux-next-cherry-picks/0079-ath9k-Fix-chainmask-selection-for-AR9462.patch
 create mode 100644 linux-next-cherry-picks/0080-ath9k-Enable-MCI-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0081-ath9k-Fix-BTCOEX-weight-initialization.patch
 delete mode 100644 linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch
 create mode 100644 linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 delete mode 100644 linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
 create mode 100644 linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 delete mode 100644 linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch
 create mode 100644 linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 delete mode 100644 linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch
 create mode 100644 linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 create mode 100644 linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 create mode 100644 linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 create mode 100644 linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 create mode 100644 linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 create mode 100644 linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 create mode 100644 linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 create mode 100644 linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 create mode 100644 linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
 delete mode 100644 pending-stable/0001-Bluetooth-mgmt-Fix-enabling-SSP-while-powered-off.patch
 delete mode 100644 pending-stable/0002-Bluetooth-mgmt-Fix-enabling-LE-while-powered-off.patch
 delete mode 100644 pending-stable/0003-Bluetooth-Fix-not-removing-power_off-delayed-work.patch
 delete mode 100644 pending-stable/0004-cfg80211-fix-possible-circular-lock-on-reg_regdb_sea.patch
 delete mode 100644 pending-stable/0005-iwlwifi-don-t-double-free-the-interrupt-in-failure-p.patch
 delete mode 100644 pending-stable/0006-Bluetooth-mgmt-Implement-support-for-passkey-notific.patch
 delete mode 100644 pending-stable/0007-Bluetooth-Update-management-interface-revision.patch
 delete mode 100644 pending-stable/0008-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch
 delete mode 100644 pending-stable/0009-ath9k-Disable-ASPM-only-for-AR9285.patch

-- 
1.7.11.4


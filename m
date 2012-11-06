Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43121 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2KFKbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 05:31:31 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 0/2] Patches for compat-drivers/linux-3.6.y
Date: Tue, 6 Nov 2012 16:01:32 +0530
Message-ID: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121106_113146_476132_134C1156)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches are for linux-3.6.y branch and has
fixes for AR9565.

Balas (2):
  compat-drivers: Move next-pending patches to cherry-picks
  compat-drivers: Add a next-pending patch.

 ...5-ath9k-fix-ASPM-initialization-on-resume.patch |   40 +++
 ...-ath9k-improve-suspend-resume-reliability.patch |  117 ++++++++
 .../0088-cfg80211-fix-antenna-gain-handling.patch  |   39 +++
 ...k-Use-a-helper-routine-for-MCI-FTP-tuning.patch |   72 +++++
 .../0090-ath9k-Fix-BT_OP_SCAN-usage.patch          |   95 ++++++
 ...091-ath9k-perform-ANI-cycle-in-idle-state.patch |  107 +++++++
 ...tale-pointers-potentially-causing-access-.patch |   43 +++
 .../0094-ath9k-Send-WLAN-channel-info-to-BT.patch  |  147 +++++++++
 ...oncurrent-WLAN-and-BT-tx-support-for-MCI-.patch |  264 +++++++++++++++++
 .../0096-ath9k-fill-channel-mode-in-caldata.patch  |   44 +++
 ...djust-WLAN-and-BT-concurrent-transmission.patch |  313 ++++++++++++++++++++
 ...00-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |   42 +++
 ...1-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |   34 +++
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |   39 +++
 ...off-RXIQ-calibration-while-re-calibrating.patch |   54 ++++
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |   42 +++
 ...0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |   76 +++++
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |   34 +++
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |   57 ++++
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |   27 ++
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |   27 ++
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |   52 ++++
 ...111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |   63 ++++
 ...9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch |   49 +++
 ...9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch |   51 ++++
 ...9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch |   38 +++
 .../0118-ath9k-Dump-BTCOEX-tuning-parameters.patch |  148 +++++++++
 ...for-TID-only-in-BlockAcks-while-checking-.patch |   65 ++++
 ...01-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |   34 ---
 ...x-signal-strength-noise-measurements-on-a.patch |   28 ++
 ...2-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |   28 --
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |   33 --
 ...off-RXIQ-calibration-while-re-calibrating.patch |   46 ---
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |   34 ---
 ...0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |   66 ----
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |   28 --
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |   47 ---
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |   21 --
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |   21 --
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |   44 ---
 ...012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |   63 ----
 41 files changed, 2207 insertions(+), 465 deletions(-)
 create mode 100644 linux-next-cherry-picks/0085-ath9k-fix-ASPM-initialization-on-resume.patch
 create mode 100644 linux-next-cherry-picks/0086-ath9k-improve-suspend-resume-reliability.patch
 create mode 100644 linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
 create mode 100644 linux-next-cherry-picks/0089-ath9k-Use-a-helper-routine-for-MCI-FTP-tuning.patch
 create mode 100644 linux-next-cherry-picks/0090-ath9k-Fix-BT_OP_SCAN-usage.patch
 create mode 100644 linux-next-cherry-picks/0091-ath9k-perform-ANI-cycle-in-idle-state.patch
 create mode 100644 linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
 create mode 100644 linux-next-cherry-picks/0094-ath9k-Send-WLAN-channel-info-to-BT.patch
 create mode 100644 linux-next-cherry-picks/0095-ath9k-Add-concurrent-WLAN-and-BT-tx-support-for-MCI-.patch
 create mode 100644 linux-next-cherry-picks/0096-ath9k-fill-channel-mode-in-caldata.patch
 create mode 100644 linux-next-cherry-picks/0097-ath9k-adjust-WLAN-and-BT-concurrent-transmission.patch
 create mode 100644 linux-next-cherry-picks/0100-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0101-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 create mode 100644 linux-next-cherry-picks/0102-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 create mode 100644 linux-next-cherry-picks/0103-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 create mode 100644 linux-next-cherry-picks/0104-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 create mode 100644 linux-next-cherry-picks/0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 create mode 100644 linux-next-cherry-picks/0106-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0107-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 create mode 100644 linux-next-cherry-picks/0108-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0109-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0110-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 create mode 100644 linux-next-cherry-picks/0111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
 create mode 100644 linux-next-cherry-picks/0115-ath9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0116-ath9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch
 create mode 100644 linux-next-cherry-picks/0117-ath9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch
 create mode 100644 linux-next-cherry-picks/0118-ath9k-Dump-BTCOEX-tuning-parameters.patch
 create mode 100644 linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
 delete mode 100644 linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 create mode 100644 linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
 delete mode 100644 linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 delete mode 100644 linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 delete mode 100644 linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 delete mode 100644 linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 delete mode 100644 linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 delete mode 100644 linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 delete mode 100644 linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 delete mode 100644 linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 delete mode 100644 linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 delete mode 100644 linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 delete mode 100644 linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch

-- 
1.7.4.1


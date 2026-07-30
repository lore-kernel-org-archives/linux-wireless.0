Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A741C44211B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422109; cv=none; b=mOtdW7TBGzKLVOW81xbavWs2G6h2ksUiov71Lp4/c9m4Hfd9b2BDz4jlGRyvuYSvtwmAtuEeCCz5lE1gIlBZhC5aQdhxWImn5oMwIHx+5q9W2kf9Q3GuQt0VHEE6QOQtJKku3V72p9gj2GSi/pfLfu8KT3+9IMgcHuyVLFc3Dzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422109; c=relaxed/simple;
	bh=4jxrn4ZV17oiZnKQGv/vvua35JDDkL1UzbdFPhr+s48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AS0UJxoFi7fX3sEkNxReKMKjJICOlWPEaRpp2zuNVCOR1GzM/iTW+ZrxmZpGPgpLAqUb/N/VSuat2/+7lz9WstWN+xSCxkT2HV67ypf63pVlrvCjNR6uuM7kVB8GjJRATH4dFKl9tf3BT4yQbFr6P3LnN0akhmoAy66ir/8Y6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LcLS3kBa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LcLS3kBa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=mv+lLm4u8AEhybNg9O5TKm/nca+D82/EFX3SLgScuoU=; t=1785422106; x=1786631706; 
	b=LcLS3kBaPWas8h//+fYK8cbQge7B8Jq6KHHQJQpcEpH0C5HWVLDazNa0gthyRZlxqF9btdYXds6
	EO3dDLHhX3TKsbHH71UhxTmSEpsqsPWS20ez6hVoeD1XZ9/BqLXJsL5wwWDusKddyhJ/2ddmgdc5J
	MAQjiR7IjG0JQn+sXRm02Z0+UoGlJi8aPCVmSYLyk9grXUOUuKSSNVO2xsegeRwvWpvA59r59ed5t
	aR3vG3XVDx513Kb3xn8X5HCzfJVGa3kfg7OorITKabZbD5N78gS6IBUwr/nyu1eVhPetsZQvH4PqP
	mVF5WUqMmFVUpwLEiRLVHRQKR1mxdpHzE3PQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpRqV-00000004mKH-47KW;
	Thu, 30 Jul 2026 16:34:52 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Jouni Malinen <j@w1.fi>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 0/8] Adding NO_STA flag and reworking RX link resolution
Date: Thu, 30 Jul 2026 16:34:16 +0200
Message-ID: <20260730143415.1833312-10-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Hi,

This patchset refactors the RX link resolution a bit to fix some issues
where mac80211 might accept frames on the wrong link and incorrectly
translate the address. It also adds a new NL80211_ATTR_FRAME_CMD_NO_STA
flag so that userspace can know whether address translation was done by
the kernel on RX and can also prevent address translation for management
frames during TX.

This together should be enough to fix the existing issues in hostapd
where stations that are still associated try to authenticate again but
hostapd for example ends up sending the frame to an old link address.

Benjamin

Changes in v1:
 * Add NAN_DATA interface handling
 * Handle NO_STA flag correctly for NAN
 * Fixed forwarding of station parameter
 * Rebase and other small fixes

Changes in RFCv2:
 * Port other drivers to new API (untested)
 * Fix a checkpatch warning

Benjamin Berg (8):
  wifi: iwlwifi: use link_sta internally to the driver
  wifi: mac80211: change public RX API to use link stations
  wifi: mac80211: refactor RX link_id and station handling
  wifi: mac80211: rework RX packet handling
  wifi: cfg80211: add attribute for TX/RX denoting there is no station
  wifi: mac80211: report to cfg80211 when no STA is known for a frame
  wifi: mac80211: pass station to ieee80211_tx_skb_tid
  wifi: mac80211: pass error station if non-STA transmit was requested

 drivers/net/wireless/ath/ath11k/dp_rx.c       |   2 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c      |   2 -
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  20 +-
 drivers/net/wireless/ath/ath12k/hw.h          |  20 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  20 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  12 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |   6 +-
 drivers/net/wireless/ath/ath12k/wmi.c         |   6 -
 drivers/net/wireless/intel/iwlwifi/mld/agg.c  |  17 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.h  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  50 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.h   |   2 +-
 .../wireless/intel/iwlwifi/mld/tests/agg.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c |  22 +-
 drivers/net/wireless/realtek/rtw89/core.c     |   6 -
 .../wireless/virtual/mac80211_hwsim_main.c    |   3 -
 include/net/cfg80211.h                        |   4 +
 include/net/mac80211.h                        |  25 +-
 include/uapi/linux/nl80211.h                  |   7 +
 net/mac80211/agg-tx.c                         |   4 +-
 net/mac80211/ap.c                             |   3 -
 net/mac80211/ht.c                             |   2 +-
 net/mac80211/ieee80211_i.h                    |  11 +-
 net/mac80211/iface.c                          |   7 +-
 net/mac80211/mlme.c                           |  10 +-
 net/mac80211/offchannel.c                     |  13 +-
 net/mac80211/rx.c                             | 447 ++++++++++--------
 net/mac80211/scan.c                           |  10 +-
 net/mac80211/tdls.c                           |   2 +-
 net/mac80211/tx.c                             |  10 +-
 net/wireless/nl80211.c                        |   8 +-
 33 files changed, 413 insertions(+), 357 deletions(-)

-- 
2.55.0


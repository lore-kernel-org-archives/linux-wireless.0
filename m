Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B37356777;
	Thu, 21 May 2026 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377357; cv=none; b=IR7vjF/e1A1xPkETTicdR51EO2xUbv0Rb6rxONtKyDiMIAz7mPaKtmJxdT7rvzKY7B3fUVTQ934NlQXKXWXzJp8gcW78wluuUqW95AroV/0QNhzRuhsbomvCJzbKg1TMz1SFeRfOmap4TW8FvyJQX2+mcfxW949GnofMdGD5fNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377357; c=relaxed/simple;
	bh=oYb9pOd8j/gebtlzVpdfdiIflXcqCMRkzK3DNBqg1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NF675Dwq4ohNADA12zIgpRSctEk4VNtjVCZsumMo3a9jeIpvSonfDXf1kESnwcVpcDTMJhWXwwc5Az/jf0udBjECiRjF2xTEA/K0JIXVC7PYPlvIjGTEhCTGSh/gXphzQP0M953vPiFCgT/fciSCfMzXRQelGr8OIj/tW/vzcFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ceI+wNUi; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ceI+wNUi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=VE9xJYyXf5sDwGiPYUXsoTr1XxVuLoI26S6XQ9SaNKo=; t=1779377355; x=1780586955; 
	b=ceI+wNUihyx8L1KNGbMPDJc9eNuNDZgaMa7X/eMNzJQzB7pNO4NBYt+e6CQRuhaGvCzmbVWG9C7
	Enp2DDDB8s4HxgjdLtqAHP4klDTnpYAGv+kNYN0DV9QlqMoarE1makLn8CbLlyCe0Whvtt3U1mgDz
	mz2zSZ6/bgiffhC6t8KxU1uTfLjERIoBBt7/q+dZri4/6Sd5R6UozcrEZeJqfDfj2cZSO7tKJEcIb
	qJ5CoaUjaqRdC3KQk0eEmrN59aHhT7VdSUdwgbutDzZEy0Hv66REIDcH64KA5BgobuC4mYDUwTolh
	cFYuiEoaOS9jCq5B8AZSXqHFdGUXuyzZvOfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wQ5Kd-0000000CgLZ-09IJ;
	Thu, 21 May 2026 17:29:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-05-21
Date: Thu, 21 May 2026 17:28:37 +0200
Message-ID: <20260521152903.374070-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Sorry for the last minute thing ... if it makes it at all.
I forgot during the day, and it's already more because we
had a holiday last week.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit fcee7d82f27d6a8b1ddc5bbefda59b4e441e9bc0:

  Merge tag 'net-7.1-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-05-07 10:32:03 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-05-21

for you to fetch changes up to dc14686f27df6454b13b16ad1c9203ab3e9b0375:

  wifi: cfg80211: wext: validate chandef in monitor mode (2026-05-20 11:44:19 +0200)

----------------------------------------------------------------
Quite a few more updates:
 - cfg80211/mac80211:
   - various security(-ish) fixes
   - fix A-MSDU subframe handling
   - fix multi-link element parsing
 - ath10: avoid sending commands to dead device
 - ath11k:
   - fix WMI buffer leaks on error conditions
   - fix UAF in RX MSDU coalesce path
   - allow peer ID 0 on RX path (legal for mobile devices)
   - reinitialize shared SRNG pointers on restart
 - ath12k:
   - fix 20 MHz-only parsing of EHT-MCS map
 - iwlwifi:
   - fix TSO segmentation explosion
   - don't TX to dead device
   - fix warning in WoWLAN
   - fix TX rates on old devices
   - disconnect on beacon loss only if also no other traffic
   - fill NULL-ptr deref
   - fix STEP_URM hardware access

----------------------------------------------------------------
Alexandru Hossu (1):
      wifi: mac80211: bounds-check link_id in ieee80211_ml_epcs

Baochen Qiang (1):
      wifi: ath12k: fix EHT TX MCS limitation due to wrong 20 MHz-only parsing

Cole Leavitt (1):
      wifi: iwlwifi: mld: fix TSO segmentation explosion when AMSDU is disabled

Emmanuel Grumbach (2):
      wifi: iwlwifi: mld: disconnect only after 6 beacons without Rx
      wifi: mac80211: don't override max_amsdu_subframes

Johannes Berg (6):
      wifi: iwlwifi: mvm: fix driver-set TX rates on old devices
      wifi: iwlwifi: mld: don't WARN on WoWLAN suspend w/o BSS vif
      wifi: mac80211: fix MLE defragmentation
      wifi: mac80211: fix multi-link element inheritance
      Merge tag 'iwlwifi-fixes-2026-05-16' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'ath-current-20260519' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

John Walker (1):
      wifi: cfg80211: advance loop vars in cfg80211_merge_profile()

Kang Yang (1):
      wifi: ath10k: skip WMI and beacon transmission when device is wedged

Kartik Nair (1):
      wifi: cfg80211: wext: validate chandef in monitor mode

Kyle Farnung (1):
      wifi: ath11k: clear shared SRNG pointer state on restart

Matthew Leach (1):
      wifi: ath11k: fix peer resolution on rx path when peer_id=0

Michael Bommarito (1):
      wifi: mac80211: consume only present negotiated TTLM maps

Miri Korenblit (1):
      wifi: iwlwifi: mld: don't dereference a pointer before NULL checking it

Moriya Itzchaki (1):
      wifi: iwlwifi: use correct function to read STEP_URM register

Nicolas Escande (3):
      wifi: ath11k: fix error path leaks in some WMI WOW calls
      wifi: ath11k: fix error path leaks in some WMI calls
      wifi: ath11k: fix error path leak in ath11k_tm_cmd_wmi_ftm()

Sheroz Juraev (1):
      wifi: iwlwifi: mld: stop TX during firmware restart

Shitalkumar Gandhi (1):
      wifi: wilc1000: fix dma_buffer leak on bus acquire failure

Willmar Knikker (1):
      wifi: ath11k: fix use after free in ath11k_dp_rx_msdu_coalesce()

Zhao Li (1):
      wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb

 drivers/net/wireless/ath/ath10k/wmi.c              |  17 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   9 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  14 ++-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   5 +-
 drivers/net/wireless/ath/ath11k/testmode.c         |   1 +
 drivers/net/wireless/ath/ath11k/wmi.c              | 131 ++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/mac.c              |   8 +-
 drivers/net/wireless/intel/iwlwifi/mld/constants.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |  13 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c        |  15 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  27 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  14 +--
 .../intel/iwlwifi/pcie/gen1_2/trans-gen2.c         |   6 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   2 +-
 net/mac80211/cfg.c                                 |   5 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/parse.c                               | 107 ++++++++++-------
 net/mac80211/rx.c                                  |   6 +-
 net/wireless/scan.c                                |   3 +
 net/wireless/wext-compat.c                         |   2 +
 21 files changed, 276 insertions(+), 124 deletions(-)

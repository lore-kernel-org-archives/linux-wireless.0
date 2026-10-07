Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC29F392836;
	Wed,  7 Oct 2026 20:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791406714; cv=none; b=OgRwUZDVGDh/wvbjrc0nu020wZBUmaaM2a9xcxx9LZkGWuWxpzt8YUyV5TG5dkVJlETBEcSAHC4tUkOmnNAK/0XDv39/35sdJzOpbr0Hjdlo31nYyDWTBWkdO6qq5i2awUpwn7WCrxluoQEFLld0CXTqCJlqJTT15xIZk4SSVe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791406714; c=relaxed/simple;
	bh=iy1LS0C2QMrCaLxAqAZmVWmZt3eW/d2g8ku+6sdlfWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ngULOMSXV65Ukp76RMwBWOV9km6D7VAWfvmAtpzJijBvDH8GweDbUZIeoIROyk6VAx/q+/vaI/4Hm/DFQQlgecsRN1vHitK2rM7XlFMqrNHWjVjjqkrTtF6V0W8DDdJB4c9JXEeMw+0qUX0+id1eRjSba/zfGmGNDeuQQ4ulStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=M4G1KOnd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="M4G1KOnd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=ay4z3GniYzsCTi7q2jajnUo8JDHtZuNjIvYlZVR0uUI=; t=1791406712; x=1792616312; 
	b=M4G1KOndAw3qucF2jzYAFHg93TS1sEjndR4pWKgYQ9i4omWEES9wKYvfZCPBHmJFZGrzWxRrvQF
	/7y3VGyr/Z3AV3k6zP0a3nv6OYPYakSqVCaaVjJ5PyEIJCu5/RmwT4ECirAQp/j4xesLkqAvAFmis
	YJ0TjKdvZh9WMuzOBFblH7qSP2Yv00WQZVH8RNpylyf5jWK3G0QAHvwtunUZJRavVSEnhiwXzLZwq
	7qjPYSNpyVzWo9Zk2ivkBgy//x3qYIVEJeWZErQM2Yaf139L+xHIsXgO7KgoN9J/kO1BtNOyJI6PK
	zMH1fnkzUfbXPwrNLtRnT/Vdrq/NPJ6rXemw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEYib-00000008OSN-48DJ;
	Wed, 07 Oct 2026 22:58:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-10-07
Date: Wed,  7 Oct 2026 22:57:00 +0200
Message-ID: <20261007205827.467974-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

Hi,

Nothing much going on in wireless-next. However, next time
I hope to land my RTNL-redux series which will (almost)
completely wean the wireless stack off the RTNL, except in
places where we need it for netdev register/unregister/etc.

I need to see what's going on with the per-netns mutex now,
can we already use that instead?

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit f49defea7668d8c68ec19fa085ef3da6075561c7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 11:02:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-10-07

for you to fetch changes up to b6f009284138884c4b07bbef7b07d780aa9b5daf:

  wifi: mac80211: use the AP address as RA for a 4-addr MLO station (2026-10-06 21:05:18 +0200)

----------------------------------------------------------------
Not too much going on:
 - brcmfmac: plenty of improvements
 - mac80211: NAN Instant Communications support
 - iwlegacy: remove sysfs
 - nxpwifi: IW610 support
 - couple of fixes for recent regressions

----------------------------------------------------------------
Aamir Ahmed (1):
      wifi: nxpwifi: validate variable IE lengths in beacon parser

Aaradhana Sahu (1):
      wifi: mac80211: Do not report BSS parameters in AP station info

Aloka Dixit (2):
      Revert "wifi: mac80211: do not use old MBSSID elements"
      wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()

Andrei-Alexandru Bleortu (1):
      wifi: mac80211: keep the BSS color while a color change is pending

Benjamin Drung (2):
      wifi: brcmfmac: Add per-board clm_blob firmware binaries
      wifi: brcmfmac: Add clm_blob firmware for brcmfmac43456-sdio

Dan Carpenter (3):
      wifi: b43: don't pass unterminated string to sscanf()
      wifi: b43legacy: debugfs: NUL terminate string in debugfs
      wifi: carl9170: NUL terminate string in debugfs

Dominic White (1):
      wifi: cfg80211: allow zero HE OBSS PD offsets

Felix Fietkau (2):
      wifi: mac80211_hwsim: reserve headroom for software encryption
      wifi: mac80211: use the AP address as RA for a 4-addr MLO station

Girish Rudrappa (1):
      wifi: brcmfmac: Set extsae_pwe parameter to Infineon firmware in SAP mode

Heyang Tan (2):
      wifi: nxpwifi: bound histogram debugfs output
      wifi: nxpwifi: bound debug info output

Huang Xiangping (1):
      wifi: cfg80211: process pending events before connect/disconnect requests

Ilan Peer (11):
      wifi: cfg80211: nan: add Instant Communication support
      wifi: mac80211: nan: Update NAN configuration copy
      wifi: cfg80211: nan: check Rx registration for NAN beacons
      wifi: cfg80211: do not use NAN beacons to update the BSS table
      wifi: mac80211: nan: allow Rx registration for NAN beacons
      wifi: mac80211: accept NAN beacons only when IC is enabled
      wifi: ieee80211: add NAN service ID list attribute definitions
      wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
      wifi: mac80211_hwsim: nan: prepare for more configurable NAN settings
      wifi: mac80211_hwsim: nan: Handle more of the NAN configuration
      wifi: mac80211_hwsim: add NAN Instant Communication support

Janne Grunau (1):
      wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload

Jeff Chen (6):
      mmc: sdio: add NXP IW610 device ID
      mmc: core: add NXP IW610 base ID and block size quirk
      wifi: nxpwifi: Add support for SDIO-based IW610
      wifi: nxpwifi: Limit channel width based on firmware capability
      wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
      wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()

Johannes Berg (7):
      wifi: mac80211: fix TPE in channel switch wrapper parsing
      wifi: ieee80211: type-check (extended) element functions
      wifi: cfg80211: add protected TWT assoc flag
      wifi: mac80211: fix and clean up protected TWT support
      wifi: mac80211: set SP in reg connectivity with any channel
      Merge tag 'nxpwifi-next-20260929-v3' of https://github.com/nxp-upstream/nxpwifi-next
      wifi: mac80211: fix non-MLD link ID handling

Manish Dharanenthiran (1):
      wifi: mac80211: Guard FILS discovery and unsolicited broadcast probe response

Nathan Chancellor (1):
      wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz

Pengpeng Hou (1):
      wifi: brcmfmac: bound NVRAM comment parsing

Raj Ojha (1):
      wifi: mac80211: acquire wiphy lock for unlisted sdata teardown

Sebastian Reichel (1):
      wifi: brcmfmac: Improve D3 substate entering timeout handling

Stanislaw Gruszka (3):
      wifi: iwlegacy: set debug level using debugfs
      wifi: iwlegacy: 4965: remove custom sysfs files
      wifi: iwlegacy: 3945: remove custom sysfs files

Vinícius Ramon Fontanela (1):
      wifi: brcmfmac: allow ISO3166 fallback for BCM4350

 drivers/mmc/core/quirks.h                          |   3 +
 drivers/net/wireless/ath/carl9170/debug.c          |   5 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |   2 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  98 ++++-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |   6 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwvid.h   |  11 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   3 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     | 441 +--------------------
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     | 121 ------
 drivers/net/wireless/intel/iwlegacy/debug.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/mld/iface.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   3 +-
 drivers/net/wireless/nxp/nxpwifi/11ax.c            |   2 +
 drivers/net/wireless/nxp/nxpwifi/11n.c             |   4 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        |   6 +-
 drivers/net/wireless/nxp/nxpwifi/debugfs.c         |  31 +-
 drivers/net/wireless/nxp/nxpwifi/fw.h              |   2 +
 drivers/net/wireless/nxp/nxpwifi/main.c            |  15 +-
 drivers/net/wireless/nxp/nxpwifi/scan.c            |  18 +
 drivers/net/wireless/nxp/nxpwifi/sdio.c            |  16 +
 drivers/net/wireless/nxp/nxpwifi/sdio.h            |   1 +
 drivers/net/wireless/nxp/nxpwifi/util.c            |  43 +-
 drivers/net/wireless/nxp/nxpwifi/util.h            |   1 +
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |   8 +-
 drivers/net/wireless/virtual/mac80211_hwsim_nan.c  | 245 ++++++++++--
 drivers/net/wireless/virtual/mac80211_hwsim_nan.h  |   7 +
 include/linux/ieee80211-nan.h                      |  28 ++
 include/linux/ieee80211.h                          |  17 +-
 include/linux/mmc/sdio_ids.h                       |   2 +
 include/net/cfg80211.h                             |  28 +-
 include/net/mac80211.h                             |   4 +-
 include/uapi/linux/nl80211.h                       |  17 +
 net/mac80211/cfg.c                                 |  35 +-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/iface.c                               |  26 +-
 net/mac80211/main.c                                |   7 +-
 net/mac80211/mlme.c                                |  23 +-
 net/mac80211/parse.c                               |   5 +-
 net/mac80211/rx.c                                  |  20 +-
 net/mac80211/sta_info.c                            |  49 ++-
 net/mac80211/tx.c                                  |   4 +-
 net/mac80211/util.c                                |   4 +-
 net/wireless/core.c                                |  12 +
 net/wireless/nl80211.c                             |  36 +-
 net/wireless/scan.c                                |   9 +-
 net/wireless/sme.c                                 |  14 +
 50 files changed, 729 insertions(+), 738 deletions(-)

Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382BD4949F0;
	Mon, 21 Sep 2026 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994478; cv=none; b=qR5S1zW+CKY9D7tlN6fxfiT0DgYuwwm+Koh/zBnGbVloYk5TIr+R/t03i5FUXQUgDjDT57XmcKnKkuME/2bXkZnjP6bQuA1efz51vG+urKV23plOeLuHroR4UF8NByXaGb3iFYDapbmFO3zrRSTyrA4UN+m6G46reI5g51gbmAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994478; c=relaxed/simple;
	bh=4xC/ANbmNRhRf8JbGa9zVRkQ15ZiLiGdGeXDx6MQtnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eS8+bW5N0pOvVH8OmeBGbv+KUaT6DoRs3fnB4DqWbfz+JHYmbWJEY4Dh8yw8T/VzOo4jzr11+6CfigP8Z1izGVFCJnTzrXkMIIt0x11nOsjQSbI+zZ4SFx8WOQ5wSMiLcPYVdCo/F1Mj0LyCullrPXZgHb8ekjwqxFe0E6pOzoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=p+5iydgD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="p+5iydgD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=0SKbgr9jwGrWUR95ZFlXK6kY4Bb/E+TkmfJXmQCfUP0=; t=1789994477; x=1791204077; 
	b=p+5iydgD/z+rm6YXhUrP3lMlv9bdDrafiXMGRjENyYRA6RYaTzMXaAH4ZxxYua8wbxxlBF+5+bo
	oWu8yf+P6UiNnfGSgdG919Tb9jwqHZpzAJTJWewCRowtgbHAFh6qFYx1+byBmgBlV4PyWMwM9l8uY
	540szu+viLtYP/rDvXtygVfWr4M9jtLb4NWJ0yGpGKPm564HvH/1S6kfRycF9LdKrD8/u4DisTxR3
	/nfwYLBwS5TrQBJyo0CKip4YrtmKcPktvhWnzSAElU8SWko91pXyAtlfofWE8QbCmfYLg4HGi2t6N
	3HG4z8DrbpaDH3Toh7V14/VzxogKRyKgNbaA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKY-00000005oVO-05ew;
	Mon, 21 Sep 2026 14:41:10 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 0/7] Add support for Control Integrity Protocol (CIP)
Date: Mon, 21 Sep 2026 14:40:49 +0200
Message-ID: <20260921124048.4146576-9-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This adds the mac80211 support for the new key type and using the
pairwise key for control frame protection (CFP).

v3:
- Add debugfs patches for hwsim testing
- Update for REVmf D3.0
- Configure CIP in hwsim for further interface types

v2:
- adjust rtl8723bs stating driver
- fix nl80211 attribute insertion

Benjamin Berg (6):
  wifi: mac80211: add key link_id to debugfs
  wifi: cfg80211: add Control Integrity Protocol (CIP) APIs
  wifi: mac80211: add cigtk parameter to ieee80211_gtk_rekey_add
  wifi: mac80211: add helpers to parse/generate CIP Capabilities
  wifi: mac80211: add Control Integrity Protocol handling
  wifi: mac80211_hwsim: claim support for Control Integrity Protocol

Johannes Berg (1):
  wifi: mac80211: add key flags to debugfs

 drivers/net/wireless/ath/ath6kl/cfg80211.c    |  10 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  13 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |  11 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   6 +-
 drivers/net/wireless/marvell/libertas/cfg.c   |   6 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   |  12 +-
 .../wireless/microchip/wilc1000/cfg80211.c    |  13 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   |  11 +-
 .../net/wireless/quantenna/qtnfmac/cfg80211.c |   8 +-
 drivers/net/wireless/realtek/rtw89/wow.c      |   6 +-
 .../wireless/virtual/mac80211_hwsim_main.c    |  35 +++++
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   9 +-
 include/linux/ieee80211.h                     |  22 ++++
 include/net/cfg80211.h                        |  19 ++-
 include/net/mac80211.h                        |  11 +-
 include/uapi/linux/nl80211.h                  |  14 ++
 net/mac80211/cfg.c                            |  41 ++++--
 net/mac80211/debugfs_key.c                    |  18 ++-
 net/mac80211/ieee80211_i.h                    |   5 +
 net/mac80211/key.c                            |  96 ++++++++++----
 net/mac80211/key.h                            |   3 +-
 net/mac80211/mlme.c                           |  20 ++-
 net/mac80211/parse.c                          |   4 +
 net/mac80211/sta_info.h                       |   2 +
 net/mac80211/util.c                           |  19 +++
 net/wireless/core.h                           |   7 +-
 net/wireless/ibss.c                           |   3 +-
 net/wireless/nl80211.c                        | 124 ++++++++++++++----
 net/wireless/rdev-ops.h                       |  23 ++--
 net/wireless/sme.c                            |  10 +-
 net/wireless/trace.h                          |  37 +++---
 net/wireless/util.c                           |  40 +++++-
 net/wireless/wext-compat.c                    |   8 +-
 34 files changed, 532 insertions(+), 140 deletions(-)

-- 
2.55.0


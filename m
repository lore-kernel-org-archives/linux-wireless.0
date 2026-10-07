Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD523E49EC;
	Wed,  7 Oct 2026 20:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791406311; cv=none; b=CjTzWgYj3nAeHTwYqHyXRLz0uBypO24I2nCKwCxQsYNwljXsi0d1nWvEOCL+srCSOzqq3nbiQ72c/pqMExgr4Z9ykiOg8NJwKff2xwICs5bIPSANBs3GdoPt7NqIwW0cPs9KmXMSBfeYapSyLP1rROHCzr7p/toj6KXHC19ZIRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791406311; c=relaxed/simple;
	bh=xB8eJcFZMizyvL+JJCNxvUQQ0QVIj9ms6HZeWAihsR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OMPxfpRG9JfOjBTzXmlI5nYqjoIBSdd9ZQ85mkLN52DkBhppw3EGthinT3RWRvvf7ZpdgT5eUDixJ5fzi22EPafkjVA3rwx/qVvM7fKNTMXpIxa5FWPKSyUyDgApojecVdLDX386kcLVq88QHjsZ9SapbInMh7TVg2/wcawHspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=accQB3ML; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="accQB3ML"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Z+zlD0ZVD6h7lZsXTpDTosXtwOwiTccJ5XNukNMEl84=; t=1791406309; x=1792615909; 
	b=accQB3MLENoFz0f/seyelBGU95ed9Z61RCjol7QzNDcrAyF56tPAKK2iFphu9mN2v3nMI8sCAdv
	wo2XtH30X8KDftjENt4JmCiaujglq2wK5HRotwRTY2B6xNGeYgwWR8Qr3P+UbN7NBKQopGTpqxDUM
	AqCdKfkWIlg5y+oZVut8JM5yxernssqbaVsmw7jEJ1Tm7Fx655NSrGsYMvicotCoOnsrNkP9CYgwH
	+8oXkOiW9g3E43nPzvIEstIjlUeusPIgZR5NJ2z0i1TiR1gmAlA5sdNIa9S5tKn8yD5RZOhxxtHO8
	KRAcfoiQNe4FPIFiMx8ZivEHLtXW57m7mb6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEYc7-00000008OEM-0Gc0;
	Wed, 07 Oct 2026 22:51:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-10-07
Date: Wed,  7 Oct 2026 22:49:59 +0200
Message-ID: <20261007205143.464714-3-johannes@sipsolutions.net>
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

So ... I pushed back as hard as I could, and Felix reduced
by ~25 patches, and I told everyone I need to get fixes much
earlier in the cycle.

Nevertheless, I ended up with 25 fixes (not counting merges).
Hope that's OK, otherwise we'll try to whittle it down more.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit d24e8ac715de2e16a53c144005b1863660a5fbea:

  Merge tag 'net-7.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 06:41:59 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-10-07

for you to fetch changes up to 9727d1c4e1c971fc42b049b645fdda6852758835:

  Revert "wifi: libertas: reject short monitor TX frames" (2026-10-07 22:48:10 +0200)

----------------------------------------------------------------
Some more fixes:
 - ath12k: revert broken panic handler
 - mt76: SAR/MLO/STA/NAPI fixes
 - nxpwifi: race fixes, validation
 - libertas: revert botched frame size fix
 - brcmfmac: fix crash on P2P removal
 - mac80211: fix WARN on downlink OFDMA frames

----------------------------------------------------------------
Aaron Ma (1):
      wifi: mt76: mt7925: restore the legacy BSS after MLO teardown

Cristian Papa (1):
      wifi: mt76: mt7603: initialize global station WCID

David Carlier (2):
      wifi: nxpwifi: fix inverted check in Tx BA stream entry deletion
      wifi: nxpwifi: do not delete Rx reorder entries under RCU

Devin Wittmayer (2):
      wifi: mt76: mt7925: don't put the band auto marker in TGID
      wifi: mt76: mt792x: pick the SAR table layout from the table itself

Felix Fietkau (4):
      wifi: mt76: mt7996: program a link again if the driver holds it
      wifi: mt76: mt7996: take over connection monitoring
      wifi: mt76: account non-AQL frames per peer rather than per link
      wifi: mt76: use ALTX queue for packets to disassociated stations

François Roux (1):
      wifi: mac80211: don't estimate airtime for unsupported rate widths

Johannes Berg (4):
      Merge tag 'mt76-fixes-2026-10-05' of https://github.com/nbd168/wireless
      Merge tag 'nxpwifi-fixes-20261006-v2' of https://github.com/nxp-upstream/nxpwifi-next
      Merge tag 'ath-current-20261006' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
      Revert "wifi: libertas: reject short monitor TX frames"

Junjie Cao (1):
      wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit

Linmao Li (7):
      wifi: nxpwifi: protect sta_list against concurrent add and delete
      wifi: nxpwifi: delete the station entry on the uAP deauth event
      wifi: nxpwifi: wait for the wakeup timer before the adapter is freed
      wifi: nxpwifi: free the aggregation buffer when the RA list disappears
      wifi: nxpwifi: zero the channel statistics array
      wifi: nxpwifi: fix the authentication frame length handling
      wifi: nxpwifi: handle authentication frame allocation failures

Lu Huang (1):
      wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()

Michele Dionisio (1):
      wifi: brcmfmac: fix P2P device removal race in brcmf_detach()

Nicolas Cavallari (1):
      wifi: mt76: mt7915: disable rx napi when removing device

Tao Gong (1):
      wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout

Yingying Tang (1):
      Revert "wifi: ath12k: add panic handler"

 drivers/net/wireless/ath/ath12k/core.c             |  33 +----
 drivers/net/wireless/ath/ath12k/core.h             |   3 -
 drivers/net/wireless/ath/ath12k/hif.h              |   9 --
 drivers/net/wireless/ath/ath12k/pci.c              |   8 --
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  27 ++++-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 --
 drivers/net/wireless/mediatek/mt76/mt76.h          |   7 ++
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  12 ++
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.c   | 134 ++++++++++++++-------
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.h   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   3 +
 drivers/net/wireless/mediatek/mt76/tx.c            |  14 ++-
 drivers/net/wireless/nxp/nxpwifi/11n.c             |   2 +-
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c        |   1 +
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c   |  11 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        |  31 +++--
 drivers/net/wireless/nxp/nxpwifi/init.c            |   2 +-
 drivers/net/wireless/nxp/nxpwifi/main.c            |   4 +-
 drivers/net/wireless/nxp/nxpwifi/uap_event.c       |   1 +
 drivers/net/wireless/nxp/nxpwifi/util.c            |   8 +-
 net/mac80211/airtime.c                             |  18 +++
 27 files changed, 230 insertions(+), 132 deletions(-)

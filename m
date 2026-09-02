Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCC32DEA74
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338777; cv=none; b=qifrOE0JHHvpka2k21nKrnhwb5XAeBk2UM1htmf7QefLDNUmEgx+1R7mjlwmUbgQhnaJuC2Cqzsb62OT7SRDaWOR4qhf0H2svWFN4pdhPcmBDRyoRULFauZhr4zD+F/Vdr9/ZpRKCvS868NNGiCIOplZEfXHZ61WE/yDE3mC+7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338777; c=relaxed/simple;
	bh=2OLNidt7YzaeovLU3OAiHvFN0y8YsQQws0tiIoO3q40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mo4a+PYpR2gmpF4TTS1aw38lbcf66R1VwPluu2+h6JmeSVHm3TzNtnZK2/Srt77J/cKOkj4fxW3wv7kxx0s2oDyddnOTDA6bMW0+nJpc+YR+WaIiGcKAVJDHy4wdJKhnk1r15RohxUhSMnKT63xWQudLm8Qu5M9PpHPU7CnkMRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=aUkrFctC; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aUkrFctC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3JBV2EYmaXWAZHm5OYLd6YiGj0qZynf9nsPxpKFKwVQ=; b=aUkrFctCEjxdbQRPsLqo2PSONP
	dDOPxspwkTogbqZno8qo+q0jOvZlNylZsh4RRknPMD7razj9RBNYvynaNlzKPziuETA4zRdWvgPNo
	fbIbE9RiVxG8kgbK1hDheZVWc6qFFwWOEytz/U6DRQSxWvjFFUsSwcz90KsWNfzTlkiY=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbl-00Cwkn-1v;
	Wed, 02 Sep 2026 10:46:13 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 00/15] wifi: SCS and MSCS
Date: Wed,  2 Sep 2026 10:45:55 +0200
Message-ID: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two services let a station tell an AP how to classify the traffic
the AP sends to it. SCS carries a classifier and the user priority to
give what matches it. MSCS asks the AP to mirror onto the downlink
whatever priority the station used on the uplink of the same flow.
802.11be adds a QoS Characteristics element to an SCS descriptor, which
describes the service a stream wants rather than how to recognise it.

The split follows the one the QoS map already uses. hostapd and
wpa_supplicant encode and decode the Robust AV Streaming action frames
that carry both services, hold the dialog tokens and decide policy. The
kernel parses the classifier elements, classifies every MSDU it queues,
and hands the traffic description to the driver. Each descriptor is
answered on its own, and the per descriptor IEEE status codes are what
userspace puts into the SCS Response frame, so the answer a station gets
is the kernel's.

An earlier RFC proposed a different split, where hostapd translates each
classifier into an nftables rule that tags the packet. Two things argue
against it. It costs on the software path, where netfilter on the bridge
adds work to every frame and evaluation scales with the rule count of
the whole BSS. And it makes a wireless feature depend on a second
subsystem being built in and enabled.

Patches 1 to 7 build the cfg80211 side, which has no user by design: the
element parsers, the flow parser and the MSCS key, the evaluator, the
request validation, the two driver ops, the nl80211 commands, and KUnit
tests for the classifier.

Patches 8 to 13 make it work in mac80211: per station rule storage, the
transmit hook, MSCS learning on receive and its application on transmit,
the sta_set_scs driver op, and two debugfs files.

Patch 14 turns both on in hwsim, so the whole of the above can be
exercised without hardware. mac80211 classifies in software for every
driver it serves, so the two feature flags are all it takes to reach the
transmit hook, the learning and the evaluator. It answers sta_set_scs as
well, because without an answer every descriptor carrying a traffic
description is declined and that half of the path cannot be reached.
Nothing simulated schedules a stream, so what it answers with comes from
debugfs.

That path is tested: on hwsim, with hostapd driving the two commands, a
classifier tags the frames it names with the user priority it asks for,
the granularity rule and the per descriptor status codes answer as
11.25.2 says, and MSCS mirrors the priority of an uplink flow onto the
downlink under its limit and its priority bitmap, each one checked
against the TID of the frames on the air.

Patch 15 is the first hardware. mt7996 hands an uplink QoS
Characteristics element to its MURU scheduler, which serves the stream
with trigger frames. It depends on the op added in patch 12, so it cannot
travel through the mt76 tree on its own.

Felix Fietkau (15):
  wifi: cfg80211: add the TCLAS element parsers
  wifi: cfg80211: add the flow parser and the MSCS key
  wifi: cfg80211: add the SCS evaluator
  wifi: cfg80211: add SCS and MSCS request validation
  wifi: cfg80211: add set_scs and set_mscs driver ops
  wifi: cfg80211: add SCS and MSCS configuration commands
  wifi: cfg80211: add KUnit tests for the SCS classifier
  wifi: mac80211: add SCS and MSCS rule storage
  wifi: mac80211: classify transmitted MSDUs with SCS
  wifi: mac80211: learn MSCS flows on receive
  wifi: mac80211: apply MSCS on transmit
  wifi: mac80211: add the sta_set_scs driver op
  wifi: mac80211: add SCS and MSCS debugfs files
  wifi: mac80211_hwsim: support SCS and MSCS
  wifi: mt76: mt7996: apply the SCS traffic description

 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   1 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  79 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  40 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   2 +-
 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |   3 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  25 +-
 include/linux/ieee80211-eht.h                      | 128 ++-
 include/linux/ieee80211.h                          |   6 +-
 include/net/cfg80211.h                             | 235 ++++-
 include/net/mac80211.h                             |  22 +-
 include/uapi/linux/nl80211.h                       | 128 ++-
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/debugfs_sta.c                         | 238 ++++-
 net/mac80211/driver-ops.h                          |  26 +-
 net/mac80211/ieee80211_i.h                         |  17 +-
 net/mac80211/iface.c                               |  12 +-
 net/mac80211/rx.c                                  |   5 +-
 net/mac80211/scs.c                                 | 639 ++++++++++-
 net/mac80211/sta_info.c                            |   1 +-
 net/mac80211/sta_info.h                            |  78 +-
 net/mac80211/trace.h                               |  27 +-
 net/mac80211/util.c                                |   2 +-
 net/mac80211/wme.c                                 |  13 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/core.c                                |  10 +-
 net/wireless/core.h                                |   8 +-
 net/wireless/nl80211.c                             | 426 +++++++-
 net/wireless/rdev-ops.h                            |  32 +-
 net/wireless/scs.c                                 | 917 ++++++++++++++-
 net/wireless/tests/Makefile                        |   2 +-
 net/wireless/tests/scs.c                           | 547 ++++++++-
 net/wireless/trace.h                               |  49 +-
 34 files changed, 3725 insertions(+), 4 deletions(-)
 create mode 100644 net/mac80211/scs.c
 create mode 100644 net/wireless/scs.c
 create mode 100644 net/wireless/tests/scs.c

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
git-series 0.9.1

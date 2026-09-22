Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204E52FE21
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072030; cv=none; b=AwE+/Cw/7G1iMJx6A0tBmKxPf40P8oFAhehTHortp+6mNe5DZmSMnjSaqMZTAzop2N2CoCXvM4IIpoOu1t0wAwFtFc5wagdM+2uf+KXiFCgUFI5mHpQj8We+yn2ITUG6e0Y5UOvHb2hxtmcgvoTYlCM1KO3NHI8UMo6TkouhVeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072030; c=relaxed/simple;
	bh=1wcQRxjSVkVRI5V0kv/t/pSa0d12wV2WjVECPH/HV40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LfcGzQwmwQVdBfQ2gzS/ksur8x10RxwABwd/GjcGQX8nP/4qYVmYZr26SlbjBbPFQ2/4yKvN9rtayNvtu7RRA8cHb0gRWyKeX0mbGaN3xFVnV6svZb9436gl4GVlUf5+dcT/tktWzPdaCO+gsSUKrV43HBpSrvGBuBAI3kbE8pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=cRs5yDbO; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cRs5yDbO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=12uDy0A2an2WqaOE6dkH/Ju8HAzKzeT14VUUeJ1uq78=; b=cRs5yDbOP4fYR6LHNQOhIMEBvX
	W94yOdwJ9T36fZnjdXJsFaknva8ao8UdosTBspg8K1LHxjYTPnXSQbOgdTsXgdQu8TtJymLdEctPc
	JKfSQLRobSh6NIOJNQQ2T0lQmiZ1E/drfEizKdvb2p+bW8fRhN1bKTdNYd7DwPoqOVio=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVR-00807z-3D;
	Tue, 22 Sep 2026 12:13:46 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 00/16] wifi: SCS and MSCS
Date: Tue, 22 Sep 2026 12:13:27 +0200
Message-ID: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SCS lets a station ask the AP to assign a chosen user priority to the
traffic that matches a classifier. MSCS lets it ask the AP to mirror the
priority of its own uplink onto the downlink of the same flow. 802.11be
adds a QoS Characteristics element to an SCS descriptor, which describes
the service a stream needs instead of how to recognise it.

The split is:

- hostapd and wpa_supplicant run the action frame exchange. They hold
  the dialog tokens, decide policy, and pass the descriptors and the
  MSCS parameters down over nl80211.
- mac80211 keeps the SCS and MSCS state of each station and runs the
  classification. It has to run there, since the TID selects the TXQ,
  the access category and the block ack session before the frame is
  queued.
- The driver gets a call for each descriptor with the QoS parameters,
  and can refuse a descriptor whose parameters it cannot serve.

The classifier is passed down as the raw elements it arrived in, so
cfg80211 is the only part that parses the element format. A classifier
it cannot evaluate is declined with a status code, and each descriptor
is answered on its own, so userspace builds the SCS Response frame from
what the kernel returns.

Patches 1 to 8 add the cfg80211 side: the element parsers, the flow
parser and the MSCS key, the evaluator, the QoS Characteristics element
definitions, the request validation, the two driver ops, the nl80211
commands, and KUnit tests.

Patches 9 to 14 implement both services in mac80211: per station rule
storage, the transmit hook, MSCS learning on receive and its use on
transmit, the sta_set_scs driver op, and two debugfs files.

Patch 15 turns both on in hwsim. mac80211 classifies in software for
every driver, so two feature flags are all it takes. hwsim also answers
sta_set_scs, because mac80211 declines every descriptor with a traffic
description when no driver does. Nothing simulated schedules a stream,
so the answer comes from debugfs.

Patch 16 is the first hardware. mt7996 passes an uplink QoS
Characteristics element to the firmware, which schedules the uplink
traffic of the stream. It depends on the op added in patch 13, so it
cannot go through the mt76 tree on its own.

Tested on hwsim with hostapd driving both commands: a classifier tags
the frames it selects with the priority it asks for, the granularity
rule and the per descriptor status codes answer as expected, and MSCS
mirrors the priority of an uplink flow onto the downlink under its limit
and its priority bitmap. Every case was checked against the TID of the
frames on the air.

v2:
- support the filter classifier, which reaches ESP and other traffic
  whose five tuple says nothing
- fix sparse warnings in the KUnit test
- do not parse the elements of a removal
- refuse a Classifier Mask with no bits set
- restrict MSCS to AP interfaces
- document what sta_set_scs() requires of a driver
- mt7996: advertise SCS Traffic Description Support
- split the QoS Characteristics element definitions into their own patch
- move the undecided verdict flag to the offload series, where it has
  a user
- replace the module parameter for the MSCS entry limit with a constant
- rework the commit messages and comments, wrap long lines

Felix Fietkau (16):
  wifi: cfg80211: add the TCLAS element parsers
  wifi: cfg80211: add the flow parser and the MSCS key
  wifi: cfg80211: add the SCS evaluator
  wifi: ieee80211: add the QoS Characteristics element
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
  wifi: mt76: mt7996: support SCS and MSCS

 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  64 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  39 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   2 +-
 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |   3 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  23 +-
 include/linux/ieee80211-eht.h                      | 125 ++-
 include/linux/ieee80211.h                          |   5 +-
 include/net/cfg80211.h                             | 257 ++++-
 include/net/mac80211.h                             |  28 +-
 include/uapi/linux/nl80211.h                       | 111 ++-
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/debugfs_sta.c                         | 240 +++-
 net/mac80211/driver-ops.h                          |  26 +-
 net/mac80211/ieee80211_i.h                         |  17 +-
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/rx.c                                  |   5 +-
 net/mac80211/scs.c                                 | 574 ++++++++-
 net/mac80211/sta_info.c                            |   1 +-
 net/mac80211/sta_info.h                            |  78 +-
 net/mac80211/trace.h                               |  27 +-
 net/mac80211/util.c                                |   2 +-
 net/mac80211/wme.c                                 |   7 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/core.c                                |  10 +-
 net/wireless/core.h                                |   8 +-
 net/wireless/nl80211.c                             | 425 ++++++-
 net/wireless/rdev-ops.h                            |  32 +-
 net/wireless/scs.c                                 | 982 ++++++++++++++-
 net/wireless/tests/Makefile                        |   2 +-
 net/wireless/tests/scs.c                           | 488 +++++++-
 net/wireless/trace.h                               |  49 +-
 34 files changed, 3651 insertions(+), 4 deletions(-)
 create mode 100644 net/mac80211/scs.c
 create mode 100644 net/wireless/scs.c
 create mode 100644 net/wireless/tests/scs.c

base-commit: 10cfa109c880092df32e396647b4afdca9be8350
-- 
git-series 0.9.1

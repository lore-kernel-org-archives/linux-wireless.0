Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723047;
	b=5lxOWKYyc5i+SzHOd6JDWNiPelmUdkhgUEZbGr3/b1zsYQTguoZvxJ8LQkhoPWpQBeJR
	 JG1Ps8r22pvrO7JoZQJ+OpIJYOXcnD0DuGz48EvnlSAp3ZceWuVlCfl88rFzyZrYlxO8/
	 aDILBzNUTjSqZBQCTkRzP1wsCyiQr6DYtJ13LpKhb0AS2Fy/15YSkuOdGOw+zqwwy4btb
	 a18G7WAMuLtyC7+rV2cB3nil8YDuIKy2HpN7v+q0oKM4KovqX5ZM/OsYONaiApRSuvQda
	 0ACYKmcLidL97u8hCF5wldxpa/yMlTIeEgh5pVh4+rvS4Oi3kuCGIo6+WxwCVYY6AHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723047;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9FWgLocFxlkz0FZ2I3PSMpGNl/8E/t04SkZ8Dvu8oIU=;
	b=Sud14W7MGUHto6Hh6jKIxjMjDc0+vmptSOseb2Mxo8fjWMTmSEdyre6EABIR2aC+rQDq
	 O6nAauZOdBoYH4S4cdPLcFQ4HCYprzAMDCxZ4duxtHNQC808Tik7cpcEv7gB7i+I4T/Js
	 2soXIB7IZv6IM6bRJV6GipDi9Aaj2jDtKEyuF1/gaCj8FhPBh6H9Y5U+vzBxfyz76BQk6
	 meiInfSeIeM0XBRmMRHCkztYDA+y9UJh79FH/Oo6CT6J9Wv4bs9SFUySxvhha99zJCmP0
	 QG6834QpVafdITerNTgie0pitolKNxnrGXJIMX8jOE8FZacUGoTTzMrnOx51evLCwOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Jluuj80p;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7F3606A33A
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D7F3606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Jluuj80p
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9FWgLocFxlkz0FZ2I3PSMpGNl/8E/t04SkZ8Dvu8oIU=; b=Jluuj80pO3ZWWKxz64E1rSuc50
	QhnTpQe7oFqMFoyQi+dnLTlZwBfSJ3p2IJ5Ew9p+wVmqjwVuvOFO6wnYBxZoopobDp1zd1qBNhDB6
	wcdc9rxBnQzFFpEW4oenBxx1cCUg2xOkUMrF8h1CY3TamHILxU9INwrTvTqNtJeSPxkQ=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIk-00FDFp-2z;
	Tue, 03 Nov 2026 17:23:58 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 00/18] wifi: SCS and MSCS
Date: Tue,  3 Nov 2026 17:23:33 +0100
Message-ID: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SCS lets a station ask the AP to assign a user priority to the traffic
that matches a classifier. MSCS lets a station ask the AP to mirror the
priority of its uplink onto the downlink of the same flow. 802.11be
adds a QoS Characteristics element to an SCS descriptor, which describes
the service that a stream needs.

hostapd and wpa_supplicant run the action frame exchange and pass the
descriptors down over nl80211. mac80211 keeps the rules of each station
and runs the classification before the frame is queued. The driver gets
a call for each descriptor with QoS parameters, and can refuse one that
it cannot serve.

The classifier is passed down as the raw elements, so cfg80211 is the
only part that parses the element format. The kernel answers each
descriptor with its own status code, and userspace builds the SCS
Response frame from the answers.

Both services also apply to the hosts behind a 4-address peer, and to
an MSCS that the AP configures for a Wi-Fi EasyMesh Controller.

- Patches 1 to 8 add the cfg80211 side: element parsers, evaluator,
  request validation, driver ops, nl80211 commands and KUnit tests.
- Patch 9 splits the DSCP mapping out of cfg80211_classify8021d().
- Patches 10 to 14 implement both services in mac80211, with an
  indication for drivers that the priority of a frame overrides the one
  of its DSCP.
- Patch 15 enables both in hwsim.
- Patches 16 to 18 let a driver apply the rules to flows that the
  hardware forwards: a priority query, and ops to flush stale offload
  entries and to report the activity of offloaded flows.

Tested on hwsim with hostapd: the classifiers, the per descriptor status
codes and the MSCS mirroring were checked against the TID of the frames
on the air.

Changes since RFC v2:
- add a client address and a configured flag to the descriptors
- add an indication for an overridden priority
- hwsim: advertise SCS Traffic Description Support
- add the cfg80211 and mac80211 patches of the offload RFC
- drop the driver patch

Felix Fietkau (18):
  wifi: cfg80211: add the TCLAS element parsers
  wifi: cfg80211: add the flow parser and the MSCS key
  wifi: cfg80211: add the SCS evaluator
  wifi: ieee80211: add the QoS Characteristics element
  wifi: cfg80211: add SCS and MSCS request validation
  wifi: cfg80211: add set_scs and set_mscs driver ops
  wifi: cfg80211: add SCS and MSCS configuration commands
  wifi: cfg80211: add KUnit tests for the SCS classifier
  wifi: cfg80211: split the DSCP mapping out of cfg80211_classify8021d()
  wifi: mac80211: add SCS and MSCS rule storage
  wifi: mac80211: classify transmitted MSDUs with SCS
  wifi: mac80211: learn and apply MSCS flows
  wifi: mac80211: add the sta_set_scs driver op
  wifi: mac80211: add SCS and MSCS debugfs files
  wifi: mac80211_hwsim: support SCS and MSCS
  wifi: mac80211: add a flow priority query
  wifi: mac80211: add the flow offload flush op
  wifi: mac80211: keep learned MSCS entries of offloaded flows

 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |    3 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |   31 +-
 include/linux/ieee80211-eht.h                      |  129 ++-
 include/linux/ieee80211.h                          |    5 +-
 include/net/cfg80211.h                             |  278 +++-
 include/net/mac80211.h                             |  120 +-
 include/uapi/linux/nl80211.h                       |  133 ++-
 net/mac80211/Makefile                              |    3 +-
 net/mac80211/cfg.c                                 |    8 +-
 net/mac80211/debugfs_sta.c                         |  190 ++-
 net/mac80211/driver-ops.h                          |   75 +-
 net/mac80211/ieee80211_i.h                         |   19 +-
 net/mac80211/iface.c                               |   11 +-
 net/mac80211/mesh.c                                |    3 +-
 net/mac80211/rx.c                                  |    5 +-
 net/mac80211/scs.c                                 |  875 +++++++++++-
 net/mac80211/sta_info.c                            |    2 +-
 net/mac80211/sta_info.h                            |   95 +-
 net/mac80211/trace.h                               |   41 +-
 net/mac80211/tx.c                                  |   11 +-
 net/mac80211/util.c                                |    2 +-
 net/mac80211/wme.c                                 |   70 +-
 net/mac80211/wme.h                                 |    3 +-
 net/wireless/Makefile                              |    2 +-
 net/wireless/core.c                                |   10 +-
 net/wireless/core.h                                |    8 +-
 net/wireless/nl80211.c                             |  480 ++++++-
 net/wireless/rdev-ops.h                            |   32 +-
 net/wireless/scs.c                                 | 1059 +++++++++++++-
 net/wireless/tests/Makefile                        |    2 +-
 net/wireless/tests/scs.c                           |  901 +++++++++++-
 net/wireless/trace.h                               |   49 +-
 net/wireless/util.c                                |   25 +-
 33 files changed, 4658 insertions(+), 22 deletions(-)
 create mode 100644 net/mac80211/scs.c
 create mode 100644 net/wireless/scs.c
 create mode 100644 net/wireless/tests/scs.c

base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2
-- 
git-series 0.9.1

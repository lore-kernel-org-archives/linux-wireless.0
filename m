Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805353;
	b=H3w7c9jJRveJ8rjeafFmkxNDL1x+ygI4Cp64DIeA48aPf+va1oXoriLTra7VRXoHyp+e
	 klZJ5tTBWCsH8+tChJUPmTaG1sna3F+brN8VWG+BsijLKemUM8NO4C8jHR3Zno6gMs3Lq
	 AiBapQkZIMwjZMV1c2o/zuTXrZBKYHsuN/IGMAvKvTIVmNKtwUB19+MZKjuY23wH7X4Ls
	 suQ5pV98Cn4kOoYzb2efdjOS6r1u76bmq5fMmjq4by2a+8rod9T7avCeYCr4sUAqogWt5
	 3tbZHxyWk2gifJ164uvocxwEjQOxUSJoztLoHfkKtSNy9jfAnBEV6DuZ1+rsvzvHSDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805353;
	h=DMARC-Filter:From:X-Lima-ML-UUID:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=l5ZvKir1PmMvrBXGpjDqb2p+nQANqEfJDu9tgJ2rlR0=;
	b=fqYEAuOf2K6+Y11g/hql4EH0ZdGij6y3EqXQgd7GiXMoAIs5zfO+qDwfJHk9xx8iSydM
	 z3XuZppfjaPhXQK2eOCS2tko29F6xwZSnXNza7Er3GlHofSgUBS/A/M9Oi5G3QOmAdUOh
	 hYnbfdJ6kL44ub1oRvVG461M/VoHOvEftCZqjuB3kxOJkIXc1dJfdVv/urQ2sTNMyHd78
	 yffPZ/7hLPvI3prNlmPxDFiodQXVKC/d4QGq4DSPtdIh1pzKtOLa8oSdUw9r3+EXbnx2j
	 KrGq2Kw/z5sNV2wBEHqLQr/69fmm7ahSnjQzKcGEOO8VDDUOj1XVbY58UKNITUp4Ehg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=dDnEilNL;
	arc=none smtp.remote-ip=91.216.248.207
Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3387606A329;
	Wed,  4 Nov 2026 15:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3387606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=dDnEilNL
From: Andre Eikmeyer <dev@deq.rocks>
X-Lima-ML-UUID: 6baddc19-b339-4c77-b1fd-c68924115296
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793805349;
	bh=GVCxYChL3bU+vz78JfNb2nU8ExMERnwcgtgty+iaHgI=;
	h=From:To:Cc:Subject:Date:From;
	b=dDnEilNLWhknLGdLBCUQpDOYizvdJJPHOVD/JRcrfSskO/fUqjMzeHLQx1XnUTUlB
	 HK4PxSHkdyt6ppVHD7lYjFujqTIaWxMFg7ecxaKTfbY8vxADkNCjTPjI1cOlPregyC
	 L3RLdktd5Tu32YfemQzJQg5aoVA3u0TW9H2BPD2GTZkSq7uOHaJ3LXIAOwvCWPTXxc
	 PkQWGlDLXcXqpgRA6kwho6g6iQrf3Tbju9aL9E3uMztaH2FmmAWhVCUr64Di1jPCd3
	 OUVEU/zJRg6LIW2OdfCspd2L9yE4TZ8QHwHD34STXA/y6B+UMhPH1pdQ7hal//AN3T
	 2KVwZWw7b8vjA==
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>
Subject: [PATCH 0/7] wifi: brcmfmac: AWDL for AirDrop on Apple T2 Macs
Date: Wed,  4 Nov 2026 16:15:40 +0100
Message-ID: <20261104151547.70333-1-dev@deq.rocks>
X-Mailer: git-send-email 2.56.0
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


This series adds AWDL support to brcmfmac, so Linux on the Apple T2 Macs
can send and receive files over AirDrop with Macs, iPhones and iPads.

AirDrop runs over Apple Wireless Direct Link (AWDL). On these Macs the
Apple firmware runs AWDL itself. The host creates an AWDL interface and
sets its parameters. From then on the firmware keeps the AWDL schedule,
sends the AWDL frames it gets from the host and carries data frames to
and from the peers. Election, peer discovery and AirDrop run in user
space.

The driver enables AWDL on any firmware that announces "awdl" in its
capabilities and supports interface_create version 3. The linux-firmware
image for the BCM4350 (7.35.180.133) on a pre-T2 MacBookPro14,1
announces "awdl" and answers interface_create with BCME_UNSUPPORTED, so
it stays without the feature. Other Apple chips, such as the BCM4355,
are untested.

The KaiT2en community, about 280 members, runs this series with its
kernels. Users reported it working with the BCM4364 and BCM4377 on the
MacBookPro15,1, 15,2, 15,3, 15,4, 16,1, 16,4, MacBookAir9,1 and
iMac20,1, and nobody reported a regression. AirDrop transfers on the
MacBookPro16,1 and 16,4 are slower than on the other models, the cause
is still open.

  1    match firmware capabilities as whole words
  2    move the interface_create definitions to fwil_types.h
  3    detect AWDL support of the firmware
  4    create and remove the AWDL interface
  5    add the AWDL data path
  6    add vendor commands for AWDL
  7    pass AWDL frames and role changes to user space

Patch 1 is a fix on its own and carries a Fixes tag. It is here because
patch 3 adds an entry next to the lines it changes.

The AWDL interface is a network device "awdl%d" outside cfg80211. User
space talks to the driver through typed vendor commands and events of
the Broadcom OUI: start, stop, frames, sync, peer add and remove, and
events for received frames and role changes. Creating the interface
needs RTNL and vendor commands run with the wiphy lock only, so
AWDL_START and AWDL_STOP run in a work item and report their result as
vendor events. The driver sets the firmware parameters itself.

The firmware interface was worked out by tracing. A dtrace script
recorded the iovar calls macOS 15.4.1 made to the firmware on a
MacBookAir9,1 (BCM4377) while AirDrop was opened and closed in Finder.
The other way round, the MacBookAir9,1 was traced as AWDL peer while a
MacBookPro15,1 (BCM4364) brought AWDL up under Linux, together with the
AWDL frames macOS received and the console and events of the BCM4364
firmware. The BCM4364 handling in patch 6 comes from these runs. The
iovars, their order, their values and the AWDL frames come from these
traces and from the frames the firmware passes up.

The user space side is t2-drop, part of KaiT2en-Fedora and published
under the GPL:

  https://github.com/kaiT2en/KaiT2en-Fedora/tree/main/apps/t2-drop

With it, AirDrop works in both directions.

Comments on the vendor command interface are welcome in particular.
nl80211 has no AWDL interface type, and the AWDL schedule and frame
exchange run in the firmware here.

Andre Eikmeyer (7):
  wifi: brcmfmac: match firmware capabilities as whole words
  wifi: brcmfmac: move the interface_create definitions to fwil_types.h
  wifi: brcmfmac: detect AWDL support of the firmware
  wifi: brcmfmac: create and remove the AWDL interface
  wifi: brcmfmac: add the AWDL data path
  wifi: brcmfmac: add vendor commands for AWDL
  wifi: brcmfmac: pass AWDL frames and role changes to user space

 .../broadcom/brcm80211/brcmfmac/Makefile      |    3 +-
 .../broadcom/brcm80211/brcmfmac/awdl.c        | 1043 +++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/awdl.h        |  113 ++
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |   50 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   80 +-
 .../broadcom/brcm80211/brcmfmac/core.h        |    7 +
 .../broadcom/brcm80211/brcmfmac/feature.c     |   40 +-
 .../broadcom/brcm80211/brcmfmac/feature.h     |    3 +-
 .../broadcom/brcm80211/brcmfmac/fweh.c        |   19 +
 .../broadcom/brcm80211/brcmfmac/fweh.h        |    5 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  |   46 +
 .../broadcom/brcm80211/brcmfmac/vendor.c      |   86 ++
 .../broadcom/brcm80211/brcmfmac/vendor.h      |   98 ++
 13 files changed, 1537 insertions(+), 56 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.h


base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2

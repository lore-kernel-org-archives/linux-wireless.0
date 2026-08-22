Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A1C339383
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420574; cv=none; b=AcFwgDov/JLhACna8oD8sSDhrTZc3kGdiGgsFrhT5m6XhdGvuMzCmHN+J+WQvfyApl99PKdWVF8wI1doKqU+I0AUG+RfqEUhxQT/90v0Pn7G8sBCyJssXTYwmh6s5mJHC1/tK1SeP0hxjBW9zjVy9mWaWzHhfeP0CoRk4FJq14A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420574; c=relaxed/simple;
	bh=mSFNisWn3DCexE/E9uFQ8dnfZ0TY+DW3dare5+aM9Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n92NUh86DQ+gOe9e3L6LMvbTfUHvBuny9MVEhqHb5lxjp8wiYH1nkdeyQNzms3PBlJBtRZlG8CNrQSF8bjmrPb5S6RyA64Y3aSaqI1DI1dZrCZPHru9Qq1WPXgQ2dgUW1ohrfuoPvyGjn7C/idPkUPcCmkIMeGrtDXAFaiA4d3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQ/RWRUl; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQ/RWRUl"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so374089666b.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787420569; x=1788025369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MX5noaktanbV+kiV5GLkL1hm7K1I5i0Cum/6PRWrFWk=;
        b=HQ/RWRUlLVPG7ShY8mL8eXH8t56vb/YgNCEkCvxHIbhKYvEGTpkvoSw+9QDgtO1L6Q
         1pBJei+f7FHeQbBp6ZSdKABXwQOozwjfY8qnii8QFUDHPH0K/j/y920GYQ1yKpO1ncM+
         sr2Z42Ac02Y7eurz2bvzCJqohhE6EqQbkMLbgstnzgQ7Xg+XSq/LSnt77z33vrhBgiaQ
         0bRHLKZH1qnf9WT4dn7Ggh2euJe2bIqvlckHPsKBOpWe8VsYzW521hefXoTB6QphthM4
         w6ATumuVpQpiCjOcnPt6irM6e0iidgkpIfE4Exx/su3e2aa4wCCSgRysSAyCtgvCTWZi
         YHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787420569; x=1788025369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MX5noaktanbV+kiV5GLkL1hm7K1I5i0Cum/6PRWrFWk=;
        b=fPfls3qTsAtuB04TUyFFOyZjrceMtMB8Lea1rnVNFWkESICmc2NMj1tcFgnIlXKTcl
         6C/vI24UaJFcw7ll4hjo+LYInbZUBQJ9iBnRcyOfxnB62OIcG6+sU7jWLwzKs693I3UG
         z8qFGowr5KzOHvypJ5oLcYY/7kMLhJilwbhgqXiSI9Skjncrpvc+vW+3yPgJZ4fCh6W3
         ikvEAcZeXWIs+dZq1+OlVepUw2lEJGBYR3Zjdr9E3JqEMulhN9az5KryQbsPAY2Sxi1V
         9AHaKGW0dX2AhbFARAZ5DFtqs3GJ7C+jOP2L+4iQH0VtT0U5+CcLUoLNZGR4hsVbv2hX
         xM2Q==
X-Gm-Message-State: AFuF++nlmrYCuCOJ5mwCb3LNHBBz/pxmkaxluTU+uJZxlSlLJBoF4Ag5
	V6gG3HbGJLpYexgtb4uVzjYWJOwFcMtnE1vNkFkbFZ2rhLl9PFHRBPcToNE46T4T
X-Gm-Gg: AR+sD123Gz1V64A0bCNHnQdCDvZCcSDK2MJMQq3eit1uIAz6qHvJwoUb+w6bHimnYY4
	vLRuxLMNes1/c/qj9L98ZkYjyxVVVUxAGahOs79SThNLf1092Jhjay2/177jLsL2D11uYU2jSbT
	VlYiDT/hTMCqYqK2nvuaRYY465NlH8UGHW2iPep358sgVxYqLQnt1z8NBLQcjnhqNP2gq85EXCf
	h9y/5K03ZDxQOntsXh35MWT/o06q5RlhhcbnnoKbs2t3vsvAKxIPU7lgZGiHlPo12OwZMkWHNSE
	31UBAd1EDyMrm9fxcz21HD0FMoBB2AEBcoqG4atll16/016EhY7ljSzPzaheNbmEAWKcD7FyZQ4
	S6HGBja289hiOtPrKgEqOWXlv876WO+STppAq8GYJR/HpJLPC5cgpSXAlhLMdsHjxqztYy3EhQU
	jwRBLWk5jb/ebC4V9aQ7QFMXDTOSUKBJlRd2Vl34F0JG+BQWArYk3jIRnewXUoK1X30lU5Rz26Y
	qH8qt+J94ZjlPlt0N72OQso/dGZ
X-Received: by 2002:a17:907:3fa0:b0:c21:3c4e:cb90 with SMTP id a640c23a62f3a-c2491d27855mr794434266b.0.1787420568515;
        Sat, 22 Aug 2026 10:42:48 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm334367466b.57.2026.08.22.10.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 10:42:47 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: andres parra <andres.parrab@gmail.com>
Subject: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE support
Date: Sat, 22 Aug 2026 19:42:25 +0200
Message-ID: <20260822174229.65643-1-andres.parrab@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I'm not a professional kernel developer -- this is my first
substantive contribution to this subsystem, so please bear with me if
anything here doesn't follow convention, and I'd appreciate direct
correction on anything I've gotten wrong.

rtw89 does not currently declare NL80211_IFTYPE_P2P_DEVICE anywhere in
interface_modes, which means wpa_supplicant/NetworkManager can never
create a real P2P-Device wdev on this hardware, and Wi-Fi Direct
casting (Miracast/WFD) to a smart TV never works: GO negotiation never
even starts. Confirmed absent across every rtw89 chip variant, not
just RTL8922AE. mt792x (mt7921/7922/7925) implements this correctly on
comparable modern, MCU-firmware-based hardware, and was used as the
reference model for this series.

This series adds it: 4 small, independent commits, RTL8922AE tested.
No new driver ops are needed -- mac80211 core itself already
implements start_p2p_device/stop_p2p_device generically
(net/mac80211/cfg.c) and dispatches straight to add_interface with
vif->type == NL80211_IFTYPE_P2P_DEVICE, so the whole change is:
declaring the interface mode + a matching iface_limit entry (patch 1),
extending two existing role-mapping switch statements in
rtw89_vif_type_mapping() that previously hit WARN_ON(1) for this type
(patches 2-3), and raising RTW89_MAX_INTERFACE_NUM from 2 to 3 so a
P2P-Device wdev can coexist with an active STA connection and the
resulting P2P-Client group link (patch 4) -- traced that this doesn't
strain the separate, firmware-tied NUM_OF_RTW89_MCC_ROLES limit (still
2, unchanged), since a P2P-Device link's remain_on_channel never
acquires a real chanctx assignment and so never occupies an MCC-role
slot.

Tested live on real hardware (RTL8922AE, current firmware
0.35.80.3), out-of-tree build against this series synced to current
mainline: a real P2P-Device wdev appears (confirmed via `iw dev`),
wpa_supplicant completes real GO negotiation against an actual Wi-Fi
Display TV (P2P-GO-NEG-SUCCESS), and a full Miracast cast completes
end to end and stays up for extended real use, with the laptop
remaining connected to its normal AP throughout and no regression to
normal STA association/roaming observed. checkpatch --strict clean on
all 4 patches.

Two things found during testing that I could not root-cause myself and
would appreciate guidance on -- happy to help gather more diagnostics
if useful:

1. If the AP the STA link is associated to does an ordinary channel
   switch (CTRL-EVENT-CHANNEL-SWITCH) onto a different channel than
   the one an active P2P-Client group is using, the P2P link is
   dropped outright (beacon loss, then a locally-generated disconnect)
   and never re-established automatically. I don't know whether this
   is a pre-existing limitation in the existing MCC entity-management
   code (rtw89_entity_mgnt / chan.c) that would reproduce identically
   with a stock, unmodified P2P_CLIENT/GO connection unrelated to this
   series, or something specific to a P2P-Device wdev being present.
   Have not yet had the chance to test against a stock driver to
   isolate which.

2. If the STA link and the P2P-Client link end up on genuinely
   different *bands* (STA on 5GHz, P2P on 2.4GHz -- WFD is 2.4GHz-only)
   rather than just different channels on the same band, the
   connection stays up but has a real, repeatable performance cost --
   confirmed clean at the RF link level (zero tx retries/failures on
   the P2P link, good signal, decent PHY rate throughout) via
   `station dump`, so it doesn't look like a radio-quality problem.
   Grepped this driver for any equivalent to Intel iwlwifi's CDB
   (Concurrent Dual-Band, IWL_UCODE_TLV_CAPA_CDB_SUPPORT, a distinct
   LMAC per band) or MediaTek mt76's DBDC (Dual-Band Dual-Concurrent,
   MCU_EXT_CMD_DBDC_CTRL) -- found nothing under either name. Is that
   because RTL8922AE genuinely lacks equivalent hardware/firmware
   capability (in which case this is a real ceiling, not something
   software can fix), or does it exist under different terminology I
   haven't found?

Grateful for any review, and for pointing out anything I've missed --
this is my first time working this deep in a wireless driver and I
know there's a lot I don't know.

Thanks,
Andres

andres parra (4):
  wifi: rtw89: declare P2P_DEVICE in interface modes/combinations
  wifi: rtw89: map P2P_DEVICE to RTW89_WIFI_ROLE_P2P_DEVICE
  wifi: rtw89: handle P2P_DEVICE in net_type/self_role switch
  wifi: rtw89: raise RTW89_MAX_INTERFACE_NUM to 3 for P2P-Device
    concurrency

 core.c | 13 ++++++++++++-
 core.h |  2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.55.0


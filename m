Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959FD34752F
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790542997; cv=none; b=WnLkHmDjZZlL8vnuB2ipmKjey2Hdu+1N8jj2Y0ONLdWIv4ErUgS8vPmKcY2zHwp9J1u+X9KWwzGlUOED63H/5AZu/i4iHr92lfpPIxpTUzap/ZTEuiodwYyL/tsDcfgifazaLQGusAdbY9ZFLEhURVKnYx9THii7ktYwNG54kJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790542997; c=relaxed/simple;
	bh=ofaUwOlWPyIfV7Yh+N9j+cIKyJhFTKxhjuMQ1xDP444=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P8OYDLhSZxsEKjZovRpfazm+Jd/0Yj2abUC/BgUzUJ0609ET36xS3Exvyt6iP8WftGF3130r75SQoFqX6p/YxhS8+9d9UPt/d0vMtw57busR6P+jlpNpOtShFQas1UUschpJYZrwE8EWxhNtB6utllhKz2mckYb2BK41b26PNCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f40.google.com with SMTP id 00721157ae682-8a87be3ca16so15616937b3.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790542994; x=1791147794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H8OCvE7enPzYeS+ZD/b1+wgUiD3d8fgb6HgQLR5dMYs=;
        b=UReTR05PJ+Z8vf6v4K4fpP6JN+2wJeiqEshlyIqbMM1Zc0QnaFf83IMSxsWDMlA/QF
         j6E+6z1NzivXroy1ih1d2j4QNudVyY6bZet3LOrOwH1bFyMni5gz/FPMAK1mlZO/3R7l
         cnOHczZrOn7R1Du5Q3S7gQRd8kQ/MimfBHluQxdP8D0ObZSnGJElCc44277lgPux15js
         8dxMFh2V/vbDujngweT1U82xGBXEx6QOTkI5njmSX23lOkp1qcfAc45d+w0Jz6JZFUwF
         hKmLiiyZeiyi3V/PRRteGVPDO/9yolacUQDudzmBEITzZsiNsGeqwBVc+XgBIK+vwRgT
         gHXA==
X-Gm-Message-State: AFq9FYKWvSIT3FdnElWIZSkG/iTYGKZaLXM0+uRDnHj7otCsREZ6bHPI
	yr1w/FH7I/RqaTQNRXIWr4xshUn6MgsvS7MAO0LA49LGq5ewDTWTpeoY
X-Gm-Gg: AYBFou2l2HiBrZg+Xda2rAn9nB3G7T+Z/GQ+vJwn9e1d3ybybZoMP5BA/4BcOpJZ3tF
	YJsRoU/+nL4oIHzHpuUyLYM3o4agJstQoYKfLltR6HsGZSIt4EDNJgTCxXREJHLYwudLH5AKQFp
	z1JnoCZ/YsmN5wcLSoFlEkWU0yJDE2xAkFa+mobfLMkP13ETwpaYrSoMwAEDv7a7iB7XVXcC4I4
	s9xKzmlr1DrrZZRP/C2BKulFk6yEMw9oSJ/TjFVZx0el0uOUUT6sxToXqOHBeg3ymjHvXQE7+xH
	fuLYwC6NSBZ6VtYWdujpz9jAspt6sW8IWSLqUy/s0zzqDCui3iWccvXFN29i0x3gUxNz+JJz3UH
	T43T3Kw6grz42N6EHOKAUWBaMcxMSiYgGsQOglDVxHIpKhrhe2R+nFwfxc+t+drkO4vitvV+LXy
	rMldVSdHYkylhkG9jWo+lhqICWiKhtPDjjO0iIayYGyQLe18lhVeYUxsqhlKiU001lD1n0pN74f
	8+b03klTl04U8EKZ8X3rXgih4gl7AptL+SmYpR8rqE//+EGmFA2U+xqybwU3yibM8QgxQ==
X-Received: by 2002:a05:690c:ec5:b0:89a:63da:fa96 with SMTP id 00721157ae682-8a648ec58e4mr47317247b3.81.1790542994491;
        Sun, 27 Sep 2026 14:03:14 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:14 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@kernel.org>
Subject: [PATCH 00/23] wifi: mt76: mt7925: add NAN security and improve NDP reliability (part 2)
Date: Sun, 27 Sep 2026 16:02:42 -0500
Message-ID: <20260927210306.737669-1-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is part 2 of the MT7925 NAN work. It continues the 15-patch series
that fixed NAN operation and NDP performance:

https://lore.kernel.org/all/20260824195227.12589-1-sean.wang@kernel.org/

This series adds NAN MAC address randomization, low power event control,
and key management for secure NAN and NAN data interfaces. It also makes
unicast management TX respect peer availability and discovery windows,
and fixes shared BSS teardown, cluster event ordering, and device removal
and frame lifetime issues found during NDP setup and teardown.

The 23 patches here cover the mt76 follow-up work. The separate mac80211
NAN receive-filter change is not included in this series.

Chengwei Yu (10):
  wifi: mt76: mt7925: make NMI address TLV tail padding explicit
  wifi: mt76: mt7925: add NMI/NDI MAC address setter helpers
  wifi: mt76: mt7925: implement NAN MAC address randomization
  wifi: mt76: mt7925: wire up NAN MAC randomization lifecycle
  wifi: mt76: mt7925: add NAN low power event control on suspend/resume
  wifi: mt76: mt7925: implement NAN key management MCU command
  wifi: mt76: mt7925: add per-peer RX IGTK/BIGTK and RX GTK WTBLs
  wifi: mt76: mt7925: add NDC-aware TX GTK table for NAN_DATA
  wifi: mt76: mt7925: implement mt7925_nan_set_key for NAN security
  wifi: mt76: mt7925: install NAN BIP keys standalone in sta_key_tlv

Jacobs Wu (13):
  wifi: mt76: mt7925: do not disable RX NAPI twice on unload
  wifi: mt76: mt7925: assign the interface WTBL to the NAN management
    TXQ
  wifi: mt76: mt7925: do not deactivate shared NAN BSS on peer STA
    removal
  wifi: mt76: gate NAN unicast mgmt by peer availability via STA queues
  wifi: mt76: mt7925: hold NAN mgmt TX to the discovery window
  wifi: mt76: mt7925: double the retry budget for NAN unicast management
  wifi: mt76: mt7925: let TX status of DW-held NAN frames outlive the DW
    period
  wifi: mt76: mt7925: defer the NAN joined-cluster event out of
    NAN_START
  wifi: mt76: mt7925: steer NAN handshake frames by committed-bitmap
    state
  wifi: mt76: mt7925: disable only the RX NAPI instances that exist
  wifi: mt76: mt7925: stop queueing resets once the device is being
    removed
  wifi: mt76: mt7925: bound the lifetime of NAN unicast management
    frames
  wifi: mt76: mt7925: always deliver the joined-cluster event through
    the deferred work

 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |  23 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 147 +++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  30 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  11 +
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |   3 +
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 710 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 131 ++++
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  19 +-
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |  58 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  98 +++
 .../net/wireless/mediatek/mt76/mt792x_core.c  |  34 +-
 drivers/net/wireless/mediatek/mt76/tx.c       |  25 +-
 13 files changed, 1248 insertions(+), 42 deletions(-)

-- 
2.43.0

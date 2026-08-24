Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B126384CCA
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601169; cv=none; b=hMYN0aD0ifb2wsgrLx4cVrrH0yE4OyFGGVHNCD91WuC0Ihr8f4lY3grxzEemcXZvoH6Y/aC/t05RsSzw886UJUm38j4Y2c+gI37XsynlJcIBo2vkOEYTmkCXaz6PWkAGe15bsz8kuREFhicC54DP7wIDrql28H84Vt5GGY0Qc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601169; c=relaxed/simple;
	bh=iAI5bH+5G9KEdkyBn3pUBBfm2ZieME8pklFLNyh01rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B6fmIy7ZvegLNXjj/K1iIWy54OW2e0QziZihnKOY9mCqYo46cZvM4PVIYh3Z6mUwc0+rwYM151P32Doyw1jRNWG1rLawMYoTzmEry20R7mp1TRiQVBPe0dT+RcsQJDouOX3XDUmMAJ9ndhguMQtuxeTNvfrGJ1WK7gqacCZKrBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7ee4399c3abso3634606a34.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601167; x=1788205967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJwi0QFK55qyeCrO86vrrS80VWeYk5fCjTfDDqIvZe0=;
        b=B7h9Tf9eUnqK1/dOc4NGb2DWCkX6+pSb6SZn4jIrkYM53CvJD69PEGK4yE/1xMvY0k
         FccWryo14F28QKQ4Pwznj/tn9GBfQ3XiHZdKbzdMw7L0Y9mJLhFjKZcAy6Rz3ioefhnX
         NG1FR5gOzIk5JU2uQYVQi807Oj1jJvIHzD9FisTC2vbw3ylnCQ4jjalkb+gx8Nu+69pi
         vG9Ke9XWOszzqK+QIk8LPmCBPsLazTeerBnJvLRMQaAy5GquDdrUCdpZKEBS3+j7LVEr
         cxNRjqWRav9I/90i4G1JQu2sepf8zQptdDB6DoafgmqVfhJeN5/LhlXRDrgrVfsFbqqY
         acig==
X-Gm-Message-State: AFuF++m9ciN/jfMo6qtzURgy2flrMe4zu13YiYSy1H/MkOzNbG6VGxTk
	vgahxZoKsD+NwB3y6hzAI8ySp2Fn97XoKqie2bwYH8VN2uBeFojpCjwd
X-Gm-Gg: AR+sD10UJX1kPWLVnHnNJKIWwwpehVyrVXuMZHtC/xfM+Y0BEtyAdPC7zoH0OexI9Zs
	lrNAxlRRkuhnPpk0SIOJ9mu0HGesvEqmsxVsYjhOz6jK5kPcMNlb7GydX30V6Elp37H2HuxcgaR
	XxA2i5Xz8O3/O8JGK1s6mKqq1fEibU7TEQYRNz3chUZeKUssoYFZWd0QRnDDZwWljnOK8T9i/o7
	dPDeKtmWxZBjo2vhDSrQDriMqU9Hreq1Ca5Rq9Z8inXPEzjiOYpVZ12wXWnJgw/uk1BmtfRRTS1
	MJzoYXzpctQeoxj+m0NEVC+xTXnvNGu27Up9Pz8Ca0NEJf+7LYc+pAIe0Pn7ctYyvMj9olyJQZT
	mmntVCdwjog9T/SlUtts9TQlXp48w32AIdB6h2bMFJ4wxbTXeHQt8Zp4PKjZdzMZ+kU1s7WXz9V
	WPYJ4ZlZSBhfV2u9VVEjDDJszcuKOB/ZpxnwtYGu+JrySU0lxdIV730HsMlvobM9MgscVsfxqtc
	63dPCH6/OxzBhOAmSYEota2XFbgalBaXqMeiuSoNrs2
X-Received: by 2002:a05:6820:612:b0:6b0:1ba4:dcc5 with SMTP id 006d021491bc7-6b1904bb382mr889480eaf.20.1787601167058;
        Mon, 24 Aug 2026 12:52:47 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:52:46 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@kernel.org>
Subject: [PATCH 00/15] wifi: mt76: mt7925: fix NAN operation and NDP performance
Date: Mon, 24 Aug 2026 14:52:12 -0500
Message-ID: <20260824195227.12589-1-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes several MT7925 NAN issues found during interoperability
and NDP testing, including NAN startup, scheduling, peer configuration,
DW handling, ULW updates, and deferred schedule events.

It also fixes HT/VHT capability and rate configuration for NDP peers.
With the fixes, an MT7925-to-MT7925 NDP link reaches VHT80 MCS9 NSS2
(866.7 Mbps) with about 290 Mbps UDP throughput.

Jacobs Wu (2):
  wifi: mt76: mt7925: support deferred NAN schedule update and cluster
    events
  wifi: mt76: mt7925: fix HT/VHT caps and rates for NAN NDP peers

Stella Liu (13):
  wifi: mt76: mt7925: fix NAN NDP STA record role index
  wifi: mt76: mt7925: fix NAN start failure
  wifi: mt76: mt7925: fix NAN committed CRB timeline layout
  wifi: mt76: mt7925: report only 2.4 GHz NAN supported band
  wifi: mt76: mt7925: drop unused NAN 2.4/5 GHz support config
  wifi: mt76: mt7925: drop deferred NAN local schedule update handling
  wifi: mt76: mt7925: use OFDM-only PHY mode for NAN STA records
  wifi: mt76: mt7925: share TLV setup for NAN enable command
  wifi: mt76: mt7925: replace NAN DW end event with DW start
  wifi: mt76: mt7925: fill all DW intervals in NAN avail_map
  wifi: mt76: mt7925: clear CRB before deactivating NAN peer record
  wifi: mt76: mt7925: add ULW event handling and peer ULW update
  wifi: mt76: mt7925: configure NAN PHY setting on enable

 .../net/wireless/mediatek/mt76/mt7925/init.c  |   2 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  47 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  12 +-
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 689 +++++++++++-------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 101 ++-
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   8 +
 8 files changed, 569 insertions(+), 292 deletions(-)

-- 
2.43.0


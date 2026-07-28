Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5DA3A9879
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267077; cv=none; b=gqXZgI/aL8GmGIkkFZYsOVmKRFtJdFf0fdbyhB3zkATsh2vIsiT7JOw0l87ZUVHfRTF/qFtKjCldWmwCHLBQ3ZotDqChOAUwFK8aDBkNodUztdST0NJKvFFcDqXlYbqI6zMmNUxTJ3lEFN1xny4+Gor/O1916Fr+DBPO+S4GrKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267077; c=relaxed/simple;
	bh=uHt4Efsqmkj4L378dWhT+hZeyytMTaorFnZGIzzoP20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lhfyi3eS/fSivVGW/lZdh0mCRysNx4P2/1Nc3asqaQOXROPtbbkBbpZDz9eIDtKimu6RoPzMmvVcR5KtbUoa2eCxQEWeSug+drdso2/46PyxRmpvFR7tOwBtSQzDvzvhLqAfTdvQO19YpEY0xQr6zXzf5z0upaTTMIuMvkYTwps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3wvpzPm; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3wvpzPm"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49553515a8bso2562035e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785267074; x=1785871874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TdVpO0t8Plo/a9fBWYcScqqmx4ugirwq63bNqhUWRVo=;
        b=A3wvpzPma9iLpe6wL7veMWtklVWMPbCd8a20BDRiJw25Q+LvHcaJLWVwFy87OY5OSV
         Dj8CWeVNXzVn8Wg2N6qbAF6JFU3IX+hJd/yMZyq/lQNnLHXN7MF6lu+NLErCPCVLNAmY
         1bbWXM1MNSDzqD1Y1APbhyeGJGCW9r8F4HAZEyttgTZk3gQTgwzuywwWxzcgpR5DBOHo
         DywTjPxBtkUnhVe0SugTBW+6sa7/E6Zi99z5kgxawJ+9XQranOtQBCncLxeHvl0Omcvi
         e4aiZdqEX7Sp88oWlZ03gXRvlpd/NguLMke4QBZWTaIcsV3eMugfQpGGvowVaUo79bgd
         fs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785267074; x=1785871874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TdVpO0t8Plo/a9fBWYcScqqmx4ugirwq63bNqhUWRVo=;
        b=XILQ9L6SzsUeBiMZESK2w9QosjcaYQlZFc+Ti846syU5npVXupxRw1aCi3eG8YI7WX
         dulfhEknaNLNuTBWf1rGzeNsBO7VDJrMU/oSGPOIDXAKOvq+hVvVDG4gVhSARyDv+0SY
         C9pKrT8/Grrb8mqdVqppsW+7f9LCCaT7muf4+LxBrttHnAy9rmi3XqBhK3Zpkj5nXDUB
         7mdi94YRLGn7gThs0yho5PDwCnlMB/QPHvBO1h/CwaMtqOZ0PHgOw/7Dt0iRGPSS84jx
         Oa3ObEbBSkXCs+gz66T7e8ac/InuMWgE5O7b5UwKwEnrYe1ZOVQ6szw1VucKAdtm+7MY
         TNPw==
X-Gm-Message-State: AOJu0YxgPyk/O1qxvvmIFC3KZm1cYziX+av7yRECKH3w+DCUaO4a+tDd
	fuLK3hn/MyPyI1udxLs94vxhhdG+F8gXL18zFQOEDE7OkPfYTefIdAcf
X-Gm-Gg: AR+sD10BArAAAAwAFQ0GjvPsFCdUnobcL92mNZeAUBMBjM20tgvwotUSV8GAkJNLhT8
	ySOZLHwve7AXde9JX3KIArSjDXnkxIsYeV6wQlVnFnWKg8G/GnvHTVF/E+tvASZ265WBKUoEDmG
	pc3FU97+z1E5OfyeLuUCh/zeiJzMQqQHOUXMY0bmnHSDL9VvBUsIskhdcFwuN6Z/U90bpSvJQyA
	OM9G8TDPb3x0hC6+IBrrEEtFqKVOl6pIgasGbK950OkGwEyoDtz23l3Fv1jWzvw82GpxwAKH/Kc
	pZIMCBIq1DukbziXzEbCZpVsWKZlZmrKGEktwAO987aHBnLakHXCC6ENjlwpLdFamztMiCrMgIu
	MT8sAoIjW/nwBj+WIMOV+3NmZ7w4PcNAjUqeV6LH2D6vo8mE9IrVjNsknawUH5YrUDYg/XTLe6X
	Zz0cWwoBgZ
X-Received: by 2002:a05:600c:3b14:b0:492:3e69:a86f with SMTP id 5b1f17b1804b1-496c6426375mr42288015e9.1.1785267074260;
        Tue, 28 Jul 2026 12:31:14 -0700 (PDT)
Received: from zbok.dom.lan ([2001:470:1f0b:afc:aee6:6ba4:3fe:6c3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd7bab1sm1496955e9.13.2026.07.28.12.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:31:13 -0700 (PDT)
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	Kamil Bienkiewicz <perceivalpercy@gmail.com>
Subject: [PATCH] wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
Date: Tue, 28 Jul 2026 21:31:05 +0200
Message-ID: <20260728193105.1064227-1-perceivalpercy@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
IPQ5332 entry does not. As ath12k sets SW_CRYPTO_CONTROL, mac80211 does
not add the mode on the driver's behalf, so AP/VLAN is absent from the
wiphy and hostapd cannot create WDS station interfaces:

  nl80211: Failed to create interface <name>: -95 (Operation not supported)

The 4-address datapath itself (sta_set_4addr, per-station TCL metadata,
WMI_PEER_USE_4ADDR/WMI_VDEV_PARAM_WDS, 4-address frame and NULL/EAPOL
handling) is shared Wi-Fi 7 code with no per-chip or per-bus gating, so
IPQ5332 can already deliver it. AP_VLAN is a software interface type, so
no interface combination changes are needed.

On a mixed-bus single-wiphy group the effect is wider still, since
ath12k_mac_get_ifmodes() intersects interface_modes across all radios:
one IPQ5332 masks AP_VLAN for the QCN9274 radios too.

Advertise AP_VLAN on IPQ5332 as QCN9274 does. Tested with 4-address WDS
stations on IPQ5332 + 2x QCN9274; RADIUS dynamic VLAN was not tested.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Kamil Bienkiewicz <perceivalpercy@gmail.com>
---
IPQ5424 (and possibly QCC2072/WCN7850) appear to need the same change,
but I have no such hardware, so I have limited this to IPQ5332 which I
could test.

--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -655,7 +655,8 @@
 
 		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				   BIT(NL80211_IFTYPE_AP) |
-				   BIT(NL80211_IFTYPE_MESH_POINT),
+				   BIT(NL80211_IFTYPE_MESH_POINT) |
+				   BIT(NL80211_IFTYPE_AP_VLAN),
 		.supports_monitor = true,
 
 		.idle_ps = false,
-- 
2.47.0

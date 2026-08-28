Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4114E49620
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787878296; cv=none; b=V2v/2eQnDS1ty6XWBjkG2nCDYG0XUBlQps962xvRV8OJD4/GXAdS9+dXHXitlKYnqIqhONL8MY3k+oViyy2kq7DUirXytiFTo3R1nebn38wLqDx+tqq7qxHJ5yOhlhMykTM6A7eg0j55w8og1gFd7HrD9D5mS0Z6zBjkaIpwejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787878296; c=relaxed/simple;
	bh=ZbMHPv8MSn+nAurxUv551/lzhuGpgaKpxZgUP8ScdMU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=su10tB2lRfiz7M5qxOeVmoJdSQPJFUoZssGvalhWsCACN3M8vCpacohUDqN8WsWQaatDEvpnM3YUlu0PAJYMAm3G+Hu4Di/hHeHLDrMOqupPXGSQAZdR881YLqWlcibqGeS22XIO+9yTGy7UbyDhdp7BWlXB6Vs8djUv1gniGqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8iVXqc0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8iVXqc0"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c250a2bc3b3so68563966b.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787878293; x=1788483093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pCMIFIxYCUsj1hMH+KHMzj8zPNuf6elRBMAuZZ590uw=;
        b=M8iVXqc0U0sweSFcnO8V21igekrr+uv04EBq/X2i1y5yaJytXQfDg0K2TnIsfD55MX
         tNZHAId07n66RLXzT2SJg+zuLg1tEgExomgmPf+J0RHFj3pawWbd4rezu1Hj90ybAm9s
         NI06ZzxqbJls8jExPc8bCBD4WUYVB/+gBkYhrvpq6Q74ndq/b3xQ/lciMT6vrlzU7bna
         Fiyesf/uEA7z/BZ7DXLFe+2QN9ZkJg78vlP7iLsaUfDBRrPiRUxQUdVrJjx/8hdIyCH3
         +2WynfzSy2ofWJmzy/N1ocoSdiKsqe7ecQe4ha7PlYzba0tkmdkImpi+vZH3HLsbWcpo
         gY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787878293; x=1788483093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pCMIFIxYCUsj1hMH+KHMzj8zPNuf6elRBMAuZZ590uw=;
        b=bCv0yHSvGlPx26KndaCWG8gbY1TH3ee7mbFvFISBTrUhfzDQQ+GUWF0MLEKf9BECa0
         LArTc6d/OKrGJV5VUHMNZsLzEpvqZ9u5skqyg5Rntso9Rf9hRTSqJV8h3KYIz9Kflo+R
         EW0KYFGKmLk5QaqpHSoCY3kPQWuE4yrA/GwPvpvaEIqewtD3pX6q4+lKj/glsOqcSEhc
         Nnt//55DiEm5BRo8xKFhAVxq6KZ0sZTW6JbjitEHBsP3yDKxiXI97rAl5/Qp8UPLdXY6
         v+3UC76O+92kFrYisSWEVucmXEQg88957donvuA0ApZqpnGDL4jG3Y4ehG50r2e4t5OB
         /4pw==
X-Forwarded-Encrypted: i=1; AHgh+RpN28XjYFt5oZVS8NA6UzHGdjDPPkEtkAwdslDsDkS3sOuHQ9BeItD3K523Qk+tVTzkheNdOT+slgJjfv8L4g==@vger.kernel.org
X-Gm-Message-State: AFuF++mdoUh7+dMbWIn8ZPNZdPUYDPnn64cXo+wEOyJa8BcvAcbtzrnf
	IyiGNmbh7PVavfJgeTSfO6i2duuQp/KUWW4szkh++olGF9WFOB6rhtTY
X-Gm-Gg: AR+sD10zUhbJf9VBS5zNzE4o+kpuzuLWSIRnt2mTQ/l1cmN9CM8d7vcIeAhGrhxUUta
	qBX+/09aoktH+xREl2y7t61mUsNoHPRGFqHKcIcjgMX8X68aP88R2xUGXFs0Dj1Zbz9AZ8k9EpK
	ngoH5x07hrwxskxbDKmytIRLbOW9MnlW8uGGfPvuU8o9ApoWJkxV8Cj1S7KkwO30804o+gbeRVQ
	EidnRRghSke0PiQf4ZehzS2XKTB+96l95eDwfOVnX4kCrz/k315dbMIeSfHpHLKvi3cjjM+DYQ1
	y8ZVIbYwEsVAW3MuCoEVlOPpNfwLdDLHgk5sslzmGxSMRBmm7pKEEzRW4U5o7C6Xh70KNEIj7Ra
	a1+JLmqaEyf5LftFY0IKUvtLnhOuRgRfBxWNYv8sQXxCL/W7EkhDz8XCQeKGXYxJJX6XkbYHzff
	6wsHn87JoVQ8tu85v8MuUcvDPaazrCVrvZGymSR0qk8GOEa3dcQ9C2p0yGZQNAGANeRbfNADSnE
	iTlw4rwul7yOJ82uF8QF/rlvRVMzqIIMQvjBKwfSeAKCg==
X-Received: by 2002:a17:907:c05:b0:c25:2d27:5648 with SMTP id a640c23a62f3a-c2556fb8e11mr180456366b.4.1787878293227;
        Thu, 27 Aug 2026 17:51:33 -0700 (PDT)
Received: from zbok.angelfish-beaver.ts.net (89-79-165-104.dynamic.play.pl. [89.79.165.104])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f25177bsm10549466b.57.2026.08.27.17.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 17:51:32 -0700 (PDT)
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	Kamil Bienkiewicz <perceivalpercy@gmail.com>
Subject: [PATCH v3] wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
Date: Fri, 28 Aug 2026 02:51:26 +0200
Message-ID: <20260828005126.1685832-1-perceivalpercy@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
IPQ5332 entry does not. ath12k sets SW_CRYPTO_CONTROL, so mac80211 does
not add the mode on the driver's behalf either -- ieee80211_alloc_hw_nm()
only does that for drivers that leave SW_CRYPTO_CONTROL clear, leaving
the declaration to drivers that can transmit software-encrypted frames.

AP/VLAN is therefore absent from the wiphy, and creating an AP_VLAN
interface without NL80211_ATTR_4ADDR is rejected by
cfg80211_iftype_allowed():

  nl80211: Failed to create interface <name>: -95 (Operation not supported)

That is the path hostapd uses for dynamic per-station VLANs, in
hostapd_vlan_if_add(). The 4-address (WDS) case is not affected, as
cfg80211_iftype_allowed() short-circuits it on WIPHY_FLAG_4ADDR_AP,
which mac80211 sets unconditionally at alloc time.

The QCN9274 entries already declare AP_VLAN, and the transmit path is
shared Wi-Fi 7 code with no per-chip or per-bus gating, so IPQ5332 can
deliver it as well. AP_VLAN is a software interface type, so no
interface combination changes are needed.

On a mixed-bus single-wiphy group the effect is wider still, since
ath12k_mac_get_ifmodes() intersects interface_modes across all radios:
one IPQ5332 masks AP_VLAN for the QCN9274 radios too.

Advertise AP_VLAN on IPQ5332 as QCN9274 does. With the mode advertised,
a non-4addr AP_VLAN interface can be created on an AP interface of an
IPQ5332 + 2x QCN9274 single-wiphy group:

  # iw dev phy0.0-ap0 interface add tvlan0 type __ap_vlan
  # iw dev tvlan0 info
  Interface tvlan0
  	ifindex 19
  	wdev 0x9
  	addr 00:03:7f:12:0b:0b
  	type AP/VLAN
  	wiphy 0
  	Radios: 0 1 2

RADIUS-assigned dynamic VLANs were not exercised end to end.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Kamil Bienkiewicz <perceivalpercy@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
---
v3: corrected the rationale. The missing interface_modes bit gates the
non-4addr AP_VLAN path (hostapd dynamic per-station VLANs), not the
4-address WDS interfaces I originally blamed -- those are allowed via
WIPHY_FLAG_4ADDR_AP regardless (thanks Rameshkumar). Added the
interface-creation check on hardware. The diff is unchanged from v2, so
I have kept the Reviewed-by.

v2: rebased onto ath/main (8150c22bc); v1 was generated against a
backports tree and its trailing context no longer matched after
.supports_cong_ctrl_max_msdus was added to the IPQ5332 hw_params entry.

IPQ5424 (and possibly QCC2072/WCN7850) appears to need the same change,
but I have no such hardware, so I have limited this to IPQ5332 which I
could test.

 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 7b86f324b..a20c21807 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -664,7 +664,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				   BIT(NL80211_IFTYPE_AP) |
-				   BIT(NL80211_IFTYPE_MESH_POINT),
+				   BIT(NL80211_IFTYPE_MESH_POINT) |
+				   BIT(NL80211_IFTYPE_AP_VLAN),
 		.supports_monitor = true,
 		.supports_cong_ctrl_max_msdus = true,
 
-- 
2.55.0


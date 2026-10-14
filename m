Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181EE48D862
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009183; cv=none; b=EXou3XTHfLOPcqn2iLOY5e5jj3WmqdSC2roHW5UTr2+S6+hL0/Hhw3z6+p/PqjxzHAgGsblvacttNP34ZvrT+E0VSDm5mWs3bDNFwjBAHV0AV+PO1H7cIKAJsXc0PBynuY4gvSqKWuHhYLhH0wfa164Go30yCajkZ6G3HMlAYoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009183; c=relaxed/simple;
	bh=k1D2Jt/MIMBi18JJ3Pt1Hkf+TwV5cUpgoCJZNM3kUto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2F2YKEhhcIU5QykNe/RLSA/qUvcK1co9Qf6JakZsvhGRKgzDjoINThza4NMmYSu0Oeslo4hb83e8NLNYiwtqdxZhPWc7gkXCuzRUoELnbf86IZx4+E4Q79Ge554sI2t9rYxcgA93bSo40CZjDCxkGKjx88kbojQ1461bQsxMl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBnBTHm/; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBnBTHm/"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48c4d870d54so2882501f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792009180; x=1792613980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OWEw1y+7jiUWTAz/9BEGibbvR7uznEdBfDaaovYCeps=;
        b=OBnBTHm/FkkQTkD2chiu35SvD7upEnXnKmecrVI3S7wDlonoTuzZgzM+hjTX1VmpYy
         QQHkSHVD58aegvUgrNrFt02hoIBkDzs6jwh9OyGBu7EVPGXI8ilhnKg7p/cj2o3pWftx
         lL9Drok9uMfNUalZfeHT90XSj6jZutLCXahUQyLNjs4Aqq8LYemSQdxg4VH3AyCqOCQJ
         rCpBI3lLHftfTdEPgxmcMiWSM/OBEla558rq0yighjgaVQd2CUYIHX3U8ur3UHK9f31b
         FNBOR8pHqa7KHC6GkkQ7Eq8TJsMvv7n0/vPEVUjrovK+21ofQ+h+Ju1jyCUJIkpmQXLP
         1CYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009180; x=1792613980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OWEw1y+7jiUWTAz/9BEGibbvR7uznEdBfDaaovYCeps=;
        b=ebqjmn4e2pAlpdxpbtZuFIfFWWjZjf64XoCJmzAsUrtDc7nS+EpSnl4SvJErk1VUBz
         3OJhx3WjU1DhEBQb8m5IUypgqXpOUVr9zCs2yskLJwKvKVrR5XNgsLo9+UR55pL2axtH
         /PkgNbakvx6XdRJDIFdOXeJWDcCSVRqZkpK501U/ThskYVRnQ1mU/GqWn7XrWcyvMP59
         BqEeDhWAr67W2DsQ3+X0uWNrEa/wFaZVXeBqHOeJ1J5raoTCOsvrZLSRSm7Q9XNb/jq5
         Dx8isYRC3xH4uJZpeUJpMrLztuDlGT/eOx3Ky+uDQjCJbtbDfKHQZh/mkZj+rjnwVXdO
         2jGg==
X-Forwarded-Encrypted: i=1; AKwUvBxAVe3JRSJTxrx8JMaSDGo5FItvny0wT6PQsPcaEz306uH5evKyjMXn/SqIRmoA9pw7gOgbsHYt1GioUX1JDw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKEUX3Xx40frzkTOzu8sM6cA5s6k1rHxPosCm/LXMPcLcxq9L/D
	iU4eXJMw3KIo9NoiRA3aRFBJxzcyjj+QVs/QkoVAHIKT+cC+BGXcIxAbpWczjRGRtR0=
X-Gm-Gg: AYBFou22XWuFPEZXo7Q9DkBli+QeWZKF/VGaPZcLMRCTiaifuFSaH/Cw0Iv3qH9IsdM
	EgLHi1pOY4AfCEp81whZadvlEPrH92q0fFWWVJZoutMZJSc8IEGZospANmvOzOqb1A/JXSe4dFv
	uUUzk+tlAr9gsF9zggUR247+RHoTFvabO2tvamh563vYiFk2Yhaw+aES9feXYfFFGhaEpL1z+U8
	7PXF8Foi9vLgv23Lpo7vfyeBDvRU4QndRy0mAqbXhaxBCsQfB11hjp1x3Dh75VjTVhMtao5QLHK
	bO4id0jpAd1hTFGuLOeA+oE0gWRNW7MT0/xuRT98KX+4g0LNfmQLmzJCERVmrhU/7MbgvH9GWHH
	SeEUBP8hMGXogtjUnwIlbueZBQWGmsFXI8mH6XsgAnXgZFXZqQs+01ckz5YjAYNwCAYNxmJFesV
	Rjiyc3laU6BQcbi6Da2VCTW5X8nOj3NFW8s6pJXI/grdbFklLtKuWWqvUXaC5UFIIGUynVTXTaT
	FrTdNGOstwnAnSgDkXvCtlWn60=
X-Received: by 2002:a05:6000:25ee:b0:48b:e50:715a with SMTP id ffacd0b85a97d-48dbace01abmr36901888f8f.34.1792009180027;
        Wed, 14 Oct 2026 13:19:40 -0700 (PDT)
Received: from localhost.localdomain ([188.190.249.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48df0f8f624sm2708292f8f.5.2026.10.14.13.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:19:39 -0700 (PDT)
From: Vladyslav Tymoshchuk <tvlad744@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: ath12k: board specific SAR table and coex settings on a devicetree platform (WCN7880)
Date: Wed, 14 Oct 2026 23:19:11 +0300
Message-ID: <20261014201912.4487-1-tvlad744@gmail.com>
X-Mailer: git-send-email 2.45.1.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jeff,

I am porting mainline to the OnePlus Pad 3 (SM8750, WCN7880 hw2.0 over
PCIe, firmware WLAN.GNG.1.0-03342). Wi-Fi works on a local branch, and I
would like to ask how you want two board specific settings to reach the
firmware before I send anything beyond the WCN7880 support itself. Both
are handled by the vendor stack today, and both are properties of the
board, not of the chip.

1. SAR table selection

The board data of this tablet has SAR V2 tables. The stock user space
always selects one of them per chain (index 6 for both chains): the
vendor driver sends WMI_SAR_LIMITS_CMDID with SAR enabled as V2 and the
table index in each row. Without that selection the firmware runs at
the target and regulatory power of the board data, which is above the
SAR level the device was certified with.

On ACPI laptops ath12k takes the BIOS SAR table from the DSM and sends
WMI_PDEV_SET_BIOS_SAR_TABLE_CMDID. A devicetree board has no such source,
and ath12k has no set_sar_specs, unlike ath11k (enabled for the AHB
WCN6750 in 2023). The limits the device was certified with live in the
board data as table indices, not as dBm values that user space could
hand over through NL80211_CMD_SET_SAR_SPECS.

Which of these would you accept?
  a) a devicetree property of the wifi node with the default SAR V2
     table index, in the spirit of qcom,calibration-variant selecting
     the board data;
  b) set_sar_specs in ath12k as in ath11k, with user space providing
     limits per frequency range (the board would then need its limits
     as dBm values from somewhere else);
  c) something else you have in mind.

On my branch the WMI parts (the SAR capability in the service ready
ext event, the SAR V2 limits command, the SAR2 result event) are
generic; only the index comes from a module parameter for now, which I
do not intend to send.

2. WLAN/Bluetooth coexistence settings

The vendor driver sends WMI_COEX_CONFIG_CMDID per station vdev with the
values of the board's WCNSS_qcom_cfg.ini: tx power while BT is active,
antenna isolation, BT RSSI and interference thresholds, TDD mode. With
none of them sent, A2DP audio drops out on this board while Wi-Fi is
busy on 2.4 GHz; with the stock values it does not.

The command itself is generic, but antenna isolation and the power
limits belong to the board. Would devicetree properties of the wifi node
be acceptable here (ath10k has qcom,coexist-support and
qcom,coexist-gpio-pin), with chip defaults in hw_params otherwise, or
do you prefer another source?

3. A scan observation, in case it is known

With no vdev started, a scan that mixes 2.4 GHz or lower 5 GHz channels
(up to 5330 MHz) with upper 5 GHz or 6 GHz channels does not report the
lower 5 GHz BSSes on this firmware, while the same channels scanned on
their own are found every time. A connection manager at boot then sees
only the 2.4 GHz BSS of a dual band access point. Splitting the scan in
the host works around it, but I would rather not send that. Is this a
known firmware issue, or is there a scan parameter the firmware expects
for this case?

Thanks,
Vladyslav

(I used an AI assistant, Claude, for the analysis and to draft this
mail; the tests ran on my device.)

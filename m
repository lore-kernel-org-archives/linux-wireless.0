Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38F54E8E04
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109628; cv=pass; b=g11dUCC0eKRg/Y+GGTABTQ6KMmph8am1j++fdAIYr7ABClHuhW6NWU1r5mrwxN5xamkHQuP/OJbKGc5MFDFuF/A+TTKhQll4mNoeSS6fYB28DzF1hndc3qK9TyMBDblPfbAPGyjoMQR/ph5A85RIuN/oUxaoSEXokNNstCPRyzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109628; c=relaxed/simple;
	bh=2WWl4epRjDFTP4CssGLx0mm/aO/ja1ugVc3Uht6W5xQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=t6N30wwd38m/nQsC2+mWISkVHdIh3TPMUkLHbfe2WiCT3oaZ05PdH6ut4cgTlt1OOihwpezkoABupl1T0CltJZbG53ldF3h0kVKib/MsyuzKC83dY6OAyi2J8ehG+3m1FwlCyjbAi275fzOKPX9Kgl2wvktLrkKhh1vCxBGF2Uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxjYwXuZ; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxjYwXuZ"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672ce86b21aso324025d50.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 13:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790109611; cv=none;
        d=google.com; s=arc-20260327;
        b=sanUDJJ8DgQ9DSL5Jy31QSrbuzSE5GNwTvBo/EarETnouB1iUFczZRTQOlRnd2spK1
         QPnMdEc1zk8EZSvQZ5JTXwXWRiMDxQ3QfnsjQMpLQ9C9K3zREHPljlQP8Hv2IKRyCB89
         +EjuplVuEKgfQ5DmqivDp0TmAdDI1x5RDSoDS1lSlDOYvkVWrag+0qB6FN6oK0gddbk9
         HDrS//R8kTS0RUP0z2i/yP5EwaWaJ5C7pJRu9RKamqag5LIEq8pXBO678tVuPAkHrt9s
         ggjOqFcwjra3UrKlu4SrkyTu586jmUaVf9BobibARbobE1sMwWrzU7T+DH5XRKqk9Xf3
         k4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8LKk+1yCqqSBPwtpjm5MjX+FdXoGXWtVvIQvMys3AHQ=;
        fh=257NU1k7yWpMtvADl0QXIxasDlKNfhRrsESSisMuHik=;
        b=LSSCZ8C3WeFkAQZmsApIRCNZ5rJpnRwHWmikIkc2H9JmTyGbeJbgy5XrO8VIeXURIY
         P3gzYjUv1nGMwSA3C4/ZU/V2Zs0PrWHGhhOhEygucoiCDzJW4S/xgb2vDfc485DtPIlr
         +nQl2u/voYfsRH0bcUlggaWJEPR6UWzQXeaJXR/DCnLZSGyCVlHXIVCezLBBTuh0BWSF
         6/MBsuO2Hf0f5lnCTOk1fawJ4CbxDGMHr9kbttLjy01Mde/yMmnov7P3Dq6hcFcoEiK+
         X8B8teeGQZ7cLHjPQz06a3PFpdYcul/rIA35a6yDDJ/+9noYGOa6qmqY3B11Q3PsAWti
         SC2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790109611; x=1790714411; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8LKk+1yCqqSBPwtpjm5MjX+FdXoGXWtVvIQvMys3AHQ=;
        b=gxjYwXuZ6YbEoNbWf1o3A/UGARKhqIZ6u1l2n+F3gtHwu6Q441PIlDpsGqMizDzdxC
         7S2ncJKLkEXrUyeOQeMToD/uK6gXwu6EAr5VESapZhzHbEIMbhup1nUs2DCjtIzPWU68
         XmUfkfcuUw+Pa2Snv30erTkqBCR88D9p+GTXICEwv85oFFISTAcFiL+7+pCZIrCrFRFE
         fSVxctz6B3Mh8GXVdwfAFx3c+PSO2c7gztQueP4WMLnivagEIgcalcvtdaj39trDXmRa
         ed8+LZndtm6+uhFmItv4o/MvxXMrSzfw0Xk685bUPL9DJrM8UkKq6fMsesBQuJaptOta
         OWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790109611; x=1790714411;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8LKk+1yCqqSBPwtpjm5MjX+FdXoGXWtVvIQvMys3AHQ=;
        b=F8bthiIlkPCQYfUS4sF53itB9wmqHNeeQRAoSF3usNOcumS/Kqk+LRcE6PXXzWRKk4
         gH2Od++1fPBFKtfpAXl5kMYUIbkJ1FtyzFzpUCdiVb1MGybIJO+CB7M9ahDDqgwSCh9D
         tPslm0ywgkxVzfpwD+kiEAbi+0YmpxwHf2hOMBP05TbIjWKNtTTfUftLohRXuHB+Hd1N
         f+86Xq/OFkO1yQ89r98Sbr2/BhXvbTAyZ4S+wGgwd1tEWOTZQDrDz6EnvwICmbCg71zi
         gw2RCgIH32/NfPVxsm4+Vbr66rJONexuJHL0MxNpLf5m5LHIvBjCC/FriqIz2Q1+Xco3
         dNQg==
X-Gm-Message-State: AFuF++kNV+pgrZEE9WwVTmdpbBJLG2QGS41PvrxH/+D4gsA9I2pGLPEH
	kEKgcnbGp78ryfRaFnGS9ExstUeyNbKm/ITqDkW5IPDVxTjV7K0T4c+6aM4FRdJ3n42SsVu/y7T
	CjxmXrNSy2jPMykEE4fyNvRFKqIe03lNfhydj
X-Gm-Gg: AYBFou3ya1zXuiqjUqgrBj7qZ1qoTRcVP4zGLPA1kO98hdrIoTFArCPmTBjkXmiEkvP
	22ln0idO3/5ssJRfgzBSKZlIdq04U5o5kTDEIn3quebstsbn69g8jYfVHwTQZYDdvBqbKZpl0+s
	xDDfXJ24ugRvWAMsr85XfhZuiMz8WmbCBovfuZSHirFi/6FKIoijTClC1+wVwc+dO0UES1Jyyye
	gFpduPlk0YFb5K/WOHuTL69TX3GZ14tsIgs8IZbUZBaXYYDkojGpuPA/5D4DCyNsyL+cMeEnJJ1
	pVpFLERaVFsMIK0RIE+xCCgov3Hes3+UGYLeh1Xa9L2hYPVznEy3FWJgZR+gS6D+i56veO4YPZt
	XrI7uoLRBzW4bkYY=
X-Received: by 2002:a05:690e:1343:b0:66c:c7f5:df48 with SMTP id
 956f58d0204a3-672d5737312mr369236d50.1.1790109610569; Tue, 22 Sep 2026
 13:40:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tom Janssens <herrwaldo@gmail.com>
Date: Tue, 22 Sep 2026 22:39:58 +0200
X-Gm-Features: AclHuK88cmyEFXyd_rMshdRCilgjP8259GdegHuH_NG85VY0dAA4AfLbB3s-qcc
Message-ID: <CAAsBusP02gPx6=i6rYqGr71xkUuCzpkG9ujE=DfuG2Y9qmPfXQ@mail.gmail.com>
Subject: ath10k: QCA6174 hw3.2 DMAR write fault on RX of 802.11k Beacon
 Request (fw WLAN.RM.4.4.1-00309)
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm seeing a reproducible IOMMU (VT-d) DMA write fault from a QCA6174
that is triggered by received 802.11k Beacon Request frames.

Client (laptop)
- Dell XPS 13 9380
- 02:00.0 Qualcomm Atheros QCA6174 [168c:003e] rev 32, subsystem Rivet
Networks Killer 1435 [1a56:143a]
- ath10k_pci: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:143a
- firmware ver WLAN.RM.4.4.1-00309- api 6 features
wowlan,ignore-otp,mfp crc32 0793bcf2
- board_file api 2 crc32 d2863f91
- htt-ver 3.87 wmi-op 4 htt-op 3
- Kernel 7.0.0-31-generic (Ubuntu), intel_iommu enabled (default
DMA/DMA-FQ domain)

Access point
- Xiaomi Mi Router AX3000T (mediatek/filogic), OpenWrt 25.12.4 r32933-4ccb782af7
- wpad-openssl 2025.08.26~ca266cc2-r1, dawn 2025.11.07~7414c34a-r1
- DAWN: update_beacon_reports=20, rrm_mode=pat (source of the 20 s
beacon requests)
- 5 GHz, ch 36, 802.11k enabled, PMF active (requests have the
Protected bit set)

Symptom
While associated, the following appears every ~20 s:

  DMAR: DRHD: handling fault status reg 2
  DMAR: [DMA Write NO_PASID] Request device [02:00.0] fault addr
0xfc2d1000 [fault reason 0x05] PTE Write access is not set

The fault address is different every time. There are no ath10k
warnings, firmware crashes or restarts, and connectivity is not
visibly affected.

Trigger
An AP-side monitor capture shows that DAWN makes hostapd send the
client two Radio Measurement Requests every 20 s, 5 s apart:

- Beacon Request, op class 129, ch 36, BSSID = the associated AP,
passive, duration 0.
  The client answers within 1-2 ms with a Radio Measurement Report,
mode 0x04 (refused).
  Body starts: 05 00 67 00 00 26 1d 01 00 05 81 24 00 00 00 00 00 a4
a9 30 c8 5e 5f 00 ...
  Reply body:  05 01 67 27 03 01 04 05
- Beacon Request, op class 129, ch 116, BSSID = a second AP. The
client sends no reply.

Using the ath10k tracepoints, each fault precedes the ath10k_wmi_event
for the ch 36 request (id 0x7001 / mgmt rx, len 152) by a constant 76
ms (+/- <1 ms) over several cycles. The 5 s / 15 s interleaving of the
two requests matches the fault/no-fault pattern.

What changes it
- Stopping DAWN on the AP (no more beacon requests): periodic faults stop.
- Client disconnected but interface up: faults stop.

No effect
- AP width 160 -> 80 MHz : faults continue.
- Disabling ASPM L1 (incl. L1.1/L1.2) on 02:00.0 via sysfs: faults continue.
- Wi-Fi power save off: faults continue.
- Continuous traffic: faults continue.
- Runtime PM: not active (power/control = on), so not a factor.

Additionally, even with DAWN stopped, a single fault appears once
after each (re)association. I haven't confirmed whether that is also
RRM-related.

It looks like the firmware writes to a stale or unmapped host buffer
when it handles an incoming (protected) RRM Beacon Request. I can
provide the full dmesg, the ath10k trace and the AP-side pcap, and I'm
happy to test patches or collect more debug data.

Thanks,
Waldo Janssens

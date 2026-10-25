Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792903346;
	b=HLhLVOAVAtKu2v0JT2GeNrDcqSnvlA+nbrrFGG2a4TNEQ/WTA3bHw9FiJbtBi+T28+7g
	 YdfITkFbbaY9jmGyEkM4+2X74NJp3aMYu0/m7iSvkzBQusJyjgkGplB4ihRi/AxHZ+jGC
	 YiK4WpCt1/LfQHlKh1Q5snZ7FXzwnTi1uwDK4EeFIrsho3JKNC0DLdbUdxTVd3FYpnshN
	 k+68CwwrcH38W5v+sxh+ZuuD7UjEQRHyds98yXO7SOoLjcsdLDa4Zw6noxMd73BQDXxwp
	 Def1NdHsvjkJsATRfMUSyN/So4C+B3Wq9Od5sj9DgngMNpXb5OUCm/yI0Nb9KtxjPYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792903346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OPCO9YjhwU3PhMX64BE3lbyAyE6lOGZesBGgUHvyjoA=;
	b=hqUNHBP8E3xm2MPrR3wd3TawNcOR5pnCaTctbfslyDW1qt82ctwWqjX6HHF3GOP8Fzf4
	 U5GqRA/UqVLqKdNT0hfVqek4lN8r6fYCKvec6844VBsQ6uiSBXxmXgEsB4Af1Y/3D/uhq
	 QeMZnsyWhI2S8rlQULCTVfqKXiSB6p8xPc0VHDWZc5F0xsu0TVfw4kHbbz9vgcqm/LPti
	 t45YyX8qZBjfpuPZigTcI9imNhtWmNrXEWrVYtwAZ15d2Yvr0zHLvR24gNwQsL1N4hWhc
	 hT66hgvjYACinZ5ErMP2xLCbPzvKpeyUFb3sQ2hQ9aUJkdZ2B9IjGNdSsTH3i9WbsRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=B+jXhrRg;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68217606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 04:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68217606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=B+jXhrRg
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-35c76e9614aso3253790eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 21:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792903345; x=1793508145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OPCO9YjhwU3PhMX64BE3lbyAyE6lOGZesBGgUHvyjoA=;
        b=B+jXhrRg1WLOCCS9x9cLhNR1waXyZOGYX1tBD+5mOAcP2TmANIwfe8TrwN7eir8gPo
         zThl5XwZr4JCVUy6dDe1KsnGW9iU2tPHRqAsYAdxEWjY9pPd0sONQ3CABdX5eAqLBNkv
         m6bpp6pzKfni20VAqQcWLPcUK7z46nF4uDfcWIIn/EU6VRcEpXVcD4Lg57SmoqTMHouK
         9sSxYjz9jlM99nW+DyndOx/w9uMav59qJvBB7eKbRKMbI/WU1+q7gxHwrVvg3bPjgfJn
         D3suExZV57f3ac9/SrLja9XeqlCchXyqLeN9yLk8Yx3F/yWEZmIQ1yG0eqqrv8EdNc+3
         9emA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792903345; x=1793508145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OPCO9YjhwU3PhMX64BE3lbyAyE6lOGZesBGgUHvyjoA=;
        b=BVlEoArzRNcTXw5w1g0iIrKeJy99+1otanCgyJfcGPP+xX8yG1XlcxgwzWD28aVoYX
         tQ40+TKYtxsKjJejEAZYQT37vuTkYTrkz7NESRBl4mgM5wqvvlVKXulqUixXAuYOtu7v
         7ypD4vSxSheqzWYiVxZ9nCYeL8E2itRNecP0fl91rSZ9oWuOnT7cf+hIAOPlcu+PYSVV
         GoNbYCFFHIIzi+UDwoek0NYSL6Tp4457irKI3xZ+hTE6VFdjzDDR6rwFQuD1YyBQE5dm
         3H7KxKWh3HdMktc9l/aS8hy+VUJ/Omf44+fptbvIKKD2YbAKsiim9w1svaNaCkN7pXJq
         tR+Q==
X-Gm-Message-State: AFq9FYJ0vm6EyNdcCO91RcIqXistTHPF+89KpSq1o5ThJe+13PBEc8cy
	/s8OnS6u0Q5mgX1R4cGQQDFkXYKXEl8BdjMO4JzX0sWIPHi6olMG6Cds
X-Gm-Gg: AYBFou3ZexVi7Zpj9IWY+4wlytHWwyAQeWAcuKRlh9nC1QhuJoEkr3UbfXfBy1IQH8K
	fAWKKFug9Rx5Ong7jn9w+1W7kcymHe46mk6RCQ3+Mj9KY5nVdaRQxGytO65OfdlbIzYXLnJef7w
	LCouKeMh0dPsLShaMI7+m3hPLETEOw+BRDEIqZlFtKDkpuKgFjTubBAVNWWEiK8732S7VWApFG5
	IipMhKBlOh7Ke5b6E2z8LK20RG92ghXBDKA92wHBKTMXdzd4S6rFqguBPhQgHrD+37bafsi0h/t
	imd133OwNZ3TRMnyccXs9YBe6CIzp6UPdB2Q150hySjsDixzECaEjV9o3wY4yemsZqft4SiS+Az
	SUrP+z+jTBgfY8jBQDhWNrWQDgOLG1BrpbUJ8vfc+TV5h85kORLzbaJsOcP9iFhMQCK5kK3Py49
	UEWbfjPLP5Y/YXZfiF60tgb3GMd5GAqQdtRuZYnsFKNCIAn1vr8nWkMOMJr0HxHYMI6Zrjz2JDI
	nNMxdCGvWJPxtIkV+vFv2tkUEhHvgb2pnQhk/j4uwv+swdDtg3tQf4PSNIgQln5uaJB+oKrTR6F
	nFrrl0km4j5BAaLEC0owEQ==
X-Received: by 2002:a05:7023:a86:b0:19a:8e3e:530e with SMTP id a92af1059eb24-19a8e3e563bmr5147203c88.8.1792903345218;
        Sat, 24 Oct 2026 21:42:25 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a37c88aasm11130088c88.23.2026.10.24.21.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 21:42:24 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	robimarko@gmail.com,
	openwrt-devel@lists.openwrt.org
Subject: Re: [RFC] IPQ8074 v1 / Netgear RAX120 v1: interest in support and review prerequisites
Date: Sat, 24 Oct 2026 21:41:57 -0700
Message-ID: <20261025044158.1375055-1-dencity7@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CA+KzPsr0G_1tpEDyi2Dk_1ZF_JVeGJL5Y6_A0aCe=dY+5ufq+A@mail.gmail.com>
References: <CA+KzPsr0G_1tpEDyi2Dk_1ZF_JVeGJL5Y6_A0aCe=dY+5ufq+A@mail.gmail.com>
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

Hello,

A progress update on the IPQ8074 v1 question, in case it helps. Robert,
thank you for the earlier guidance on openwrt-devel. Your summary of why
v1 was left unsupported (early silicon, different peripherals and
clocks, pre-final 802.11ax, no public firmware) gave me a clear list to
work through, and I have tried to check each point rather than assume
the answers.

Everything below is from a single RAX120 v1 (IPQ8074 rev 1.2, SoC ID
323) on OpenWrt main with Linux 6.18.55 and backports 7.2. The work was
done with AI assistance.

1. Pieces that are not v1-specific, sent separately

- READY event MAC-address array bounds, ath11k and ath12k, now v2 for
  ath-next:
  https://lore.kernel.org/all/20261021-rdy-mac-array-bounds-v2-0-cf7f45f868dd@gmail.com/
- The mac_phy_caps stride overflow was already fixed in ath-next
  (7a246c72132e, 4c6eb712a91f); I sent an OpenWrt backport to
  openwrt-devel today.
- The secure WCSS separate-M3 loading, as an RFC on top of v14 of the
  WCSS secure PIL series:
  https://lore.kernel.org/all/20261025042100.1356088-1-dencity7@gmail.com/

2. Firmware availability

The HK1.2 firmware is included in NETGEAR's own public RAX120 downloads
(http://downloads.netgear.com/files/GDC/RAX120/). Six public releases
contain a complete HK1.2 set, in two builds:

  V1.2.1.22, V1.2.2.24, V1.2.3.28, V1.2.8.40:
    WLAN.HK.2.0-01792-QCAHKSWPL_SILICONZ-1.379352.1.389278.1
  V1.2.9.52, V1.2.10.56:
    WLAN.HK.2.0-01792-QCAHKSWPL_SILICONZ-1.379352.1.536141.4

I have a small script that an owner can run to download one of these
official images, check it against a pinned SHA-256 and extract the q6/m3
firmware and board file, without running anything from the image and
without touching per-device calibration. Repeated runs give
byte-identical results. This follows the b43-fwcutter model: the owner
fetches from the vendor and nothing is redistributed. NETGEAR's terms
do not explicitly cover extraction, so I am not suggesting adding these
files to linux-firmware. Both firmware builds work on the unit.

3. 802.11ax

I have no way to show conformance with the final standard and do not
claim it. What I can report is interoperability: a 27-case client test
on both bands, with an Intel AX200 and, for the two-client cases, a
MediaTek MT7925. It covers WPA2-PSK, WPA3-SAE and mixed mode at 20, 40
and 80 MHz on 5 GHz and 20 MHz on 2.4 GHz, plus reassociation, AP
restart, radio restart, channel reload, two clients on one band, one
client per band, and a bounded load case. All 27 ran; 23 pass. The
other 4 asked for 40 MHz on 2.4 GHz and came up at 20 MHz, which
hostapd logs as 20/40 coexistence with overlapping BSSes, so that is
expected behaviour rather than a fault. MU-MIMO, OFDMA, TWT and 160 MHz
are untested. If the draft-era HE behaviour is a concern, I would be
glad to hear whether an HE-disabled v1 profile would be a reasonable
starting point.

4. Silicon, peripherals and clocks

The v1 Wi-Fi block does differ from hw2.0, and each out-of-tree driver
change is tied to a specific documented or measured difference: ring
register offsets, TCL descriptor layout and DSCP maps, 16-bit ring size
fields, REO fragment-destination bits, RX TID/NSS field positions, four
WBM release rings, copy-engine interrupt offsets and tables, a shorter
INIT resource encoding, a 9-word VDEV start response, a CALDB request
with coldboot calibration off, a reported high_5ghz_chan of 6100, and
zero NSS in RX metadata for HT EAPOL frames. Each sits in a separate v1
path so existing hardware is unaffected.

Outside the Wi-Fi block:

- cpufreq does not recognise SoC ID 323 and falls back to a 1.38 GHz
  cap. I have left that alone, since the v1 voltage/CPR behaviour is not
  verified.
- The APSS watchdog appears to count about 20 times slower than the
  32768 Hz that qcom-wdt assumes (a 20 s pretimeout fired after about
  409 s).
- On a small fraction of boots (5 of 300 in the last long run), transmit
  on one QCA8075 port stopped while everything else kept working, and
  only a full reset cleared it. A PSGMII init change that gates the
  channel clocks, runs the soft reset and calibration, then resets the
  QCA8075 SERDES (closer to the vendor SDK sequence) gave 0 events in
  the following 200 boots. That run also changed the Wi-Fi driver, so
  it does not prove the cause, and I have not posted it yet.

I have not compared the remaining SoC peripherals register by register.

5. Questions

I would value your view on two points, and I am happy to be told if v1
is simply not something the project wants to carry:

1. Would owner-side extraction from the vendor's public images be an
   acceptable firmware story for IPQ8074 v1, or is redistributable
   firmware a firm prerequisite?
2. Is v1 support something you would consider reviewing, perhaps
   starting with an HE-disabled profile?

I can share the extraction script, hashes, measurements and the v1
series in whatever form is most convenient. No firmware or calibration
files are attached.

Thank you for your time.

John

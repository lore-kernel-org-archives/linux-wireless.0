Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E5422E3F0
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 02:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791512827; cv=pass; b=bxhvNj0B4W1kgixhII31nZUkJWD8xHGcIeRsaLEXheiAG8T8VSAAXKPtE/XH6fVelSPgzcgGWQr6dmk3F7OemqNdUTGvuslwEgryuWFJAKT97d8Xa0trwJDHaUgjKNBn2GKb596cn+nvPLbkUL6CN73jnfbMnZQ2dypHF6QU+js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791512827; c=relaxed/simple;
	bh=3b1loYLEhp6SOubHLa99kNhFwblaN+7+Puk9eyVwzyI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kB/a2R8C8SQzpCOowAERj25QzJ5eKy8N71RwvyV6Wma50aZsIoGwWbLzTvG/mXe3pmADxy4JRupvheDMlRT8gR74vspbZoxrKyKOkXacgP/o8+4FxgHw2LNQySYcm7+aeXh7S8/b5cGgOC6N4NjI6KXuCjKr1unFiELautsGIb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n1beMMYX; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n1beMMYX"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-745497ac8fcso1272777137.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 19:27:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791512825; cv=none;
        d=google.com; s=arc-20260327;
        b=YC7qhs3PjcYgrT8MMmnscWSho7bBfvbafR2EUS219UhdaVK7EUKvgfStHTXkAs2JNf
         NgaFfHsVm86mE8VIx7icRlxAKtaGODJEQr+E3UaW+vNGecpDSShubRy9qq5XsdK5pXjo
         XwNThgxjgGicDqORwnGRbeakcSOiOVZ+O+HxGWGygLlB5efnMV2m9cTC9TnSrLf/4Eit
         UteF8Q6iOxqomDbID+Fns2+6GBYCLfyO1huKbCjuwJeDTOxgWkCcJhsUAOaOOw38v43O
         hJ+YCoZySTNwQlEgkmy328H0IhZVnKYCITda3VGRoR+RuoW8rxsRVQpvNMg9hUmvDk4E
         BiaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=egxi+201yGET8ndQ3kOqOy3K5QsLp7SfAN0KuoJ9QK0=;
        fh=oCTNZ+ERBrbtkfMPw7n0IUReDZfGw+CVfzNMjqGgVnM=;
        b=OgJS5zrZ2bUvHQaQ/allzha2y9mEotoHT5V6DE6zhDvZjqT58tWEj3XmLd4z35EqwS
         D0+n8lTZKLA4MqyTozOvWADRgUy4AlRD42/K6RchMeKwUQ+OghE/i3Tv2ejJqDn1+RJA
         E5uaR7xoIXSj4dZYv9RXkiEQYEgmRRFHSBHM2BpScl1v1zsZkaAfFDWlHs/RcyInlyNy
         qSeGTpCADW44fjn8vyk8d1l9R9UbZmZ8BiV+Jijsy6DQKUZ3h+MKqbvAc4qPTk4CSEWA
         SP1Dyy79FrcW6Qi1Epmi4vRXBS7hboI0942Ny8XZLK66DnPKG6J380onhxvkij/UgEE9
         mvTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791512825; x=1792117625; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=egxi+201yGET8ndQ3kOqOy3K5QsLp7SfAN0KuoJ9QK0=;
        b=n1beMMYXdAPtBH6s2QArW8UfBXxEn4aLnkbwR9H9KWarK7zXaRMFOKhTmdLkbBNfkU
         t6nQKoiW52V8WfRqIEbHyHYWI8Eb14x1fuhaXcxyxXws9DiJLrZLYXikZ+U85NnHWcRV
         3CkkCtLl1lQxLhyRhwTU1TRm6IXG5HCT1GdUYTNDQsiGCPV6lsyKjkH5z/e0byCdSKnP
         9uMpPLgZN5PehxZqSbg/vnTOsr2/RrIAZRSFMM2eiZFUACmNTBjJ2P8+RuVIkOLk8vc2
         rqsQSxnTyw9dVwnUC2lUrWdEUPNZeZWi4yahARIvV+isXXaZZdOjOwQm1hjkTvjhiT2v
         zu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791512825; x=1792117625;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=egxi+201yGET8ndQ3kOqOy3K5QsLp7SfAN0KuoJ9QK0=;
        b=YZuzpQCZaHzDK4xHLBJVSjtt6x6QPr4g/Wskzt51qruAAS1+BcOUW5i+WeZVT8fwH4
         6Nyi6z6XYYSgAFe7SkiYUV6alJWfWSWNxOeaeHBvPyuxNTvEp3f6IVrw3XxAL0IS/dc8
         4mBKUBFuKzfUFpvwjGhuwq41yEDfAa23bcSjk+1YS7KFJI728t2I7+PeUUUbBaYqhRZW
         MLSU14DPKtkxnAgBNn7n1YBD7gqObpjZ43mBk4uXHl35kC3hPyVadOmr+Gyyca6QGvjt
         CH7CgAFOsaau05yKgCtw90nU+mwvP97WPjsJywVTjEe5ig1Tc/mk0HVQC3RB1sT9mudn
         iIwg==
X-Gm-Message-State: AFq9FYKRD3Imnb7BdtgvvSGqq7Tq7XFNfJrislZZ3OZ5VzqN1LUIa/Kz
	dbIN+raScsfFRmGcKizf9iviqeB9pBIRKWDxx9EjriuYSL6ga9JO6tRquG4/7awlbqWoXx4ZM9p
	DS1sDkxvvAwvG15lppKB0LS0ePu4LWi8liU/s
X-Gm-Gg: AYBFou1rZIq8VxZcAfavguAuU54MJqQysU9ETxUcXrXinw7WRccn8kT/om2qWzYQr3U
	Ny+/LaFFhmPPLeMkNwpbW9lnqWMkIRZoK1j2OXwWxxWOm8DIbpLrHWyru6tq869O+RRHVL0ZhRm
	tvwpNH+DG0MKxWuzVHznvTwWwNOirpTzzDFZEBUKWwPgoBwPNYkHC93Je9L/PXnPEH2uOfqMtJg
	BLVrajMDAUMHjJgpfBWrg6UvV4cmnMadVU4FvjRBmdCjGZhsJ0PoZ6gspWy4szQKG+B6jVEdcCm
	N1AoEAUc2ZLByoqn9tkxnFvPodRUFg1BNEHlpnPrvH86S1pFjuJsqQ==
X-Received: by 2002:a05:6102:6b0b:b0:7cb:1546:f54a with SMTP id
 ada2fe7eead31-7cb373e6b92mr162183137.31.1791512824847; Thu, 08 Oct 2026
 19:27:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Christopher Griffin <christophergriffin05@gmail.com>
Date: Thu, 8 Oct 2026 21:26:54 -0500
X-Gm-Features: AclHuK-bsiErsf7TWx5azqLJmbMhHSpk6SEMD_NhsaC9UTLVN3kQF_L2MJrtOq8
Message-ID: <CAKobHXBuRr2Mz=yqFoqzQpeL9nY6ZeXY1HftEwyUxPYoDkS_+w@mail.gmail.com>
Subject: ath11k: QCN9074 public firmware stalls at QMI cap request on C-360
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"

To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: ath11k: QCN9074 public firmware stalls at QMI cap request on C-360

Hello Jeff, hello ath11k list,

I'm bringing up OpenWrt on the Arista C-360 access point (IPQ8076A with
two QCN9074 cards, 17cb:1104). The IPQ8074 radios run the public
firmware fine. The two QCN9074 cards don't, with any public QCN9074
build: 15 builds, WLAN.HK.2.5.0.1 to 2.9.0.1.

With every one of them, each card gets as far as:
- MHI mission mode;
- QMI connected;
- host-cap and the memory exchange completed;
- FW_MEM_READY.

Then it never answers the target-capability request.

The firmware Arista ships, WLAN.HK.2.5.r4-00683, works on the same
cards with the same ath11k: it answers in 3.7 ms and runs normally.
Swapping files shows that amss.bin decides it, not m3.bin: the vendor
amss.bin with a public m3.bin works, and a public amss.bin with the
vendor m3.bin fails.

It reproduces 100% (every boot, both cards) on:
- Linux 6.18.55 with ath11k from wireless 7.2 (OpenWrt main);
- linux-firmware 20260910 (WLAN.HK.2.9.0.1-02146).

It also fails on OpenWrt 25.12 (Linux 6.12, ath11k from 6.18.55).

Failing, 2.9.0.1-02146, debug_mask=0x1060, card 0001:01:00.0
(timestamps in seconds; "ath11k_pci 0001:01:00.0:" removed):

  170.464 qmi wifi fw qmi service connected
  170.466 qmi indication register request
  170.467 qmi host cap request
  170.472 qmi firmware request memory request
  170.476 qmi mem seg type 1 size 36700160
  170.476 qmi mem seg type 4 size 3784704
  170.476 qmi mem seg type 3 size 1048576
  170.476 qmi mem seg type 9 size 8388608
  170.476 qmi mem seg type 10 size 8192
  170.476 qmi ignore invalid mem req type 9
  170.481 qmi ignore invalid mem req type 10
  170.488 qmi req mem_seg[0] 0x0000000054800000 36700160 1
  170.488 qmi req mem_seg[1] 0x0000000000000000 3784704 4
  170.488 qmi req mem_seg[2] 0x0000000057500000 1048576 3
  170.488 qmi respond memory request delayed 0
  170.491 qmi firmware memory ready indication
  170.491 qmi target cap request
  180.975 failed to wait qmi cap request: -110
  180.975 failed to request qmi target capabilities: -110

Working, the same system, driver and debug mask, with Arista's
WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1.691405.6.706957.1:

  229.140 qmi host cap request
  229.148 qmi mem seg type 1 size 36700160
  229.148 qmi mem seg type 4 size 3768320
  229.148 qmi mem seg type 3 size 1048576
  229.150 qmi firmware memory ready indication
  229.150 qmi target cap request
  229.153 fw_version 0x250affff fw_build_timestamp 2025-03-21 04:01
  229.162 boot using board name 'bus=pci,qmi-chip-id=0,
          qmi-board-id=255,variant=Arista-C360-pcie1'
  229.263 qmi firmware init done

Hardware:

  SoC       IPQ8076A (soc_id 391, rev 2.0), 2 GiB RAM
  card 0    0000:01:00.0, PCIe Gen3 x1 (root port 17cb:1002)
  card 1    0001:01:00.0, PCIe Gen2 x1 (root port 17cb:0302)
  cards     17cb:1104, subsystem 17cb:1104, revision 01
  QMI       chip_id 0x0 chip_family 0x0 board_id 0xff
            soc_id 0xffffffff (as reported with the vendor firmware)
  memory    fixed regions (memory-region), fw memory mode 0:
            card 0 0x51100000, card 1 0x54800000, 0x3700000 each;
            M3 dump at 0x53e00000 and 0x57500000

The vendor system (QSDK, qca_ol.ko, Linux 4.4.60) describes each card
as "qcom,cnss-qcn9000" with:

  base-addr       0x51100000 / 0x54800000
  hremote-size    0x2d00000 (45 MiB)
  m3-dump-addr    0x53e00000 / 0x57500000
  etr-addr        0x53f00000 / 0x57600000
  caldb-addr      0x54000000 / 0x57700000, caldb-size 0x800000
  tgt-mem-mode    0
  board_id        0xab / 0xaa
  qrtr_node_id    0x20 / 0x21

It also gives each card's MHI a 24 MiB shared-dma-pool (0x57f00000,
0x59700000) and LOOPBACK, DIAG and IPCR channels. It has no pageable
region.

Firmware tested, every one failing the same way:

  2.5.0.1  -01100 -01192 -01201 -01208 (SILICONZ-1), -03982 (SILICONZ-3)
  2.6.0.1  -00861 -00883 -01081
  2.7.0.1  -01744 -02409
  2.9.0.1  -01837 -01862 -01890 -01977 -02146
  (2.9.0.1-02175-SILICONZ-2 has 02146's amss.bin, so it was not tested
  separately)

Ruled out, each tested with the same failure:
- memory mode 0 (fixed) and 2 (dynamic);
- CALDB at 0, and inside the region;
- the type 9 and 10 segments given inside the region;
- the reserved memory zeroed;
- host cap without m3_support and m3_cache_support (as cnss2);
- 1 and 16 MSI vectors;
- a single card on the bus;
- ath11k_ahb unloaded;
- the vendor's PCIe CLKREQ/WAKE and PTA pin functions;
- two ath11k versions.

For comparison, OpenWrt supports the Xiaomi AX9000 (IPQ8072A + QCN9074)
on the same ath11k with the public firmware. Its board data is keyed
qmi-board-id=255, so its card also has an unprogrammed board ID.

After the timeout the firmware is alive: MHI stays in mission mode M0
and the IPCR channels are up. A forced RDDM dump of each card (about
46 MB, ATH11K-FW-DUMP v2) shows a thread table with wlan_platform
(entry in a paged segment), DLPager_main, IPCRTR, diag_task and MHI
CORE, but none of the main WLAN threads. The rest is hashed ulog we
can't read.

Three questions:

1. What do the public QCN9074 builds wait for between FW_MEM_READY and
   the capability response, and could someone decode the ulog in our
   RDDM dumps? I can send them.

2. Is there a known board, module or host requirement that these
   Arista modules don't meet and that the 2.5.r4 build doesn't need?

3. Would Qualcomm consider a QCN9074 build in linux-firmware that runs
   on these modules? Today OpenWrt can use these radios only by copying
   the vendor's firmware from the unit's own flash.

I can test any firmware build or debug option on the hardware. Full
logs are available on request.

Firmware files present during the failing run
(md5, path under /lib/firmware/ath11k/):

  1f7baaccad424a768233eaabb684b5ad  IPQ8074/hw2.0/board-2.bin
  90654417600d4438918ec9e5e42fcd3b  QCN9074/hw1.0/amss.bin
  16c532c984d22895601d2107c11920be  QCN9074/hw1.0/m3.bin
  efcfc16a938d16875500bf9250bc5a52  QCN9074/hw1.0/board-2.bin

uname -a: Linux OpenWrt 6.18.55 #0 SMP aarch64 GNU/Linux

Thank you,

Christopher Griffin

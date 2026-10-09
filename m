Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC8F4418E4
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791559967; cv=pass; b=ruDTbCgjvv1bFmPeEujTkiCUeCpZ2VEJtHnWVH68Q7XI645SgJS97atD+/bZUsUOdJGe4fS7uz3mE9Lqkamxl2bt2RLUVGoEY/A/TzRcNbtXGnZzx5q2wUWNQUVlUvZtvttHIk/9R1Fl7rX/iBfyFoqGu2qFGK8xfj8TMUSdLSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791559967; c=relaxed/simple;
	bh=P91JI+UrZ8E6AI38CcGCwLi1QYqPNiFBnsJ7ztDHfPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kbsx/2nelaBWbtXLnO6iETaNUDvFGw9PSu5AM/j62dj0sM8s7RgWrUMAYiJEJPm4AFH11YgTh3GgVlf2cULg2VbWXc9BSKOw49frFOXI+IecKAlTbAdkkKfVDFwNz5oTlZzmpTqOplkltt69/2Cr7JDsZN2Vo0oxo+oFHvALWCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lWgUomxa; arc=pass smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWgUomxa"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7cb3388613fso588778137.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 08:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791559964; cv=none;
        d=google.com; s=arc-20260327;
        b=Wne9FQECGYUSf7vQPajHkDWiHny0ya4No8MFQsQViH/1QW0LabLCk1hbRAl3liEE+j
         uozZMt34HToRuzDfCbof6XyfQTOwWKdcvkEhWte/N/njkmTg2CmDQei3vjUz/GUaV9Rl
         9Z1Wi1q8gQ3qF5CXgalr6uHY94Dnlutw8AoEbiwkl5bumjg/ZuCvYrb20xa8ikgP5lsH
         +8AE7jJO81J0ZzucF3wTqm4P9Ak2d3ZiCUk9niNbBuplXKOlHKdn2RCY6qfbQ/OCAKRy
         mmjTCVPvtYN+ZPeLTIo8/MA7JpJeiTBV23xlIqSCsC5bAnIY3e7T9TqLfarpXtPNrumK
         OICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oK3Ivt8NRMhrN8+YhB16r8C5VJnRhcnbe0Nh4n/MAUU=;
        fh=3wVLLPpzT9Cm9dqVC/jqgD1CpGvU2Mw7lSs9jN8dYDk=;
        b=SkSqy2/sixQ7NfoQAdccxh3zvWSTU2uFa7n8nZmiHduyAKnxWKon0dyKMIL6vRZxBL
         EyjFI9HCl995+4lCbwlnDykndSa076MWXXujdDfrtBmI3s0H5rq/JDgWKUSbEmfsmd41
         4uK4YnrT74jVlOY1kZypLfIWdpN9GR5L1d8WGtw1cAwnFvVBPJRKNMVvmNECg9IpCtdU
         rkyYJFzNvUteeTmiKxvsKk7tojBTq2LQikX/i+Zv3EPF9lonLQUMXJb8C5UT4A0XbJE1
         jTQlXAQWPFIIgynuyRl1IctZsPgDVWct5Wzu0Atlwyzm4qE3/A6m/oaDGIpyCNm6xT/v
         pb4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791559964; x=1792164764; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oK3Ivt8NRMhrN8+YhB16r8C5VJnRhcnbe0Nh4n/MAUU=;
        b=lWgUomxaQ3CI3ejQOTX9y/qDY4MNp6lBQo0/ahqdspDkWy+He/1zDoVeq495X9Mr2+
         GhzkqQUr6i+UTdn+ijOsUOx5XIwCzdPI6jcwc6V3hRA2ZPsYXltIOdUDYO19FCyoGoZR
         kcG3lwxF1qvZkBvtRh4WLfim/CMXDmiJ8GQGQ/VSjU90RXnvYuCOJLcZNJsnYGhO7268
         ebZ2Obpl3gNo5OvK2LslqhRE57T3I7Ow0We7BRCmcrAl7085YB8MCv6/99dgu4Ip1Mpl
         YQdUPwZXIG4qNAAeks/Tvlyf2lsrmTlgKxsVQj11CdwaoGntwPv8lkkgdLjLaal1Kr9i
         Q1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791559964; x=1792164764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oK3Ivt8NRMhrN8+YhB16r8C5VJnRhcnbe0Nh4n/MAUU=;
        b=aopBqBZ4PonBfoV9/27mVi0uYYOZRfpc6V95mNXzLOHqlbRqi6ocTZE997VgyvGkGY
         Qko+RTkPkN8uc+GWx8dHM5RxctoFNxM21eOh2n9xPP3kRs1DYyxAhQQk1C7DF2ycqLSC
         FB33ZoLqPuSsyt1PGEmOWD1v7JOd6lUFPiUCr+4+tEi09dOgh5/a1u0NmnIfwB62UYph
         i42PKzPFvIaGjua/HV8ymWe3vIYAS5ODpqFBorYeCaNq7scgl4sW+JIE99SwFkBlw+7K
         U+fqwfCapHMFitNx05k6OWtR7Rkub2ZKA3++/7A8yVKFKayQAHpHpKYwjcERbgnAOOEX
         YXgg==
X-Gm-Message-State: AFq9FYJQTp4wXBfuz7LcGmDtnQRwxLd84B/KRasi7uVLyVeXh4QY2Tle
	yq/itZJrUV98JEGJP9RWn76JrzRyeTxquC113buHojkl+15hL1MsezfYK/eNS9U1ewJOxkigpau
	wjpU5jdps+fmwVxKRA67GdPoM5uIqJvxwVJcZ0J8=
X-Gm-Gg: AYBFou3s7jr7a/K4/+BsOGsqbVyoXZtmLEBB4g69qGGMcr/Ay7UYbz83AASODrAFTvO
	SW89UF3V5va+Wb/PU856hL0gZ4p0LwzHXOCaSne5kvmF1a1b5MM3EEStPNcIUwbkAiMrWu8NHaE
	k/NeNXsmSVibHQZ/4oUg9B3LFyPg0tUCbF8dPq+PSZjGhfzn/+Y2J98nOo5ZySNqOKHM8C4sPX2
	utIn7CfLmSuLEw5VkmpVah0uX+QHu32UxphgKpDqoS6hQT7n0s58N/WhICV2+Fg6SwAVIAxcK84
	ieZNFnUpG5Jjd/yCOC5Rblt4sGy1+lpeIC4gZ4nYdkgjAW1LJYf5czc=
X-Received: by 2002:a05:6102:14aa:b0:7c2:5692:1951 with SMTP id
 ada2fe7eead31-7cb373e4803mr871432137.30.1791559964184; Fri, 09 Oct 2026
 08:32:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKobHXBuRr2Mz=yqFoqzQpeL9nY6ZeXY1HftEwyUxPYoDkS_+w@mail.gmail.com>
In-Reply-To: <CAKobHXBuRr2Mz=yqFoqzQpeL9nY6ZeXY1HftEwyUxPYoDkS_+w@mail.gmail.com>
From: Christopher Griffin <christophergriffin05@gmail.com>
Date: Fri, 9 Oct 2026 10:32:32 -0500
X-Gm-Features: AclHuK_EQ-0DYke54sK5jxs4nUybyttZZCF6eDf-JhIc3m9-XUz1QLIcbxnien4
Message-ID: <CAKobHXCMdy1YT8SO+kkZP9sCr+KOhOXU+if_r=_hb_5pgKO0mQ@mail.gmail.com>
Subject: Re: ath11k: QCN9074 public firmware stalls at QMI cap request on C-360
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, vasanthakumar.thiagarajan@oss.qualcomm.com, 
	dchen@silexamerica.com, ath11k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Jeff, hello ath11k list,

A follow-up, with a request: could Qualcomm publish a newer QCN9074
firmware in ath11k-firmware / linux-firmware?

 I have Cc'd Vasanthakumar and Dawei, from the March thread "A question abo=
ut
supporting the QCN9072 radio": the second card here looks like a
QCN9072, and below is what it does with the QCN9074 firmware.

The newest public QCN9074 build is still WLAN.HK.2.9.0.1-02146 (built
2024-09-23; also what linux-firmware 20260910 carries). A build from a
newer branch, WLAN.HK.2.15.0.1.r2-00004 (fw_version 0x2f0b0214, built
2026-09-22), answers the target-capability request on both C-360 cards
where every public build from 2.5.0.1 to 2.9.0.1 times out. Same ath11k
(OpenWrt 25.12: Linux 6.12.112, ath11k from 6.18.55), same device tree,
the vendor's board data. That build came to us as redistributed by
DD-WRT, so we can't ship it; a public one would let OpenWrt support this
board with linux-firmware instead of copying the vendor's build from the
unit's flash.

It would help more than this board. OpenWrt has 13 boards with a
QCN9074 (IPQ5018, IPQ6018 and IPQ807x: among them the Xiaomi AX9000 and
AX6000, Linksys MX8500, MR7500 and MX5500, TP-Link EAP650-Outdoor, prpl
Haze), all on 2.9.0.1-02146, and some downstream builds already ship
2.12 and 2.15 blobs from other sources because the public build is two
years old.

What we see with 2.15, in case it is useful:

- board_id is reported as 0xffffffff, not 0xff, so ath11k looks for
  "qmi-board-id=3D-1" in board-2.bin.

- PCIe 0 (6 GHz, bdwlan.bab) ran 15 minutes as a 6 GHz AP (SAE,
  channel 37, 80 MHz) with no error, and a 6 GHz scan on it completes.

- PCIe 1 (2.4/5/6 GHz, bdwlan.baa) never completes a scan: a scan of
  2.4 GHz alone, 5 GHz alone or 6 GHz alone, each after a fresh driver
  load, gets no scan-started event, and then nothing more answers:

    ath11k_pci 0001:01:00.0: failed to receive scan abort comple: timed out
    ath11k_pci 0001:01:00.0: failed to start hw scan: -110
    ath11k_pci 0001:01:00.0: Timeout in receiving vdev delete response
    ath11k_pci 0001:01:00.0: ce desc not available for wmi command 16387

  The same with the fixed memory-region (ath11k then leaves out the
  paged memory, types 9 and 10) and with host memory ath11k allocates
  (every segment given), so it is not the memory. Perhaps it needs a
  newer board data than the vendor's 2.5-era bdwlan.baa.

  PCIe 1 is the 2x2 card (antenna mask 0x5, where PCIe 0 has 0xf), which
  we believe is a QCN9072 (the same 17cb:1104). In March, Vasanthakumar
  expected a QCN9072 to work with ath11k and the QCN9074 firmware (the
  thread "A question about supporting the QCN9072 radio"). With 2.15 it
  boots, registers its bands and then never completes a scan; with the
  vendor's 2.5.r4 it runs fully, scanning all three bands.

Both cards, and the vendor's own 2.5.r4 build for comparison, are here
to test any build you can share, on Linux 6.12 and 6.18. Logs on
request.

Thank you,
Christopher Griffin

On Thu, Oct 8, 2026 at 9:26=E2=80=AFPM Christopher Griffin
<christophergriffin05@gmail.com> wrote:
>
> To: Jeff Johnson <jjohnson@kernel.org>
> Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
> Subject: ath11k: QCN9074 public firmware stalls at QMI cap request on C-3=
60
>
> Hello Jeff, hello ath11k list,
>
> I'm bringing up OpenWrt on the Arista C-360 access point (IPQ8076A with
> two QCN9074 cards, 17cb:1104). The IPQ8074 radios run the public
> firmware fine. The two QCN9074 cards don't, with any public QCN9074
> build: 15 builds, WLAN.HK.2.5.0.1 to 2.9.0.1.
>
> With every one of them, each card gets as far as:
> - MHI mission mode;
> - QMI connected;
> - host-cap and the memory exchange completed;
> - FW_MEM_READY.
>
> Then it never answers the target-capability request.
>
> The firmware Arista ships, WLAN.HK.2.5.r4-00683, works on the same
> cards with the same ath11k: it answers in 3.7 ms and runs normally.
> Swapping files shows that amss.bin decides it, not m3.bin: the vendor
> amss.bin with a public m3.bin works, and a public amss.bin with the
> vendor m3.bin fails.
>
> It reproduces 100% (every boot, both cards) on:
> - Linux 6.18.55 with ath11k from wireless 7.2 (OpenWrt main);
> - linux-firmware 20260910 (WLAN.HK.2.9.0.1-02146).
>
> It also fails on OpenWrt 25.12 (Linux 6.12, ath11k from 6.18.55).
>
> Failing, 2.9.0.1-02146, debug_mask=3D0x1060, card 0001:01:00.0
> (timestamps in seconds; "ath11k_pci 0001:01:00.0:" removed):
>
>   170.464 qmi wifi fw qmi service connected
>   170.466 qmi indication register request
>   170.467 qmi host cap request
>   170.472 qmi firmware request memory request
>   170.476 qmi mem seg type 1 size 36700160
>   170.476 qmi mem seg type 4 size 3784704
>   170.476 qmi mem seg type 3 size 1048576
>   170.476 qmi mem seg type 9 size 8388608
>   170.476 qmi mem seg type 10 size 8192
>   170.476 qmi ignore invalid mem req type 9
>   170.481 qmi ignore invalid mem req type 10
>   170.488 qmi req mem_seg[0] 0x0000000054800000 36700160 1
>   170.488 qmi req mem_seg[1] 0x0000000000000000 3784704 4
>   170.488 qmi req mem_seg[2] 0x0000000057500000 1048576 3
>   170.488 qmi respond memory request delayed 0
>   170.491 qmi firmware memory ready indication
>   170.491 qmi target cap request
>   180.975 failed to wait qmi cap request: -110
>   180.975 failed to request qmi target capabilities: -110
>
> Working, the same system, driver and debug mask, with Arista's
> WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1.691405.6.706957.1:
>
>   229.140 qmi host cap request
>   229.148 qmi mem seg type 1 size 36700160
>   229.148 qmi mem seg type 4 size 3768320
>   229.148 qmi mem seg type 3 size 1048576
>   229.150 qmi firmware memory ready indication
>   229.150 qmi target cap request
>   229.153 fw_version 0x250affff fw_build_timestamp 2025-03-21 04:01
>   229.162 boot using board name 'bus=3Dpci,qmi-chip-id=3D0,
>           qmi-board-id=3D255,variant=3DArista-C360-pcie1'
>   229.263 qmi firmware init done
>
> Hardware:
>
>   SoC       IPQ8076A (soc_id 391, rev 2.0), 2 GiB RAM
>   card 0    0000:01:00.0, PCIe Gen3 x1 (root port 17cb:1002)
>   card 1    0001:01:00.0, PCIe Gen2 x1 (root port 17cb:0302)
>   cards     17cb:1104, subsystem 17cb:1104, revision 01
>   QMI       chip_id 0x0 chip_family 0x0 board_id 0xff
>             soc_id 0xffffffff (as reported with the vendor firmware)
>   memory    fixed regions (memory-region), fw memory mode 0:
>             card 0 0x51100000, card 1 0x54800000, 0x3700000 each;
>             M3 dump at 0x53e00000 and 0x57500000
>
> The vendor system (QSDK, qca_ol.ko, Linux 4.4.60) describes each card
> as "qcom,cnss-qcn9000" with:
>
>   base-addr       0x51100000 / 0x54800000
>   hremote-size    0x2d00000 (45 MiB)
>   m3-dump-addr    0x53e00000 / 0x57500000
>   etr-addr        0x53f00000 / 0x57600000
>   caldb-addr      0x54000000 / 0x57700000, caldb-size 0x800000
>   tgt-mem-mode    0
>   board_id        0xab / 0xaa
>   qrtr_node_id    0x20 / 0x21
>
> It also gives each card's MHI a 24 MiB shared-dma-pool (0x57f00000,
> 0x59700000) and LOOPBACK, DIAG and IPCR channels. It has no pageable
> region.
>
> Firmware tested, every one failing the same way:
>
>   2.5.0.1  -01100 -01192 -01201 -01208 (SILICONZ-1), -03982 (SILICONZ-3)
>   2.6.0.1  -00861 -00883 -01081
>   2.7.0.1  -01744 -02409
>   2.9.0.1  -01837 -01862 -01890 -01977 -02146
>   (2.9.0.1-02175-SILICONZ-2 has 02146's amss.bin, so it was not tested
>   separately)
>
> Ruled out, each tested with the same failure:
> - memory mode 0 (fixed) and 2 (dynamic);
> - CALDB at 0, and inside the region;
> - the type 9 and 10 segments given inside the region;
> - the reserved memory zeroed;
> - host cap without m3_support and m3_cache_support (as cnss2);
> - 1 and 16 MSI vectors;
> - a single card on the bus;
> - ath11k_ahb unloaded;
> - the vendor's PCIe CLKREQ/WAKE and PTA pin functions;
> - two ath11k versions.
>
> For comparison, OpenWrt supports the Xiaomi AX9000 (IPQ8072A + QCN9074)
> on the same ath11k with the public firmware. Its board data is keyed
> qmi-board-id=3D255, so its card also has an unprogrammed board ID.
>
> After the timeout the firmware is alive: MHI stays in mission mode M0
> and the IPCR channels are up. A forced RDDM dump of each card (about
> 46 MB, ATH11K-FW-DUMP v2) shows a thread table with wlan_platform
> (entry in a paged segment), DLPager_main, IPCRTR, diag_task and MHI
> CORE, but none of the main WLAN threads. The rest is hashed ulog we
> can't read.
>
> Three questions:
>
> 1. What do the public QCN9074 builds wait for between FW_MEM_READY and
>    the capability response, and could someone decode the ulog in our
>    RDDM dumps? I can send them.
>
> 2. Is there a known board, module or host requirement that these
>    Arista modules don't meet and that the 2.5.r4 build doesn't need?
>
> 3. Would Qualcomm consider a QCN9074 build in linux-firmware that runs
>    on these modules? Today OpenWrt can use these radios only by copying
>    the vendor's firmware from the unit's own flash.
>
> I can test any firmware build or debug option on the hardware. Full
> logs are available on request.
>
> Firmware files present during the failing run
> (md5, path under /lib/firmware/ath11k/):
>
>   1f7baaccad424a768233eaabb684b5ad  IPQ8074/hw2.0/board-2.bin
>   90654417600d4438918ec9e5e42fcd3b  QCN9074/hw1.0/amss.bin
>   16c532c984d22895601d2107c11920be  QCN9074/hw1.0/m3.bin
>   efcfc16a938d16875500bf9250bc5a52  QCN9074/hw1.0/board-2.bin
>
> uname -a: Linux OpenWrt 6.18.55 #0 SMP aarch64 GNU/Linux
>
> Thank you,
>
> Christopher Griffin

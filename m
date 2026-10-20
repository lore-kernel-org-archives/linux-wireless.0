Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792495984;
	b=mO2iqqtZmOH2DZxiToKUWAJ1TrZwxAQ9PJrez108Zc40nM9FUkmkEoWCW5Mcx7HD18Yt
	 qShtzyNSOlLT6bmJ6xIUByyj05innsFdNhSf6iPVdU9QuTT6InglUDvUPQsExkLBSorZa
	 DTqv8PVKixtN43ZxAd6Z9y0aysN6D4axHv48bPdek/IoW3F2O5n/CrjRTeHYUwtkqM3Ra
	 hFGFPYrtvycDLBLToSB+UxXvbSvbr6nIpXIJ/GI9gTJ4fs8NF+QUpUm/PZplWlxD3HCov
	 TR2FGYNPEsSFRUiMKeoyXJvIqrKcWzWfxpLHSnbWe09IzppcMnRWQs+/oM8H+HgZONg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495984;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=6w7JRuFovvwwUBTh/FtHv2xuiuhqO2jha1lfwIcoggA=;
	b=trR1psEs/0SFPmE/q6DaBm7NthUsSw+vcDytuB/Ux4rjpEmyBCQeTGRTxf2644Zgs9aU
	 5KZ9bBLHioSFmQjbglSHBwblLvVKLDnCaH7DsEL7uaDisCsdQWJbiv+ZxwxbGR94KbrdX
	 c01hJHc20qKpsmUFPVSoloeh4+uiCPB+yKorjjHCrzrG8X1virlk+lTVFo3zedtnyolJj
	 RChh89tRlLAfO2pL5U6v/oKuFiYQejvgvZPNZvD4LLKm2QhcZcAdBsIiz3R/fQas1o/1l
	 aRCYLCvqrWLasC+1Ib+OLS/bb0EYb63JtO7g617ltchWD/PBCu77lPObrAyy1ajj1mQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=kiddier.org;
	spf=pass smtp.mailfrom=kiddier.org;
	dkim=pass header.d=kiddier.org header.i=@kiddier.org header.a=rsa-sha256 header.s=google header.b=HmPFLRzI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.175
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEAC606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 11:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DEAC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kiddier.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kiddier.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kiddier.org header.i=@kiddier.org header.a=rsa-sha256 header.s=google header.b=HmPFLRzI
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5d7daf06158so985020e0c.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 04:33:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792495983; cv=none;
        d=google.com; s=arc-20260327;
        b=PPgOnIZQ0T9W1J+FpgA09U8bMSx+Su/UBD7DMUVFGhWiEIVu8pZHQ4snkFEDZ0VCjr
         tlsBqDn8N9G/44zRpy5XgaRkUcPyEJCeGpM0lQx7wX268v5R/1MP0UhY3snRbgGoSnFx
         ue3i1uTIYhu1mS2lmjXQKvYH6d9bd9q/NFFXAr5LieNPZ5UYZiiirmenXB8YdaOEYZ2R
         lcQ0vrjbbAnIplgTZ+x75Pjq0oR3Kb6WLrNUbepdicYW7pEyJVJID9iGsgY7Fhuq2976
         fD1tBsdVVp8TN3Ezi9USQIORD02K3bkWRLxWHRAVcc9mvXw8VwtfRTyP/gxpMZ40K0QY
         +fAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6w7JRuFovvwwUBTh/FtHv2xuiuhqO2jha1lfwIcoggA=;
        fh=eBrhJa1lJH37wwcsI1/3G5ARcZAHpxqz5uprsLVmFEY=;
        b=U/E/1FytWkWUHnxl9qRLjtKWkGRGfJuiAKkJFMS9ixTBCGvGqC5Ue5johx33pf0eC7
         68s9Q7LI7VwYOZEpYy/Zbwq1Nj38qUfR0LS2Aiiw84YkTiqe+KmYxhD50oc8I3TVeMqk
         Wsuq3uFxGgffkB2PLKY9053gYUTVytuqVzhTgynyQ2c8d+MTs5CMUjaQIU+CTtWwVs0P
         i+J3BMALDMdjjBRZst1xsu4FW6Kb7O0yQTD2nvuJfsi8nBhzMydH5T6rzn3s3nHsQaqx
         J4Td7zDUGgB6+gpjRJYapFxrceZCiYOn1YRmYeyAu++M7EF04jGX0sePgHCX31Gg2CwI
         G/iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kiddier.org; s=google; t=1792495983; x=1793100783; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6w7JRuFovvwwUBTh/FtHv2xuiuhqO2jha1lfwIcoggA=;
        b=HmPFLRzIJEU6VIC1JLZTRPO4QELtemCQd8BKkLQMmTZ+ZjU6pkhX6goWUYHvZRcCEd
         Dp+kf2mDBbc69bCEH6ShjqgjQCDWRWCzVXGAc2UoWuEYdZ3fHaqvOwoI6d4ncuz0SccR
         uurcDrehgKSe3Ue4CIfmTYh2I6Z7zD8OLi79M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792495983; x=1793100783;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6w7JRuFovvwwUBTh/FtHv2xuiuhqO2jha1lfwIcoggA=;
        b=zx4Kn3J692v2/qKp2THuvsJfT+4TXI73jVMp9X9Zp3fMZMpACyr+390vGbFphEpaOj
         rlx9Jgjii2JAjTia7eaBLFeJ24dTA93qZiWLM8moK+NaRCB76Cm1nc9JovAxhQBqUKIf
         e13jKf51OezPz0Z+kTT287Fihtp0dkBrGN55yY5lhImcnTOExjY1MG7FkuYQbfdohi/8
         lMPZa6Su/nWf22H2u4E8xASgmtQfblfgJqK5BhzDx93jZhEwqGFRIGSHOfST1ySDgkoF
         Uinpf5p0KNclCboTSA4RcB31aBMHfPPq78SCusMh5vgCqdZKLz2C/aoCXPLrFm/9llwO
         CtgQ==
X-Gm-Message-State: AFq9FYKFlWrp3YpDXrUrfnpAMEvWHG7Jo2/C2lQEr0msU3gyMleyT/3Z
	mBP9vcAfLxrvyTKSt45rdlveeUKqkCsm0lrRAjFsI0JE7NfX0/vMqYxcd7icN8mDjV0sWEjEIha
	mqI6uYzovcg1qObV2QUoqzP3ZOaSy6vmUr/QAaOKgKoi0H1d+0GQ8hXA=
X-Gm-Gg: AYBFou2Kp4Rn3VUKh/IIMSlQb/lKwFWU+ATORsAtoy53MMWWWj8BPwaEo5dmYnphBee
	DN5ccxOYmUjpt9dpDwkr0SdmS3JkltKfowFAGhHdiDbWrpw5tcU+VtY2S7iJ4t5OHYWMyUxrZV2
	QDSMfuy72mJHrMwuqk7TvQVaHEwT6wyKZjjvqLP7/XqptSnU/Ln3UoB18aHYDj77ibgNqF0Jgg6
	nE0zPQ99kdzxztvsnpV63JqhOHl2RqN9grwVzrdAYkeSnKghoTe0ETGrCXvLij2GNA5WzeQahwL
	WjJfvWupRs3pUqcsEOs1/hjH6f2BGxi79c4xv6R0ylYo/3ANSQ27qvH5rQ==
X-Received: by 2002:a05:6122:4307:b0:5e9:7458:9bb2 with SMTP id
 71dfb90a1353d-5eaaa392b1emr2875328e0c.5.1792495982934; Tue, 20 Oct 2026
 04:33:02 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Peter Kiddier <peter@kiddier.org>
Date: Tue, 20 Oct 2026 22:32:51 +1100
X-Gm-Features: AclHuK_5AI531dlJobOpneIUNwUkuWTyVSnUQajyWhdToxWSB6hT9Bldv5uGkoQ
Message-ID: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
Subject: [REGRESSION] BCM4355 Wi-Fi fails with Intel IOMMU on 7.3.0-2-t2-noble
To: linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev, iommu@lists.linux.dev, 
	arend.vanspriel@broadcom.com, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

I am reporting a Wi-Fi regression on a 2018 Apple MacBook Air with a
T2 chip, running Linux Mint Zena based on Ubuntu 24.04.

The Broadcom BCM4355 Wi-Fi device works with kernel 7.2.11-3-t2-noble
but fails with 7.3.0-2-t2-noble. Disabling the Intel IOMMU using
intel_iommu=off restores Wi-Fi on 7.3.0-2.

Hardware:
- Apple MacBook Air 2018 (MacBookAir8,1)
- Wi-Fi: Broadcom BCM4355 802.11ac Wireless LAN SoC
- PCI ID: 14e4:43dc (subsystem 106b:0843)
- Driver: brcmfmac
- Interface: wlp2s0

Test results:

- 7.2.11-3-t2-noble, default kernel command line: Wi-Fi works.
- 7.3.0-2-t2-noble, default kernel command line: Wi-Fi fails.
- 7.3.0-2-t2-noble with intel_iommu=off: Wi-Fi works.
- Reloading brcmfmac on the failing configuration does not restore Wi-Fi.

On the failing 7.3.0-2 boot, the driver detects the device, loads its
firmware and creates wlp2s0:

brcmfmac 0000:02:00.0: enabling device (0000 -> 0002)
brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4355c1-pcie for
chip BCM4355/12
brcmfmac: brcmf_c_process_txcap_blob: TxCap blob found, loading
brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4355/12 wl0: Jul  8 2023
17:49:51 version 9.30.503.0.32.5.87 FWID 01-e74b9cb0
brcmfmac 0000:02:00.0 wlp2s0: renamed from wlan0

However, Wi-Fi subsequently stops responding. The kernel log reports
errors including:

brcmf_msgbuf_query_dcmd: Timeout on response for query command
brcmf_cfg80211_scan: scan error (-5)
brcmf_run_escan: error (-5)
brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring
brcmf_cfg80211_get_channel: chanspec failed (-5)

There is also an error creating the P2P interface:

brcmf_cfg80211_add_iface: add iface p2p-dev-wlp2s0 type 10 failed: err=-52

I tried reloading the driver using:

sudo modprobe -r brcmfmac_wcc
sudo modprobe -r brcmfmac
sudo modprobe brcmfmac

The driver and firmware loaded again, but Wi-Fi remained unusable.

The firmware files are present under /lib/firmware/brcm/, and the
firmware version reported by the driver is the same on the working and
failing kernels.

The brcmfmac module metadata differs between the kernels:

Working kernel 7.2.11-3-t2-noble:
srcversion: 3B6176FDB720DDE8E7C596B

Failing kernel 7.3.0-2-t2-noble:
srcversion: 3DCA38D52402541701276CF

I did not find obvious PCIe AER or fatal errors in the failing boot's
kernel log.

It has been suggested testing intel_iommu=off after reloading
brcmfmac. The driver reload did not help, but booting with
intel_iommu=off restored Wi-Fi.

This strongly suggests an interaction between Intel IOMMU handling and
the BCM4355/brcmfmac driver in the 7.3.0-2-t2-noble kernel.

I have not tested a vanilla upstream kernel, so I cannot yet confirm
whether this reproduces outside the T2 kernel packages. Unfortunately,
I have limited time available for further testing, so I may not be
able to investigate additional requests promptly. I wanted to report
the reproducible behaviour and the intel_iommu=off workaround in case
it helps identify the regression.

Could you advise on further diagnostics, or whether this should be
investigated as an IOMMU or brcmfmac regression?

Thank you.

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792496986;
	b=Xljn7/UlP0Tmeew2OoQMoZSyGEb/Q0qTp/Ywys1IxIRo2WE3263nzyRr7B+H/TKMNDch
	 8dp8zDZ+rFGkztMMtW+pBP+SEJ/e/aut+9f261K7J1oO2O2vOYoOmzNX4374IvMl/GsZ5
	 Ygm3Ysh3tLDMnBhXCv/0YCaPBzhVowhdy3yYpW/cy+cfemil4K1QWAbdUExKQChgfRNGR
	 lkPvDIk6ew1sh9dvIGXMHJGE2qS7TzIxtrkwXnImdLhWDVs1y/HVSFDcTdxYvQroBi1FD
	 p/rwIMsBm6G+wuDfH+BxednSMkLqPlkjXulujY4XjMESOZYeFoUVZb5N3kOdlRwBSLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792496986;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=XLGNYitZ4EdMcotU/GOI9I5PtjbgIsDlPVNeP1wv+jI=;
	b=SxEAnjU0/DFhcYZslV4Tx1vxAWxr5v2De6iDQ6nMJHVSPDOwy8tytjbVSin6PqRbz7CI
	 PjN1nURaTH5vuc68rP2iEP157Ml8iZMAPvYDL60dXCRaKt8mJS0pfHmKefI1GAovKjgBk
	 Uxli3hdb+apvIQVRCe+AtyBHdDpQ1Eldstv8+nZzC/Z8eAogeIpBb2rdP16EEsTv0gr9X
	 NiYDTryh5GxFPM7QSc+Ufg6sFczWFvbm/U6HDLq98/NrXdzTlJavkylAA6iYHnHbRveGI
	 ZdK4y7zhBu6MQ2YJ62uvceofsTcuH1syr9iPe9oPObVlson69O5r6Du/RF50jqrhZBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=kiddier.org;
	spf=pass smtp.mailfrom=kiddier.org;
	dkim=pass header.d=kiddier.org header.i=@kiddier.org header.a=rsa-sha256 header.s=google header.b=jcEXUuFN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.177
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C61606A324
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 11:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14C61606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kiddier.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kiddier.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kiddier.org header.i=@kiddier.org header.a=rsa-sha256 header.s=google header.b=jcEXUuFN
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5eac01ff101so769064e0c.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 04:49:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792496985; cv=none;
        d=google.com; s=arc-20260327;
        b=sDNAMvlwtVdWqu9qv87FLlMdfG3Q+xXEFl9bUAfhfawR3U2MnlND7rudyIEG+xLVc8
         aSNfxJ8jDI6SZcl6yiz13KtVZRJiK8KZTZuiR/d4CskItZh9FEgL731IYq0AaY5PZh/3
         JOJoG+LBjjfzBBfuNEG8/NT3MSEOJwJcgpNcmLJtc/veo0NYN6usrHerb3D0xyRWh392
         4pee/NWaJqRYgyllp5ViU9LiZ6jEuC0mpkyyE8JvnBwoxVcs2YLmCCsIfsuxpwqviLNn
         GvLGK/cCGu/ORZpOAqhf1ZIoj6kppkhiodJjprU6PBCQBTUmqdyuUtMlq5bbWf/QcpsO
         5mJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XLGNYitZ4EdMcotU/GOI9I5PtjbgIsDlPVNeP1wv+jI=;
        fh=soUFqfkruCpqI1/Y82VNJnHTmeXhq4buh8XwThTmjsY=;
        b=Zue0B7GwS26ETJHsk0iOaNvyg7LJ3oAS6kcMgH161FYXBhhoeNTNtD62Hc/fQFVfsS
         Si10g9lJ5HSpK/nZYOVlqRIu8gq0W6oXO239itcb8SrFtMB8VosvlmcO/qzgyEHSefjE
         /MUAVZJMVkRIoG5uIQRfH5fb0593LvtJDdKClFNU5ocxDzTxBx2EQ0T8EoVtLwaAE3JX
         ppmr4aEMp4I5Z5SMVQP2o4Hz99lHzpThQtUo8o1UJid3CUXTQpi2rkzO0yWScrpuSw7z
         xcGXLT3mUF56YGOoYrRcXQOuZuD6w+lu0HJf+/KKPdWxmCSb1KiZEGf0vINsjFvB4RvJ
         zebA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kiddier.org; s=google; t=1792496985; x=1793101785; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLGNYitZ4EdMcotU/GOI9I5PtjbgIsDlPVNeP1wv+jI=;
        b=jcEXUuFNMltH+U9bsfQhaoEJcw3oYpquLvoEe01+X9wWxXWVoLM1NWoQ5VmxHTpO72
         CUDxuZC/MlUj6w0dEYWAgd+KNbwbAbUZTaCw/G1YeFJSNCUf8LHNp4Gw8tfsNQHImRfw
         NcVz6VVZKV1sZw3L5/1LyAKyJEVQP4JJdRmxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792496985; x=1793101785;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XLGNYitZ4EdMcotU/GOI9I5PtjbgIsDlPVNeP1wv+jI=;
        b=Dt7EcVlLODXFmZmgw+oqIMjtE1kqgNrRS1ubLQsci/w9slLjH/r3Ga85W4rGIeAXMc
         7uUICwgQcLpuI5lbPuZy0UiYjGRLd2yci9cXb6oUe0Yr6CyFYvMPhxwLtHYnljaVud04
         U7Klb4l4NwBkoMHMLq8nIxNZZbSHR3zbTYIFQzKiX7gFphK6aJJe4Jtmf1hKFBh2OmQg
         SLeD0O0NKQwFpkxxMM7JrvCpObqusLIILjoiITWsl2l4/eq4Q6UXYviSTmA/UQsO3ptF
         ZDxxgs2zuJtNs2IjmxlCXSSlG+mPOOJCsZnvmzY3zRjNXjAQDkiQz3l2idR1fjRZDQMT
         itHw==
X-Gm-Message-State: AFq9FYIAa1yO9O05oKsWUdSKd5OlovEL1RB8NNzTRdV+aHoPcmYIjZMy
	AVxeLKMNp6RkUv5prro62+Vmfr6TwuCo9U7Va/qv7lVQfoQm7uJo4Qe0E70ZX0VwMlv1AdFHgZw
	pzvmAjR1SDTBlW1RzQAwYl2oueveGRIXjV1ZcoE1rb1v9fpVcXnXpwT5xJw==
X-Gm-Gg: AYBFou0iKLSoPfWNW433RCJnapB+qRo4zCRA1alKAo25zH+3LK4JWtRiOXZH9LQ5nvv
	802Wl+9gn5UzZHpjWeUoLaglqzD0I4hc4Mm2rU+WpvCLlkKB2UGGT3oS5fCxR8C6BZ06ZqXPEJ7
	LDQ+dFlXJ8niCxEhZKGVdV742MjzqS5+TUYSNNNe4bRt0t502u2+fmDbFulj/rMsH9cLVeX5H+S
	vNu4L8f/wUUSCDdpcHA7HFrgsP9zcuJSCZzkq58C5bG7Ofhn8SctVnwlGSx1JQ8oRbHYTINVsNX
	5DAW/RGOGC864rnCNo5rpgwsw0U7eo9RYuMbDFPE7em/3GPS2m3EbonlkA==
X-Received: by 2002:a05:6122:8c1:b0:5da:9b81:1aa4 with SMTP id
 71dfb90a1353d-5eaaa3c174cmr3451932e0c.5.1792496984909; Tue, 20 Oct 2026
 04:49:44 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
In-Reply-To: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
From: Peter Kiddier <peter@kiddier.org>
Date: Tue, 20 Oct 2026 22:49:33 +1100
X-Gm-Features: AclHuK_KgzridKLRANvtLJkSHaLWJWHnmxsRRdoNj6COaR_e09DKIcJwjLUSHC0
Message-ID: <CA+3E58-2N-uVNsmwvOGDKZvtnDQ1DF=GzFbTyRLuN8FpAd4qdg@mail.gmail.com>
Subject: [REGRESSION] BCM4355 Wi-Fi fails with Intel IOMMU on 7.3.0-2-t2-noble
To: linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev, iommu@lists.linux.dev, 
	arend.vanspriel@broadcom.com, regressions@lists.linux.dev, jgg@nvidia.com, 
	kevin.tian@intel.com, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Adding the IOMMU maintainers and linux-kernel.

The original report and test results are below for context.

I haven't tested a vanilla upstream kernel, and may have limited time
for further testing, but wanted to share the findings in case they're
useful.

Thank you.


On Tue, 20 Oct 2026 at 22:32, Peter Kiddier <peter@kiddier.org> wrote:
>
> Hello,
>
> I am reporting a Wi-Fi regression on a 2018 Apple MacBook Air with a
> T2 chip, running Linux Mint Zena based on Ubuntu 24.04.
>
> The Broadcom BCM4355 Wi-Fi device works with kernel 7.2.11-3-t2-noble
> but fails with 7.3.0-2-t2-noble. Disabling the Intel IOMMU using
> intel_iommu=off restores Wi-Fi on 7.3.0-2.
>
> Hardware:
> - Apple MacBook Air 2018 (MacBookAir8,1)
> - Wi-Fi: Broadcom BCM4355 802.11ac Wireless LAN SoC
> - PCI ID: 14e4:43dc (subsystem 106b:0843)
> - Driver: brcmfmac
> - Interface: wlp2s0
>
> Test results:
>
> - 7.2.11-3-t2-noble, default kernel command line: Wi-Fi works.
> - 7.3.0-2-t2-noble, default kernel command line: Wi-Fi fails.
> - 7.3.0-2-t2-noble with intel_iommu=off: Wi-Fi works.
> - Reloading brcmfmac on the failing configuration does not restore Wi-Fi.
>
> On the failing 7.3.0-2 boot, the driver detects the device, loads its
> firmware and creates wlp2s0:
>
> brcmfmac 0000:02:00.0: enabling device (0000 -> 0002)
> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4355c1-pcie for
> chip BCM4355/12
> brcmfmac: brcmf_c_process_txcap_blob: TxCap blob found, loading
> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4355/12 wl0: Jul  8 2023
> 17:49:51 version 9.30.503.0.32.5.87 FWID 01-e74b9cb0
> brcmfmac 0000:02:00.0 wlp2s0: renamed from wlan0
>
> However, Wi-Fi subsequently stops responding. The kernel log reports
> errors including:
>
> brcmf_msgbuf_query_dcmd: Timeout on response for query command
> brcmf_cfg80211_scan: scan error (-5)
> brcmf_run_escan: error (-5)
> brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring
> brcmf_cfg80211_get_channel: chanspec failed (-5)
>
> There is also an error creating the P2P interface:
>
> brcmf_cfg80211_add_iface: add iface p2p-dev-wlp2s0 type 10 failed: err=-52
>
> I tried reloading the driver using:
>
> sudo modprobe -r brcmfmac_wcc
> sudo modprobe -r brcmfmac
> sudo modprobe brcmfmac
>
> The driver and firmware loaded again, but Wi-Fi remained unusable.
>
> The firmware files are present under /lib/firmware/brcm/, and the
> firmware version reported by the driver is the same on the working and
> failing kernels.
>
> The brcmfmac module metadata differs between the kernels:
>
> Working kernel 7.2.11-3-t2-noble:
> srcversion: 3B6176FDB720DDE8E7C596B
>
> Failing kernel 7.3.0-2-t2-noble:
> srcversion: 3DCA38D52402541701276CF
>
> I did not find obvious PCIe AER or fatal errors in the failing boot's
> kernel log.
>
> It has been suggested testing intel_iommu=off after reloading
> brcmfmac. The driver reload did not help, but booting with
> intel_iommu=off restored Wi-Fi.
>
> This strongly suggests an interaction between Intel IOMMU handling and
> the BCM4355/brcmfmac driver in the 7.3.0-2-t2-noble kernel.
>
> I have not tested a vanilla upstream kernel, so I cannot yet confirm
> whether this reproduces outside the T2 kernel packages. Unfortunately,
> I have limited time available for further testing, so I may not be
> able to investigate additional requests promptly. I wanted to report
> the reproducible behaviour and the intel_iommu=off workaround in case
> it helps identify the regression.
>
> Could you advise on further diagnostics, or whether this should be
> investigated as an IOMMU or brcmfmac regression?
>
> Thank you.

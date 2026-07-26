Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430726ED46
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 06:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785047244; cv=pass; b=Mh4aN2V05MGoPgrO7RYoAxy34DZs5Y95q/qmPTYwEXS5jy9HcjmASPHAtPMiw3IJC+pRQJZWeZrtGTXN3/xAEuMyYYr/0MRTruB9PmFwOXwHf0GSSNvRHTjOCLzG0k1h4Y4Z+Y12M+IShcIjIUbXa+PytExV9uzDKdb3S2aUjDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785047244; c=relaxed/simple;
	bh=vDSJsguHP3GZC2s9QaNxRVXRfaZ1bkde77LcEfAefD8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EmLIf8YFm33jvEvS2eKMIiun7FzDT5JAle3fCBYuH+/daSsyXsqTCLjWp3b/vM9s2TdK+EFYjCd+gD+zOQ/0OGOwdAmGV8R9+DfT5QS69XxuQf3pySTfBAEDxtTLTTb8hqrSs1sClxl85pVFG0A5g+hHC5dx+LUIUuGCDOzTUhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qDmosKkT; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qDmosKkT"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6ab0223a3d3so346239eaf.3
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 23:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785047242; cv=none;
        d=google.com; s=arc-20260327;
        b=DNNySebuR8FS+jalXcI5JzAHWTAyPHbbBeRMK8P7C9uZ6+e46KEhlRJqYt91O3EN6Q
         vkscJNVO5Tl3ulw+jUS29RnhO0srYpAUJCMv71pVydP4guVrHDaFBCqaT+ygjAwXtlaP
         xlm9I9d/nCe/asn3l/drZuH/04/NABx23rIt5CyEgnp3xXc9b/q26e/pOob8nqsByM8T
         VsNkD7ojWwEKnnxPtaSDJ76T45UtZkPnIWDpeHe9elAmAROOzq0L5TaqBYeTKqMIwotA
         s5gsur7Hi3CzwkmoSz7DBGSO8IVncREELf2Atk5ygcXaayPs1QEG8ApLVZtnGbu679CS
         9ijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=vDSJsguHP3GZC2s9QaNxRVXRfaZ1bkde77LcEfAefD8=;
        fh=KbH3UBjZ8QomLCl0k9G6sVubiiph/RoE0MOW28u+q3s=;
        b=k0nxTMGZvEzENHi+pTP8T9TXh+3AKUzMHlb8jOfiBnZknQzPudu5S02flzTP/xhhL3
         dCYetEKCOyFeJfO6fN9ZEFV1cN6l5QeR/UYvSdQvMgACnZHCRabNt5YOPFfV+TiCba3L
         BRcgL+gfwEeLQ/mfY8SiIYz1LKYMd706Qcbu0zAC/NoXvnu9krqSb9cH/PHpdFQ0qDPV
         VlP72fFVGkY/odiV4uvWaCneNbb8C6QwLQwA4ppdDVBuNWmow60clPDQQhY2092AmbFW
         QJxq5/P9onIs7Nf+Owio+em9n3b091fcQMTq8WZt6UAYekPf/4tnFKrbBXg8pziY6prb
         iRjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785047242; x=1785652042; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vDSJsguHP3GZC2s9QaNxRVXRfaZ1bkde77LcEfAefD8=;
        b=qDmosKkToFIANiO46ZLVPt6oGAlmjHX8Vzdvv5AEJHLPhrkf3fCttaBGI+UAC8wFVO
         4zqIphH7+hHg5azSDdaRPoXGvjy3G3Nj/hWqZA1Zwip83dvGKCS7TGj/9vUytoy5yTR+
         7oEPOBorLYia9ylpfjMi3xjtdtaQvabVIVNITTvFyd+A87V/D/d5lCGHnFWxbb0FjXsM
         ejWrG8Aq6e886mLaBE6EV+7YjYZVcAktxMBa8Zwb0jt35KSosUIxvFFGfn8nB6suGVhJ
         fW/KdqMC0v9BfTmVz3ghWkyKbmH5odYeJRyuD2ddmi/V98GC7L9t6pFX3uZkFdyDmbX9
         lzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785047242; x=1785652042;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vDSJsguHP3GZC2s9QaNxRVXRfaZ1bkde77LcEfAefD8=;
        b=lNy72AgaY+bGMiob9tNflxB2RV5rsjhJmajSHXdnKL97jcTxOIzdCBI5Jk1ln9o9Mg
         u4ROsSlPZipGjk/UWNbuvWBSY7n5N1dVQpJFnBXWpcgvT/kUdYi0K2T2FSuqfDdIGvFh
         guYYHT0Os7M04631ed0ngZBOmGGifXCE21rru9nzV1mJ1TnLL76kxuuGO4TfJf0iD2fy
         4OV6hBt0Dac6VTWGLN3pRKY1lZOA7AHnF0Alk/Le9DUmERyl4fdsC4RsZdXctErLPU2w
         W50VXMxAooEPXYM/AokaiDpF72BXWtRk1utByHAwRjcacWYSyPHzKa6qTswkiJ/r90q2
         ZEOg==
X-Gm-Message-State: AOJu0YxGdlFBzxSh5OwtNcvRe4Wphg2kJq6IacKq8eH4gPU1BMyH/yUU
	eRDwwTrRRdwAkz/dpMI0mwxa1pzIY8H7wZb1SA/2LoF27Etz2OpUgp1Ko0PidQ/eZL+/0jI7pLv
	FC5uWw2tONupA+ylqNNib95PegKCKHC+q2pzR
X-Gm-Gg: AR+sD12sF+Vda2tnZS6iQSigI9te4ZaDC+c7O/AjvJqcpVdcDokPrR6PVQtzqAra60F
	nQbBhE/GhNAghFnzU+S3eLEOJMqf6BpZ5lUDUCH/aZb9z8u7NGEt9MdkMtKoKYZAYQBoi83jatN
	t/QgsoRtIGuQN/Bh9kFs+vY8ba1oNNnlLhNDY0A0mLtzB4JJ1lLT3Omgn5l7PhAtjyykP5HYPjE
	oRtma66/p/SP8OsVzbHJzLVkIBQ+U/AUzRyzo7CdshCBOiFmG7RoCwwZKmL/Q==
X-Received: by 2002:a05:6820:168d:b0:6aa:e854:d03b with SMTP id
 006d021491bc7-6aaff861424mr3019938eaf.2.1785047241836; Sat, 25 Jul 2026
 23:27:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rakesh <alasyamrakesh77@gmail.com>
Date: Sun, 26 Jul 2026 11:57:09 +0530
X-Gm-Features: AUfX_mwVESciFjrQOYAwjGdza-1UBWJjl4OKsNkk0jI3qgxj35yF7YD3Wx5CaIY
Message-ID: <CAMizObmsJkvUJ07YpY7r7FNXSfvEiKjDNkPEq7mxVhrytejkBg@mail.gmail.com>
Subject: [BUG] ath10k_pci: QCA9377 reports recurring PCIe AER RxErr/BadDLLP
 errors with ASPM enabled
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, jjohnson@kernel.org, johannes@sipsolutions.net, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I am reporting what appears to be a reproducible ASPM-related issue
affecting the Qualcomm Atheros QCA9377 (ath10k_pci) wireless adapter.

I initially reported this to the PCI subsystem in Kernel Bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=221784

The report was reviewed, and I was advised to report it to the
ath10k/linux-wireless maintainers since the PCI subsystem itself
appears to be functioning correctly.

Hardware:

Dell Latitude 3500
BIOS 1.37.0
Intel PCIe Root Port: 8086:9db1
Qualcomm Atheros QCA9377 (168c:0042), subsystem 1028:1810
Driver: ath10k_pci

Kernels tested:

Ubuntu 20.04 (Linux 5.15.x)
Ubuntu development release (Linux 7.0.0-14)

Observed behavior:
With ASPM enabled, the system continuously reports PCIe AER
Correctable Errors, primarily RxErr and BadDLLP, while the wireless
device is active. The issue is consistently reproducible.

Workaround:
Booting with:

pcie_aspm=off

completely eliminates the AER errors.

Additional observations:

ASPM L1 is enabled on the PCIe link.
L1.1/L1.2 substates are enabled on both the Root Port and the endpoint.
During initialization, ath10k_pci temporarily disables ASPM and later
restores it.
I was unable to find an existing device-specific ASPM/AER quirk for the QCA9377.

The Bugzilla report contains the complete investigation, hardware
information, lspci output, dmesg logs, and supporting diagnostics:

https://bugzilla.kernel.org/show_bug.cgi?id=221784

If additional diagnostics, testing, or patches would be helpful, I
would be happy to assist.

Thank you for your time.

Best regards,

Alasyam Rakesh

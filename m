Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793916049;
	b=ADN1AvklCWYQh/ERbMvBNdyQh7G4ZoaFnoAxfcRzjNcpW8R/mmDEbtYdRe+60yuPospl
	 4JxRyB1GbHXqgTfHOISCwQFcZO6XyK+YaEfPu/t3mDiNSGY+I4dd7OgKdizvtT+IbKY94
	 80dt/RLaKJXzJZlZA95s2nrCecW3bzR0+Bi/AD3/F36dDgd690nzlqVJeLBUTSN1St25i
	 5Q0/xfCE4162b7n4eWrAy9andr0cEipVqXsERIfyUCyEqfuUSWj8h0Zhe4t7RUaTp7kjr
	 rPH8C+cNbZNcwpkeaVDlgZSStCdi9Goe0w4JIHjdkcBjxWfWHdQQtehtL0OAtblWHLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wqunNf7po3SWQvrl/Fx8/EGqJsJQtjAHPOjZVlD31M4=;
	b=uyJUyWkhE7pLbSW7tLbvmJsnpF2KK1lr9r0giSuim1yzwM7CDsOHpyCWvInWw4l9YBwq
	 Bp+wTW0aTllSP/Jfejj5THDKZl9LwViClA4t6vW2XtgmTTofBdHrx65bZY+A/MvIqVJmB
	 8fj5VqNRfDfFAlECBjKmCjYbRT048DO8VHXKQgC7y5xGhEiiZJBk2VNpPB+oypk8B9xkW
	 z15sdUgRdk9nqVykPByloOZfNCWKGWsQuqPeF9NIb7LHBI1BPhAvxDPYPVF31W7BejnFK
	 fEjzjxMgoqTnYzACpIZvOdoMHj7x48JCmLcIym+1BBIAeMytSw3znj0rWv06Z8q+oNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IvvrPR8r;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA4D606A328
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 22:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFA4D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IvvrPR8r
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so163955e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 14:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793916047; x=1794520847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wqunNf7po3SWQvrl/Fx8/EGqJsJQtjAHPOjZVlD31M4=;
        b=IvvrPR8rJNdSg7+VrJ+tP8LEhQ3J9l5W58p2aueu2Q4Rb/m+Tzhmk/TZ3k78vLxOVV
         0c7CHm7hybtmBmVDlzdycT2uQ7lzOXZ30u0/mK7vbh/tZwBJyjTso+XVQr/7hnoz+51n
         mo6A+DWWPsUgmb1lbOYKhl0UxWSBqN+n5vFsf3GkrAk8357MQH+rgWkVgH+k8jFhxZpy
         L8WP01ae0hJCqNRJhGyZTLrbuk6MImnLN/AW+Dqry8TmA2z3zFMmsk3d5Kvl6R3RYidT
         j4oDgJFqYiDNWGaXVKAK7tjuTNrmEfisPPKr5ojR8hJ0unIQ0R0qDEzWdT9wKj7dHDPu
         E8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916047; x=1794520847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wqunNf7po3SWQvrl/Fx8/EGqJsJQtjAHPOjZVlD31M4=;
        b=JmAdBeWueQn/iNzV5gHu/plWFUbjV+VzNwEGj7gFQ5ZhwqZt3jQPOZix7hJOp3zQ7y
         4qZzfbXVIW2B150mnA3utWzSt7K2J5f04doJI1Oe0MSGeA56zRD8Mhgy4pvB7ihGUBkK
         pPFZdftkZM5dh/EXLd9J60B0UsxDoniYd54YR+H35TWR9t+aStRUF2lX/zvX47vlTQ8m
         lsf0XcddLJsiCi9eVOj4x/YQVeAqG5Hro6azNNab2H4wpxbhwwD8rgRzA+4pb0cbU2ld
         SfkspnRMXFM4hb1GGwjQmpNsrrlgSLp6rxnTL4/cpeVK9N5yvlaUQUP3L/i4YO/XRHox
         jRSA==
X-Gm-Message-State: APuU4Z/20mhc+rtor/NbhnyAW/1knJ/voRS4a9UIYnoObmEs8J47m46B
	OMp8wRF80ejzr2kaL7QD+nCaPAvQ3r2ac8fB/EPowepVxslVJp1mubAt58SxYPsjSKI=
X-Gm-Gg: AYBFou0fZGnbkAQu683OlFOyow4oe4OyJWb4/hwjNyS/w9mV0PmH8P3QRZ+oVvem/u8
	VN3WKoDQHFJzQJAs+svm0bVX2LP9OrKuc/4qbFlBtrELERW0ebtYHNNVUjbStmGcVz7ddLB1PDB
	9sJsLfE1N+xQKv+4dl8sDEV1Rpqtf1cZ6t+JrssTjx2j9iWABmnGsh3+XlA1RDy5eTtj5p4cxMx
	r2V8+lYAAXh404b3EmkoaTEWVGSFIxqW8cketccKvDRadUzvUCKZNGPIy1Plc3qZJSwRbE1Oqwi
	9njIAEmJCmTwYOhdFeftJNXnGJayrDDNM9rDV0+NhXEkhVJZULZCRcEuDi1uMvX8BjMqrOsEBu/
	wCej3seIE4QJegIutFvG0TNAEk6TrSbQiYrzRUGrmv1hLrihGUfTVxE04wpmWKexti09jBlxBlW
	JTg+CJvOhgTJ6S/L3baOryNoUOtdcEXQEDdXvzTdkgLVJIpc9VpgooHaAWBNCR2JEGiNvCoCBGc
	ul658xm/VVuipLZ1SxyTB1JkMexmOoamstlXAQ4j+dU5DANcmD//3HpfOZ6Ar1aGDcqVMvGsnD8
	JjO+txAU+PQwbQzr5ZT6303OmYbvtu90/uLuKf9CpS3op7M989iiXj+n9+oVf/vIX5IC06SfL8V
	q5WQAxfUH
X-Received: by 2002:a05:600c:c16a:b0:4a2:150f:160f with SMTP id 5b1f17b1804b1-4b6dfe8d0bdmr6835185e9.25.1793916046944;
        Thu, 05 Nov 2026 14:00:46 -0800 (PST)
Received: from soeren-MS-7A32.tail37253f.ts.net ([2001:a61:13ae:e301:329c:23ff:fea4:379])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda203b6sm11922212f8f.48.2026.11.05.14.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:00:46 -0800 (PST)
From: Soeren Coremans <sorencoremans@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	Soeren Coremans <sorencoremans@gmail.com>
Subject: [PATCH wireless-next 0/3] wifi: brcmfmac: pcie: recover from fatal PCIe errors
Date: Thu,  5 Nov 2026 22:59:51 +0100
Message-ID: <20261105215954.184290-1-sorencoremans@gmail.com>
X-Mailer: git-send-email 2.53.0
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

On a desktop board with a BCM4366/4 (14e4:43c3, firmware 10.28.2), the
firmware traps every few days, at the same address in every trap I
checked. The driver's reset recovered from 10 of 12 traps in five
weeks. In the other two, the downstream port reported a fatal FCP error
about 0.7 s after the trap:

  pcieport 0000:16:01.0: PCIe Bus Error: severity=Uncorrectable (Fatal)
  pcieport 0000:16:01.0:    [13] FCP                    (First)
  brcmfmac 0000:18:00.0: AER: can't recover (no error_detected callback)
  brcmfmac: brcmf_chip_get_raminfo: RAM size is incorrect
  brcmfmac 0000:18:00.0: brcmf_pcie_setup: Dongle setup failed

WiFi then stayed dead until reboot, and brcmf_pcie_bus_console_read()
kept logging 0xff characters at about 2,800 lines per second.

Patch 1 stops that console loop. Patch 2 fixes a fault in the memdump
that patch 1 uncovers on CONFIG_BRCMDBG builds. Patch 3 adds PCI error
handlers and re-probes the device after the link reset.

Patches 1 and 2 are fixes and could go through wireless instead. Patch 3
depends on patch 1: without it, error_detected() waits forever for a
reset that is stuck in the console loop. I sent them together against
wireless-next for that reason, and am happy to split them if you prefer.

Testing
-------

All runs used a test kernel built from the Ubuntu 7.0.0-42 source (based
on v7.0.14), with CONFIG_PCIEAER_INJECT and, unless noted, CONFIG_BRCMDBG.
On the stock Ubuntu kernel the series has only run for about an hour,
which did not exercise the error paths. Results on the test kernel:

- aer_inject with FCP on the downstream port 0000:16:01.0, alone (5
  runs) and 0.3 s after a debugfs-triggered bus reset, which mimics the
  trap-then-FCP order seen in the field (10 runs), plus one plain reset:
  WiFi back within 6-12 s in 16 of 16 runs.
- The final series, built without CONFIG_BRCMDBG: 5 of 5 injected-only
  runs recovered in 6-12 s. The combined reset-and-inject case needs the
  debugfs reset file, so it only ran on the debug build, shortly before
  two small cleanups (no markers, kzalloc_obj()).
- Real FCP errors, no injection (aer_inject unloaded): debugfs-triggered
  resets under a ping flood over WiFi produced 3 real fatal errors in 47
  resets. All 3 recovered: "device recovery successful", one re-probe, and
  WiFi back within 4-11 s of the error. The log order matches the field
  failures, including the "delete_flowring: timed out" about 60 ms before
  the error. These runs used the debug build.
- Without the series, the injected error reproduces the dead device and
  the log flood.

Not done:

- No runtime test on wireless-next. I only compiled pcie.c from
  wireless-next with the series applied (W=1, no new warnings), against
  7.0 headers; the rest of the driver does not build against those.
- The real errors above came from resets on healthy firmware. I have only
  run the series for about a day, so a firmware trap followed by an FCP
  error is still unverified.

Open points
-----------

1. Patch 3 re-probes because brcmf_pcie_reset() alone was not enough
   after a link reset: in 5 of 9 runs the firmware came up, but scan
   results showed the guest network's SSID under the main network's
   BSSID, and association failed with status 16. I did not find which
   part of the probe-time setup is missing.

2. The FCP error may come from the driver's own chip reset. It arrived
   0.6-0.7 s after teardown started in every real case, about when
   brcmf_pcie_reset_device() writes the watchdog register. That is timing
   only, I have no proof of the cause. Frequency: 2 of 12 firmware traps,
   3 of 47 debugfs resets, 2 of 20 module unloads. An error during unload
   leaves the device dead, as no driver is bound to recover it; this series
   does not address that.

3. brcmf_pcie_reset() and brcmf_pcie_remove() free the DMA rings before
   brcmf_pcie_reset_device() stops the chip. In one of those unloads, the
   device wrote into freed buffers first (8 AMD-Vi IO_PAGE_FAULTs). The
   other real errors showed no such faults, so this looks separate. This
   series does not touch the order; you may know whether it is deliberate.

Tool use
--------

I developed this series with an AI coding assistant, Claude Opus 5.5
(Anthropic), in one long session. I asked it why my WiFi kept
disappearing. It read the logs and the driver source, proposed the
analysis and the fixes, wrote the code, commit messages and test
scripts, and set up the aer_inject test kernel. I ran every test on my
hardware, chose between the options it offered (for example re-probing
after the internal reset failed the tests), and reviewed the patches
before sending.

Soeren Coremans (3):
  wifi: brcmfmac: pcie: stop console read on invalid write index
  wifi: brcmfmac: pcie: bound memdump to the mapped TCM window
  wifi: brcmfmac: pcie: recover from fatal PCIe errors

 .../broadcom/brcm80211/brcmfmac/pcie.c        | 144 +++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)


base-commit: b8e5b0ae8ff47240366d38e5d12c65f878724316
-- 
2.53.0


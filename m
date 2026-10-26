Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792977117;
	b=zYqbSJCofty9O/nApltSpN5lnsIWf57SSGl8q32kld+YANx32OHOEPsVz75xuiXOu9LY
	 Ue0tgGerCD2XeawDFU7ilt6t/0LM/dAouYjItr2SEWsEBoC4oUmlqFcsGCIrTPYfQ6rZv
	 4f2DPPpZqfG7n/gjAdyuVuSiX78Z6R7WqJrRCEv/MGaaAVs+PnZ7klbdSeWJF6pKN9JhZ
	 rBa5fbU6JqUaodfP5G2NEjebUe+DdCOJ1AR8mYuFGPbmmgXCJ7XMB6T2L/3Mo9QpK1SPu
	 S9h6imJHlWyhpat7AYStij00X+OmivkoHHkQCoV107Iu9C3ZjPbZ8dKVp4lyOxB2T3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792977117;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:MIME-Version:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=3tjtj4LsBCTmim+1Ivvh+J04zu4kCZ6W9uWJQPYf0DA=;
	b=OvV9Gj97pVIo75d+SeHhP4xCCNOXeq4Qeu2r1M/BKiQW3xEzqoTUV6rbCFbAAVh1eJ3Q
	 /D/xqraRQM6LHjVqf1bO8ibhxys4C3+r1jU5Qpbme+hTiSn7gIKHc9gLzPN1QlI1UQJ0a
	 f8eLcaA7V+MpDJLXhhDCBuvLWA03XEPBqPEwDf5eeFcBVHUxkJLIAJBGxX58yV7hV2HcI
	 5J/fiJL522tW+Dix/+WMlfAKi+fOrsFHYzVT5U2zLzABtFeBjmcB2fx5NSwLinl3SXkzC
	 ZlCPWcdV8MQSd3SXg4rnVOkrH7e03SjmdbRVKkHZ2ddT9ImCWbD3wCwyPD8MuljvuPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LfsoGUrh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5C7606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 01:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C5C7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LfsoGUrh
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e608cd460eso15200475ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:11:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792977116; cv=none;
        d=google.com; s=arc-20260327;
        b=IBx9N7n7XZo+vouQF7LjUQjjIVg00/bUm+OrvCKEXGDuj1dGEk6iwS1iuPQEgPY+A8
         c2BstudkPFdsoH2U9V+nN068jb6Fl1wAkGCCC6yFmn3lC8m1I6PtBlWC6uxkm0yCPKrH
         sbk+Da/GAF4jS5vSq3roRaObH0WpPC3k4z7WqF+pOhKsHLGd1PefwogNLwhVSWFzduW2
         6DBdtx44ScKmMpPHH8lPyIQJtdBV2rsZPHGRAmgIO6ZuARFz6NsNDtdq/l/KCsOn5/ke
         2o4TgjJqb7DA0HrNeyxMfvgjb3jQJcWQdBgHL0TVcEjm2tOwhQuAGCfXoRKDOLuzV4qc
         AmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=3tjtj4LsBCTmim+1Ivvh+J04zu4kCZ6W9uWJQPYf0DA=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=PjWlZLL0AFfrEbf4t/ZSF33et1moV6OkroFHdLBruJg0OOG2XqXhE66P+jaguv52+b
         RVmW3bVc261wei4j30k7UZhyATpYsd9Y3L4e6lDgQK4GvOwCCcgg8PsKXO4xss3BCwty
         L76CDw6+CnF7jgQ0IL1mk3VycMddVAm+U1cm3/IkgB+BVTy04/HTdt0dio8uRfKXSyiK
         j1/2QqF1hm9F4mOJYM0ouVRLb+MttOpIo3ln/FblmoK0OJgztNyAni36EkrCBuFkc/Fr
         iflNku7Qc9Gt0zr9WMFAbpc7Iyz+s1/Af9Y1nfvxRg+XHp3co8H8I5xsS1BjxGwXFrD5
         x3Uw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792977116; x=1793581916; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3tjtj4LsBCTmim+1Ivvh+J04zu4kCZ6W9uWJQPYf0DA=;
        b=LfsoGUrhUIyKBea38Hju1lmoAqrVBVWIDDpE32+c6/e5CTLmbt5Ot5UZW9e8ZgChZT
         nBbwHMG7aXbRbYDFZHBvsv7LJl5tO8bbSTiJXG93cNhqOkPOHVwj6FmGPmuMCcAbPswr
         ITqbeLPkXtDc8xMoNE2g8oUNurtWhaJHhAwkuA2oYMT1ac+1ZPJuYKVjK+Uftdz7ytBP
         ZZPEYXRHxgQ+u1ZTc65GNK8n/ATrtwH2aVtL9NtdyT06z4NerrgCPiy50iyYPGsMoH9q
         YU3lpBXLhNoWTklT3SutkH5LH4q3MH6lctIM0vPe2rKua3rZZUb5xXsCKz3na3kQrm2Q
         cM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792977116; x=1793581916;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3tjtj4LsBCTmim+1Ivvh+J04zu4kCZ6W9uWJQPYf0DA=;
        b=BQdj3lETbntUUIxj39nqKjKnL8cKc9MDSuehrwOP/us8FwBb9BrTp2mjbO9niCNAjp
         z56uIazP1vyCOXUAfB5YnpPIwbXN76Iyd7KH2RCvuVFzXgro0M6Pp2MS/uteTV56I5BV
         inqx5XKx2DoLFuIx6CM5wJWozm9jyZ3PR0wbreJfE2q9fqseBGFVpJhDUBl1GPT9l+jb
         l5K4UJE37uRQxcxDd0LF+W81AtZFxuH36/EVwzDEEVeugXmE/SNbzcqoCA+Qpr3BSolY
         XDu9lS5Mhk1qgy48uxUaRh9DPmNH3isJuiozJbJIz6T149jAMLJZveFXTKdDRIumd0Eh
         dPbQ==
X-Gm-Message-State: AFq9FYJCItJ/gMZghEUq4NCOplDmCyXjPuA+C3RbCXWGAHv5r0mEHjcr
	SIXGlWwOz1FGVk/SSMaDONCKqVQlnFQUaShh3XPHq1Mx7/ao4TTcGWl3II6mwZjHNtfY5G0wVuf
	Xy1+OEuU+aCibtqd0r1YPvyxsk/1SCOm5JA==
X-Gm-Gg: AYBFou13L8z9SJZeXFnhrAkxJBhXPOIc8VAcqnlwLh+05kZrq9aStSrvziyANC5Jh8D
	paHtKrnUdq33OS87mJ0p4bUyU5+97LrMsQtnTzsGTNG0t5qhE9rnuvIHPd1ruid5vA5Q1JioqaJ
	DM87gZw+ET0/5v+lAJLYv2JJN56H9CUcASOCDmGVNhqKd9+22eEr/As4XW+d0gR5/PlfboaeYI9
	SeduNIdoy4ypNCB9NRXXpJE02krJUM6Tygcjc9kcYRxqfjYGDDW+KlQuyv1tYa09RVSODahVfu2
	U7Q5WvNbpa82rdkv1mxXlOy5/B8xYxEdJqakU/wnSirw5bOA/kPXjxJjEzym1688Wwrf2Ay5bu1
	GrMGRCJDuorVRtwWmjRct8g1mjivhX4+YCG5qKILpYyVLC+4NljuszFk=
X-Received: by 2002:a17:902:d4c1:b0:2e9:5eee:e074 with SMTP id
 d9443c01a7336-2ea9c69b1fdmr43705805ad.46.1792977116168; Sun, 25 Oct 2026
 18:11:56 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 25 Oct 2026 18:11:55 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 25 Oct 2026 18:11:55 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Thomas Mason <ranchitossf@gmail.com>
Date: Sun, 25 Oct 2026 18:11:55 -0700
X-Gm-Features: AclHuK9BXdjfcU5QlGnG072t8FeOpflhf_s2fi-Hg0MDn-Y42hOQqvLVVlG1UMg
Message-ID: <CAGhUpaPwFz6C1GnP-JxQ=_-XqgOLXWyxTyEd5h3BaM1-tZvsZA@mail.gmail.com>
Subject: [brcmfmac] BCM4350C2 MacBook10,1 cannot discover DFS channel 104 AP
 (Ubuntu 7.0.0-38)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello linux-wireless maintainers,

I'm reporting a reproducible Wi-Fi discovery problem on a 2017 Apple
12-inch MacBook (MacBook10,1).

Hardware and software:
- Ubuntu 24.04.5.1 LTS, kernel 7.0.0-38-generic
- Broadcom BCM4350/5 BCM4350C2 PCIe wireless adapter, PCI ID
14e4:43a3, using brcmfmac
- Firmware: 7.35.180.133 (r602372), FWID 01-c45b39d6
- Global regulatory domain: US / DFS-FCC; phy0 reports country 99 / DFS-UNSET

Problem:
The MacBook discovers its UniFi SSID "macgmason" on 2.4 GHz (BSSID
9C:05:D6:BD:B9:CA, channel 11), as well as other 5 GHz APs on channels
48 and 153, but never discovers the same nearby AP's 5 GHz BSSID
9C:05:D6:BD:B9:CB operating on channel 104 (5520 MHz, 80 MHz width).
UniFi confirms that this AP is operating on channel 104 and serving
another 5 GHz client.

The wireless PHY lists:
  5520 MHz [104]
  Maximum TX power: 20.0 dBm
  Radar detection
  Channel widths: 20MHz HT40- HT40+ VHT80
  DFS state: usable
  DFS CAC time: 60000 ms

Reproduction:
  sudo iw dev wlp2s0 scan flush freq 5520
  nmcli device wifi rescan
  nmcli -f BSSID,SSID,CHAN,FREQ,SIGNAL device wifi list

The targeted iw scan returns successfully, but displays BSS entries on
other frequencies and none for the channel-104 BSSID. It is not clear
whether the firmware actually scanned 5520 MHz or returned
wider/cached results.

Kernel tracing produced:
  872.205343: rdev_scan: phy0
  874.279291: cfg80211_scan_done: aborted: false

The scan completed in approximately 2.07 seconds. The rdev_scan
tracepoint in this kernel exposes only wiphy_name, not the requested
channel list; the trace therefore cannot confirm whether channel 104
was passed down.

Kernel configuration:
  CONFIG_BRCM_TRACING=y
  # CONFIG_BRCMDBG is not set
  CONFIG_DYNAMIC_DEBUG=y
  CONFIG_DYNAMIC_DEBUG_CORE=y

Firmware observations:
  Direct firmware load for brcm/brcmfmac4350c2-pcie.clm_blob failed
with error -2
  brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may
have limited channels available

Tests tried without success:
- The stock Ubuntu BCM4350C2 firmware
- A minimal MacBook-specific NVRAM .txt with ccode=US / regrev=53
- The alternative BCM4350C2 firmware image in
WiltonH/macbook12-wifi-driver (different file hash, same embedded
firmware version/FWID)

The original Ubuntu firmware was restored; the machine is otherwise
stable. I have not patched the brcmfmac kernel driver.

Could you advise:
1. Whether this BCM4350C2 firmware supports passive discovery of DFS
channel 104 under FCC rules;
2. Whether the absent CLM blob could specifically affect DFS discovery
despite other 5 GHz channels working;
3. Whether brcmfmac could be ignoring the frequency-restricted scan request;
4. The preferred instrumentation to inspect channel specifications
generated by brcmf_escan_prep() without needing an entire custom
kernel?

I can provide additional diagnostic traces or tests if helpful.

Thank you.

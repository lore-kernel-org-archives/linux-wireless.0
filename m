Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558BB221FD4
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 11:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201314; cv=pass; b=Z4WNzWGywPCGh8MWrpmNXxEZ2yAJ3X+5G7jfgouskv5u0RyCJIx4xT106KV3yj1JZjf4DJMbIKzgvQyFLLnQ81rW5+Bd2a/vfhhyl1rEkbxE8ErBLNBe/te1dlqCZGjNY4cvFsDyK4W5GEeqdOyxG7t6Rwe+OOIE9of7h7Rjc4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201314; c=relaxed/simple;
	bh=exRxIskWFNPYOwkKeipQ9T2aVSUzJuVpO/XknTmBsP8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=iXl2Tq07+0m+BNcQbTqUHBjsH7qrkzN9ZNyFiJ+XGmphNH+yces9xfUJ3wzoN45nLBPiDHkfHGOEp967t0iS0DKVMbwSuwtYNJeHmZdeeCeqhGImCtGAHJgv0FIqhttSZ53WfM6ixVYayuS8nzLHzxtuPjkp6FwQtKlaFMuvFjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6uC99lz; arc=pass smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6uC99lz"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6d7a9e2eb24so1084986eaf.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 04:55:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791201312; cv=none;
        d=google.com; s=arc-20260327;
        b=OB581PSJb/+t6C8Rc3i0OiT8lT6QLbm1kGU3omMhl0V0JArdgzSaQh0qHXDtlu7+IG
         vD6l3+v7sV0k3x/+jO/jytt58QQODxPN0YW2XymwLTFfMC3tzMAcS44tPBHNp/24fMYy
         DF/Sh9WD/nTCSzH2RY45bkXBkmbBOmg62YKO4/ow4BjGCFwb+qBcWF1YK1YlEOaf4z4x
         a12x+ZwS5g5rp/TptQlBz65LCPfeDE/sZ4IqmxjJoTbScl0E0zQz4TfDYHfoAOw1FFXS
         vEmctZSjPCxouSioY745m88YUQShyKVFq0yjou0ll+Ar+XKLYBY3d4hkifM5tUYXHB8L
         3NzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=exRxIskWFNPYOwkKeipQ9T2aVSUzJuVpO/XknTmBsP8=;
        fh=xGxUdzwdbyRoNAZKBE29esoEL+aGDjDZsQAkUwahFfo=;
        b=l76Ojyfed7ZdBlavvPOXlQGTCH5Zlav/2BLC3uEajvl712jSuSIS9POt7lB5kmQcMh
         L4q29OeowqC66BvTtBwqW1zAXL3Nr3Z1Z1gPOyZ4Mb9rFHQQQVwxKC7yqtg/EaD28Ity
         Y08ni/Zv7TVHQFbZMMUTP1cE9tMP6GSY+KJhLmNuVn0o5a57O1dMI6j24692fYwXYw8T
         tNCTGbw5IKlNd0+WIFxykIRhKDnaiB+8Q4/8TEze3p7XYb8hZ3rS0RVj8j0lQDXBltA3
         eVBNYAO33L+8Kpm1GxKCXlBPbT/2v16bWS6GsePnmz4/tjzqQLHmyr5A+ju1w/DcT8zj
         IwTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791201312; x=1791806112; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=exRxIskWFNPYOwkKeipQ9T2aVSUzJuVpO/XknTmBsP8=;
        b=S6uC99lz/5N/rmWnw4dcfsYSXetEiN/5rIFnUQYoOaj3I3hFuWV4+QYNG6VGrszP2/
         kznNCOuv6FleQvhHDsbN+qQpKhiQQzqmpNUNjJfcXNd/KTFXp05bkpRVrijp/OPcrbXY
         pvHCTyGr7PXtENxSlXIgu6nJjGsKLfW3/+qy7guep3GUk4zFLwtu4BmAE5fAttSRHO6m
         2wOnmgCit/PPq0oRxOMC3g/BdE1V4qzqScllBEI9KKigpL8Nmpz8Z8TyR1nFyRzpVDNB
         TCwx/hlMiTC7LQCOn14cvU6tffllzUIdIBib2cGHqCy0Jz4bLzpZ/cQRs05XCVcwXO9q
         8LcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791201312; x=1791806112;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=exRxIskWFNPYOwkKeipQ9T2aVSUzJuVpO/XknTmBsP8=;
        b=vcf21IupvVXsam1z1U8luFjCA4yEgjAuaXrrlGiCmuvoZnFcnKK83CTYbAjjJgTfas
         hZcBZ8fLlGj2GoDl2F0zvDyKdbkrDgbgBQzuYNmWnu8Fcp3MfJoNnvoNJ0i5QCGANt8S
         Os+xOSLlmkI1qiAXAPGLadY+bmmWuydVYLz6sQcm7pCQbBU+quYLrd+6V5bh6WrxPWMV
         E5qIFPs0aBubUseyCvvpa+cSNEqrPXlakjCgHuV+dLBWZ2ld3cFadMjH2b2lIzLiEN/0
         OjHC5IGXjgeaWYNv6u+yJTOfFQ9UQdbA3HsYc4Ld6lAYc7wU/hLZTfIUh4hx89xVQYJp
         lQyQ==
X-Gm-Message-State: AFuF++lqc/Ssv0eeHpcGLDBQ8QxnJOvVrqXZWtN6bp68PP12GZXwh3OY
	zQxF2mWvilWlXEgRsP1xoMmwGxIfk2EHLMOhymSqSCQh4TpJWdBnrx2g5GvQ4Othn3dE488e+Lb
	l4SqLbrQg7pJymHeVQm4u1kRoTFyrevM9n9zd/9Q=
X-Gm-Gg: AYBFou34dBRj2g6YGWvrAXqTGgLiv1iaQlHHhzjbLMUBiXwwfQNfOAmSKRtwsMYS65B
	te+0WXWbHkVsxhhc4+b0hFuSKN3ugQyO6cGPLPLPEaHRgL8CUYp4PLMuaK4UMPQEO0EUssdniXc
	9DYkpfsQhx9VB8poq0gX0vsI2VekbsVjlG+orb59ENiEh/Z+En0jJLnUxIhrflGixVj3XnylBcj
	IqMQuYxJab2fjiZucoTn0Ar7sx8/PnugLFQYIYAQ6d65JLWReNyK//AsFMsms+yQHptg8ORfdB5
	d3IpHOCWk7GGUNUGbb6JCzZGGYSwJ4nvBmtQ78KMk54WYrKWujThCjpe40k7VF2ojG0lou1nUAC
	YT1wbHC6IZW1uAA==
X-Received: by 2002:a05:6820:c0cd:20b0:6e0:ad2a:8afc with SMTP id
 006d021491bc7-6e0ad2a8bffmr3862415eaf.49.1791201312096; Mon, 05 Oct 2026
 04:55:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zack Johnson <cyrillios90@gmail.com>
Date: Mon, 5 Oct 2026 14:55:00 +0300
X-Gm-Features: AclHuK-YB60pTyUsA3_9rXw7WQR39HKLMGiEFHfLb_6pEUIXQssDGEJywx4PA90
Message-ID: <CADi5oX+e+QKQXqgmVU0Rurcw51shCGhBef2V5nExxvBPnQohpQ@mail.gmail.com>
Subject: rtw89: RTL8922AE slow RX (MCS 0) on 5 GHz with Wi-Fi 7 MLD mesh, fine
 on Windows
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hardware: Realtek RTL8922AE (AzureWave subsystem 6011), PCIe Driver:
rtw89-dkms-git r2010.faad399 (also tested in-kernel rtw89_8922ae)
Kernel: 7.2.9-1-cachyos (CachyOS) Firmware: linux-firmware 20260916,
rtw89/rtw8922a_fw-4.bin, version 0.35.80.3 (8ef4f0cf). Also ran "make
install_fw" from the morrownr/rtw89 repo: same version and hash after
reboot.Setup: Wi-Fi 7 mesh node, 5 GHz channel 48, WPA3 (SAE, H2E).
Connects as MLD (wifi_generation=7, ap_mld_addr present). Signal -74
to -78 dBm.Problem on Linux: - Receive rate often collapses to 8.6
Mbit/s EHT-MCS 0, downloads 20-50 KB/s - After connecting, IPv4 DHCP
can take a minute or more, or not complete - Once it worked well: ~5
MB/s, pings 28-58 ms, 0% loss, but this is not repeatable - 2.4 GHz
works but only ~1 MB/s - dmesg occasionally: "timed out to flush
queues"Same PC on Windows (Realtek driver 6102.24.145.100, dated
4/6/2026): same node (BSSID 3c:64:cf:0f:0e:03), 5 GHz channel 48,
802.11be, WPA3 H2E, receive rate 2882 Mbps, full speed.Already tried,
no change: power save off (disable_ps_mode=Y), ASPM L1/L1SS off, band
lock, WPA3 vs WPA2 profile, iwd instead of wpa_supplicant, community
driver vs in-kernel driver, repo firmware install.LTS kernel 6.18.55
result: <fill in after the test>Question: is multi-link (MLO) on the
8922AE known to have problems, and is there a way to disable it on the
client?

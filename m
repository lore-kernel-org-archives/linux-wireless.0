Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793966857;
	b=T3cpD5PoMSA8SHUyIN8sg+1v4iPSWRNmnMvBCxnU9Z9VNfo0jOypAGcA26CfZHKY7nNk
	 L93f3Rg+ZCEyTnxWwy6F4ajfCXsNdlFA7SvrqhC5rArUlY2f4wWCSExHS70ouoTz+PdGT
	 d4YshjJtzO/D3QW5TgWj9WT1QD/hoTVNp2kpJ5f8JXO/ypQOziX4kQ/LefxhYlk6PqNz5
	 r5L8Pb/mIhOCPh/eZkmqJ8zY0YBgoUIz8Z/3J+X1VVH3kn//aPZbtIFgJy1kCitxKIk2R
	 ZcgpP+raCaMm35PizSfRFViMRkcdRtGOzUIdXCU+/Gd2n95h/fBm4qR9OgSdyftNG2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793966857;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=py3eBtt8P5bhIku2z3P55+R55Vv5f4EkkhmMuJFNNdQ=;
	b=OxC0WxQWnBjRx62Y00EZCmieIqMX8C0JynlFTfkjeptwT6aMoH7/Zxuimbmdp3kz97PF
	 OOuYfv0IF2x+c+EmoRpAu6TyS5aztF94L01X+CFa3rnT80Rb+f6Fu5iKqg1pmLqjxsMVi
	 7DFYuihu+S5AlYaeVkVetMRENuJgL2RgMuyUiwXRc/M6f8kDXHrhYjCjRLHj6iosBckfw
	 wvWew38v+5sMXxRDxum9UGkydseTw7R1rFJpzWsNx4LJC+5XcoViJmYxLc8MnUwSzI6FO
	 agzWlPMCQxraH51gLi0yQpHNdc+G6cy+GbcjtWvQfVUgJNdmYBdXkFgi75euFPTGR4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yjei9UoS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8C5606A32E
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 12:07:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F8C5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yjei9UoS
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1a2761c69fbso1339072c88.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 04:07:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793966856; cv=none;
        d=google.com; s=arc-20260327;
        b=odqNwvdq5RKO/DZPhsOAILNy/s9vbCJmty+YbtlKtDDKsou8pQKr4wFYzWVxdXkoMA
         7A0FZ/XjejN5+yLPwik61vGbb0AiQZbASIvl1NhRsWs2/crjT8wiSqxojU1bVS05i7Gf
         /J2+NPq9cNV9+IAwD6OWGyWP1swkkKQJZ2eERsVWjNmMbZaZF4ktCAhIR4449w9pyGzF
         x3MQ+bZThnElhvQJU2oz9XYkDbrHt6loxeykAuNJWC+Tp2IgVLMXnoBlNMI2l9vu2DIa
         CTiYQ+sJjwzjjQAVx2bVseSKkkXf0K+lnPPWVQPAS5/kVjYseCKgeTDklCe5TtK7n8xy
         IWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=py3eBtt8P5bhIku2z3P55+R55Vv5f4EkkhmMuJFNNdQ=;
        fh=nbs6Z/XzZBEIcqoAY5dtnChIyBBn082zYR5I5GflP50=;
        b=hw0W/WV/2fJAIcxZ5RBcHy6cJ1EA0y6LO/Ez1RuVpINchVVqOaUybRh/PYgC6yd0ME
         Jebje4koJdwqAsyBHh2EqLdS4SuENzi76jzveTEn8TMpwVW4JkjadbEyDEdfi/jb6/nq
         vsgKRw4ZoADcjitkFo0jA6fIpbRNdqrIPCq4EHkP6jRU1NnoL6MoBZNkomVO2421D/mh
         B9nNrfIk+Sbthy8e3nBZc87XajtlSLCVMR4o0nnIfLvVaSOLE9+ElswtC2zWb3vck13W
         1TBuhIJkfUPmKOtC46qD1PP1lp7aBFdohLfMnbMoZ0rKr00ewiB+DY/234uyuWfjAku3
         CuxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793966856; x=1794571656; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=py3eBtt8P5bhIku2z3P55+R55Vv5f4EkkhmMuJFNNdQ=;
        b=yjei9UoScWziazO8OE4ngVnJ/vND3sRlDCjWDxJthBkPoQ0HVyu3AmGe0P5GKU+OZ7
         pwDGow6addSEsxGTlIY76BLdivqnvutCgkwXEIJX+ck9AyBhFpi5pmcGpe0EML2Bd5jU
         n9ytLAdkZ03YBt3BBX4brBOGGdeOwBCbdmdrk+8k9x3ncDy1NSLOMY5tF0zatedjIo6U
         l9e5AIgYCT9YagpDqagugLyT8ezm81j/vdxc6D68NBxQK+f3hO33tZCiffyCg1Zb+Ley
         IF43a83yUa+ncy7hWlZVLBXYf65Ls9HCqIl6f+hDaK1glGkA2tzH58LIY93KYlY++qgn
         UiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793966856; x=1794571656;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=py3eBtt8P5bhIku2z3P55+R55Vv5f4EkkhmMuJFNNdQ=;
        b=aAv2b7MmJbVlSA0wb6mHxqday90V8rh5/5lgS76uU33zy97ex6I9On9jn4k+JnAupi
         7o7Ogu4ZlWBOj+4gaZZpTe3eWzJBP1NxyWkWPua5MAFCNODTmjRSHsuhjc/M6EsdcfY2
         Lp4MvEXUNVrV4UALDNw6NlJLsC3+N/3gfIjdeWxazffoTL07bcqxDvTxdFm+IeHesks8
         5bs5BLyEMtm8bL6ZkNvtBNI2TdPkG379ZnXTV6dhbvvW+C0YFGNP0CRjNWoOJnaFmC5x
         DErRRUSgOg0rspRQLMBbS3JbBELadrao5v4P9F7x9a4VfJ2qBmjwVQy0am1ygn2Tehhh
         jXAw==
X-Forwarded-Encrypted: i=1; AKwUvByJeOI31JN/zml61eDKRn79bEOCKMqcDasLhhdP/xyYOzQSV5adsZWAKE+jmQ0T0CnJhgwifVL/8NH8LmZ+RQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+qq7V/K9Aft2A+vhaWWIzpFAXDVhLlMOnlSS/4tU4J0r+32ZL/
	nGz2EIp4MdIX20G4LhZSSLQ+LN59Jd4B2Sc1N4dF+v/osDiJP6t/oY1fGkg2+SXuyxc/DGinqpc
	ll/CtFsGhwrB/3Fticuw3FWZ8RuNbE13d4EiM
X-Gm-Gg: AYBFou1dnRr9j6QW/yIm3TXdoe3syp/YBldWIcTeOBKbLKrgp+CcjbN5BzKMWR29JaM
	UQ4+wM0siRbIhVluupO7disMbYiAkhWKHAhpMv4NTlSSWaEru2sPEQ/pumDzLHrFle3o7hbBuAu
	RPOiWC5uL2tEvb1xERMwg2vcyfJSEdOeBI5oCKeYBQPVru2UTHXobmBOp5TLQOryGQGUQH+PMXu
	oV0f6dcvMnC70Q0bdo2hYLXV/oCMNkyqp3lY5lQ9R9lUEa/JCQlEJGcog62homobf3nOyFlfw8r
	qCocMhoG2hQR1uvaaRcl0RddGHyxoj68FedPwzyLYI3INpu7iXIfFrT6ZI2NS4iPw+BrbGMnjlK
	m3Q5TywZTerCfOoP2MkaO9wW3H2FPVXRN5g==
X-Received: by 2002:a05:7022:1702:b0:187:7514:47f4 with SMTP id
 a92af1059eb24-1b25d3927dcmr2536752c88.46.1793966855022; Fri, 06 Nov 2026
 04:07:35 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Rahul Balakrishnan <rahulbal29@gmail.com>
Date: Fri, 6 Nov 2026 04:07:34 -0800
X-Gm-Features: AclHuK8BGNXkZKg3kxkBKPc12vNFTGIurvqilUCXNILdY1Fwr1YUHwExKh7w-Rw
Message-ID: <CAMOo2XeHzsWR_f5j1+ukPn97CpSNtPM7WLm1Y8cWqdGm3=yJFA@mail.gmail.com>
Subject: Issues with ath12 wifi driver on WCN7850
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Mr Johnson,

I have been encountering an issue with my Qualcomm Wi-Fi chipset. Here
is my currrent system configuration.

Environment
===========
  Board:     MSI PRO X870E-P WIFI (MS-7E70), BIOS 2.A52
  Device:    17cb:1107, subsystem 105b:e0f7 (Foxconn)
             "Wi-Fi 7 Hardware name: wcn7850 hw2.0"
             chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
  Firmware:  fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10
             WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
             (Arch linux-firmware 20261019)
  Kernel:    7.2.11-arch1-1 (Arch distribution kernel, not yet
             reproduced on mainline)
  Userspace: iwd 3.12
  AP:        5 GHz, 5240 MHz (channel 48), beacon interval 100 TU, PMF
             in use

Symptoms
=========
The problem surfaces after S3 resume. The AP beacon is missed about
~12 seconds after establishing a link with the AP. At that point, the
AP disconnects. It then loops back into scanning for available
networks, and the cycle repeats. The issue is infrequent but it's
rather annoying, which is why I decided to investigate it.

Here is a Journal log of what I see with (debug_mask=0x1132)
  03:16:32.917  keys installed, "connection done, update reg rules"
  03:16:32.935  txpower fetched from firmware 1 dBm
  03:16:44.567  wmi roam event vdev 0 reason 2 rssi -128   <- beacon miss
  03:16:46.397  5x mgmt rx stype d0 (protected action, len 49), snr -44
  03:16:46.575  scan started (iwd roam scan after CQM beacon loss)
  03:16:46.586  mgmt rx stype 50 (probe response, len 708), 5240 MHz,
                snr -44
  03:16:47.574  wlan0: Connection to AP xx:xx:xx:xx:xx:xx lost
                (deauth reason 4, from_ap: false)

I initially reduced the signal strength required to maintain a link.
Then I assumed the kernel was setting the module to low power mode. I
disabled low power mode. That didn't fix the issue. I noticed that we
still receive management messages from the AP. So I looked into the
driver code and saw that "no beacon forwarded" is treated as "AP
gone," which might be the issue.

I might try to get this to Qualcomm too just in case through a channel I know.

Regards,
Rahul

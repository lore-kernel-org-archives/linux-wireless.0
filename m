Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63C2FD1DA
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502189; cv=none; b=sUY0J4zhxUq9SRevyccspxZ9Se31Jlj/OVFV5A5ZHOSu9orLQY79lslwU1o8Pow9P32QiOMs7JkzjqwmxLRxTgnzY36cV7oGBYk/OwMbn67OwsfyOSQxxLhRbFEydGJ0HAcCkOuTcfcGA5Y3JFoXVT2iyFhGsviLjkTOaQxjXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502189; c=relaxed/simple;
	bh=JfdA0lxxRXBCBbdz74Kw/v3dMxN9zRLnTp09VJehmxA=;
	h=From:Content-Type:Mime-Version:Subject:Date:Message-Id:Cc:To; b=c7yl+GdmMrtfEfXRYGzyneoW39NPU2PSouHQcWCvJ5Xe0r/BMynA5JiztwGxsLbxbgf6zcmHUF4/Rt4SM4dp1ikMGYntaSGJYnwY22qIiObyLbV59S7ROyale2bnQPblmzbr+Rb/pHcxYH3ThIt0wCfxjcvbi24DqKy/qakImJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFiaaKJN; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFiaaKJN"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6685483aad2so1291583d50.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785502187; x=1786106987; darn=vger.kernel.org;
        h=to:cc:message-id:date:subject:mime-version:reply-to
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jx2biU5gtyVT3FeljkrYWqXAEW6HBZ3aE35eEsWXHY8=;
        b=mFiaaKJNHH8qGW0nJMZHJ4PdgwHludt8DobdKHppxoZ48Pljkc+XM+C2RKLxHbr9Ht
         N3w2s1G3uo9z4K0Q0bbh6AGDn198z9tbPxxAklFIXJlHAKQgWq0etfY6OflYirmdGJBi
         sxDXcRJXVJDn9sTOBgtJ01W1ung3+cM6zynAmTvTj8hg9LjUTUY1T8F/z6X/XWi/0mb0
         ClNqmXz5+lkL0CK5KG8IEzVF1Yqpma4uxPzwSIBVrmMTchIep1HTwoP+xpXCVs5hM/NO
         uWv2kDpkoMlDicmjaupPwPm8Jsz3ILPG7dUoKC54H4DGBaS1VbMG9cNmreIUmoDK2hfS
         LVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785502187; x=1786106987;
        h=to:cc:message-id:date:subject:mime-version:reply-to
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jx2biU5gtyVT3FeljkrYWqXAEW6HBZ3aE35eEsWXHY8=;
        b=GmRC2SxAWrAPaZb3iBk6Kl/4O6Tq+KKfp0FFjVv/BdujCFZ8W7F/ABl5NTnjsgBwhg
         xxETNdLC5yj+kBSmMOjK873SiZ1UF8D0++v0iubdMcLU7adxUTXxTzMHbAMPGEYdIZv9
         oKkXAw4xyFUHNHxi9gR+i3QWh+Z2TzWV/Y2EJYbn9/EmmP05y3HqgmFUQ1zl6qi/GUA7
         R4R4k1IDH4qQmq77clWFO3wEA+XdlBhHtA6rj1mLowKr8k0utUfN3sLRX/tnQVfW/bsn
         x6zFR3K6st1Vrk4Vch/viCSKT6CDyjvVh5uRKJdgifLH/l9jrIMNhWgmdcaddu8x4mM1
         01rA==
X-Gm-Message-State: AOJu0YzZhbu6p1Z67IYfrr23pjHG6FqXK0Kqn84Z/NIz8JpLxQmG6aS/
	1kGguNcetuqKsB/+ybsfiwyLmACI5y6+R+R0yj5M3Il/yM3pWPbBeVONaLRXsA==
X-Gm-Gg: AR+sD10mDpZgROSIxqJH0xVCRsdm1PU8q1fZhqjZPljRyk39ZKANfmrstpw+HTu/ZoC
	AJdp68U1eXsEUd7q0L9dVLIlux2KNu6FPQQetHtg7FHFdJphJn4EqSzRfT6J5gmk+E4UfPurUcV
	lb2xQVvX5GdfML2y2o4GBhij9dO+p3nt7GQ9gomTb5t2a7AWvooPpsnArz0AJa6elTowcBe0G+N
	mKZrh8ZKRXrQG3fgNL69fKrm+gYm04YY7VQoatnge/ZEkToXy1SXvw58GyEeOgR/VgkKg9HNhRR
	sCwL/FVXXFw0ykKvHbEfkULnbcxTjm1z5W7Daj4pHGhGoLLlO2y2zjFeY8jnv/ZLRzzvfzhyTZm
	P/f+RGxi1UnZzDV8bOq4tuESvuKIlq90Sa/bDB2WIqvvmqDNe2Lglc52mZiplgn9rRtijvY3z3V
	Fumj48M1AjNev5IgHeQbPyKepPJauLm/NKX8mxjwgpNg/YyKIBvrGTkO6+nE0=
X-Received: by 2002:a05:690e:4401:b0:667:8495:9604 with SMTP id 956f58d0204a3-66945231726mr1244603d50.25.1785502186638;
        Fri, 31 Jul 2026 05:49:46 -0700 (PDT)
Received: from smtpclient.apple ([149.22.94.34])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66948cff660sm482947d50.3.2026.07.31.05.49.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:49:46 -0700 (PDT)
From: Bruce Hanat <bhanat@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Reply-To: Bruce Hanat <bhanat@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: MediaTek MT7902 WiFi Adapter (PCI ID 14c3:7902) on ASUS Vivobook
 X1605VA
Date: Fri, 31 Jul 2026 08:49:21 -0400
Message-Id: <E2BBB61E-A31B-4764-859A-223443F146ED@gmail.com>
Cc: lorenzo@kernel.org,
 sean.wang@mediatek.com
To: linux-wireless@vger.kernel.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hello,
I am requesting information regarding Linux support for the MediaTek =
MT7902 wireless adapter installed in my ASUS Vivobook X1605VA_F1605VA =
laptop.
System information:
Manufacturer: ASUSTeK COMPUTER INC.
Model: Vivobook_ASUSLaptop X1605VA_F1605VA

BIOS:
Version: X1605VA.313
Release Date: 05/21/2025

Operating System:
Linux Mint 21.3 Cinnamon

Kernel versions tested:
6.8.0-134-generic
6.8.0-136-generic

Wireless hardware information:
Wireless controller:
MediaTek Corp. MT7902

PCI ID:
14c3:7902

Subsystem:
AzureWave 5520

Linux detects the hardware correctly:
lspci:
0000:02:00.0 Network controller:
MEDIATEK Corp. Device [14c3:7902]

However, the device remains unclaimed:
lshw -C network:

*-network UNCLAIMED
description: Network controller
product: MEDIATEK Corp.

The installed Linux MediaTek driver is present:
mt7921e

but the driver does not contain an alias for this device:
Supported IDs:
14c3:0616
14c3:0608
14c3:7922
14c3:7961

The installed driver therefore does not bind to:
14c3:7902

A USB MediaTek wireless adapter works correctly using:
driver=3Dmt7921u

This confirms that the Linux wireless stack is functioning, but the =
internal MT7902 PCI device currently lacks driver support.
My questions are:
    =E2=80=A2 Is Linux support planned or available for the MediaTek =
MT7902 (14c3:7902)?
    =E2=80=A2 Is there a recommended driver, firmware package, or BIOS =
update required?
    =E2=80=A2 Is this device expected to be supported by future kernels?
Thank you for any information or guidance you can provide.
Regards
Bruce Hanat=

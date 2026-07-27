Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411F1386552
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162929; cv=pass; b=TJXBl8XB1jX/t81Qve9bTqILu8i59eQ3HP3g5OlPMTUQpDrOZFQzX4nWHLAKBgm0Q+5eitRaUSZGobSJFUqKw4jCnVrVZnHMVaF287J9e7i+FEml8mJ6rPAbEZWl95Gd45nbKhCW/vjZYmx2yWIDiF4EJ377gUrr4c2eceq/uEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162929; c=relaxed/simple;
	bh=SosyKlFr35hMKUPUxbk/W+muJ1fa/A+uka2rh0lt/II=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=PLYz/uhrf8q/nSRZI5ZYKKAm+P5EhkmsqbOiaSuPH8Bl8e55rmcrLExIW5eVB40+qVJDR4kUMhkia5k5OXv2rtkQEJv63Cy99ZF+TyFGAfb3Cu4l7RLcWbji3qGgGwt9IEWKlT7meP6yVVOpI93hkqJ+9E57RqHXZXbQKh08Ttg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oXljAvdv; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oXljAvdv"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca12086c06eso2177862a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 07:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785162926; cv=none;
        d=google.com; s=arc-20260327;
        b=dM/H/AmMqLd8iN7CHS9uEqIl4AfsVOorS0F565YsjlfYlC2lRUVlmIRcNj2bqpfsUQ
         Aakb9YOslascrtnu0hiwKNwKrnET+0hXemgBIWew+PvjTmoOkNt7XzYyLQW/ncyBAfvm
         6tn9hpRrVyGIekk5OM1AdSktj4FgrQRCmrYMo1OMkkheCIL67NmaJ/LJgA66/c3/h3nd
         3xhYg2rBrLgNpoJyznrTxDwRsCrIttoA5I+t1L7OqfKUIwe4vlTgxkdmo2ykXLbn56Gt
         SFBt9oBXOO8YCsCbJ4VcL/Lqxl1U8Anbk8CWEbvY1I1Fv3MgmPAJ1e0OTT1+/FbQOYAV
         uwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=SosyKlFr35hMKUPUxbk/W+muJ1fa/A+uka2rh0lt/II=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=a7f5NnLsSksmXWIm41U0Ow/PSsuEgCnxYuB9H2WGMMOKiTYpHcaaKGuiKN8opKmt8b
         p98lin5UYCV8/u8LIngKjK1eaP49AwROXYuWh6N44GJmdePwFPcUwzfERpVue268bgYB
         UL/fc7l+WU+FHgATn21cYZFR1tCBLpQVEQWwKZO/8cuWklnzdbM8ixoti7UN3QJNFhY2
         XKfU1W9Y1W+xL9Y8tybtICrOf4nf/3lvcC3dChj7gPQV9asZGI+bv1BJ53bn9tfymqrv
         GrHHtAHskW00n66FqSAMDypd16C6HAF2R82O8S0SNEFokHmzlP90ur7bmBmFVAi2uk8s
         Ywyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785162926; x=1785767726; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SosyKlFr35hMKUPUxbk/W+muJ1fa/A+uka2rh0lt/II=;
        b=oXljAvdvmKlA3Gg7teGpeW5LNf7faxUOPE9qypU5sjxLNXZ+H8etwHRpxZm6AUulkb
         tZ5MLG4jmjcgGxOeNIGNXXnljFjAx6/BSblNXcmvmhHbYX/L9xOxL1tFqkLaRf6qnehP
         vn+kojjxQxi54pYQW/fyQNteOgL1eyJddaMxz92YDmOaeFd+mvFSMFuo0vCQCUXmpdDe
         8XuGOdq/p1Orc122g02LY9zHaEdYJgXThcy8qBf/kxoTtSKJLXGIglXIbJUrOkdol1As
         41aLo5sB45UyFyJA9Zr+0SQPXRoM11xT9SqYUVjfauy4sGFKfi83CweUKisLJ+nk70y7
         I2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162926; x=1785767726;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SosyKlFr35hMKUPUxbk/W+muJ1fa/A+uka2rh0lt/II=;
        b=qL86NYj4mO5MhsbtgahS8XIKga3mEu9un02sYxxQLx3v+om/OSJOHJPBw7bWE1WTqE
         aGq76DcwkUeROJ/wf9YIP1+yWDgxXfCtCcnZjIhqy0RvBj1lYqm8mM0jpLqYzCIoZ3Vc
         EDmOQlTu3dgpnFB7ogZRAZkDEh6QE1RsbYPI9IztbNBig1kFiecQm/SkAa7fyvYIIvWJ
         QYci7J4gw6OlwCAyDbckYeHUz/aLmPpEJuQjYXLzPMX/bOROF+VQrGu+KZLiTAH8Kb+G
         dnix02AtyQNmDJL1z5/zDrg85jJIwn57advsfuWbN+LP22ogs/SM3FIaKYLqiXvsgW9c
         GrZA==
X-Gm-Message-State: AOJu0YxAdSG61x6JxD+tDTdIYue6ixJCvQpiwG5AtMn3BIc1xYF3TjGP
	OtljCpXJzaDT1XeRCJfR+B83v31fFcDEk/I/qE1/9E1McRZ7ABF806f0Q0eiM0ygM5QaN/NGpNw
	PyKYUmW5fxVqD5QQVgfk3Oz3rnynqkqOhNki11q4=
X-Gm-Gg: AR+sD11o9DykZqCp18j7RjHqjKP2eXYcR8w2cm42ttnbD9JLvg+xdh4nJggVAXsTrNc
	YsRTbYPMOls8xELEwXYFu7M4kQiXTLkrQ6MRSbjs46335YsoiFZPLZtug7NykFVxVtWTYpbiAGC
	eaNUMjg4LdgbWssUp7hGPoMB1+eJi8axmV7+e22JXApxhCgPcs+Mq085zxrh7g7a12GCn7u06Wd
	Q5eWOcPgAuRv4bCCOChn2jbikqUz3HJuZn8DyhgqZqNZo9YIXLFCRx8q31apo+0CnybpXj1is2j
	aVISayqc/lihBLTqpxaMC0FeNmJDGp6R1xAqti225iyaN+JC
X-Received: by 2002:a05:6a21:1392:b0:3c4:2fe1:fa28 with SMTP id
 adf61e73a8af0-3c67e05e566mr7962694637.71.1785162926337; Mon, 27 Jul 2026
 07:35:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Adrodoc <adrodoc55@googlemail.com>
Date: Mon, 27 Jul 2026 16:35:14 +0200
X-Gm-Features: AUfX_my63OJ0T6RHuuv33Oklm2kD9xAxrdagXT_oLbhRGZgNah0_fLCicUQkZ_g
Message-ID: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
Subject: Error in rtw89 using Kernel 7.1.4
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I was asked by dubhater in
https://github.com/morrownr/rtw89/issues/116 to report this to
linux-wireless@vger.kernel.org. He said you would know what to do with
R_AX_DMAC_ERR_ISR=0x00000040

I get random wifi disconnects on 7.1.4-1-cachyos using rtw89, that
heal after a minute or so. If I manually disconnect from and reconnect
to the network it heals immediately.

journalctl shows me this error:

Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feaf
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe87
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8b
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffa1
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff8d
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febf
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe95
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe83
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffa3
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff93
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffdd
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb7
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe91
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[CMAC] : CMAC1 not enabled
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
firmware failed to ack for leaving ps mode
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff95
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff8f
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe9f
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe91
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb7
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb1
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff83
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febf
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe9b
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febf
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe83
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff99
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89273df
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89b582f
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899cff1
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a5e1
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a65d
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899b02d
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8935571
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c12fb
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a2c5
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897be11
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a5f9
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897beaf
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897dc03
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897bdeb
Jul 23 11:48:11 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c12df

Full log and system info: https://paste.cachyos.org/p/7f39b6e.log

Here is another example:

Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff87
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb1
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff99
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffb3
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe93
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feab
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff97
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe7f
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe9d
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff87
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff9f
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7f
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff97
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[CMAC] : CMAC1 not enabled
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
firmware failed to ack for leaving ps mode
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe99
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff99
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe95
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fead
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff83
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff99
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe83
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb1
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89afe18
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe89
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febb
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff95
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8b
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7b
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffab
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8935b5c
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8973ac5
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893b577
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8935680
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899b2ad
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8936a03
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8935571
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a601
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89790d1
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899d01d
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89356a0
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893569c
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899adff
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893728f
Jul 27 12:44:14 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893ab13
Jul 27 12:45:12 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=60927 DF PROTO=2
Jul 27 12:47:17 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=12130 DF PROTO=2
Jul 27 12:51:16 <hostname-redacted> org.remmina.Remmina[2267]: [RDP]
gp=0x55f0d23a95b0 Clipboard data wait aborted.
Jul 27 12:51:27 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=45619 DF PROTO=2
Jul 27 12:52:14 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=37223 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=37344 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=37376 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:52:15 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:86:dd
SRC=fe80:0000:0000:0000:0e72:74ff:fe47:5be3
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=1
FLOWLBL=0 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:08 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:08 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=625 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=748 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=1 ID=35675 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:86:dd
SRC=fe80:0000:0000:0000:0e72:74ff:fe47:5be3
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=1
FLOWLBL=0 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=fe80:0000:0000:0000:2248:500b:142f:e6a0
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=255
FLOWLBL=289035 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC= SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=255 ID=803 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=1 ID=35679 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:09 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:86:dd
SRC=fe80:0000:0000:0000:0e72:74ff:fe47:5be3
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=1
FLOWLBL=0 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:10 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=61 TOS=0x00 PREC=0x00
TTL=1 ID=35716 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:10 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:86:dd
SRC=fe80:0000:0000:0000:0e72:74ff:fe47:5be3
DST=ff02:0000:0000:0000:0000:0000:0001:0003 LEN=81 TC=0 HOPLIMIT=1
FLOWLBL=0 PROTO=UDP SPT=5355 DPT=5355 LEN=41
Jul 27 12:53:32 <hostname-redacted> kernel: [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=56233 DF PROTO=2
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffad
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feaf
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff87
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffa5
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8b
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff91
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febd
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffa1
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe9f
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff81
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffb1
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[CMAC] : CMAC1 not enabled
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
firmware failed to ack for leaving ps mode
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff83
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe97
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7f
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff97
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffa9
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febb
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff85
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff99
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffb3
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea9
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7f
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffad
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8f
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a64f
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89b5715
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb899a86b
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a667
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8937a31
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89274e7
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8939555
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c329d
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a5f7
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89790d1
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89355fb
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8980175
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a653
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c136d
Jul 27 12:53:58 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89b96c7

Full log and system info: https://paste.cachyos.org/p/433a961.log

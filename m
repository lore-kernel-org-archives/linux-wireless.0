Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072628030E
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 02:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317628; cv=none; b=QF2uOBVKIL7+9z0CUChdfMaRO8gktxJh3odsFu49aZ+LElKuoesXcZEAMaeeFzGcoJcghF4zXiCgUcQ37XJixwAIMHpQSv6STgU7pPJImAuoi49OOvadbh6y0ss5PxnumV38/SN2SVaNFO3ArFAcWA60oHnuf/6Qajig2HBjRZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317628; c=relaxed/simple;
	bh=2C1ZChuEgOK7V9GZaEywDDISQ17LSCnKHOVbV9SgpB8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=G5PC7nhvvm99vpiD8iz0ga4NPm2suOeB1mh/GWu6UEAulbejfVfHSw0DAVbXmvmnLTO9oqgsx5mS67dxp5UkWsD57mzmOn44E/eqsTCHxbPHw8MQ8hTmhiPqdKNwxHuxy35kOkLW+thdNJFjiJLPZzLhjIRoZmu2YFRDdHPeZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Q1sfT5pW; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Q1sfT5pW"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822rbHI32262604, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788317617; bh=FKv1LWx9v8Z1Y9rEFVUIyQJEGJRMn+a6j1z8/+Rl3NE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Q1sfT5pWxnyWtCQidVIjUmpf6Kztg6inu85h8u0lCVcnqxP8FHr2fNcEj3EVVOVwv
	 Ro6q8Gk/CuFYcgXfCewE+TS/4NSUq8DPr2ecUAoqPde7FaWqBrFL8Cog/pd5FIoYkI
	 mTFlHzIrVXWrMrBfmnXqYJiU4CvweBD0wWLvTvtdWtOrJBa0oztGgcsEcnr4qxf5xR
	 oKDX04zDBX2eP6b/uwAWd98eK5lSjQwxduCWYv/JgWPZ9UGTBgstc7VJZ6zxExgRtV
	 SWJji7e37Hrb6y4ErBvzGSEQRlbR1UmauJwz+SCnj/s0R2EW7SrBfjcnai+xeC6i40
	 gdam3/ZGRrTSg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822rbHI32262604
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:53:37 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:53:36 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:53:36 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:53:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Mehmet Fide <mehmet.fide@screeningeagle.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next v5] wifi: rtw88: usb: do not log transfers lost to a mode switch
In-Reply-To: <20260817063319.389188-1-mehmet.fide@gmail.com>
References: <20260817063319.389188-1-mehmet.fide@gmail.com>
Message-ID: <8b520161-f60b-4157-a4f8-2e1517fb1f9e@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:53:35 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mehmet Fide <mehmet.fide@gmail.com> wrote:

> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
> rtw_usb_switch_mode_new(). The chip powers off its MAC and leaves the bus
> while the last control transfers of that sequence are still in flight, so
> they complete with -EPROTO and the driver reports them as errors:
> 
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>   rtw_8822bu 1-1:1.0: write register 0xc4 failed with -71
>   usb 1-1: USB disconnect, device number 2
>   usbcore: registered new interface driver rtw_8822bu
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
> 
> Register 0xc4 is REG_PAD_CTRL2 and the access losing the race is the
> rtw_write32_set() that ends the switch sequence, a few milliseconds before
> the disconnect. Which transfer gets caught varies from boot to boot: 0xc4
> is in the "always on" section, so every write to it is followed by a second
> one from rtw_usb_reg_sec(), and sometimes that is the one that fails:
> 
>   rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail,
>   status: -71
> 
> Nothing is wrong here. The device re-enumerates, probes again and registers
> normally, which is why rtw_usb_probe() already treats a non-zero return
> from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
> switch can never succeed, so the message returns on every boot and
> everyone using such a port has to work out that it is harmless.
> 
> Mark the window in which the chip is expected to leave the bus and skip the
> error reports for transfers that fall into it. The mark is a rtw_flags bit
> set in rtw_usb_switch_mode(), so it covers both the new and the old switch
> sequence, and it is cleared again right after them: the transfers that lose
> the race are issued from inside the sequences, and anything that fails
> later must be reported again.
> 
> Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
> where the message appears exactly once per boot. With the patch both lines
> are gone while the disconnect, the re-enumeration and the second firmware
> load are unchanged.
> 
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

0b772bb2d6c0 wifi: rtw88: usb: do not log transfers lost to a mode switch

---
https://github.com/pkshih/rtw.git


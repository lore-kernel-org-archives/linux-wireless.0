Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95013A1B5
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 02:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047322; cv=none; b=jaizSJY7WMokmZCccIrlxUaQFZZuA83lWanCEJ7WhRmP1PngUf9rjd4ygm357qxgGRcMcTZXuaderov8fOACLZO5ygDuOYb65BdBALAkf+aMbqRds3O/B8asgz/XlkzlcIUVLQ2JijeN496Pt4wcBZHSbVlO9f+ueWG8S0cvKiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047322; c=relaxed/simple;
	bh=DASLVWcwXx86+bpXJZBj39BT0GGeN+Hw8Uradrb1Wrs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=l19UwhrhPfTPTu0PiEjVaA6UTrwsHHuxhWHdPu3+y5Sz8HeUjcay+DAuzcNDJwlGAWLnG+3Fj1ji2P6H/jQJfJZs69mhuc/AI5aBr/jDrW6evNC+4z3VbklKo4TuGLqAqBbP9No8V8usckBX7DF2LtzpNYi0MQ9W+a7pSB0IhIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ByDCE7O9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ByDCE7O9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6632tA1312402834, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783047310; bh=ueypNIeZJ1L5Xq7KGzlN11Are+yyW8Zox1yJVo3XBg0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ByDCE7O9HXBzuDv8Z4XOG10yEKFRgeuDKpr88nQ2Xvnf5Wu4GeQA3v//a30JzSWtU
	 Sn/I5OJWStCKhh1eYCQd+uPdhPMYma7IqT2hEVTro3GPzNipg3t29XDWoPp0zunzah
	 0oTX4SJDq1vnR9HdcJNvsIMP9ctSX+Fhb8jvp29XeSdzC3j8RuqkohalOUgMwVIj0D
	 K5OfaRA0668JkWVXB60CN+dV01LYOY7vM158lLUjZ3g/bzb46Q8Zz4KBpi63qBj+8g
	 5UDIleYhZgZVID9h9S5IvXsEjzbVfPIlVp3BR183DYraQGaXe09BxzdgPMdNDz1iXL
	 xebugeItyOPBA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6632tA1312402834
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 3 Jul 2026 10:55:10 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 10:55:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 10:55:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>, =?utf-8?q?Georg_Bi=C3=9Feling?=
	<georg.bisseling@sea-gmbh.com>
Subject: Re: [PATCH rtw-next] wifi: rtw88: Enable receiving control frames in monitor mode
In-Reply-To: <2a52d718-9e46-47f2-84a1-d8e7b1ed89a8@gmail.com>
References: <2a52d718-9e46-47f2-84a1-d8e7b1ed89a8@gmail.com>
Message-ID: <00fbcdc2-4d26-4cb8-9448-f62e6ec42063@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 3 Jul 2026 10:55:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> From: Bitterblue Smith (S.E.A. Datentechnik GmbH) <rtl8821cerfe2@gmail.com>
> 
> By default RTL8723D, RTL8703B, RTL8812A, RTL8821A, and RTL8814A are
> configured to filter out all control frames except PS-Poll, even in
> monitor mode.
> 
> Handle FIF_CONTROL in rtw_ops_configure_filter(). When it's set,
> configure REG_RXFLTMAP1 to let all control frames through. When it's
> unset, restore the original value. Because some drivers configure
> REG_RXFLTMAP1 differently, keep track of its value in a new member of
> struct rtw_hal.
> 
> Signed-off-by: Bitterblue Smith (S.E.A. Datentechnik GmbH) <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

ed51a86b787f wifi: rtw88: Enable receiving control frames in monitor mode

---
https://github.com/pkshih/rtw.git


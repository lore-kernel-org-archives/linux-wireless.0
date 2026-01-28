Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC841373
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2026 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571950; cv=none; b=nO/MzvgY7hfTziP+qyeEbeCUMUdSSL/YgmcxUETKLJnBf/ekVy7l8wfUyySbqfSbiitG1F8lEqSYWR5Fm/pifuuxQ0jiMoAfrBl4OQEX/7NGOhC6X3DwvcQ5SUm0annVzOLxWRlgfLiJez88cuiX6bCa0zG4UTfmQmrtbXr0PcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571950; c=relaxed/simple;
	bh=lpliyRPzERaBSATVF6MUwXv++P2voqzb4qKHmApK3Kk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=lhDJFmtE4Z1yPJ+hZQC/F9jG/bA2CWRbhvRp4R91WswAgDyXYvbBWpqnIk0BEHH+lP0+mxMukxc257O1JsGXpJwkxrDDV0VbG6B407/1aTyh6ifxoyYis5kN5eANtCZUfoBV+TINMC0w4F0RdbRHeQF5FWZrpfoFWkyMDMrZ3y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jGJQhN4u; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jGJQhN4u"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60S3jjsU7155768, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769571945; bh=H7xWWBEcuoky/FC7CyctS8M1VkPMPG7baaqZncQBeAM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=jGJQhN4ukVLkIJ28v4cu+8XdwS/H1PfCt//GkT2wQt3iua1/b65F0XTde9xCMalxU
	 R0xHkJUDDZX8wmQnCesTppRKhYkrvp1d9vWJ0MscdzbbJ7t9hoMZC/91vvAaZDj3h/
	 HE90ubbzk9uPk7ON+IuOXQ5EfV7tTfGJhzmAx0GkkBCyxuD6mdifQrmPNPVsagRIZx
	 8/ijTo0+X58/2z1+s0rm0JF0mhl5kJQW+IRcUms/nOT7G3Glip2UaV1SH6F0hTbj8A
	 L00ymH06XYxUS3FVbKtpFPbXt4hMxEGi3RDjmLZ5elxc35yGXse/613JSGcxDsnJuG
	 dxN6tCJ6Nj6Bw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60S3jjsU7155768
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2026 11:45:45 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 28 Jan 2026 11:45:46 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 28 Jan 2026 11:45:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 28 Jan 2026 11:45:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 01/11] wifi: rtw89: rfk: add firmware command to do TX IQK
In-Reply-To: <20260123013957.16418-2-pkshih@realtek.com>
References: <20260123013957.16418-1-pkshih@realtek.com> <20260123013957.16418-2-pkshih@realtek.com>
Message-ID: <705c5635-909a-4980-8c13-9ef90c0f9b45@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 28 Jan 2026 11:45:45 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> TX IQK is a RF calibration, which driver call this H2C command to trigger
> the calibration.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

11 patch(es) applied to rtw-next branch of rtw.git, thanks.

ebd8a1d736ee wifi: rtw89: rfk: add firmware command to do TX IQK
9df3575ed2bb wifi: rtw89: rfk: add to print debug log of TX IQK
17b75fbf9c71 wifi: rtw89: rfk: add firmware command to do CIM3K
571f945fb91b wifi: rtw89: rfk: add to print debug log of CIM3K
21344e741377 wifi: rtw89: rfk: update RFK report format of IQK, DACK and TXGAPK
c938cb486254 wifi: rtw89: fw: correct content of DACK H2C command
69ed25f25faa wifi: rtw89: phy: add PHY C2H event dummy handler for func 1-7 and 2-10
3b85a8948f52 wifi: rtw89: 8922a: configure FW version for SIM_SER_L0L1_BY_HALT_H2C
986aa89b7613 wifi: rtw89: get designated link to replace link instance 0
5f93d611b33a wifi: rtw89: pci: validate release report content before using for RTL8922DE
599b1b9fb967 wifi: rtw89: regd: update regulatory map to R73-R54

---
https://github.com/pkshih/rtw.git


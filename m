Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA65132E6BB
	for <linux-wireless@vger.kernel.org>; Thu,  2 Apr 2026 03:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775102310; cv=none; b=BLh9DSBqlmvywwvjJ0IpQg+dYS1WFZa9ngjG/EZzZCiVq8npXDDW5/nMXMlMQ+kKFZadR7jIu9bumbiqcspM12BtLGJklNGVNLA8CCjQfvhcJY9mtJ3HFRP5SHFjteOXDznifUiXUJM2wh6jRg/lEnEDVhCRLo2B8mKdOefDtq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775102310; c=relaxed/simple;
	bh=SBsqWR4tV7aWTus999imsYAfAyNPatOFdb4ur1WGcAM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=kQjGdN2sBXQ2TpFdqXhxIJLP83JWcvznj+LI5EMbzOvw4MhLAMAUcPgwDjtuO9Cp/q5cnJmMcLXPYYcZxsv5FmqdXS9lJtXYUFUXYsqVttvdxOXkPAYHUemB0e8XiclnoMRIWK7P/AgmZiOuvS7aFX5tF8QorWj8bjxUHP7cIXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=afWtzGlj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="afWtzGlj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6323wP9v92395052, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1775102305; bh=0PLSTbz4zoox4U5P1+OcKf6xjDYTY1Wvt90l+VGKTOU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=afWtzGljWDC2D3TYIF6YlNLbcUGYAkDrt/TVNEsGA3ZqHIH7D+CWTIWmzX/d/WZ2+
	 +4LuTJoJT+GD2Y9DCCM0m2tU8LEyLcDgqJ1M++itadM8BGc+Vp0n687ykdc0ecKpjt
	 84oVMv95vXJ5M8RbqeDOzmaXnwbLA8d8DHiDQBScoW7N9Cx/k9Fj399+dt+jpjDGyI
	 /Lmclwcx0wj1ZZixCMgv27B/gRFdQTE/eqIwVv2Zjd229cH7kNb3BRUDrzfSFEs7fG
	 j4Mb5hRxRxCTkOzT4JuxOSvxt1mfC5LnOR0vuGPoqV3qSPKSAqMCYaXF0EG1fOBcG2
	 E7d0e8x2IiZhQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 6323wP9v92395052
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 11:58:25 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Apr 2026 11:58:26 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Apr 2026 11:58:25 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Thu, 2 Apr 2026 11:58:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Zenm Chen <zenmchen@gmail.com>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <rtl8821cerfe2@gmail.com>
CC: <zenmchen@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: Add support for Elecom WDC-XE2402TU3-B
In-Reply-To: <20260330093440.3615-1-zenmchen@gmail.com>
References: <20260330093440.3615-1-zenmchen@gmail.com>
Message-ID: <d5121892-0961-4e2f-8cab-c5f53c500b20@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 2 Apr 2026 11:58:20 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zenm Chen <zenmchen@gmail.com> wrote:

> Add the ID 056e:4024 to the table to support an additional RTL8832CU
> adapter: Elecom WDC-XE2402TU3-B.
> 
> Link: https://github.com/morrownr/rtw89/commit/55c059e2bd49acd5cf93edbc8eda7b9e042f4efd
> Signed-off-by: Zenm Chen <zenmchen@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

4e4fc2149b0a wifi: rtw89: Add support for Elecom WDC-XE2402TU3-B

---
https://github.com/pkshih/rtw.git


Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0A280331
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791164687; cv=none; b=tEKPVgIkAdESgA6MtAGc9Lc1jYmGQpFG516fIat7Cr8NyY4ihJKv6PV33E7hns9FhYRiY28OmkYAvNG86AEqcm0i/KZiK6zPdlN53zfTNZFaxP63nUGSIIzC5NtExKEuA81Ata0PATnwPwvXqOhUf7+7LEwlCs51fMc7rNg9jeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791164687; c=relaxed/simple;
	bh=baq9i4WFBspA70jVR8hsIb3z++mwgp2W7KYyzN8qr7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XChXjYnE1sklBW5qxqS/7xheTOlHEJur5nBXQCoIKdb2zK8o8a5dzccSC6kc4+x0Efn5CEp1Qhbl85bF3C9MCsrXoNbeJlW3tKb5CjnCkWGcSVJPW0F6J4hNWHw+RVTE489tAvY6PG1BdC5rDAmIc3ql//obfWY2Sq3WmIZ0otA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Ar7AH7z0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Ar7AH7z0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6951iSevD1525890, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791164668; bh=baq9i4WFBspA70jVR8hsIb3z++mwgp2W7KYyzN8qr7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Ar7AH7z0jtzZky+1NmocYmkvecB04AQfBACMDKLw9LEMvRdWzI4Rre6tI4+h+piLE
	 Bx4wKv20vzv2dFIl0cd3kuUDo+0SLRH8Z9KS7mFMGoJlm/HcIBizuAqPKaUtWYm6lQ
	 cSV4MxDWcVuUBsfrZWfKcjUKV9QDGrEpw3+Q3048NfoFrsfyRhDUZYPP4CyzXD3noT
	 PFRCyaaOwmNCiu9rxY7Kt4Vsu43pR1BAu4tLg64WU8epYEt/ovKJ6oR8nHfY+YK9e5
	 t0lqS78lUPGPWw+I06+0sA8opTNqNGKfaD+0P/JA6IatCs3wY1Mw29LdcZEt6VYclb
	 pfnxLhNZW7FyA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6951iSevD1525890
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 09:44:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 09:44:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 09:44:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"briannorris@chromium.org" <briannorris@chromium.org>, "kvalo@kernel.org"
	<kvalo@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next 0/2] rtw88: recover a stopped TX queue, and
 notice a stalled ring
Thread-Topic: [PATCH rtw-next 0/2] rtw88: recover a stopped TX queue, and
 notice a stalled ring
Thread-Index: AQHdUsM/vc3iJPh8qEClM8xuoUQbrLbqYmEAgAPNx4A=
Date: Mon, 5 Oct 2026 01:44:28 +0000
Message-ID: <09d458b125354705844985d94c90d918@realtek.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
 <20261002233738.29618-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261002233738.29618-1-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> Adding Brian Norris and Kalle Valo, who were missing from the
> original Cc.

Kalle wasn't be a maintainer.=20
I think sending to linux-wireless@vger.kernel.org is enough.=20


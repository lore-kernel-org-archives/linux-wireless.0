Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD715350B
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 04:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788668759; cv=none; b=HFjoJrN2ZoDOT0Vku9Wbc31/LGxgVJ7512bjdMmtyrNlb0HPVW7t6cySbQKJsxyEx1mp/Q5+LhRJQkCk0TeIvQQR1oF1VhKz0jU1DQDI62qDNg+0n17xtfME2jkUTqsWbie75f296Yzf0R3sxEaQ00sy5leIkQkSD+qNlR2QE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788668759; c=relaxed/simple;
	bh=iTKJUtPX3Y5mFhLJLKBd7KqW0s9cQVmNMbGdCaTdpIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=at7lUqTTuakXJmwIJ2GNPdWPoBm3+pf6GtX8t3deMQj1JX8Td0K2VbdvAoDMv2WOJ7siwJVYQ3YX8rXfiZpHG+4snE4IB7SyZDcjcKK9c1fDufqNH/JnV9zBDDaqDgNFbHjxADFfVSqlrLUIpkbMAC2dLp2uUZ8G0V5+y73l15E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XM0M0yhK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XM0M0yhK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6864PstM61658371, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788668754; bh=4aHsBY30scnNS3lE/Fn4dZoOwqrugg88AyJw5N8NuRs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=XM0M0yhK/9Xpdbr4j0zDywNS8nfjQ4Xo+MWeCptJNne5rsP/Br6NnMTFIpoQ8MZWp
	 L5xCAGzRXm/862XboGbtNzTBRwAnEON0J9TnJni8yj6ADHtm/0vQ2qw0EEPbjkQSpJ
	 y4JAehoOxK+emieATPQUwSz79sxghx6/klxrYKmrbUi+9+bzmR0JhbbWSQY95hAnFZ
	 ybElWhzrENf1b3dqzXPneyjgxLpLvHMbDfK7zVaAPy4R0iRrxdsRMG6tDm26h1XGc4
	 nxhmVOybUVgFrTuLi+vw3AZtWR3zQdEiVUp2+tI+uS1Ljc0t9pwKhurVpKAzt4aFqa
	 5drO4HCq393Jw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6864PstM61658371
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 12:25:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 12:25:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 12:25:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 12:25:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rtw89: RTL8851B BTC entry requires unpublished firmware
 0.29.133.0
Thread-Topic: rtw89: RTL8851B BTC entry requires unpublished firmware
 0.29.133.0
Thread-Index: AQHdPTiveb8acy2IWEyuU/lutHatFrbA8tcQ
Date: Sun, 6 Sep 2026 04:25:54 +0000
Message-ID: <5976dee678a04857b862bc8745420fef@realtek.com>
References: <20260905131503.6160-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260905131503.6160-1-skokovmaksimevg@gmail.com>
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

Maxim Skokov <skokovmaksimevg@gmail.com> wrote:
> To be clear, I am not reporting a malfunction.  I have not observed any
> concrete problem that I can attribute to this, and the legacy profile may
> well be perfectly adequate.  I simply cannot tell how the situation is
> meant to be read:
>=20
>   - Is firmware 0.29.133 or newer expected to reach linux-firmware at
>     some point, with the driver support having landed ahead of it?

This one.

When BTC expert does upgrade, he does review and implement the changes
across chips in one go, because the firmware is share to many chips.=20
Or, he will review the changes again and again.=20

Ping-Ke


Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A2926ED4F
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 02:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788835387; cv=none; b=EGcf+p2DVOjSMfVJ8gC8P2EaV6qKj1gojRe72sKJJdfeZtti4i0RQb0Qra30bNEuP+pqURtH5lRfMjvgO7wC393FUXDZUk39q65tWv3K4ZOKOSERgy/8gIbE3RqbU5PenEK5sUXAaZEvZnZ8WHKE8jMnLyi2X6IQ2htEEct3nPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788835387; c=relaxed/simple;
	bh=yCTDtHadYo8nmjRyP6z5N9MFlxMksYCZE4pscq8OQlg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=WEPV0SL4MHrR/NVFTGdXTO6Yy10FgmZjKgsfmgDOkUyN7MSDGVyA5DFGgBh8seTrHbOPGoUhF+Spx5Pa9p3pjEmZWyWIRduD03NISlCppTPVqwTTrzG1nU2bWGAhpqU05ecGLIgxg0wgdnOPoBhUt9MfYVlD4DK9FSw0mMY2VVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n+L6HeF6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n+L6HeF6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6882go8wB3420136, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788835370; bh=I9iiiVogH0YdB2RIhJzD+IU58nlEot8EJOrBHergPsQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=n+L6HeF6clfAL7dr6CopOJNemzMirmPzmoTOsqSrqo5klvT2SQI/3P2en/s2L/Sme
	 NO7QGgyhUCGqWyn4zE02gxRAzrvhpEwstgK+vHWpqnkZAC3+qQt+geOGkwP+GSXIQE
	 bqMLQTocuDBI8THcCnbSV1aQlHSdQkb9FbSCQ+DoAXrPa0DaOeZHxfrwsEwq4ZdHPm
	 6PGkdEKkbxz2/XxAzL1Zro/AO8WNjuTk7wxy7n2GwBQzbw9gmXoXk6UrdLYhEa2h3n
	 gHzGEyWjlKSc2y3wMae78CVXvtMqL6ONhzqb261XMGSA3LriGrTBQZQkc5a4fuMGw0
	 1Qevz1wtxkLYQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6882go8wB3420136
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 8 Sep 2026 10:42:50 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:42:50 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 10:42:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <nick@venenga.com>, <linux-wireless@vger.kernel.org>, <pkshih@realtek.com>
CC: <tyrelpark@gmail.com>, Nick Venenga <nick@venenga.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: 8922au: Add support for TP-Link TBE400U
In-Reply-To: <010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com>
References: <010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com>
Message-ID: <016105aa-db76-419e-9cd2-8b69d0e94943@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 8 Sep 2026 10:42:45 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nick@venenga.com wrote:

> From: Nick Venenga <nick@venenga.com>
> 
> idVendor=37ad, idProduct=0104 TP-Link TBE400U (USB-C, no external
> antenna)
> idVendor=37ad, idProduct=0106 TP-Link Archer TBE400U Plus (USB-A,
> antenna)
> 
> https://github.com/morrownr/rtw89/pull/123
> https://github.com/morrownr/rtw89/commit/c98e6ff31c331be35383b5a500cfaf76620e2d0c
> 
> Signed-off-by: Nick Venenga <nick@venenga.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

73def0f722c7 wifi: rtw89: 8922au: Add support for TP-Link TBE400U

---
https://github.com/pkshih/rtw.git


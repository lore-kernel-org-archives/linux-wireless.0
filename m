Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155AF28B7DB
	for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2026 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674518; cv=none; b=frqvgZYXliB2uJrSzeInEQ0+PjpTT3bEbpZ2JZYrPU1wr5+262mOQBH2D9ei1Dn9esJ6JVRCevVJQg3/lLpmIdk++9mVehd3A20WlzBj7jroQPK4kyYI5ETUd2LMcqMJJ4bOJdsRJggFMm1LFlhp9EypOYkxc0QqLpYdmTrMQGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674518; c=relaxed/simple;
	bh=sZylmzMLzJxGwwmn8ymS0FkPCnFB8fRV6r5mxc8W/8I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S6AGJqY7K+KCHPSZn2E7AdpwbkjJCf+sdvVk+QE6Xu9nYimQdTirm+hQjkTDGzDH9z6wu6zenKRfeZDWaAm3VlBPRB6ehCor8XdK5ooOV33bJpdDW2aI5Upozc2/Tv6NOc76UAn0fU22mmlK4hwTNcIK5RlxZvAC58lCLbQsYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZJ0A00Mk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZJ0A00Mk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63K8frF03838688, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776674513; bh=sZylmzMLzJxGwwmn8ymS0FkPCnFB8fRV6r5mxc8W/8I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZJ0A00MkfcOXW0gswixQwqr34DY5c1YLt0nRHp05nkKWmbKGGjwkFqUW1/zw9OZDG
	 f9+Y7GCrPYfN/l6WkDXnzgzNFUXQjp5mtYHZwefn14IooBNqb4vxhpvnq0ti+Z5H9g
	 lY+sTTNGqAPRsHQa0V1TsSU8BrDMFH/8OARttj7R2rqMAhur9sbvzEZhimKxxi1j4W
	 CBL9ZGCqe8b0lIJ8Eg5lGUdmwlBTkxOjhSWCQkIEnOkrSJYTuSw6G/1ZI4sFS7akUt
	 rQvBtkbR+NxSZLEXdB4+fiUBgUegtR0d+bv33zdaqqgWTJS1KAMv1Zd1riKPXv3GTN
	 nJDVs4srT2tfA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63K8frF03838688
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 16:41:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 16:41:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 16:41:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Mon, 20 Apr 2026 16:41:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 10/11] wifi: rtw89: Add rtw8922au.c
Thread-Topic: [PATCH rtw-next v2 10/11] wifi: rtw89: Add rtw8922au.c
Thread-Index: AQHc0AMclmHNr9m8XEuGL2v+Azrtd7XnougA
Date: Mon, 20 Apr 2026 08:41:53 +0000
Message-ID: <35a33276337d423faac206ffaf0f1995@realtek.com>
References: <6ba2910d-020c-41bd-86fa-d1b0e0f7a2f5@gmail.com>
 <0d22cd72-4048-41ad-a4aa-511681e6ba51@gmail.com>
In-Reply-To: <0d22cd72-4048-41ad-a4aa-511681e6ba51@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBUaGlz
IGlzIHRoZSBlbnRyeSBwb2ludCBvZiB0aGUgbmV3IHJ0dzg5Xzg5MjJhdSBtb2R1bGUuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNv
bT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==

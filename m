Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AEE14BF92;
	Mon, 24 Aug 2026 01:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533968; cv=none; b=daVnEBO3BI21xVrVL7KEKxREZpsJRHQd29BH/WR5oKKPN/BIh+rCJDdi5ZQ4BxzAofo3anxH8VemaMuKmufpuz9VyoTb0ZdFtzL5RRatqxcH/bHKX5vWRvxzvmePw5F5zkVh2knPgc/g22haPhTfjlWLRkSk1rOFqdykPh2uNMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533968; c=relaxed/simple;
	bh=f4Lk+ymv0W2W1IBQFXcPZSEmQQMkuDNqLZ2wKY+371U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SYEBwQqXnijA2awRWV/2vDexhZ6yVPHrPAb5HITR7UVlMY8963AYRQlVSi7/BxiVmR4kzw/1uePJhbxgnAK4Cjt7pvzd4qprZQadL0nZULl49dxHQuTENRBH5Ci0G56Keb6H4m6TTbyy3yK9if0Z0fVpJff91/3mn3EugiZcZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TrqGSNBq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TrqGSNBq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67O1CgJA22339663, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787533962; bh=f4Lk+ymv0W2W1IBQFXcPZSEmQQMkuDNqLZ2wKY+371U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=TrqGSNBqF9K4m7t66xyobt+LZOdk07pknBE8s1J2+295sGQEFtjBNVDm+iq5Et3tk
	 1keO3oInK0Iq9kQMQrrBqX9vT5Z62D7jM/JRGxV9JQ6KYCFwCvu4TzMVRYCDucx345
	 gii2/HtI6VjmCyu8iQ+zdm0m4iuVN4OT53mN+wQuN7iNupQdpac1BWu1yqGvRAT6+3
	 NGB33cgkg/0QXtSGoQWh7Ee+3UL5gTVEROzL2qZLfWG/kT1BUhICpN0eRaoRvcNhJ3
	 jsUGLnnSogMJqFF80Iev6blX+q1HnzFanvPIb1wF8jTu6Pt3GQLaStlPhCat5R3hAL
	 Rkpk7uKZTQjZg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67O1CgJA22339663
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 24 Aug 2026 09:12:42 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 24 Aug 2026 09:12:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 24 Aug 2026 09:12:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 24 Aug 2026 09:12:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw88: disable ASPM for Lenovo IdeaPad
 S340-14IWL
Thread-Topic: [PATCH v2] wifi: rtw88: disable ASPM for Lenovo IdeaPad
 S340-14IWL
Thread-Index: AQHdMuRaDdn6aY0a5kGwUVP/YCiDlLasZXgw
Date: Mon, 24 Aug 2026 01:12:43 +0000
Message-ID: <070444ae1c564d0cac523952a26ae787@realtek.com>
References: <20260823094640.22585-1-atailhan2006@gmail.com>
In-Reply-To: <20260823094640.22585-1-atailhan2006@gmail.com>
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

QXRhIMSwbGhhbiBLw7ZrdMO8cmsgPGF0YWlsaGFuMjAwNkBnbWFpbC5jb20+IHdyb3RlOg0KPiBU
aGUgTGVub3ZvIElkZWFQYWQgUzM0MC0xNElXTCAoRE1JIHByb2R1Y3QgbmFtZSAiODFONCIpIGV4
cGVyaWVuY2VzDQo+IHNldmVyZSBjb25uZWN0aXZpdHkgaXNzdWVzIHdpdGggdGhlIFJlYWx0ZWsg
ODgyMkJFIHJ0dzg4IFBDSWUNCj4gd2lyZWxlc3MgY2FyZCB3aGVuIEFTUE0gaXMgZW5hYmxlZC4g
UmVwb3J0ZWQgc3ltcHRvbXMgaW5jbHVkZQ0KPiBmcmVxdWVudCBkaXNjb25uZWN0aW9ucywgY2Fu
bm90IHJlc3VtZSBhZnRlciBzbGVlcCwga2VybmVsIHBhbmljcywNCj4gYW5kIHRoZSBkcml2ZXIg
ZmFpbGluZyB0byBsb2FkIHRpbWUgdG8gdGltZS4NCj4gDQo+IFRoZSBpc3N1ZSBjYW4gYmUgd29y
a2VkIGFyb3VuZCBieSBlaXRoZXIgYWRkaW5nIHBjaT1ub2FzcG0gdG8gdGhlDQo+IGtlcm5lbCBj
b21tYW5kIGxpbmUgb3IgYnkgcmVsb2FkaW5nIHRoZSBkcml2ZXIgd2l0aCBkaXNhYmxlX2FzcG09
MQ0KPiB2aWEgbW9kcHJvYmUuIEFkZCBhIERNSSBxdWlyayB0byBkaXNhYmxlIEFTUE0gYXV0b21h
dGljYWxseSBmb3INCj4gdGhpcyBkZXZpY2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBdGEgxLBs
aGFuIEvDtmt0w7xyayA8YXRhaWxoYW4yMDA2QGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmct
S2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo=

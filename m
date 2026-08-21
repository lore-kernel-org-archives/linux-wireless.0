Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208630ACF0;
	Fri, 21 Aug 2026 00:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787273119; cv=none; b=utzbHoxOyppMHGDCKB/nr1TljAWlsKjo/SnlTa3PmlvYhngO2uH6u2mcyrlj7HwHHJ7OjiZ8UIXfkESMlEFi1antXtk8nist2EWY7d+G/yLfibJs/VBdsB2pNHtceGV+LJdP6gOAPQ+FU0WAicKZMTKd2xO+URA5rW+YmrYse8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787273119; c=relaxed/simple;
	bh=+AU5qaAD3W/uiz2/09AwV34B0zPsN0ik1CmnQCYo3zw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K3nQ1/7RwKzkh45ladeHbG4qp5zz/B0h28ia4xTS6q8rvBXTSDoY6eRcJGCkeTCmpAqESH08xJjJKZjpga4s45czRlRQxKWkmkTz69qVrBzXOTBRHoZay8BPeATgx34Xj5BbPSCvM50/1aC+SqNxdsolZ23fNFjnhxX55+KjcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=J97pGeJN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="J97pGeJN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67L0j1E513940101, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787273101; bh=+AU5qaAD3W/uiz2/09AwV34B0zPsN0ik1CmnQCYo3zw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=J97pGeJNrLkiF8vReA6Aj4PTFM6zakv8Ye6vUfi55sJU6ob/0PUwn/rOxH5znnDXo
	 0pKJgOS6K0KDBTrU+Mb9LpA3t+85B2+9/HA/6j07OzLTnmyEqRjxHTmhkWyOWCYu/e
	 bQ7r+iHBucDSVfwj49/sV45x2QIyytVmsNkzY5XvLDxuUPFXFtFBMk9B4pFfNsKJVk
	 qqOg33LJeb/7U4QwOmilhrP/bT/0oeMxs7ARDeJlU/fZq4eSxrELHQpdYxoubCxrQy
	 st/n3qnlfTniuv5X+MtMFN7iLTVxQ+0biVPu1xcsilkELPnyAMM9UkL5SsPdzxSyfk
	 olC4MR9c76s3A==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67L0j1E513940101
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 21 Aug 2026 08:45:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 21 Aug 2026 08:45:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 21 Aug 2026 08:45:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 21 Aug 2026 08:45:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Topic: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Index: AQHdK9s24o7nvN7toUOll3UaGdFmtbamJ2gAgAGM8UA=
Date: Fri, 21 Aug 2026 00:45:01 +0000
Message-ID: <2c1379e3eec54a0fb8f7b348ec3babc5@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev>
In-Reply-To: <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev>
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

RnJvbTogTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBJIGFtIHBv
c3RpbmcgaXQgcmF0aGVyIHRoYW4gd2FpdGluZyBmb3IgeW91ciBjb21tZW50cyBvbiB2Niwgc2lu
Y2UNCj4gcGF0Y2hlcyA0IGFuZCA2IGNoYW5nZWQgZW5vdWdoIHRoYXQgcmV2aWV3aW5nIHRoZSB2
NiB2ZXJzaW9ucyB3b3VsZCBub3QNCj4gYmUgYSBnb29kIHVzZSBvZiB5b3VyIHRpbWUuDQoNClRo
YW5rcyBmb3IgeW91ciBoZWFkcy11cC4gDQpJJ2xsIGFycmFuZ2UgbXkgdGltZSB0byByZXZpZXcg
djcgYXMgc29vbiBhcyBwb3NzaWJsZS4gDQoNClBpbmctS2UNCg0K

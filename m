Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F437E0FF;
	Sun, 13 Sep 2026 03:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789268585; cv=none; b=hEHbJl9rtTQent+PNCsetctdq3ZHcArX51Sp+a6VGBDYt8q4rcfgIPI5jO7OgkCabc1yykIGCLa4CzDT67Y1omTf84c7Hfokz1Fn6lF9zhZuojT+kWodiTW0a4RCOxPlf7A9W6yEonGeA8NnT9C5dC/mRWD6CRhtVvWqI0fI8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789268585; c=relaxed/simple;
	bh=b4gOxGcEIfLAYCLNPTVEM0GYPnhqvyknQ48/77IfXIo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HlYuDd9ZVcTmvXNobxNZ+KaEJyWPCg91e0lcwYg1FIbNhIkGLvI6jy3pDogCfv8usUgi6fG5u93+tMA3b6TFtGmRyHgMheg2yhZ+xdq1DROBjjGrJ4hbZOTQvIg5/mcFL2K3qXSeK2og1DM18xSZCjVnJMebu5CXz8NocvWxi5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Qa56y0SH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Qa56y0SH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D32vZK23629900, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789268578; bh=b4gOxGcEIfLAYCLNPTVEM0GYPnhqvyknQ48/77IfXIo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Qa56y0SHWkzbdHKIvq55EEaL+7Ig6hMznAxp0+A/tv/1kFnuVzcBmL8DrSStl5RLc
	 E2rkKat7ebufP+TQg3tqupEqEhjBy/X0DJuuENAn7IUnypw72ePPCUVWebA2kLMjTQ
	 8urr7ulY7Z0HLW3xllo+w+Zluo77H1rKOEQ4gsdZ6eO824udQ/JzFcsNAvdzJAYlXs
	 5UOlpfRZkIFsm9Qm8K5LI8x2WqZDxAsy3MCewR/ca/PSMnYXjvLFZtsNBaVX/5oFGF
	 ZcAtHCJUOKEHjaBRq3BYiWCmmkw+rDfONDGjC83jMgbQzC6T6GHvsWFQ6vymaVruDi
	 L5fGTo2Ta4KUA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D32vZK23629900
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 11:02:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 11:02:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 11:02:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 11:02:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: kimwooseok <5mghybrid@khu.ac.kr>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Topic: [PATCH RESEND wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Index: AQHdQwNzVbXJAZy0LEOjDiLsjEfukbbL0kmA
Date: Sun, 13 Sep 2026 03:02:57 +0000
Message-ID: <2637a1d25de6431c89c4670b000fb9a9@realtek.com>
References: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
 <CAH1Bc_zqe_a93WcmksWBfmBkW2JGdhuRHcLECpLtznXA_dTWEA@mail.gmail.com>
In-Reply-To: <CAH1Bc_zqe_a93WcmksWBfmBkW2JGdhuRHcLECpLtznXA_dTWEA@mail.gmail.com>
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

a2ltd29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4gd3JvdGU6DQo+ICBkcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L2NvcmUuYyB8IDE2ICsrKysrLS0tLS0tLS0tLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KDQpQbGVh
c2Ugc2VuZCBwYXRjaCBsaWtlIG5vbi1SRVNFTkQgdmVyc2lvbiB3aXRob3V0IHBhdGNoIGF0dGFj
aGVkLg0KDQpQaW5nLUtlDQoNCg==

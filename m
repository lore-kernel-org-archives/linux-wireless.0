Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D51FBC8C;
	Sun, 13 Sep 2026 03:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789268732; cv=none; b=keLY9psxDW9P9K/nad4sV24FgiGPoJqldQ/xgeEhIPUA0jjTuNe4/6lQVPfaLNcmJqe4vohUWqpUVR71GxLMy+eOZnCzHAlKwtIqAcK0jeNBPzvTr+yruPdfCqzFx55YhIXr4vta5tPcIwG1bizLq3dbP5Y4oFy+ZxYgVPHlB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789268732; c=relaxed/simple;
	bh=VxKpDM0WLrcU2FWE5MC+aSck89lGpzVJMvJPx5bAwA8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=myuaQVRT+VHWTx3JF4rYtpx4mLKPrVvwEp5zZuWadG9G0LZJ6H4lHu4xuekxfZOu97Amua1Kj5huwhRILEBcwUk1oPw7fveqzFD6TfJEoOhBQhkSgeI96NcaxCeKydQK6eSrog5yySPD7QjXlO1iw3MUUtWxncTfSgst1f0OrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uVDopKmi; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uVDopKmi"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D35P2603630326, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789268725; bh=VxKpDM0WLrcU2FWE5MC+aSck89lGpzVJMvJPx5bAwA8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=uVDopKmi81ysaH+GKEJWD1ZbpRmK95nWgsgjVG2kiB2VI/kbnxIK6vbMgWiMOrk/M
	 yjiGnulPUmfQZTC8yhudXT1tUSfqZOWcDz9Dk7/TxCqZROl/QObYPAcm2X4gWzyJjv
	 RxurLdPpk6kSYQyAeJTBXJc7CQmCy5jl4mpio5QnhY2ki5FBhZesViZ78iv6jLqpMV
	 9EOsNIUx4A25xv+pYVnJaER4XR9zm+bhzDcyfP2FgXLWOvnOGat5aLpzDRmTim7nOR
	 lFV3w2dRoP3aemLuy0xCuRiHvuJky3c7gTNG2S0bHIEGZcZzDt+SqmiViKphO5ivGi
	 eruW+52pCxjZQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D35P2603630326
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 11:05:25 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 11:05:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 11:05:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 11:05:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: kimwooseok <5mghybrid@khu.ac.kr>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Topic: [PATCH RESEND wireless 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Index: AQHdQwNzVbXJAZy0LEOjDiLsjEfukbbL0kmAgAAAy4A=
Date: Sun, 13 Sep 2026 03:05:25 +0000
Message-ID: <09990db399dc4a76b08b41eb59325c76@realtek.com>
References: <CAH1Bc_yJ1e_nHk9tP2qP_4D8MHEve1R2EF5cYCEXRwc+1xVAxw@mail.gmail.com>
 <CAH1Bc_zqe_a93WcmksWBfmBkW2JGdhuRHcLECpLtznXA_dTWEA@mail.gmail.com>
 <2637a1d25de6431c89c4670b000fb9a9@realtek.com>
In-Reply-To: <2637a1d25de6431c89c4670b000fb9a9@realtek.com>
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

UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KIA0KPiBraW13b29zZW9r
IDw1bWdoeWJyaWRAa2h1LmFjLmtyPiB3cm90ZToNCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydGw4eHh4dS9jb3JlLmMgfCAxNiArKysrKy0tLS0tLS0tLS0tDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gUGxlYXNl
IHNlbmQgcGF0Y2ggbGlrZSBub24tUkVTRU5EIHZlcnNpb24gd2l0aG91dCBwYXRjaCBhdHRhY2hl
ZC4NCj4gDQoNCkZvcmdvdCB0byBzYXkgdGhlIGNvZGViYXNlIHNob3VsZCBiZSBydHctbmV4dCBi
cmFuY2ggb2YNCmh0dHBzOi8vZ2l0aHViLmNvbS9wa3NoaWgvcnR3LmdpdCwgYW5kIHBhdGNoIHRh
ZyBpcyAncnR3LW5leHQnLg0KDQpQaW5nLUtlDQoNCg==

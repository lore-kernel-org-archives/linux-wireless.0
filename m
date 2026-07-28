Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0623D28C
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 00:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199851; cv=none; b=QuSVPeZoaLU0uR38hJ2PJcyQ3ALCTbXogcOwMUqbPh56zZWQ6v005CDhGgiFquZf1ItgZLlSjk3N1kzgfcSB1UnMPb85xQlb4w65oBmRmmXlGHOXQJLTyzxMopx75rklguV7E2QLwEa4lWyeRa38Ojy1YxWo9y8zTN8M6sPJWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199851; c=relaxed/simple;
	bh=8bFWRreqeq1ohRMytgy77ZvMdwOBeUtMXS8KbbBOZ4g=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0oifL6MxwTYORJjr+A73nQ3hEdjqrK3z6SJh4sHnPCktOxYpYGVX/2v6Wo6WFhbEw7eE/qSH0q8g0r/lzFjUhwoa280Axm+cqfPEk/762T3WjXh+R2xZ3EovA06ZhTE3oNLWN7QrufmlDUq7319jfS4oGrCK1RScpHof/9MHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jhMSs7TJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jhMSs7TJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66S0ogShB3482364, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785199843; bh=8bFWRreqeq1ohRMytgy77ZvMdwOBeUtMXS8KbbBOZ4g=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=jhMSs7TJOQF1oiSSS2+vYNkb3etd4L0xFROwkFaOHXQTZYwr8c+QKKyEUQ14uep2F
	 zp5l9XTYyUTTLXJqB5s9HOvtTKhSEpSHFTRRZMqlpNaKPt9rdQgZNyAMz4WT+57ENS
	 1Yy2GNfPNNya/0NpWGn4eZZN9lBatgYm65tMg95Q9ba/8sPSi1z85n+WqQSuv4FTMq
	 gVkC7W6s2G1Bdy13L4V0mW2DRVs/z1nrBaLe6XxveshjwpviXOH1DP8OypIyy0vo0E
	 ekoHQMDcoaAXqj/1uThTYNlMPSFfyTdx+0QRPsa3t7R7FpcW+gaXjyUZSLy7U6Aneb
	 6srztlIdyMorQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66S0ogShB3482364
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 28 Jul 2026 08:50:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 28 Jul 2026 08:50:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 28 Jul 2026 08:50:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Tue, 28 Jul 2026 08:50:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPA
Date: Tue, 28 Jul 2026 00:50:43 +0000
Message-ID: <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
In-Reply-To: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
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

QWRyb2RvYyA8YWRyb2RvYzU1QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gSSB3YXMgYXNrZWQg
YnkgZHViaGF0ZXIgaW4NCj4gaHR0cHM6Ly9naXRodWIuY29tL21vcnJvd25yL3J0dzg5L2lzc3Vl
cy8xMTYgdG8gcmVwb3J0IHRoaXMgdG8NCj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3Jn
LiBIZSBzYWlkIHlvdSB3b3VsZCBrbm93IHdoYXQgdG8gZG8gd2l0aA0KPiBSX0FYX0RNQUNfRVJS
X0lTUj0weDAwMDAwMDQwDQoNCkkgd2lsbCByZXBvcnQgdGhlIHBlcnNwZWN0aXZlIHRvIGludGVy
bmFsIGV4cGVydHMuIA0KDQo+IA0KPiBJIGdldCByYW5kb20gd2lmaSBkaXNjb25uZWN0cyBvbiA3
LjEuNC0xLWNhY2h5b3MgdXNpbmcgcnR3ODksIHRoYXQNCj4gaGVhbCBhZnRlciBhIG1pbnV0ZSBv
ciBzby4gSWYgSSBtYW51YWxseSBkaXNjb25uZWN0IGZyb20gYW5kIHJlY29ubmVjdA0KPiB0byB0
aGUgbmV0d29yayBpdCBoZWFscyBpbW1lZGlhdGVseS4NCg0KRGlkIHlvdSBlbmNvdW50ZXIgdGhp
cyBwcm9ibGVtIGluIG9sZGVyIGtlcm5lbCB2ZXJzaW9uPyANCklmIG9sZGVyIGtlcm5lbCB3b3Jr
cyB3ZWxsLCBjb3VsZCB5b3Ugc2hhcmUgdGhlIHZlcnNpb24gYW5kIGhlbHAgdG8NCmJpc2VjdCB0
aGUgY2F1c2U/DQoNClBpbmctS2UNCg0K

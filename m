Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E3C186A
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 01:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774490114; cv=none; b=FqonlqVcfgrK7jdSG4nfW1BPIYPlixSzhsfNLTXAaxPajeqvRVYxrObNBH0Fbh9jhu9b1J1aPNixqvzBWvuTODPVfg2gAwg3VhUy2PTskqAjhUKvQl+8fjOt3OfxZhQ/bFEjzqh2rgG1mm7GMsnddOdHmYY2AMEkeBtkmJi+RTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774490114; c=relaxed/simple;
	bh=BlZPabnEsEfBzLw7+GNyd1KkLLe6DMPV99NIazHFsEo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MY7zziNqGZsEnF+wBi5eJPIX4eIpunHpLlgREXCTPjCE9EEy0K1ER4Dvxg9rXkX2KlGfgObORRmVU+bOtODiNwMXs2SjHqXEBcfSLqUfEE0vZnJoHyaY/7gOSmDjHxjR2PPNImJP9I/rkpO2CgSRcTV32wwbTeMKUmOcMsjiQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YFUSxL21; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YFUSxL21"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62Q1t9tdD537759, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774490109; bh=BlZPabnEsEfBzLw7+GNyd1KkLLe6DMPV99NIazHFsEo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YFUSxL21N5vCK/h392qHYk0aFeaS6Vx0+rAuEYrmtid0wGVY2VtXCoQBkXMNNTJar
	 AZ2PMukWIZkpXkiRRhARhY9v8opzb2SEAz3asIoFo6YqDn9qE+Y8dxqo3rHeRhB+Zj
	 8bYjWXaRUY3CtiM/Wmei6S6e2P+GZ/dGqS2am6oJ8/EbeojuWjSXD7deSBmMW+A6tA
	 3DEColWn+mcpDwKFv/9bZIv82fERcHfM5nhLcmlmT3gd9gL5Y5wMN88DmJZ8GzuYkk
	 oAlDWGjSjDZ7vQUHN8PQROYOV5/9n1XgA2LpFmQNzpfEG9jWnbfsC5X0mIfcHlk18P
	 LtWQd1jCwf5uA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62Q1t9tdD537759
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 09:55:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 26 Mar 2026 09:55:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::46e9:fab9:b2cf:c99b%10]) with mapi id
 15.02.1748.010; Thu, 26 Mar 2026 09:55:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: Fill fw_version member of struct
 wiphy
Thread-Topic: [PATCH rtw-next] wifi: rtw89: Fill fw_version member of struct
 wiphy
Thread-Index: AQHcvKXL0HQyWdB8wkiRkis6gU0vLrXACODg
Date: Thu, 26 Mar 2026 01:55:08 +0000
Message-ID: <9c25a5eee4194356b4d0210b2bace5f2@realtek.com>
References: <60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b@gmail.com>
In-Reply-To: <60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBMZXQg
dXNlcnNwYWNlIHRvb2xzIGxpa2UgbHNodyBzaG93IHRoZSBmaXJtd2FyZSB2ZXJzaW9uIGJ5IGZp
bGxpbmcgdGhlDQo+IGZ3X3ZlcnNpb24gbWVtYmVyIG9mIHN0cnVjdCB3aXBoeS4NCj4gDQo+IEJl
Zm9yZToNCj4gDQo+IGNvbmZpZ3VyYXRpb246IGJyb2FkY2FzdD15ZXMgZHJpdmVyPXJ0dzg5Xzg4
NTJhdQ0KPiBkcml2ZXJ2ZXJzaW9uPTYuMTkuNi1hcmNoMS0xIGZpcm13YXJlPU4vQSBsaW5rPW5v
IG11bHRpY2FzdD15ZXMNCj4gd2lyZWxlc3M9SUVFRSA4MDIuMTENCj4gDQo+IEFmdGVyOg0KPiAN
Cj4gY29uZmlndXJhdGlvbjogYnJvYWRjYXN0PXllcyBkcml2ZXI9cnR3ODlfODg1MmF1DQo+IGRy
aXZlcnZlcnNpb249Ni4xOS42LWFyY2gxLTEgZmlybXdhcmU9MC4xMy4zNi4yIGxpbms9bm8gbXVs
dGljYXN0PXllcw0KPiB3aXJlbGVzcz1JRUVFIDgwMi4xMQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9mdy5jIHwgOCArKysrKysrKw0KPiAgMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvZncuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnR3ODkvZncuYw0KPiBpbmRleCA0NWQ4YzVlNzAwODQuLjU1YWVlNmViODQ3OCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9mdy5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvZncuYw0KPiBAQCAtNzU1
LDYgKzc1NSwxNCBAQCBzdGF0aWMgaW50IHJ0dzg5X2Z3X3VwZGF0ZV92ZXIoc3RydWN0IHJ0dzg5
X2RldiAqcnR3ZGV2LA0KPiAgICAgICAgICAgICAgICAgICAgZndfc3VpdC0+bWFqb3JfdmVyLCBm
d19zdWl0LT5taW5vcl92ZXIsIGZ3X3N1aXQtPnN1Yl92ZXIsDQo+ICAgICAgICAgICAgICAgICAg
ICBmd19zdWl0LT5zdWJfaWRleCwgZndfc3VpdC0+Y29tbWl0aWQsIGZ3X3N1aXQtPmNtZF92ZXIs
DQo+IHR5cGUpOw0KPiANCj4gKyAgICAgICBpZiAodHlwZSA9PSBSVFc4OV9GV19OT1JNQUwgfHwg
dHlwZSA9PSBSVFc4OV9GV19OT1JNQUxfQ0UgfHwNCj4gKyAgICAgICAgICAgdHlwZSA9PSBSVFc4
OV9GV19OT1JNQUxfQikNCj4gKyAgICAgICAgICAgICAgIHNucHJpbnRmKHJ0d2Rldi0+aHctPndp
cGh5LT5md192ZXJzaW9uLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKHJ0d2Rl
di0+aHctPndpcGh5LT5md192ZXJzaW9uKSwNCg0Kbml0OiBob3cgYWJvdXQgZGVmaW5pbmcgYSBs
b2NhbCB2YXJpYWJsZSB3aXBoeT8gYXMgd2VsbCBhcyBydHc4OC4NCg0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgIiV1LiV1LiV1LiV1IiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgIGZ3
X3N1aXQtPm1ham9yX3ZlciwgZndfc3VpdC0+bWlub3JfdmVyLA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgZndfc3VpdC0+c3ViX3ZlciwgZndfc3VpdC0+c3ViX2lkZXgpOw0KPiArDQo+ICAg
ICAgICAgcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiAtLQ0KPiAyLjUzLjANCg0K

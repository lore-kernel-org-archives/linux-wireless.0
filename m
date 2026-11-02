Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585521;
	b=Xx9RD2ZfNj4tKvokXUbZXKWfZAkAztBmUXyQBaXtr1PveGIN43rlgs4ZZZ98fzxSk6Rb
	 ZaQin2WjVFhwoogRn/ZWTfuEUw1uXHU8Zvi8hPHfPouOoHLmb4CN8uRr7uivLjqm2Ey84
	 M53ohuADXL4njHEHKNQgNXZbOALiFqEZ6cHHMwaa1CjZuUJPuAaR1F21jFG1/zIrYWAj8
	 CdzJ4kQQ8m4bmfuXScHHzQXLc9waU9621ogT0tG7wOyflPgr80PL6eWPffeCpIi8zFAgR
	 mmSa2EUXafrpkfSbj+emEbhroqmTDqDqLbgtWKjpy2ufUQ9FxHA+rsqgbXSsZK/Jxhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585521;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=D5lpmnmFS0c3ABXVbJIspHurJGdg8rCxxheaWJnIqtA=;
	b=C5DAWpgEOqEFuzBPSEMZE6ErofKPjI4yuiUInnF4dzncxR381BpDVYRlr+qBvV7Km1GT
	 4wEbBDCvxDOQ+Jz2KhcMW1YKuin0/NJJRNAFLsYi8T7fYNWWmYucHRYPM49AIrpwyU24L
	 60G52G2t3+ugZrq1gmW63Cj/GVnVmR8yLUZRH6sEWRSxh3oVb4uyi6HxMyvjE5djQJPjr
	 Q5KTSC3AexPbRIwy0gST+1tTQX3tgBZxfcRX+ESoM4rvHqeBLP7YG4uIv6CfIxU+62qzb
	 DTchBTLkIe9rfmdyLueSHWgcYwX1aG9o24FtxXuabNyL6K4yZpf8329edxH3MF/oQ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hHzietzZ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D5606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 02:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 897D5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hHzietzZ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A22BlU321775834, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793585508; bh=D5lpmnmFS0c3ABXVbJIspHurJGdg8rCxxheaWJnIqtA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hHzietzZ0KEc9deWgxSg4EwZu/R9EikCbQ2ZhR5zUwcVL7Xl7gO/u7pTtje9Scicy
	 hEplpr7Tg+mSH2irtufJ7B+XYBWx5olBIqdVjWjSJU8dNH4PhuA5Xs07K54qVOjAwd
	 WHkADVtmlOrviE91uDTgtShVEj5ZAG2oVXtIU3bCBqtHVjqFvWBPNU1pTJg+GO2KCq
	 7hcT6QnoWnR/MjVdpf/TbVuhMp1UuGIG2zzEtXdQp4dp8t+lSnU3E9oI/5UYeVgy3g
	 akbhMNmATbhOi+cJ4a2CqAIq/49i+CTye7gZ7cxdDTiBbcIV85hDaMI+LekYxP6+fL
	 /35528GS0k7pg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A22BlU321775834
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 10:11:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 10:11:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 10:11:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: ph4ntom-rev <owner@ph4ntom-rev.uz>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "kvalo@kernel.org" <kvalo@kernel.org>
Subject: RE: [PATCH RFC net-next 0/2] wifi: rtw89: fix monitor mode RX
 filtering and enable raw packet injection
Thread-Topic: [PATCH RFC net-next 0/2] wifi: rtw89: fix monitor mode RX
 filtering and enable raw packet injection
Thread-Index: AQHdafoJ4NXzIeP2G0CSnWvXi0+7RLcaCKjA
Date: Mon, 2 Nov 2026 02:11:47 +0000
Message-ID: <b41e89b40fc640879b9d71b86311f900@realtek.com>
References: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
In-Reply-To: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

cGg0bnRvbS1yZXYgPG93bmVyQHBoNG50b20tcmV2LnV6PiB3cm90ZToNCj4gSGkgUGluZy1LZSwg
S2FsbGUsIGFuZCBsaW51eC13aXJlbGVzcyBtYWludGFpbmVycywNCj4gDQo+IFRoaXMgUkZDIHBh
dGNoc2V0IGFkZHJlc3NlcyBsb25nLXN0YW5kaW5nIGxpbWl0YXRpb25zIGluIHJ0dzg5IHJlZ2Fy
ZGluZw0KPiBJRUVFIDgwMi4xMSBtb25pdG9yIGludGVyZmFjZXMgKE5MODAyMTFfSUZUWVBFX01P
TklUT1IpIGFuZCByYXcgZnJhbWUNCj4gdHJhbnNtaXNzaW9uIC8gZGlhZ25vc3RpYyBpbmplY3Rp
b24gKElFRUU4MDIxMV9UWF9DVExfSU5KRUNURUQpIG9uIFJlYWx0ZWsNCj4gODAyLjExYXggUENJ
ZSBoYXJkd2FyZSAoc3BlY2lmaWNhbGx5IHZlcmlmaWVkIG9uIFJUTDg4NTJBRSBbMTBlYzo4ODUy
XSkuDQoNCkkgY2FuIG9ubHkgc2VlIHRoaXMgY292ZXIgbGV0dGVyLiBEaWQgSSBtaXNzIHNvbWV0
aGluZz8NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMWExOTZkNmRm
YmMuMzU1MzdkMjIxOTEzMTA0NDUwLjM3MjAwNjA0NTU4MzE5MzM3ODlAem9oby5jb20vDQoNCj4g
DQo+IFdoaWxlIHJ0dzg5IGluY2x1ZGVzIHNjYWZmb2xkaW5nIGZvciBtb25pdG9yIG1vZGUgKHB1
cmVfbW9uaXRvcl9tb2RlX3ZpZg0KPiBhbmQgcnR3ODlfY29yZV90eF91cGRhdGVfaW5qZWN0aW9u
KSwgc3RhbmRhbG9uZSBtb25pdG9yIG9wZXJhdGlvbiBoaXRzDQo+IGZvdXIgZGlzdGluY3QgaG9z
dC1kcml2ZXIgb2JzdGFjbGVzIHJhdGhlciB0aGFuIGEgZmlybXdhcmUgbGltaXRhdGlvbjoNCj4g
DQo+IDEuIE1BQyBQcm9taXNjdW91cyBSWCBEcm9wczoNCj4gICAgQmFuZCAwIE1BQyByZWdpc3Rl
cnMgKFJfQVhfUlhfRkxUUl9PUFQgMHhDRTIwLCBSX0FYX0NUUkxfRkxUUiAweENFMjQsDQo+ICAg
IGFuZCBSX0FYX0RBVEFfRkxUUiAweENFMkMpIGRlZmF1bHQgdG8gZmlsdGVyaW5nIG91dCBDb250
cm9sIGZyYW1lcyAoQUNLLA0KPiAgICBSVFMsIENUUywgQmxvY2tBY2spIGFuZCBub24tbWF0Y2hp
bmcgQlNTSUQgRGF0YSBiZWZvcmUgcmVhY2hpbmcgaG9zdA0KPiAgICBETUEgcmluZ3MuIFNldHRp
bmcgcHJvbWlzY3VvdXMgbWFzayAweDU1NTU1NTU1IGFuZCBzeW5jaW5nIENSQzMyIGRyb3BzDQo+
ICAgIHdpdGggRklGX0ZDU0ZBSUwgdW5sb2NrcyBhbGwgMTYgSUVFRSA4MDIuMTEgQ29udHJvbCBh
bmQgTWFuYWdlbWVudA0KPiAgICBzdWJ0eXBlcyBhY3Jvc3MgY2hhbm5lbCBzd2l0Y2hlcy4NCg0K
VGhlIGNvbW1pdCBhMzcxMTM5ZDhiZTkgKCJ3aWZpOiBydHc4OTogU05JRkZFUl9NT0RFIGJpdCBh
bG9uZyBJRUVFODAyMTFfQ09ORl9NT05JVE9SIikNCmFkZGVkIGEgbWlzc2luZyBiaXQgQl9BWF9T
TklGRkVSX01PREUsIHdoaWNoIEkgc3VwcG9zZSBpdCBjYW4gY2FwdHVyZQ0KcGFja2V0cyBwcm9t
aXNjdW91c2x5LiBDYW4geW91IHRyeSBpdD8NCg0KPiANCj4gMi4gTlVMTCB2aWYgRGVyZWZlcmVu
Y2Ugb24gTW9uaXRvciBUWDoNCj4gICAgSW4gcnR3ODlfb3BzX3R4KCkgYW5kIHJ0dzg5X2NvcmVf
dHhfd3JpdGUoKSwgdmlmX3RvX3J0d3ZpZih2aWYpIGlzDQo+ICAgIGV2YWx1YXRlZCB1bmNvbmRp
dGlvbmFsbHkgaW4gbG9jYWwgZGVjbGFyYXRpb25zIGJlZm9yZSBjaGVja2luZyB3aGV0aGVyDQo+
ICAgIGluZm8tPmNvbnRyb2wudmlmIGlzIE5VTEwuIEluamVjdGVkIFJhZGlvdGFwIGZyYW1lcyBm
cm9tIG1hYzgwMjExIHBhc3MNCj4gICAgYSBOVUxMIGNvbnRyb2wudmlmLCB0cmlnZ2VyaW5nIGFu
IGltbWVkaWF0ZSBrZXJuZWwgb29wcy4NCg0KUGxlYXNlIGFkZCBhIGd1YXJkLiBCdXQgSSBoYXZl
IG5ldmVyIGVuY291bnRlcmVkIHRoZSBvb3BzLiBDb3VsZCB5b3UNCnNoYXJlIHRoZSBzdGVwcz8N
Cg0KPiANCj4gMy4gSW5qZWN0aW9uIERlc2NyaXB0b3IgUmF0ZSBIYW5kbGluZzoNCj4gICAgV2hl
biBSYWRpb3RhcCBoZWFkZXJzIG9taXQgYW4gZXhwbGljaXQgYml0cmF0ZSwgbWFjODAyMTEgc2V0
cw0KPiAgICByYXRlc1swXS5pZHggPSAtMS4gSW4gcnR3ODlfY29yZV90eF91cGRhdGVfaW5qZWN0
aW9uKCksIGNhc3RpbmcgdGhpcyB0bw0KPiAgICB1OCB5aWVsZHMgYW4gaW52YWxpZCByYXRlIGlu
ZGV4IDI1NSBhbmQgbGVhdmVzIGRlc2NfaW5mby0+ZW5fd2RfaW5mbw0KPiAgICB1bnNldCBmb3Ig
bm9uLW1hbmFnZW1lbnQgZnJhbWVzLiBXZSBtYXAgbmVnYXRpdmUgaW5kaWNlcyB0byBhIHZhbGlk
DQo+ICAgIE9GRE0gNi4wIE1icHMgZmFsbGJhY2sgKFJUVzg5X0hXX1JBVEVfT0ZETTYpLCBlbmFi
bGUgaGFyZHdhcmUgcmF0ZQ0KPiAgICBvdmVycmlkZSAodXNlX3JhdGUsIGRpc19kYXRhX2ZiKSwg
YW5kIGJvdW5kIHJldHJpZXMgKHR4X2NudF9sbXQgPSAxKQ0KPiAgICB3aGVuIElFRUU4MDIxMV9U
WF9DVExfTk9fQUNLIGlzIHNldC4NCg0KT0suDQoNCj4gDQo+IDQuIEZpcm13YXJlIFNjaGVkdWxl
ciBNQUNJRCBTdGFsbGluZzoNCj4gICAgV2hlbiBtYWM4MDIxMSBhbGxvY2F0ZXMgYSBzdGFuZGFs
b25lIG1vbml0b3IgVklGLCBhIG1hY19pZCBpcyBhc3NpZ25lZCwNCj4gICAgYnV0IGRlZmF1bHQg
Q01BQy9ETUFDIHRhYmxlcyBhcmUgbmV2ZXIgcG9wdWxhdGVkIGFuZCBubyBIMkMgam9pbiBpcw0K
PiAgICBpc3N1ZWQsIGxlYXZpbmcgdGhlIE1BQ0lEIGNvbnRleHQgcGF1c2VkIGluIHRoZSBmaXJt
d2FyZSBzY2hlZHVsZXIuDQo+ICAgIEF0dGVtcHRpbmcgdG8gam9pbiBhcyBSVFc4OV9TRUxGX1JP
TEVfQ0xJRU5UIHRyaWdnZXJzIGZpcm13YXJlIDUtc2Vjb25kDQo+ICAgIGJlYWNvbi1sb3NzIHRp
bWVvdXRzLiBIb3dldmVyLCByZWdpc3RlcmluZyBhIG5vbi1hc3NvY2lhdGVkIEFQIGNvbnRleHQN
Cj4gICAgKFJUVzg5X1NFTEZfUk9MRV9BUCB3aXRoIFJUVzg5X05FVF9UWVBFX05PX0xJTkspIGlu
aXRpYWxpemVzIHRoZSBNQUNJRA0KPiAgICBxdWV1ZXMgd2l0aG91dCBnZW5lcmF0aW5nIEFQIGJl
YWNvbnMgb3IgdHJhY2tpbmcgY2xpZW50IGJlYWNvbnMuIENsZWFyaW5nDQo+ICAgIFJfQVhfTUFD
SURfU0xFRVBfMCAoMHhDMkMwKSBhbmQgc2VuZGluZyBydHc4OV9md19oMmNfbWFjaWRfcGF1c2Uo
Li4uLCBmYWxzZSkNCj4gICAgY2xlYW5seSB1bnBhdXNlcyBoYXJkd2FyZSB0cmFuc21pdCBxdWV1
ZXMuDQoNCkknZCBjaGVjayB0aGlzIGluIGRldGFpbCB3aXRoIFJGQyBwYXRjaC4gDQoNCg0K

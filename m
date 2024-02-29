Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D7168B8
	for <linux-wireless@vger.kernel.org>; Thu, 29 Feb 2024 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709169840; cv=none; b=W8DfwGUfSzSZlQxMaO7V3fZY/ngnRsBCrBrR89Z46J0qpx66SrEo0jMUawbDDjf5VX9WQE/o3RNA32GGQFid7hMYsagrIB+b7b6z93+vDXrtCRP85B7WswIYvqRXC+wDEDZPs9nFYKUG1mNsRFJzVuJqYEl1n5Knh1+VarrGDB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709169840; c=relaxed/simple;
	bh=Q8Yjta4BIHRMTkQsg9JMQSCNMx+3ygKqGyrqjF21FNg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JFYUtZvJo2TRzSBwTyzvzarR3u6SyuIY76pNAp70wtOAdxvA+/l37HbSfu8wkDk/ileHBhq40KphlLtNdumvY+SG9jbWF/go8FObAAWwDNCVerTg+ce44jUcpj6izV7lLuYsXHox2lbqhAUtZ1FCHEgfc30xULX/1zOISIp6ft8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 41T1NrJvA984666, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
	by rtits2.realtek.com.tw (8.15.2/2.95/5.92) with ESMTPS id 41T1NrJvA984666
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 09:23:53 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.32; Thu, 29 Feb 2024 09:23:53 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 09:23:52 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::c9b7:82a9:7e98:fa7f]) by
 RTEXMBS04.realtek.com.tw ([fe80::c9b7:82a9:7e98:fa7f%7]) with mapi id
 15.01.2507.035; Thu, 29 Feb 2024 09:23:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: Remove rtl_intf_ops.read_efuse_byte
Thread-Topic: [PATCH] wifi: rtlwifi: Remove rtl_intf_ops.read_efuse_byte
Thread-Index: AQHaaXa5N0JBYvp5CkqasxGEXgS7uLEgiOjQ
Date: Thu, 29 Feb 2024 01:23:52 +0000
Message-ID: <ca36cbefdd114082abf629513db04880@realtek.com>
References: <4e2c968d-f25c-4a40-be97-4fdcbdde69cf@gmail.com>
In-Reply-To: <4e2c968d-f25c-4a40-be97-4fdcbdde69cf@gmail.com>
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
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQml0dGVyYmx1ZSBTbWl0
aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEZlYnJ1YXJ5IDI3
LCAyMDI0IDg6MTYgUE0NCj4gVG86IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBD
YzogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSF0g
d2lmaTogcnRsd2lmaTogUmVtb3ZlIHJ0bF9pbnRmX29wcy5yZWFkX2VmdXNlX2J5dGUNCj4gDQo+
IFBDSSBkcml2ZXJzIGFuZCBVU0IgZHJpdmVycyBjYW4gYm90aCB1c2UgdGhlIHNhbWUgZnVuY3Rp
b24sDQo+IHJlYWRfZWZ1c2VfYnl0ZSgpLCBhbmQgdGhleSBjYW4gY2FsbCBpdCBkaXJlY3RseS4N
Cj4gDQo+IHJ0bDgxOTJkZSB3YXMgdGhlIG9ubHkgdXNlci4NCj4gDQo+IFRlc3RlZCBvbmx5IHdp
dGggdGhlIHVwY29taW5nIHJ0bDgxOTJkdSBkcml2ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBC
aXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBp
bmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==

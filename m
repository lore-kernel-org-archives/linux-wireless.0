Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5DA3939C1
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 03:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774841947; cv=none; b=Bs+WAB8QzoRAK8gvNqJFD7k4T4KAMIYndoZ4XWBppApHVVfeeY5WFO+ZN5vCgt08PkPxpoLJodixOKQJqBS31jS4H1moMGTlQPSrIsRCPIqq3Ar60uVaDnVFKe15bdIZNln7Zubh0F8A6LwDOcRsBnr05VVMiwD5qhFRQAzBKPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774841947; c=relaxed/simple;
	bh=0RQL2orcsVgQk5DAQ97NoeEFPSv3tv6yeapCwl9RkVA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JbLWZ+k9kGuuoXI8KVM99GGfRj2JE2a6eXIf7PngT0hcva5WeR3teVszSwrNAqNx5Hm1To4pLnD81lgxkIFhMt0r71sThh2ARqBgFFSQtPBiCAA/vi2q6RW2uO51/05vhD2pOgS9p/wmgQLy0I57fIZa6SMFytF6b1EXOuwHWDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=A9ROI2tB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="A9ROI2tB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U3d0Iz9263515, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774841940; bh=0RQL2orcsVgQk5DAQ97NoeEFPSv3tv6yeapCwl9RkVA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=A9ROI2tBmp/J6S+a3QH12rhNjChIiRearWy3e+rYKSBsHye57498g/ZTpLqHiQSc7
	 IUz6krk3CaW0H6Pp5XduAF8EO4Mp645vu+50lBJnMyRIj5bJ+V3Gaig8BH8+yjROm3
	 87i3UhcgEdZYb6mKcuaPTWfyNY2dBlx+4qj9GU8GC2O5Ty9s/MMhdsQCqagWqy1q+6
	 +WZwpntMtsjMXhhgeyK2aptNEJhp0I+PmEPK7+RqmcrZIEdhyNuGKWE1NSNZnSxRB1
	 g1BKrvU7IIfjdePNitd3Q3DURLtFzWyxDMEouT5plqR7Iewf2WLuwUTXFsc89I0pyP
	 3Zg8HzcRu/bSg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U3d0Iz9263515
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 11:39:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 11:39:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::46e9:fab9:b2cf:c99b%10]) with mapi id
 15.02.1748.010; Mon, 30 Mar 2026 11:39:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 04/12] wifi: rtw89: Fix
 rtw89_usb_ops_mac_pre_init() for RTL8922AU
Thread-Topic: [PATCH rtw-next 04/12] wifi: rtw89: Fix
 rtw89_usb_ops_mac_pre_init() for RTL8922AU
Thread-Index: AQHcvUK77ehs7iOpWUmb2s/L9i7acLXGct7g
Date: Mon, 30 Mar 2026 03:39:00 +0000
Message-ID: <852df64b42ae4fe5998847829afdf3da@realtek.com>
References: <8549233f-dd83-4e77-be88-5e22ecd4f5f1@gmail.com>
 <e93c0b0d-7d27-4adc-813b-d490fd1b3edb@gmail.com>
In-Reply-To: <e93c0b0d-7d27-4adc-813b-d490fd1b3edb@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBSZXR1
cm4gZWFybHkgYmVjYXVzZSBSVEw4OTIyQVUgZG9lc24ndCBuZWVkIHRvIGRvIGFueXRoaW5nIGhl
cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUy
QGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29t
Pg0KDQoNCg0K

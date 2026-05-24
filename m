Received: from sender4-of-o50.zoho.com (sender4-of-o50.zoho.com [136.143.188.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD163019DC
	for <linux-wireless@vger.kernel.org>; Sun, 24 May 2026 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779629916; cv=pass; b=HYxmilNYMaW1UubHqTogsDlkhYHR0bvzlwnFfdpbV72y/CahZZyx0XeXjMdwqbIHm+seG/+otPwl/PdnODwvlreRAp59r2iTimwff4rScdgdLSsK5hTcqHy6HfVLGWbNtuQy7duExMME1M1ZGmkElI/rZFxIIYB5Syrvlppc4Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779629916; c=relaxed/simple;
	bh=LTBitT9wtOKAKpx5UQkIyUlEBQovd/BnTQ6s+czd5J0=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=O/0T4IESeAZ8VLSAmYGJQbMmynSHAmByg1rI8IVmnPjVTHwibc8grpvF1mNsxoTzmbdSoC4Uvv9Zh+rui3vj5ghhP7p7ZNsbfQQJD6N9i9skrWuC8CgVt0WY50i+SZB1BDLG5jC6UG1Bmry4brzmtgX2UBHv9pNEHL84YGAVVRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gservera.com; spf=pass smtp.mailfrom=gservera.com; dkim=pass (1024-bit key) header.d=gservera.com header.i=guillem@gservera.com header.b=KIpLpx3T; arc=pass smtp.client-ip=136.143.188.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gservera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gservera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gservera.com header.i=guillem@gservera.com header.b="KIpLpx3T"
ARC-Seal: i=1; a=rsa-sha256; t=1779629912; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Lfd/xgt6b/mT2SpbwDCI7VaDDQxXIqErI0JGGLXRnFi4eArPmNIkxr/fOd9Uo3+CPom9bD/wCv0f9BvyIoogOKfXHaoOn6go+pmnksjWpS7/yYI4UUUmYO9O24k65i5QPdfN7ozG6CpFq2TZkkiGTJO2gJGNFkcdycrubkWX/Qw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779629912; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=LTBitT9wtOKAKpx5UQkIyUlEBQovd/BnTQ6s+czd5J0=; 
	b=mKxpNTiXriqF2SVEkGilljk0TXRpuKY2wHUYB7qxkueTe8UPo+Ad0lpUHsqIqIuqmVoDN842Ia3G/L4Y4dJuxWRmosxf2WNvCYNxypD2L61aeiJvmT0lRF6qqyyB7Sc/B4ruN4Y7cAalkYZfprW6tYY6aTiWZNUHR+6EUaZ+IwE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=gservera.com;
	spf=pass  smtp.mailfrom=guillem@gservera.com;
	dmarc=pass header.from=<guillem@gservera.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779629912;
	s=mailguard; d=gservera.com; i=guillem@gservera.com;
	h=From:From:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Subject:Message-Id:Message-Id:Date:Date:To:To:Reply-To:Cc;
	bh=LTBitT9wtOKAKpx5UQkIyUlEBQovd/BnTQ6s+czd5J0=;
	b=KIpLpx3T7Ztnc6qqF6fH/o/h+0ivITHSWZCoXYK2OZu48MgcQk4WXDJHVofz5KEu
	p1K3DFJ26WtftUOZzyG3iFmR95TutJZWB0crLWNpgAZNM8Wt0IAb+0QCkEwbkRwJFnU
	enxjtUfjq9Nya8H8E1YzxyvJDbfra+ireyEpy3Xw=
Received: by mx.zohomail.com with SMTPS id 1779629910066539.0439107290106;
	Sun, 24 May 2026 06:38:30 -0700 (PDT)
From: Guillermo Servera Negre <guillem@gservera.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)
Message-Id: <418D5F85-B110-4CD2-B733-FEA8D4901EBB@gservera.com>
Date: Sun, 24 May 2026 15:38:17 +0200
To: linux-wireless@vger.kernel.org
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-ZohoMailClient: External

Hi,

The Mercusys MA60XNB (AX900 Nano USB WiFi 6 adapter) works with the =
rtw89_8851bu driver but its USB ID (2c4e:0128) is not in the device =
table. Windows identifies the chipset as RTL8851BU.

 Adding the following entry to rtw_8851bu_id_table in rtw8851bu.c makes =
the adapter fully functional:

 { USB_DEVICE_AND_INTERFACE_INFO(0x2C4E, 0x0128, 0xff, 0xff, 0xff), =
.driver_info =3D (kernel_ulong_t)&rtw89_8851bu_info },

Tested on Fedora 44 with kernel 7.0.8-200.fc44.x86_64 and linux-firmware =
20260410-1.fc44.

USB device details:
idVendor 0x2c4e Mercucys INC
idProduct 0x0128
iProduct 2 802.11ax WLAN Adapter
iManufacturer 1 Realtek
bcdUSB 2.00
bNumInterfaces 3


Thanks,
Guillem=

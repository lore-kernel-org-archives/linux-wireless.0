Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58013EC81D;
	Wed,  7 Oct 2026 08:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361072; cv=none; b=Xq8dQtuc+SyQiBPTWx7Kl6HFEqg4L0jC9OxrerOI2tvHoTD2/08wHJrwga1KKtOA4DXBZzuXy2WHujIBKAUzZ1IvH3X5lRexukiFRlF94qOhURPvUQahhrEKLtV3g9q5nZ/hy54sDZjvLZvyNC9cuS85FB5tzwdPqnnMDA0/CXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361072; c=relaxed/simple;
	bh=guNkVnH/A1z2dX1P+JZFWZ1BRvUMX+SZpvKtpQfmXqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fhhBWJstrBoESl8OW7kLVLtOD8vgWNFnSHdyO1VIoddEXxtj8ZYaLVqQfplZAtLV+dNpVqN53sWRbaWXZrQM25neHvKaQSQJ6QRfSNbujlkHqVKH1HGHDOvxDHQ+q14fp+tdjBOBuvRKWfL7hfJEyHzfXl4te0TcYiZTX8v0Tic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=O9iQ4ygx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="O9iQ4ygx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6978HTgfC3668123, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791361051; bh=YwfVYxvMHGjXQC4CAP2uAl0or44eFtlRoEKxP/vp6Mg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=O9iQ4ygxpBrpBUmDsVJZ3VXeqN1AbwZb2Qq7IhzcGUdv/1HvjTjpHZTHHgAghMFM8
	 e95E/q4ZAicicCsx5hD7YhXMng5g/dIiZlo7na0XatVLZdUeW7OV5htbw/aTVfQ9qw
	 KK6vMJ//A8wmOsau0WbESsTLbz0zGTM1RN3ZkQ14X34cl/jEtHJVHDRRpmlQp9GsgW
	 7gYV3VoOcNQlaYgdctVTaD6fjZrRUji0pR/M09/pJFOMQzDXX9Vn8J8ZJw5zpquKuO
	 Sb79kG3uE19R/9aFjQLZihDKcpSLlQNBXNy+Q/u+FpjHiAtMyfhTzvYK7J5G+g/AZw
	 WKV9aJTturKNw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6978HTgfC3668123
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 16:17:31 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:17:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:17:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 16:17:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: "luka.gejak@linux.dev" <luka.gejak@linux.dev>, "rtl8821cerfe2@gmail.com"
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v4 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v4 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdViKsq55Ir0Z0UEaMXTAuIl77ILbxm64g//+YSwCAAIdD4A==
Date: Wed, 7 Oct 2026 08:17:25 +0000
Message-ID: <ea472899e65e4140990b15603e23d0ee@realtek.com>
References: <63ac6992e6614de1a085131964974ff1@realtek.com>
 <20261007080930.2473263-1-mehmet.fide@gmail.com>
In-Reply-To: <20261007080930.2473263-1-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> On 2026-10-07 Ping-Ke Shih wrote:
> > > -                       rtw_fw_download_rsvd_page(rtwdev);
> > > -                       rtw_send_rsvd_page_h2c(rtwdev);
> > > +                       if (!rtw_fw_csa_active(rtwdev)) {
> >
> > Does it actually happen to AP mode?
> >
> > If it could happen, check the condition by conf->csa_active (like below=
)?
>=20
> Not for the AP interface: mac80211 raises BSS_CHANGED_ASSOC for a
> station interface only. The hunk is for the STA+AP combination the
> driver registers for the 8822C, and it does happen there: with an AP
> on an RTL8822CU counting down from channel 6 to 11, a station interface
> on the same device that had a fresh scan result associated with an AP
> on channel 11 while the countdown ran, so BSS_CHANGED_ASSOC arrived in
> the middle of it. That download would rebuild the reserved page with a
> fresh beacon. conf belongs to the station there, so conf->csa_active
> would say nothing about the AP; that is why the check is on
> rtwdev->csa_vif.

Got it. Add a comment to point out "STA+AP combination" then.

And, agree with your other reply.=20

Ping-Ke


Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3736040DFC4
	for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2026 05:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776663132; cv=none; b=PkTEqdV3qR38RbKDfWVFhC7QTJi74/FUCRTuH7enMebb1AUz2kMKogKLkMSUpDJ++ax9oqHF37UNKs+xhuBxFtmfC17C0ytF0LP3YiafTSk/otq1qwjSvAbJfNiJ+T0NcMqMZpZGEW1A3YB1aP4uehnZ1fboQSNNOql2ED1fsfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776663132; c=relaxed/simple;
	bh=vE9d1vspqjDuP0ABRo6RyAH8FVTLMMLod3PDy1acVc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kdcRo3itcufz888PPqN6Bt1GFikKxD+9oxq8xkiJixOO34ElJTu0L44d2k6vIVRXKNNziViPvcI8GbR3gv83hL5HRcVTpb4/Cr3HhG/XQYnnFHDeViS8j0UFDclErqH3sQGCLFgUoIqhpcTdgOnkHFXc9TV39sdOFdws8EYLO9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Vzkl07iV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Vzkl07iV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63K5W2K10589837, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776663122; bh=M3zRbiUEpnHgLfhXlVYBMKylHr52Jgoxmuh0QSerRqs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Vzkl07iVn/fBwOdait0t//+HmvaYbFTBCErVd9BrqOVZwFWPEaKTEL32b7zRFNGGv
	 tlgu3VBfj17Ck04IEnJgtHcuC0XTFD2PwWtJgIiiADmCWbs/rmVrzeCkY6n4BDJRSb
	 hLrjBAQdOF5INojk9W8xVUmVkmELNv4VGC/IwBYWAGHcwlRglILhJnI2uErKu4t+h7
	 0uDLmhwCre52iLD51lOxoRoYeyJi9BlJI2QDvRjs64fNXvOZ9m7uR986yemLvzg5bj
	 QO27vDmTfTIkTuarEyXx937XeUQF/fGK7TrrjlNChHQj9rKlwfH+sYpKMHWEXihffO
	 OSe++1F60yW/g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63K5W2K10589837
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 13:32:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 13:32:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Mon, 20 Apr 2026 13:32:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Tristan Madani <tristmd@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw89: add bounds check on firmware mac_id in
 link lookup
Thread-Topic: [PATCH v2] wifi: rtw89: add bounds check on firmware mac_id in
 link lookup
Thread-Index: AQHczSamfHmuypaigkWDd7GVrTdpGLXnc3uQ
Date: Mon, 20 Apr 2026 05:32:01 +0000
Message-ID: <28b787a929674c249edec3e2bdbf6872@realtek.com>
References: <20260415222433.1545305-1-tristmd@gmail.com>
In-Reply-To: <20260415222433.1545305-1-tristmd@gmail.com>
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

Tristan Madani <tristmd@gmail.com> wrote:
> drivers/net/wireless/realtek/rtw89/core.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wire=
less/realtek/rtw89/core.h
> index XXXXXXX..XXXXXXX 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.h
> +++ b/drivers/net/wireless/realtek/rtw89/core.h
> @@ -6435,6 +6435,9 @@ static inline struct rtw89_sta_link *
>  rtw89_assoc_link_rcu_dereference(struct rtw89_dev *rtwdev, u8 macid)
>  {
> +       if (macid >=3D RTW89_MAX_MAC_ID_NUM)

Since this is used by data path, I prefer 'unlikely(macid >=3D RTW89_MAX_MA=
C_ID_NUM'.

> +               return NULL;
> +
>         return rcu_dereference(rtwdev->assoc_link_on_macid[macid]);
>  }


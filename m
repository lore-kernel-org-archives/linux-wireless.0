Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DEC367F2F;
	Wed,  6 May 2026 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778057112; cv=none; b=JFnbZlA3hGLuQUTkveEXIEu8bQzVqIU3rlKBPSnW0YTh0nIQXZbK09AUfz4eos8ozdCdLCSQZQzG+ttTpcTyXl4WMd9fADYlB2RH0Qiww6FTHQJlzs3hYB08MMDUdfy9SoOO+uyWVXT4WTBnCnJ/tCL8kF5lZQ72DvKfgvedVnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778057112; c=relaxed/simple;
	bh=eASrWcqj03oxK89tGuJ2wp0iaZMi93/C6vMxj4REWFk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MaBRl8EYNvOdPKRdZ5/1L3A0gp7lg4RrXRvmW1uyRi1OYsAAnIn9c9YsYPZAYEJXPu9CprbFNkqDNpCypIrb9Ae+PfFIS00XXLqtdyHLtV3Dt5OzA+RWnlrRtNKnm1nHS5zEJY1K6RRCQVeRfGGIhPshVwVmoiXqQIDXga4yF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pS407icZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pS407icZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6468itImB1882924, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778057095; bh=pY/DylG4gBtMA6Pji5x2DGvlSOfGUkNNFDpLRdtnLOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=pS407icZx2wMV8uMr9UEXMGy3Fdreyzvy4baQlaARsOt7JblKB0G3be6TH75ip7c8
	 QsJEbsnjPEOMf1sMdN2wOBE18ejnoTygGG2IoWKkypK1xu1sew1GvTjLYLQkMoVV1S
	 6MfLqAygUpJ20vtk+md9eomNp6gILkYanTtvIz23p9snbudK/ADBmL3vkGMOows7OW
	 ubjZydmLOT3OzMTe5WghdAxYAGIUPh+ytv/U7Pc/fTjUkiAx2TEU5SK0I397KJqATE
	 dwYN/vxQwweyTZsCwXN70HLaOcx/6CIHaIImdiDLgpUGZWTqHILFxJRjWUvIH1Vzif
	 qkEeQN8QK8vZQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 6468itImB1882924
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 May 2026 16:44:55 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 6 May 2026 16:44:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 6 May 2026 16:44:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 6 May 2026 16:44:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Martin Kaiser <martin@kaiser.cx>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: remove rtw_txq_dequeue
Thread-Topic: [PATCH] wifi: rtw88: remove rtw_txq_dequeue
Thread-Index: AQHc2jYFTSuhzo0cskymiGQNTEdhpbYAtIAg
Date: Wed, 6 May 2026 08:44:55 +0000
Message-ID: <8b2e123e70db41a0b6e0e06159a879d1@realtek.com>
References: <20260502131641.141136-1-martin@kaiser.cx>
In-Reply-To: <20260502131641.141136-1-martin@kaiser.cx>
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

Martin Kaiser <martin@kaiser.cx> wrote:
> Remove the rtw_txq_dequeue helper. It's a wrapper around
> ieee80211_tx_dequeue with just one caller.
>=20
> Call ieee80211_tx_dequeue directly in rtw_txq_push. There's no need to
> fetch txq for every frame, we can do this once outside of the rcu lock.
>=20
> Make the loop variable i unsigned long, it should have the same type as
> frames.
>=20
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/net/wireless/realtek/rtw88/tx.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wirele=
ss/realtek/rtw88/tx.c
> index 3106edb84fb4..ea2dc9bda1b6 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.c
> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
> @@ -619,31 +619,19 @@ static int rtw_txq_push_skb(struct rtw_dev *rtwdev,
>         return 0;
>  }
>=20
> -static struct sk_buff *rtw_txq_dequeue(struct rtw_dev *rtwdev,
> -                                      struct rtw_txq *rtwtxq)
> -{
> -       struct ieee80211_txq *txq =3D rtwtxq_to_txq(rtwtxq);
> -       struct sk_buff *skb;
> -
> -       skb =3D ieee80211_tx_dequeue(rtwdev->hw, txq);
> -       if (!skb)
> -               return NULL;
> -
> -       return skb;
> -}
> -
>  static void rtw_txq_push(struct rtw_dev *rtwdev,
>                          struct rtw_txq *rtwtxq,
>                          unsigned long frames)
>  {
> +       struct ieee80211_txq *txq =3D rtwtxq_to_txq(rtwtxq);
>         struct sk_buff *skb;
>         int ret;
> -       int i;
> +       unsigned long i;

In reverse X'mas order.

>=20
>         rcu_read_lock();
>=20
>         for (i =3D 0; i < frames; i++) {
> -               skb =3D rtw_txq_dequeue(rtwdev, rtwtxq);
> +               skb =3D ieee80211_tx_dequeue(rtwdev->hw, txq);
>                 if (!skb)
>                         break;
>=20
> --
> 2.43.7
>=20


Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195FD3E1692;
	Mon, 27 Jul 2026 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140524; cv=none; b=JoQqdXvjv4K09wq0UXzk0S8pLhwaUvKFv/fH5czxOxnADB82bT9tFGSvq+HPSrtRzOKoMpiEP+RHLqWLEIu+qnJ+2uB4GUT+FCVs2DEYneG/3ALgZMSGKR/r/D09iwYsOjUMDToYHI2x0RrJYRQOKP+fr9tLvO9e0i5owglcwzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140524; c=relaxed/simple;
	bh=2gmDLk+egwE6biYc+KZnuK7vLcsd+rwZ7uem/Y/+NEk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hpsx+qKEvEpWKfltBkfXEMs6WU3EJYRFSP/jH9iZ2F7aT9ysN5XIdrMFJ8A71sMXPOsg7fTWRXqzbvUrF9oq34jCCjHyisKtby96637rv5hIk8SWv4vfttyEW3ZSuuZbKptkf6eOa44aNcUGiL3Dh61Vej9B/u9d12/1BUjQmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MQ2NDdqg; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MQ2NDdqg"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R8LnQsA2948135, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785140510; bh=ey1h0k0qAchZxb0kb/Cet4p5beAZVZvkZCXpBESqoKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MQ2NDdqgyUrRrihoCwgoqh5Sg9u3hyfy/a2BgZcanSAhTQcVjYmHRPSaB8fox7PS5
	 okuYv/fgsevjGKozLoKwosdqwWK11XL31q2AaSdJK/8js3iWqi0WWHpLMtMelIpPGn
	 HIEjVfveTZaUUu5SotaAjLLEXX14TCCucAg+MOi3NzgldLC5XdPjTRY1z/9t9jNM6n
	 QnzaSCcv+Zi6UjWhwheOKwVYa9RVdjPEGIKsPtBbMCJ0rhY/JbJyP1DnslYwIvbSRE
	 9zxlsDkSeWOgahdJB8wLuWnJvHwkreS6JAeb7AAeeRu8xONWSF4Oj5781ab5HF8pYv
	 aykowEGeIoDvw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R8LnQsA2948135
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:21:50 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:21:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:21:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 16:21:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 06/11] wifi: rtw88: coex: reassert the antenna path
 when associating
Thread-Topic: [PATCH v2 06/11] wifi: rtw88: coex: reassert the antenna path
 when associating
Thread-Index: AQHdHEb6torHPjXX3kG1aOOR7i4g9raBCTbA
Date: Mon, 27 Jul 2026 08:21:48 +0000
Message-ID: <67bd17b405084af29d4d07e855ec5b60@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-7-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-7-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:

[...]

> +/* Replayed immediately before start_clnt_join()/auth: BT_INFO + PS-TDMA=
 type 8
> + * then the forced WiFi PTA antenna path, so the auth window is clean.
> + */

Comment style.=20

> +void rtw_coex_8723bs_pre_auth_h2c(struct rtw_dev *rtwdev)
> +{
> +       lockdep_assert_held(&rtwdev->mutex);
> +
> +       if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +               return;
> +
> +       rtw_fw_query_bt_info(rtwdev);
> +       rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +       rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +       rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +       rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
> +       rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
> +}
> +
>  static const char *rtw_coex_get_algo_string(u8 algo)
>  {
>         switch (algo) {
> @@ -3115,6 +3150,17 @@ void rtw_coex_connect_notify(struct rtw_dev *rtwde=
v, u8 type)
>         if (coex->manual_control || coex->stop_dm)
>                 return;
>=20
> +       /* 8723BS SDIO BT-disabled: the vendor ConnectNotify() early-retu=
rns
> +        * without sending H2Cs; scan_workaround already established the =
PTA
> +        * path / coex table / PS-TDMA. Keep only the register-level PTA
> +        * reassertion at associate-start.
> +        */
> +       if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
> +               if (type =3D=3D COEX_ASSOCIATE_START)
> +                       rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
> +               return;
> +       }
> +
>         rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, t=
rue);
>=20
>         if (type =3D=3D COEX_ASSOCIATE_5G_START) {


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793598838;
	b=2UkyY8Nqk1R0fzxo+4IY+EZ6807MN0BSy33oQ8i+skhUixGxxjEF2vZQPpQxcp3yurrr
	 5voKZvz8is54lYuBjuSDgE+iYuRo1ukuDJFRQpezCtznU/oHFO0PPt247aN5BN/LKKXvP
	 rjtEybHfvNuDa/sJDBe8M3fTp9lt+ZIjPAHNBBF7DKKtuEWOm5igyA/Ep7maIT397IbyL
	 6lLEgFHN6sPwMtz8yGGBDBV0q2JSVbCNxWl2Qq2ukzxZrRGyJwZIGCnR6kbd87kGlMEoK
	 RpIEnFuse1msTI/EwJgpggwWhV90IXPJ8fUBwQxXQl2VyewuV40MxH3jiqm1D9zKZbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793598838;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=vD1/O6M6L5azUbJVyggZAvHHWLWY9/eStPMRvgaaR+g=;
	b=iMcoUpPjOskIhQ2vPHUxL/jmGF7C3NSsfGTftgJU+NuyXWwq69qjp0Gi9AJrX2j6E4Ek
	 W/k8fe0wMb4N6x4P3HCdnwFYbQIdCYZrvTSlE7l9BIz7HmxPcVmcPwcEUS4755tWUvSh3
	 e5+277vDC2MxDsy6erpT1JDUj9AyE2ocBgcykNduZkH6Vm3OEUT8iFalqFVNQiMRvHInT
	 M3nBw13hM1natGhnIKbUp7UVMLetwGB3Mdc02H5g2opJRn4Z3MVIQWZCAiZY5HJNafmCy
	 jNeUUe84Z67ZDheYjX0tDxCz6jw+4MiCsi6jxzocVDHl1+vHgcC2yC34sUbDbm57mqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=BipYfxhG;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3850F606A324;
	Mon,  2 Nov 2026 05:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3850F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=BipYfxhG
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A25roRG31914931, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793598830; bh=vD1/O6M6L5azUbJVyggZAvHHWLWY9/eStPMRvgaaR+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BipYfxhGOT496gsPXTB1LN/SUzfe6al3gNnImHT/becvPAZJh89sn6aVV3BYdGZEX
	 z14BDLiVXQW/p1TXEe1CW54P2UKJDQqgKy8JlDyFLx4YSq1KG/z+rtlCLyiPB84tcs
	 a+dmJU1cR0TGQVtjP/51SVdkeKf59CISeFm3FlxPrC6HZjXsMJ0D5P84T265zi4+9T
	 hbUbdUFtN+xcST6C+nCj4PfrWAqoH0flgPCbuFM83+OFu0xbqFkJKmOkuu2rLy0NQK
	 v7IQIisOXKaHgvqfSVJteDatxI/e1Wl7HRtNUaA+/ZhHwZnnjs1/WbvsDmOw8UgyRO
	 NfzTr05rvfOsw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A25roRG31914931
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 13:53:50 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 13:53:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 13:53:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 13:53:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kalpesh Solanki <skalpesh942@gmail.com>, "kvalo@kernel.org"
	<kvalo@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Topic: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Index: AQHdaeZfIO21Xr9w40u1hjvcgWoU0bcaR5gg
Date: Mon, 2 Nov 2026 05:53:49 +0000
Message-ID: <f917e8cda1b94d46b3ee66efbd092861@realtek.com>
References: <20261101094905.1299638-1-skalpesh942@gmail.com>
 <20261101094905.1299638-2-skalpesh942@gmail.com>
In-Reply-To: <20261101094905.1299638-2-skalpesh942@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Kalpesh Solanki <skalpesh942@gmail.com> wrote:
> When rtw_fw_leave_lps_check() fails, the firmware has locked up or
> failed to exit its low power state. Currently, the driver only logs
> 'firmware failed to leave lps state' and clears REG_TCR, leaving the
> hardware in an unresponsive state where subsequent H2C commands fail
> and TX traffic hangs indefinitely.

After patch 1/2, does it still happen?

Is it helpful if you enlarge timeout time of __rtw_fw_leave_lps_check_c2h()
or __rtw_fw_leave_lps_check_reg()?

or retry 3 times to leave PS with below three steps?

	rtw_fw_leave_lps_check_prepare(rtwdev);
	rtw_fw_set_pwr_mode(rtwdev);
	rtw_fw_leave_lps_check(rtwdev);

>=20
> Call rtw_fw_recovery() when rtw_fw_leave_lps_check() fails so the driver
> can automatically reset the hardware and re-sync without requiring manual
> user intervention.

Is this a real case? I'd just want to confirm this is real case it can help=
.

>=20
> Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/ps.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wirele=
ss/realtek/rtw88/ps.c
> index c6360cf..db1e9e7 100644
> --- a/drivers/net/wireless/realtek/rtw88/ps.c
> +++ b/drivers/net/wireless/realtek/rtw88/ps.c
> @@ -166,6 +166,7 @@ static void rtw_fw_leave_lps_check(struct rtw_dev *rt=
wdev)
>                 rtw_write32_clr(rtwdev, REG_TCR, BIT_PWRMGT_HWDATA_EN);
>                 rtw_warn_once(rtwdev, "firmware failed to leave lps state=
\n");
>                 rtw_fw_dump_dbg_info(rtwdev);
> +               rtw_fw_recovery(rtwdev);

failed to apply, because rebase to rtw-next.

https://github.com/pkshih/rtw.git

>         }
>  }
>=20
> --
> 2.53.0
>=20


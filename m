Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C53EFFC5;
	Mon, 27 Jul 2026 09:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144818; cv=none; b=EJrFTf/vg4U5QtiOuxsNLH+7W66/FvlcqXBIr6P11zzScHxs4k3RqVC+iZ43uWVrAdwixFgFYn/wJU1vbfwsmNFkCAB+y3jvprHt+hQKQZ6hYOTTvofjROG96U1MOd6VEKDt1PhSEzlFaX5Sr8sDpow0TXVuhlDdsJNQ7ltbKbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144818; c=relaxed/simple;
	bh=Z440T4mRS+39HAKMIsD+HiCmi60ymJk6lkvoB/FfUfU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KFByAevBIbAVzJRa/Di11kG+VqU9ZzTSFqdpnoMt+hIj5x3iL3AVbJ0wXN1NtSgm7LXMpTT9b+nyyU1KWqkSzHiJejVPxPl5EQpFCzHO9YMWm4Ln/fsnSCMrkB5B/mLLoCI7eNyx2ZV3WqpPMFkCBXx5LWPIAIAJ1Pgi2i2ya5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=EKF94wY4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="EKF94wY4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R9XQU402993146, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785144807; bh=7Ws7VPgFrxRQ4notehY1GuruGvqo+QS1vtES7/G8eOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=EKF94wY4CJm7JY2koCeOvdl3RxBbQj9PVXLgdtAOqSMnvCblORkeODhwhKDwK9JtR
	 +bgIEJkztFpbNkwYtMb69hVMzetFn9+7SMq1UZlON/ABHP/QFWy0nKYmf+8ElAerZO
	 4toPLBib20j/kUQkbBd07pcGjJ36qB+pZi+X77dle4WwJ73griUrGd7NyGReYM7mQ+
	 0WcABohlR3dEJxqz7v0mGAE6c52FG+PYD2KHU8sseZ1SL7IQdmCIA94qVkq6U6NxQi
	 2qdLweuWm3Z1e0cZ5McCMp4KeLH78LHDXe88GsVnowL2aWMbUk+HJgUQTc6gnh8PlI
	 c7DUwxnrJm5Yw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R9XQU402993146
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 17:33:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 17:33:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 17:33:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Topic: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Index: AQHdHEb/KrivPqpz/0SOkFGQL9rTRbaBHE5w
Date: Mon, 27 Jul 2026 09:33:26 +0000
Message-ID: <611b495996b74b278bfd769a9c045582@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-12-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-12-luka.gejak@linux.dev>
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
> @@ -740,8 +1215,23 @@ static void rtw_ops_mgd_prepare_tx(struct ieee80211=
_hw *hw,
>=20
>         mutex_lock(&rtwdev->mutex);
>         rtw_leave_lps_deep(rtwdev);
> -       rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
> -       rtw_chip_prepare_tx(rtwdev);
> +
> +       if (rtw_is_8723bs(rtwdev)) {
> +               /* Wake from soft IPS and run the vendor join sequence. T=
he RFK
> +                * is handled by the once-only power-on IQK plus the ps.c
> +                * post-IPS RF-bus recovery, not a fresh calibration here=
.
> +                */
> +               if (rtw_leave_ips(rtwdev)) {
> +                       rtw_err(rtwdev, "failed to leave idle state for m=
gd tx\n");
> +                       goto out;
> +               }
> +               rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
> +               rtw8723bs_mgd_prepare_auth_join(rtwdev, vif, info);

I'm surprising that RTL8723BS needs so many special handing. Can you reduce=
 them?
At least, use rtw_chip_prepare_tx() to implement its specific functions.

> +       } else {
> +               rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
> +               rtw_chip_prepare_tx(rtwdev);
> +       }
> +out:
>         mutex_unlock(&rtwdev->mutex);
>  }
>=20


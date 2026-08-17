Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A24B04A7;
	Mon, 17 Aug 2026 02:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786934848; cv=none; b=NXPTn02acZuqNAFAqTXDogTvhspXfVI8eJ50YSOSy1lgIDgfL+VO/ycrRhMwpIK1v4UlcgXbN5gRbEPhrT1cm5i4KA3mu+dzkIJXE3bb73jqpvkrRpvVnvmS+zHGalRPR5NlVMEG5zzOTcaEi6eiSEHhbMtMsfpaCdvVFcBFpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786934848; c=relaxed/simple;
	bh=5q2ZIzepjZS+NSHlFW3qeI4Tm38LlmKJJo5zOrKINHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hjmSLaXAkzL7bRZnV4Czp4VvfFevjQrR8EkjC/fvOftOItdWfXMgJ6HKElxiHc2MQveuYzfQho6FDRFx/bi+uYO7/giPq0yjIfmjp7a6oozSPrcNtxn0m1bdd3NpohDZ+kGRDcaE7hyxrc5GfieJKwmif2inkv350eC4ZzkHhAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bzyVC+J8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bzyVC+J8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H2lLrE53463683, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786934841; bh=FWFeCcXXQ7YQsBWvC+paQNRxXcvXJuOj0x7JzpIR28k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=bzyVC+J8FFJBJ6V5K1TNyeFLQN9FZk/13QjOweYgrfsB30Ti/gkmi8DRnTZ0FFgjc
	 ysssKHOYI6KvWRZcPVr52Wn/NXAbv5Kh9+tUDABzzbWlkFantNQrNgFOFZPD+eIdl+
	 H9gU9IFxgwU+JABdggMHNZwDs1U7ifixnTHaxy3Cbu8v8IHtF69x6JlU49smI/E1dF
	 fe1jHz/WmRyjjJfVUTZB8vjgD2FlX8Ik5YmY6pxDUIRRMIy2U8RSzZTZ2aHWefKvyY
	 sO7kC6x54kH/5hEzzZbyaKwbFIAzQaEhLQhZgZuB5IKmLmS5mnRzURCDKLMgd96cC8
	 mMD5non+jeBRw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H2lLrE53463683
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 10:47:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 10:47:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 10:47:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
Thread-Index: AQHdKu6xO0Kq5x/s40SdRevYQFbFwLahjTaw
Date: Mon, 17 Aug 2026 02:47:18 +0000
Message-ID: <33f6fd3af18e4ec1808771a15ce7e845@realtek.com>
References: <72ff0d793d61415eb9fd1c513abdcc5a@realtek.com>
 <20260813064048.198903-1-mehmet.fide@gmail.com>
In-Reply-To: <20260813064048.198903-1-mehmet.fide@gmail.com>
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
> An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
> rtw_usb_switch_mode_new(). The chip powers off its MAC and leaves the bus
> while the last control transfers of that sequence are still in flight, so
> they complete with -EPROTO and the driver reports them as errors:
>=20
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>   rtw_8822bu 1-1:1.0: write register 0xc4 failed with -71
>   usb 1-1: USB disconnect, device number 2
>   usbcore: registered new interface driver rtw_8822bu
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>=20
> Register 0xc4 is REG_PAD_CTRL2 and the access losing the race is the
> rtw_write32_set() that ends the switch sequence, a few milliseconds befor=
e
> the disconnect. Which transfer gets caught varies from boot to boot: 0xc4
> is in the "always on" section, so every write to it is followed by a seco=
nd
> one from rtw_usb_reg_sec(), and sometimes that is the one that fails:
>=20
>   rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail, statu=
s: -71
>=20
> Nothing is wrong here. The device re-enumerates, probes again and registe=
rs
> normally, which is why rtw_usb_probe() already treats a non-zero return
> from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
> switch can never succeed, so the message returns on every boot and
> everyone using such a port has to work out that it is harmless.
>=20
> Mark the window in which the chip is expected to leave the bus and skip t=
he
> error reports for transfers that fall into it. The mark is set in
> rtw_usb_switch_mode(), so it covers both the new and the old switch
> sequence, and it is dropped again unless a switch was really started. It =
is
> never cleared after that because the switch always ends in a re-probe wit=
h
> a fresh struct rtw_usb.
>=20
> Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM6=
2,
> where the message appears exactly once per boot. With the patch both line=
s
> are gone while the disconnect, the re-enumeration and the second firmware
> load are unchanged.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@gmail.com>

[...]

> @@ -1189,10 +1191,21 @@ static int rtw_usb_switch_mode(struct rtw_dev *rt=
wdev)
>                 return 0;
>         }
>=20
> +       /* From here the chip may power off its MAC and re-enumerate, so =
it can
> +        * leave the bus while a control transfer is still in flight. Kee=
p the
> +        * mark only if a switch was really started.
> +        */

First line of comment block should be empty.

But I think the comment in usb.h along declaration is enough.=20


> +       rtwusb->switching_mode =3D true;
> +
>         if (rtw_usb3_chip_old(id))
> -               return rtw_usb_switch_mode_old(rtwdev);
> +               ret =3D rtw_usb_switch_mode_old(rtwdev);
>         else
> -               return rtw_usb_switch_mode_new(rtwdev);
> +               ret =3D rtw_usb_switch_mode_new(rtwdev);
> +
> +       if (ret !=3D 1)
> +               rtwusb->switching_mode =3D false;

Shouldn't it set to false unconditionally?
Regarding normal read/write (not for switching mode) gets wrong, I think
it needs to throw an error.

I also think you might add/use a flag to 'enum rtw_flags'.

> +
> +       return ret;
>  }
>=20
>  #define USB_REG_PAGE   0xf4
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wirel=
ess/realtek/rtw88/usb.h
> index 9b695b688..9d2825368 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.h
> +++ b/drivers/net/wireless/realtek/rtw88/usb.h
> @@ -85,6 +85,9 @@ struct rtw_usb {
>         struct sk_buff_head rx_free_queue;
>         struct work_struct rx_work;
>         struct work_struct rx_urb_work;
> +
> +       /* the chip is re-enumerating, control transfers are expected to =
fail */
> +       bool switching_mode;
>  };
>=20
>  static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff=
 *skb)
> --
> 2.54.0


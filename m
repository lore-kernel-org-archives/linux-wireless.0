Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:34975 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZCBPUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 10:20:10 -0500
Received: by gxk22 with SMTP id 22so4616524gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 07:20:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090302130728.GB30293@jm.kir.nu>
References: <20090302130728.GB30293@jm.kir.nu>
Date: Mon, 2 Mar 2009 10:20:07 -0500
Message-ID: <b6c5339f0903020720x3b2b8ef8ldf726d99c32a5202@mail.gmail.com> (sfid-20090302_162016_255187_04410EE0)
Subject: Re: [PATCH] ath9k: Remove unused key xoring
From: Bob Copeland <me@bobcopeland.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> - =A0 =A0 =A0 key0 =3D get_unaligned_le32(k->kv_val + 0) ^ xorMask;
> - =A0 =A0 =A0 key1 =3D (get_unaligned_le16(k->kv_val + 4) ^ xorMask) =
& 0xffff;
> - =A0 =A0 =A0 key2 =3D get_unaligned_le32(k->kv_val + 6) ^ xorMask;
> - =A0 =A0 =A0 key3 =3D (get_unaligned_le16(k->kv_val + 10) ^ xorMask)=
 & 0xffff;
> - =A0 =A0 =A0 key4 =3D get_unaligned_le32(k->kv_val + 12) ^ xorMask;
> + =A0 =A0 =A0 key0 =3D get_unaligned_le32(k->kv_val + 0);
> + =A0 =A0 =A0 key1 =3D get_unaligned_le16(k->kv_val + 4);
> + =A0 =A0 =A0 key2 =3D get_unaligned_le32(k->kv_val + 6);
> + =A0 =A0 =A0 key3 =3D get_unaligned_le16(k->kv_val + 10) & 0xffff;
> + =A0 =A0 =A0 key4 =3D get_unaligned_le32(k->kv_val + 12);

key1 lost the mask but key3 kept it?

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

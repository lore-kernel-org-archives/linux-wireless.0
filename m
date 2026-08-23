Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26919E7F7
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 05:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787463991; cv=pass; b=KlJ/BsZ0gsG1M+sYCJ92HFFFqjesA2vMbeVUgkW4FoYRGiQ8mjxHjPMSI8uLbGe+hPltmEUtXmjaALe5CYqiindskdoCB5ayznqTTb0X+pmdHHWkyty5aSv76eD7x9AvHl+gZvT74iw2WP31pPzd/dBWwuTrOKVzk9xaG0udZ4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787463991; c=relaxed/simple;
	bh=+RwA/dOgl+AS9kJIjuiX9sh5I0j4Vv/vZ7UKGOtsuao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nNIzTX08jWZ7Sc4/toXNsyWYiV0FWjN1VIOyC/PCuorhxq29NCioQ0qnm0v5cdvrE0BpJ7qqTj/PIA5xWFOE52Xq0qVX6B0kZc5gakW0WHjGshGlD6I58xaYRiiD8cvV3qPoVunNpjEQ4MQG2EivLvoIRvqMouj7z8EejY6GmmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adnSE+xP; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adnSE+xP"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-836cda225c1so34796057b3.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 22:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787463989; cv=none;
        d=google.com; s=arc-20260327;
        b=gXbWY6CvqVkbM8TtaN8p9lO7NIy1XbKRJaNiWk9zSESFtKcjo57psEUPGIWDETLgBn
         rBmm4W7GHjAoTxtS5pRxoogSLzkLEit+gGI9LpDfynABb7clQs5kiQBDHL1IUn/6UTtm
         Bo0dBqqBs7s1UZBK5SUVx4LYMRAM86uHosPDPsmQbPmfhVu56aTBhmRusb83wmSC+eUj
         oxIEBqpIKORLtyHh8l78QT45c2UJIuN4RhVJFgxLrTgpHfzOHQhpVomgyMI3WOuMgSf8
         cSy6ei0FJW921EMXdzVkjYFX0ossmbv+v/OLZfcnfKFfAloFedsWyO+GXJ46wgqvxM0w
         UDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6CKmDpzg7W4E18Z8ukMBndRgCaQ+p6JKZK7dsKU9kqc=;
        fh=JNA+7JEjppusWoigji+PEpZ7abuU5sibpzH8lxZqQvk=;
        b=E6hFaQvfpkPX1b+VjvmZcwX+L63/b9YRD5fb/bEU9emxvHzJLqbiAifrCN/PdsP/NN
         7TVfNo+lkjVG6bk4otURN2sEsgpMfGkNI2GzkArfpTkpDcn1x4128huubogrHRuZRx73
         st1EnqQ/FtJHnC30YU/5Wz/J0H4wa9itvVIw/l94wVVC/aS53ImhWCdaGd/FqqmQk6+n
         BdtULJSPZp/aiPe2zWgwL/DuL6LJYJX880GowG8GJPd6yWojvCoPuMduhIZUfwRoaPIG
         bgmdTYIyhgvkulDZmk6wqSMCp685nXliqMRraiK/UAHLfaipmZUXhvS67RfjSXogocMz
         R5sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787463989; x=1788068789; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6CKmDpzg7W4E18Z8ukMBndRgCaQ+p6JKZK7dsKU9kqc=;
        b=adnSE+xPamSz1g2GJpAx3/uV9G1RRbvyWhnR0tg2AKyVn9QYM+8VKOm/0H5k6a3BqA
         hDKvZ5tnARYEJE1E7RcLlHPUj1cF+tDquIRFmrqvBKBnzKeduM1BLFrfrPxpDVUY6Ki7
         +wNH5qRrVvxJAJ4wA+wm/DeYlZ0t0kSnnMOjNK0YM0UHiBIX40pOfennn7JtvZcXe2vB
         SOGR5YqjfA5pCJrLc8dwXgjuNcdNpZkrN6soqKL2caR0pcUCSkFJRDNk09ba5se2FVN0
         CeDAX5frLtV433IPinzcte9h53eTO5eWaCekJuKiFZILSpw5Py/YxTSiMUOrnZ3udffy
         0MeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787463989; x=1788068789;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6CKmDpzg7W4E18Z8ukMBndRgCaQ+p6JKZK7dsKU9kqc=;
        b=TcoAQSHtbWznx1uyasl9dbp+AKVHNjEHuh3IoVORit1T8VO+UOmCYD00aEWvkMAfQ8
         4ELuAlTjqCBZIldZDQ8i6tgQIIdFaNOW/HnxO3kTlcC61gbA8ufL5KEi1FFmrHY+KWxm
         y1JR5bRRR2XiKZO/5VRiYWll+I7dT3wgZy0jGJmYTItZKxrpHuCbs/oXbu+Da7ChkCHE
         2OoMqHtDEAG5zeu3JFYK00EhVBbqvw9QDGnT5ZM6Iwkce8mtPP+zxZwosek6pO1pL6bV
         sUZC1MvlHsWbn1KfU2uDH8NcxJTKSUDwN7Q9azDc7LM6IVuBbQYYVL69Ix15wo3KOga4
         z0mg==
X-Gm-Message-State: AFuF++mN4CaeIJXSfHPqqftNN4W3ZQwAHDyqwl5wBrEluYXaXcH2uvtS
	0AUyPf+lNqrOID9vQU55oE9iolStzd2YHMA6m2+G3xEmuPKybuGN/w+wWv1aleTMjYFZv9L3845
	NL+UNEpq8PJJ53bMlFt2XouW9ulY3vnl0hxq+
X-Gm-Gg: AR+sD113MPO+GZ1UUnoFHB75rB9FBAfc0fGiK9G5m/VMFSEXBBROlf4ReEbrTGWS2dn
	p/YaORpGlBZufI+CxIM5o01VsiunU1AyRkEQCqFO7/sQQblUDB6cWwS4t/LV9q5TPLPW2OtYmd/
	Ao6Eb7KT6CN+r1e8Mt7GzvRwZeIP20/7nuZygP8cIDItm/5wJ/Fq08tlSNBqeN0SipkybA/Rs9V
	TrFoD06bdstsgF5Frw94b4n932YOvfUQrkhsV5ZQHWRFddr2MOrH/h2V7szDnWnu2qCIn7lc0hy
	0Wo0f7jUb8zWLfn07yauhAUYu4pDFYkqLPNY1XuRqMVDDQiR1x1aqdgqQw0rmgNDbtWC8W/N0g=
	=
X-Received: by 2002:a05:690c:7483:b0:81e:3965:40b5 with SMTP id
 00721157ae682-849f5fed6cfmr63348787b3.28.1787463989429; Sat, 22 Aug 2026
 22:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260816205119.1793197-1-gongtao0607@gmail.com>
In-Reply-To: <20260816205119.1793197-1-gongtao0607@gmail.com>
From: Tao Gong <gongtao0607@gmail.com>
Date: Sat, 22 Aug 2026 22:46:17 -0700
X-Gm-Features: AcwNN1US5tjPwBpymE_ucXqxDyTdin5Q-vqNdNDb96J5jagOwFMOQZxOS8ownUw
Message-ID: <CACmSHQt1ZAD6KBfkAonNAvVnA1VoCMOVb_wb2vhQaua4hRph0A@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt7996: skip HW_RRO for sub-64 window
 BlockAck sessions
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, openwrt-devel@lists.openwrt.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please disregard this patch.

Upon further investigation, the root cause is a struct mismatch. Fix
sent to: https://lore.kernel.org/linux-wireless/20260823053739.186748-1-gon=
gtao0607@gmail.com/

On Sun, Aug 16, 2026 at 1:51=E2=80=AFPM Tao <gongtao0607@gmail.com> wrote:
>
> From: Tao Gong <gongtao0607@gmail.com>
>
> MT7996 HW_RRO (Hardware Receive Reordering Offload) seems to be
> architected around 64-frame minimum BlockAck bitmap windows. Enabling
> HW_RRO on sub-64 window sessions causes it to lock up internally,
> stalling hardware RX offload on subsequent associations reusing that
> WCID. This was observed on the W1700k with Apple Wi-Fi clients, which
> negotiate buf_size =3D 8 (TID 6) and buf_size =3D 16 (TID 1).
>
> Bypass HW_RRO for RX BlockAck sessions with buf_size < 64 and delegate
> them to mac80211 software reordering to work around this issue.
>
> Signed-off-by: Tao Gong <gongtao0607@gmail.com>
> ---
>  mt7996/mcu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mt7996/mcu.c b/mt7996/mcu.c
> index 176d71e8..f021c4b3 100644
> --- a/mt7996/mcu.c
> +++ b/mt7996/mcu.c
> @@ -1500,7 +1500,8 @@ mt7996_mcu_sta_ba(struct mt7996_dev *dev, struct mt=
76_vif_link *mvif,
>         ba->ba_en =3D enable << params->tid;
>         ba->amsdu =3D params->amsdu;
>         ba->tid =3D params->tid;
> -       ba->ba_rdd_rro =3D !tx && enable && mt7996_has_hwrro(dev);
> +       ba->ba_rdd_rro =3D !tx && enable && mt7996_has_hwrro(dev) &&
> +                        params->buf_size >=3D 64;
>
>         return mt76_mcu_skb_send_msg(&dev->mt76, skb,
>                                      MCU_WMWA_UNI_CMD(STA_REC_UPDATE), tr=
ue);
>
> base-commit: b2704cf5a4068b672bf47ad5bf6b4802b6770a90
> --
> 2.54.0
>


--
~Tao

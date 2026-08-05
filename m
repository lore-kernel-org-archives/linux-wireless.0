Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427E53E8C64
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785919723; cv=pass; b=m88tk4o32QU09zjWY5nNg1/5I2jq0FtAd+O5N5UPJdlmy1zdMkc1JAG1MTrrQVzbpwDo/imZXXRhBzsRQ09WHzlQ8miXr09TDyt+cdk7tEFyn1qzA1qNPwr7Y7USP8YqXghsHgMzpS0WMf1jZ6Y6fskRtjRMnY9TgCdogQNKQ8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785919723; c=relaxed/simple;
	bh=c8d6oY/qvZgV+eMSrglWUNtmpyiZdkYKgyx5ZV+Ovg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gx1fGtMHsQ5GoE9Hd3DHLP+km3eRiC+V5GdQC8XCcJZX0bzyJgWRdel/b2e3MBctO/U1kyx7WkmpiitQh8SpX/gEOHIU6HAKfq0TlBUYLpEbMyJ5TM8nAtO6mH9tpe+slDA4IfLZu72dDcRi/AMBU5JQVmH+JZ7jd2jxHCxdtxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqAQhg1i; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqAQhg1i"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1f7666a90bso115220166b.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:48:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785919719; cv=none;
        d=google.com; s=arc-20260327;
        b=Klm52P1Tvgaqkpcjts/jnE3eaabeRLrHlHEPL3QkKFknEEaddYQnTosggT37Ia/kom
         Op51KNhX9oKiXcowpVvG9zkkIGW7eksyhJfxZx8If9vShfDAgZzAcOoJlUqEWaoiIlyL
         yOYK74+tOSsXsK3zkCKwUe9H6XQ/Oj1ZbBCBpE6xiAyajTpMtuF/g2UjY3rtKrteovWg
         cF9Y0Ec0ACoZPUHfEkBmpwXscuLqhWwZn6IfjpDZ95f7Whv7VgAX6gIy76GqYLmMroPt
         oZy6IUWo9cZfVmXECmqKf7id24nl1JAaBQiE37OxSTWTIhzghX3+54Q6Vgk8E8Z2m5ol
         I2ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Dw08ZkvlKjGUhl/zyBOS4XsCzhr7+Rt7Yc3t6JVkFQU=;
        fh=kuckbBOIJxBoY8vJ9UbDeDcu6z8BqaVyGme1s/4CZo8=;
        b=Z0Xr380de//HfLSKhc8ybWqy5pPydCX81xku6USSpHDL74GMqABd8p251PSv/sOp7F
         VH7MjQ4pdI+VD9+eAu2bLy4ryHdJiXio3jWthtOl3hTB1BKjZ3sRMhqvZXmCJC/qM2Ow
         oyA1xxCkHxg6g9NKO+o0lC1TpTeSJ7+ox0y0ICmyX5Uj/3e/Jme9Yp99M/QloUHgQkp1
         HxRsp1iditxO8d89xzIcomqrHTN9zSfS0ZvrGHvVpPT7Md2NGPUPImhfe2iSWCUbYdEo
         CpPaaRH6k29IBYHQ/LrErgpIwQvebTXRZv5+Ik5rB04u2lC9oKlpnhACWNSJYfcwpG+4
         JRjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785919719; x=1786524519; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dw08ZkvlKjGUhl/zyBOS4XsCzhr7+Rt7Yc3t6JVkFQU=;
        b=UqAQhg1io9JNmiq5VTFxQi3orT8SugQcnPjVDgmpNdjbxo2qwL4gvYBzpLcK2jFMC+
         TXuYpSxWqFdMa3gP2yKIl3PsB6EHqpRVXX6VhT5nnm99OhEPJNWMHgFCiyP0mjM+YvIn
         YLMZFlSXoosO1C2hZD9KlE14/VK8MGv99picFX/CNpBZQ50j+wUhIwyfW+Mp5Ah9hdHN
         RsFNUZ1AOmC5XpzVy7/CNME2RZIDUYM4FCia6EFAhOUHRTBThJHpKzucn//aG+gHZYfS
         xVVwA3LzwDumuEhZu3UYdfz3k1SXwTiA3ijqPMLVxYZJA0H29+rmc2Mwo45zWsN8Zhgh
         8QZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785919719; x=1786524519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dw08ZkvlKjGUhl/zyBOS4XsCzhr7+Rt7Yc3t6JVkFQU=;
        b=eCzx4mUuwhSr5O2AxOk3voTkqmBQnbXweQ2Bb0+HYvw9kn5ZWLoh41N2CLjCCvMAhM
         Xj7NTlVd9haUsIxlnd23kdVGGNkZ4EeGCF743l5RWiWQxcocpnKpsbJYmUHL4ygx4lgT
         G85gQkIsKCwkmzqtlOaEXUvmRVSIRHs1ZnqMdl1GCWa4QPuSp0XYT23PQNGX+xR04FNG
         aIpNw9UNXtBGDFxiN6vSVtDpvFum1NCowpi0Nw2mXLTdplqBidVn8CHni6spBzLIn3Bt
         QjjB+XJbflNWLnrYFxCW6D/494RQRklWmU6ezH8sjVmTN78lOxLNcbXs5bKBf0dhmcxj
         uPTQ==
X-Forwarded-Encrypted: i=1; AHgh+RpgcAOBfQpM1X7w6V818znfwqrMZ8wgeoC3yM0mD2l420Vj1gmJKyhyfzIrXu3r0ygD0rsUCkfEbXV05u/jRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4v/uBtiHpIyer2w/dm4F/Jo0LDOd+3MwORYe3vhasva/fqY4g
	Xsdm/LQs5TlLf6pLYJSFH+KchAtT3sydlS27vKCGwl7OO6+HVP/ce1/rNFDpjahFMVEzTm5f/Wd
	dQEqonPXGVpOxH009oQyN4RiPzYaocOc=
X-Gm-Gg: AR+sD10AUScOD8qD7D+mLqk2rKPIhZCC8RN19PmrK9PqW5/B1uk6rcBHGpXDjxZ/9ef
	CmQ6czM8YGoPfGCguYUg1SW0R8clnX9KPhosSK+/5Es8Lt4HDpbvlHxWyFRPRiKd9UYaR/hCTj+
	+WDND3pelKDKr4dS86r9PdnZa997Ow5p9vJvrgAHoLtbtIav7zag2oLQVyS2IafaixzRsqfCYok
	1YwFswQ8Y8C18xnP5mgg+mfv59GfTk2XDAr5GgXfq0Uf/aarUoJrx7cNPFmGPSQTxO13GC3/haF
	Gv7EJg4fVqavU8w1tkRRdC81Lp+xOznT7I3P1EB1lklW
X-Received: by 2002:a17:907:7b91:b0:c12:764e:326 with SMTP id
 a640c23a62f3a-c2039d10eb3mr203394266b.27.1785919719449; Wed, 05 Aug 2026
 01:48:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804095832.784121-1-colin.i.king@gmail.com>
In-Reply-To: <20260804095832.784121-1-colin.i.king@gmail.com>
From: chelsy ratnawat <chelsyratnawat2001@gmail.com>
Date: Wed, 5 Aug 2026 14:18:28 +0530
X-Gm-Features: AUfX_my0J7JoH0gW8Dxh60k6T4o2zXgNHRGX1_3KTnrwVaQICcPvxXITiqvQcQo
Message-ID: <CAOeBcHMBmzQAqSYWLotdb2k98+i+YaXyfTMy6sbqUr7geM5=Zg@mail.gmail.com>
Subject: Re: [PATCH][next] wifi: rtw89: coex: Fix spelling mistake "verseion"
 -> "version"
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:39=E2=80=AFPM Colin Ian King <colin.i.king@gmail.c=
om> wrote:
>
> There is a spelling mistake in a rtw89_warn message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
Reviewed-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

>  drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wire=
less/realtek/rtw89/coex.c
> index 5a9dc4d8a00b..84ae14f993e6 100644
> --- a/drivers/net/wireless/realtek/rtw89/coex.c
> +++ b/drivers/net/wireless/realtek/rtw89/coex.c
> @@ -4086,7 +4086,7 @@ static void _set_rf_trx_para(struct rtw89_dev *rtwd=
ev)
>                 ul_para_num =3D chip->rf_para_ulink_num_v0;
>                 dl_para_num =3D chip->rf_para_dlink_num_v0;
>         } else {
> -               rtw89_warn(rtwdev, "[BTC]%s(), No rf_para for verseion %d=
\n",
> +               rtw89_warn(rtwdev, "[BTC]%s(), No rf_para for version %d\=
n",
>                            __func__, ver->fcxtrx);
>                 goto next;
>         }
> --
> 2.53.0
>
>

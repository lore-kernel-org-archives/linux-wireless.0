Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B801DC985
	for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2026 23:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781823720; cv=pass; b=f9gCp3Mkx8tyKVZ8GicrLnhO6i/A/SkgzNsrrYhl4Wb8ESDL6OHvHiHquvhs+10TPoHeJSi1Ljgr5B/3+moSg3x5eRbfAxnwfr4FKF+Locmj6I+OMXsUmSwAwojxRGAeNxchhu8c/kBRmeZUyzKY4x6hpLzxB7oCM1P9jGZJBoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781823720; c=relaxed/simple;
	bh=7RPZ8oIw9peSod+NBFbMjqYqBcpKComngNCXBueYoiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SbyTMFSQqw/IuT49zGk6BREdwcFjD8UO7SL7Qi/t3XshdadD45sIxszE833aeBuygmZWPVnggPG6Tge5skNQ8nDqH7q2bbyOlt2rsbyTGTRJreH5LHMZi2BxTxKfZwY0n4JE9eigrV9YqDmnIticgUCH1gwYE8JjjVjNuVJ6B0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KvS7t3Os; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvS7t3Os"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68bfcf11050so2567143a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2026 16:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781823717; cv=none;
        d=google.com; s=arc-20240605;
        b=QE/mPliXeS08wTK9ynkkNdr/7hCwZ2MIWdDfdSRo71ds/9QwoR5YghJqf2cGijOwAt
         HSCLZiScRj0pHau8qFkleWdaJjZxz8bybPkkcXSK9mKgFFcv8fSNJlIadHtzTdpg7FB0
         jCEjy2votWlFfHNNmcQZavsj8uSXI2ofBRbnR/c3FtDOdW0aMaMdrW5Kg1AvesMqkMY2
         abut5n5LMs5B5T61v3LT8E1LOTc58WPjKF/8A9fSq5g3uaaBvIJiTAlOT2ILLM2XNAt8
         jBg7WD0g3AV0nfyaXMo5xxwdsBJABY3CoSUydtkwjpNwFK32btxlnNS82tutV+wZ4Xom
         cGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LrgAfG22KAorY853iHAUHzDmNBQcwguhA1ZSTcHUX7k=;
        fh=P5B5Mu0P9ArEDgyDA6yMEa2xJkI1W3b74cwOnDcOpps=;
        b=WSxVX3KVljLBfedJl166muWHj2kp7FxVn76zX+7pdJshJgg/ebzBZfVlMLb5RWK+WH
         Ggf0cO74Nsjd88DIZl/A0vgPO1zhvxZcf3FcOFIQXCA+jmjBkrRkJLWSelUwtmoMS1ea
         DrvkfTaXMD1h9iMeTOgGDYghMEQN3jC6Qiqk+oOh/h5rucDz9BKGKdHGBX4sJRA1JGwu
         YdRGcPrXAbJPiKpqDFtWa+wkowmIvZjKj2f6ec4iFpkj0OKKvAPuMftXotypLK+m4imK
         3KBXEGOJgFHvtk4w8PEDZEMaklVyxWh2+jTDJB78frr47/NVzgvMXjYd6rr7wJDw4VOg
         mwEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781823717; x=1782428517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrgAfG22KAorY853iHAUHzDmNBQcwguhA1ZSTcHUX7k=;
        b=KvS7t3OsCnkmBsB+FGt0RikeNxFNVbCPP++KD/RT+c21B7pPfZryMyHeYy3hWLRBE3
         bbzEN+Y2+ckeGsy6K8w2W4++IZFb+G8N1hO+K7VNrYeh/25smv/u09vNXmnilykNiwio
         34ueaielD5ZR1nLCkq+nAKYsjaK9YZG9q0tOFENajfXLJPp9hB1mNQrTEXEoIKtNPIH8
         +FxePVlr30R/7cdYxNY8X11Xy5uBJ/xEfvP+lnzxow5hn2NccIkRqyQEfBVzJquNKG26
         7OlkogNEaaMpDVeBzVTMrX/0/erfn7ThcrljrB4YIqz8eWw79jtjuTUX9guz1fA6+3wh
         aioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781823717; x=1782428517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LrgAfG22KAorY853iHAUHzDmNBQcwguhA1ZSTcHUX7k=;
        b=W4R2WsvQQb79XuOx4TVyHc3g90qvgVy9EY008JymOMfBv+F9SntV6xEvgAIQUU01P2
         qIKrIXeLe+RW6YzAPd/GZ0nmjG80nMQOu0vyf/gUYTA1uej+lJXT1SpVKyigBrcS40iV
         g2x5uLG1Kql7/p9CAq2VxB9S2RZtWzf5r0hSxH30p4XDPvROtoXtOlULSM5wjd6w3a6I
         7OPma1G2CmCFclMxPPh2BOMZh9qdmcQUQCLla3h8+GRfgwwXZId56pZzo7sD/+sQrs+D
         OOmTvZWsZniBFOnIgSJWJar6tbn/L0KnxeNWvClpqm2JR64Ug6P4BlJmbhPjKfbHBpAG
         lVqg==
X-Gm-Message-State: AOJu0YyyOyGjt00icXEmaxc9NlV4aWdh4O+orMqsHDGuTif6vQEQmbUB
	5W95kigNfezhJKKX/+YD5xa3hpo0Fj9EyjR+pQRnD3zaz4dQjf+CjsZGeUYzUJGQzwLWauzUbvd
	vvKCFUsB/O57doEfmuoGtaVi2N/IesWY=
X-Gm-Gg: AfdE7cm+Zl7VrXmxcN19WQrq1gnzZrBqLpI8W9i4io6aglnDrQ6dPaWwDjFk/YVepVP
	TTItX2dLpCiR6gav73VkJEGY+afQJEmKIHs1e5U9wtAPiAWqBn696TmjJ387dPb5GQTuOMEEg8S
	iEJKFcUMHNmq45ndqajRr9fzAPE8X9mB6XH7YkdSQaih/yR7SozmwO2R/d7wN6KGVcoZCk5pvQZ
	Z+13i1BX33WAdz/0A0LCey6Dsj01TPk73oqvZKjxdppEpsC+CN9Uicizf7lPncHcDdO/7g6P2we
	sVShWwzQsz4+fyLZJJdubEfEVMdhjdSWwW8vyuI2JxBSsb8AtpNtpjfufW5YDzA4a+t3eXC8tSk
	PbrxBeURB5+uAHtxracZ5ov7mrf6OqX9/figFFmE/kBeFNRPW+C3KtQOUsg==
X-Received: by 2002:a50:ed15:0:b0:695:dcb2:7438 with SMTP id
 4fb4d7f45d1cf-696e52647bdmr431695a12.28.1781823716380; Thu, 18 Jun 2026
 16:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427051746.954704-1-rosenp@gmail.com> <ajRmlyx_AEGybykL@soda.int.kasm.eu>
In-Reply-To: <ajRmlyx_AEGybykL@soda.int.kasm.eu>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 18 Jun 2026 16:01:45 -0700
X-Gm-Features: AVVi8Cd8pKJV8TDSQqNM8KIOqfYt7FlEl94-2dFF7xSm3zDLY3ekIKFMu3kD-wY
Message-ID: <CAKxU2N-gfH8Tq29-j2MArogLZuO7JEqtN5LNPVygJzrAERa3cg@mail.gmail.com>
Subject: Re: [PATCH wireless-next] wifi: mt76: fix of_get_mac_address error handling
To: Klara Modin <klarasmodin@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	"open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2026 at 2:47=E2=80=AFPM Klara Modin <klarasmodin@gmail.com>=
 wrote:
>
> Hi,
>
> On 2026-04-26 22:17:46 -0700, Rosen Penev wrote:
> > Check return value instead of is_valid_ether_addr. The latter is handle=
d
> > by the former.
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/eeprom.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/=
wireless/mediatek/mt76/eeprom.c
> > index 93d91264687f..0f6ccf6ed53d 100644
> > --- a/drivers/net/wireless/mediatek/mt76/eeprom.c
> > +++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
> > @@ -93,7 +93,7 @@ mt76_eeprom_override(struct mt76_phy *phy)
> >       if (err =3D=3D -EPROBE_DEFER)
> >               return err;
> >
> > -     if (!is_valid_ether_addr(phy->macaddr)) {
> > +     if (err) {
> >               eth_random_addr(phy->macaddr);
> >               dev_info(dev->dev,
> >                        "Invalid MAC address, using random address %pM\n=
",
> > --
> > 2.54.0
> >
>
> Recently I have started to see randomized MAC-addresses on my x86 laptop
> with a MT7922 and the above message printed in the kernel log. I have
> CONFIG_OF turned on, but since this is an ACPI system the device is not
> described by any device tree and the earlier of_get_mac_address() likely
> fails with -ENODEV. Looking at the !CONFIG_OF stub for
> of_get_mac_address it always returns -ENODEV, meaning this will always
> randomize the mac in that case too.
IIRC, the normal device_get_mac_address supports nvmem now. Does that
fix your use case?
>
> Reverting this patch fixes the issue and the correct MAC address is
> used. I'm not sure if there is any case where of_get_mac_addres() could
> fail in a way that results in a valid MAC address but it seems unlikely
> to me.
>
> Regards,
> Klara Modin

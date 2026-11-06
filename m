Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977670;
	b=mkEtsbnpBGPSnpt6ItpbhAw4HQJShvUsLmmUhAXBiuUqz0Kmjvn7B5WR7RDt0crIpPjp
	 UaLvFm+fuQLA4SpV5gGTdiRxzkFz1YXgo0QCjUEwOd+him6BG86cvn58XRhi5KzlqYD0b
	 ptpdmgIUXJ+7qRvu2IyC1NE++0gHGTjYuyBuebxmdmr7C8I+vtZA2pulr2CiUPr1MEl+n
	 ZtKNfo+up5VVuWliWlUigNuydjtiDW+V2WiqEwuH+Xq+elVrI+PVYa9D2kAMLvWkzWEtt
	 mj/K+sNPgrXwdYyq+yyIpWX15RHujnnz/hKffwVqVD7tWyDR9It0qCNIh/EHuCObpjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977670;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=uhfmT1IiRbitTf2nGJgABf4mbFwdhgE6lRGWUZmbaes=;
	b=SDecUxCma7tBIMvktb+ypZPxBLGAOJt2H1xBauqMynWfzqbFGCOyeicu17EC4RpvLWjr
	 VPQEyUZ4KJBey014SySj7DMqALNZJoLWjYFfrnlW7GGsJ1pPR9QDZghaMQMaySRuJ2RgT
	 cu0w6vhxT+2Zk34Rr4xwM0Kn8SE6hyat6zj9CdpIaqhJMoiCdtQKaUbCBXl63E4cC6t1N
	 G/fV5ph+O93LvxRsRT3I1E38DDqR8w75a2JCaN55LvGlnND9jBNr8M8Eef9ryEax3+U7l
	 AczZeRBHheNoKcYTOL8UX7WHbRJ5i7BAR6z7urMMwVknqsqk2QmX9Yx+iByrGIrDIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xbMUdS3N;
	arc=none smtp.remote-ip=95.215.58.135
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366B606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:07:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A366B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xbMUdS3N
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iUgwg3wOU0y3JGB7xLSFqDmWliv+o/Ng4s2MaACzyrQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793977666; v=1; x=1794582466;
 b=xbMUdS3NZHCmuF89wzhD2Bqqv44hLBxt4jwhOS9+RuhzNBdYkuMDdfxKOsRmYT9aKMlQm/BE
 uul8D1uSHDTRUK+PgfZb17nYatLfZQ1JRLt+gETp+ERNN2P8bkZvDH8F8Gu0DJimXe6emAzUSe8
 PfzJ6dApLUe3z1sqcTi2GM/o=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e724dfcd2d325e23;
	Fri, 06 Nov 2026 15:07:46 +0000
X-Mizu-Trace-ID: e724dfcd2d325e23
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 06 Nov 2026 15:07:46 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <f6a7d3272fe7635c6a83698dfab5d85500437ca6@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8822c: fix out-of-bounds access in
 cck_pd_set
To: "Zeshan Ahmed Nobin" <zeshanahmednobin@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <20261105113415.73184-1-zeshanahmednobin@gmail.com>
References: <20261105113415.73184-1-zeshanahmednobin@gmail.com>

Hi Zeshan,

Thanks for tracking this down. Few things below.

November 5, 2026 at 12:34 PM, "Zeshan Ahmed Nobin" <zeshanahmednobin@gmai=
l.com> wrote:

>=20
>=20rtw8822c_phy_cck_pd_set() reads the current bandwidth from a 2-bit
> register field (0x9b0[3:2]) and uses it as the first index into
> dm_info->cck_pd_lv[2][RTW_RF_PATH_MAX]. CCK PD only runs on 2.4 GHz,
> where the bandwidth is 20 or 40 MHz, so the array has two entries.
>=20
>=20When the chip stops responding on the PCIe bus, register reads return
> all ones and bw becomes 3. The function then reads cck_pd_lv[3][nrx]
> three times. rtw8822c_phy_cck_pd_set_reg() rejects bw with WARN_ON()
> and returns, but the caller still writes new_lvl to cck_pd_lv[3][nrx],
> past the end of the array, into the fields that follow it in struct
> rtw_dm_info. Depending on the byte read back, pd_lvl[cur_lvl] and
> cs_lvl[cur_lvl] can also read past the end of the on-stack arrays.
>=20
>=20On Ubuntu's 7.0.0-42 kernel, whose line numbers here are three lower
> than in mainline, each chip failure seen so far logged one report for
> each of the three reads, then the WARN_ON(), then one for the write:
>=20
>=20 UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4407:21
>  index 3 is out of range for type 'u8 [2][4]'
>  Workqueue: phy0 rtw_watch_dog_work [rtw88_core]
>  Call Trace:
>  <TASK>
>  __ubsan_handle_out_of_bounds+0xdd/0x120
>  rtw8822c_phy_cck_pd_set+0x33c/0x510 [rtw88_8822c]
>  rtw_phy_dynamic_mechanism+0x310/0x330 [rtw88_core]
>  rtw_watch_dog_work+0x217/0x330 [rtw88_core]
>  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4410:24
>  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4413:30
>  WARNING: .../rtw88/rtw8822c.c:4364 at rtw8822c_phy_cck_pd_set+0x322
>  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4422:20
>=20
>=20Return early when bw is out of range. nrx comes from a 2-bit field an=
d
> always fits the second dimension; it is checked as well so that both
> indices are validated before use. The chip is already unusable at that
> point; this only stops the driver from corrupting its own state.
>=20
>=20On the machine below, every boot with a chip failure logged these
> reports together with the WARN_ON(): 17 boots between 2026-10-18 and
> 2026-11-02 on Ubuntu's 6.8.0-147 kernel, and 3 boots on 2026-11-04/05
> on 7.0.0-42. Boots without a chip failure logged neither. With this
> patch applied to 6.8.0-147, 5 boots with chip failures logged no UBSAN
> report and no WARN_ON().
>=20
>=20Seen on an RTL8822CE in an ASUS TUF Gaming A15 FA506IU whose chip
> intermittently drops off the PCIe bus.
>=20
>=20The problem was found from the UBSAN reports above. The analysis, the
> fix and this message were written with the help of an AI coding
> assistant (Claude Opus 5.5 by Anthropic), then reviewed and tested by
> the submitter as described above.
>=20
>=20Fixes: 479c4ee931a6 ("rtw88: add dynamic cck pd mechanism")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zeshan Ahmed Nobin <zeshanahmednobin@gmail.com>
> ---

This is a lot of testing data in commit message. Are you sure all of
it is necessary or maybe big chunk of it can be moved under ---, so
commit message stays clean?

> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/ne=
t/wireless/realtek/rtw88/rtw8822c.c
> index 09315d23e2c4..a29611ff248d 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -4406,6 +4406,13 @@ static void rtw8822c_phy_cck_pd_set(struct rtw_d=
ev *rtwdev, u8 new_lvl)
>       nrx =3D (u8)rtw_read32_mask(rtwdev, 0x1a2c, 0x60000);
>       bw =3D (u8)rtw_read32_mask(rtwdev, 0x9b0, 0xc);
>
> +     /* cck_pd_lv[] only has entries for 20 and 40 MHz. A chip that st=
ops
> +      * responding on the bus reads back as all ones, giving bw =3D 3.
> +      */

We do not use this style for comments anymore. Current style is:

/*
 * text
 * text
 */

> +     if (bw >=3D ARRAY_SIZE(dm_info->cck_pd_lv) ||
> +         nrx >=3D ARRAY_SIZE(dm_info->cck_pd_lv[0]))
> +             return;

As far as I can see the nrx part can never be true, since nrx is a two bi=
t
field and cck_pd_lv[0] has RTW_RF_PATH_MAX entries. The commit message
says that too.

The array where nrx seems to matter is rtw8822c_cck_pd_reg[], which only
has entries for nrx 0 and 1. For 2 and 3 the rows are all zero, so
rtw8822c_phy_cck_pd_set_reg() gets past its WARN_ON() and does a read
modify write of register 0x0 with a zero mask, with __ffs(0) in

        rtw_read32_mask(rtwdev, 0x0, 0x0)
        rtw_write32_mask(rtwdev, 0x0, 0x0, pd)

With all ones from PCIe bw is 3 as well, so your check catches that. But
on USB a failed read returns whatever was left in its usb_data[] slot, so
if I read it right bw 0 or 1 with nrx 2 or 3 is possible there once the
device stops answering.

That is not new with this patch. But since nrx is checked anyway, maybe
check it against the two entries rtw8822c_cck_pd_reg[] has for each bw,
or drop the nrx part if you want to keep the fix to bw only.

Best regards,
Luka Gejak

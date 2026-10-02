Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519DB427FBB
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790925829; cv=none; b=LilqBRfkiNdYwTm1G6K1pg5IJMI+Ca3yLscHAUY/hMTXqQ3op3Eewy+KJCSTOtaT6bT4XWniY3ANxDRn+HqREzwKXOqiloCTSmzSAoX6SQG2/URcsjfMg2Pe7xB7orKZbwwATby0BMB6E0/ucsoYWHqlYGWw7V/YNjfpFmELzWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790925829; c=relaxed/simple;
	bh=aehX07tXcClaa0qrFr7rI9C7ikNEWSssO6nsmHIatUQ=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=TBqmn55eDlSQQ3h/iJJe6nSzilGwuYbqBbjdLEmzDGPAKOUmtiAD18jz+jrlbIxokMMRtQY3W7Mr0mHI3L6IQ7aRE3FlU96R4hwZ4aeoUeBcZX7W1Z0QTMTXZut9OvuW4xUGuM/iS+pXrcZVAUBMdsf94Huo2z9pw9ondOWhvV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=isP/iQu7; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="isP/iQu7"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aehX07tXcClaa0qrFr7rI9C7ikNEWSssO6nsmHIatUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790925816; v=1; x=1791530616;
 b=isP/iQu7FuYOBT9ByB+d2ubcLBvN30xxqoO4r52UG/8rVGmRFgiw7P98RphTSshplNkz4v5e
 pRJ15KHQ/Ljj63JQbVuhGPG448tRhC7fV6OWakHaHeEAYf0hJK8Ynw/LwEaqN729lwhRvDY5OiJ
 7dUsVnFbTXarhT37ajA1rXi4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 21994e6c724f157f;
	Fri, 02 Oct 2026 07:23:36 +0000
X-Mizu-Trace-ID: 21994e6c724f157f
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 02 Oct 2026 07:23:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a2b6f0773b075286fedf0014fd5b6634d3a5ec2e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v6 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <10b9f8b9-87e1-43c9-8c15-27f5475f5f09@gmail.com>
References: <20261001091835.67909-1-luka.gejak@linux.dev>
 <20261001091835.67909-5-luka.gejak@linux.dev>
 <10b9f8b9-87e1-43c9-8c15-27f5475f5f09@gmail.com>

October 1, 2026 at 22:39, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mai=
lto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821cer=
fe2%40gmail.com%3E > wrote:


>=20
>=20On 01/10/2026 12:18, Luka Gejak wrote:
>=20
>=20>=20
[...]
>=20>  +static void rtw8723b_sdio_restore_pad_ctrl(struct rtw_dev *rtwdev=
,
> >  + bool keep_pta_owner)
> >  +{
> >  + u32 before;
> >  + u32 after;
> >  +
> >  + if (!rtw_is_8723bs(rtwdev))
> >  + return;
> >  +
> >  + before =3D rtw_read32(rtwdev, REG_PAD_CTRL1);
> >  + after =3D before & ~(BIT_LNAON_WLBT_SEL | BIT_SW_DPDT_SEL_DATA);
> >  + if (keep_pta_owner)
> >  + after |=3D BIT_PAPE_WLBT_SEL;
> >  + else
> >  + after &=3D ~BIT_PAPE_WLBT_SEL;
> >  + if (after =3D=3D before)
> >  + return;
> >  +
> >  + rtw_write32(rtwdev, REG_PAD_CTRL1, after);
> >  +}
> >=20
>=20Is this function still needed if rtw_mac_pre_system_cfg() doesn't
> touch REG_PAD_CTRL1?
>=20

Not=20needed anymore, I missed it. It and its call sites are removed in v=
7.

> >=20
>=20> +
[...]
> >  +static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
> >  + struct rtw_tx_pkt_info *pkt_info,
> >  + u8 *txdesc)
> >  +{
> >  + struct rtw_tx_desc *tx_desc =3D (struct rtw_tx_desc *)txdesc;
> >  + const u8 *data =3D txdesc;
> >  + int words =3D 32 / 2;
> >  + u16 checksum =3D 0;
> >  +
> >  + /* Unlike the shared 8723x helper, the checksum is not inverted he=
re. */
> >  + le32p_replace_bits(&tx_desc->w7, 0, RTW_TX_DESC_W7_TXDESC_CHECKSUM=
);
> >  +
> >  + while (words--) {
> >  + checksum ^=3D get_unaligned_le16(data);
> >  + data +=3D sizeof(__le16);
> >  + }
> >  +
> >  + le32p_replace_bits(&tx_desc->w7, checksum,
> >  + RTW_TX_DESC_W7_TXDESC_CHECKSUM);
> >=20
>=20This function can just call fill_txdesc_checksum_common() from tx.h.
>=20

Thanks, I didn't catch it. It does call it in v7.

Best regards,
Luka Gejak

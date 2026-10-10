Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E074B1B56
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791658170; cv=none; b=D0TKkRG9Sp5+f7JqaqJbffz6KgAKRxK7jiuK0Xqx3RCe/MI2wWEe+b83vl4m42HR3Biv3JEL5EUF411qPu4Qd+rKU2YtAJQoahsFXIpN0N1b5G0RakpMhrI8tNXyHiVjNfNbabt/DfthClMdE6EbTXF1zhxdCEjQ4ZsE0wTjY7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791658170; c=relaxed/simple;
	bh=59xR7YicHokBXXvN6W/dHs+mzVmTpBwAzmF0DeSU7cI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=nydQE9eyVIQ7FKoCweu/WfXS2QHd5H0DoT8xoKIdeGfg6dzDEWovQ2+LgwALqIlv72MyFPoKV4dYIgV6ibn45udmZq1kPy8ZfLkpzhrheUCNZpB7p1tXS6qEdyITpWFm4tSWo8rutkUon7E6m7RAc3vjIeF1yypy98v0FZFuAUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MFCqN9st; arc=none smtp.client-ip=95.215.58.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MFCqN9st"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=59xR7YicHokBXXvN6W/dHs+mzVmTpBwAzmF0DeSU7cI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791658167; v=1; x=1792262967;
 b=MFCqN9stPmnWorJwLqbFsSMKqLcwuTAbiwkbETUyxNr5jcJvHvD3S3Ur9P0AMwxr03SRRmrd
 YbrRGmybHJ8IdkrrAIKmXxif80r4+LLluBm97SdoCg3qpEzG1KYzwd3rVHu2bWEWpQiT+Tof9/2
 yqO7y8Luaf0qvAGQCoNNs2xA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0a7d148c83b72ea6;
	Sat, 10 Oct 2026 18:49:27 +0000
X-Mizu-Trace-ID: 0a7d148c83b72ea6
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 10 Oct 2026 18:49:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ef27f9a98d8e15b43d07d76d1772f9c1188d8809@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 fiona.klute@gmx.de, kvalo@kernel.org, "Hungyu Lin"
 <dennylin0707@gmail.com>
In-Reply-To: <c6cefedd4c0c92dd3530d6f585e021ceca5d354f@linux.dev>
References: <20261010183629.39748-1-dennylin0707@gmail.com>
 <c6cefedd4c0c92dd3530d6f585e021ceca5d354f@linux.dev>

October 10, 2026 at 8:48 PM, "Luka Gejak" <luka.gejak@linux.dev> wrote:


>=20
>=20October 10, 2026 at 8:36 PM, "Hungyu Lin" <dennylin0707@gmail.com> wr=
ote:
>=20
>=20>=20
>=20> query_phy_status_ofdm() divides the SNR report by two when filling
> >  pkt_stat->rx_snr, then shifts it again when updating dm_info->rx_snr=
.
> >  This halves the SNR used for diagnostics and average statistics.
> >=20=20
>=20>  Store the raw report in pkt_stat->rx_snr and convert it only when
> >  updating dm_info->rx_snr, as the other chip drivers do.
> >=20=20
>=20>  Fixes: 61a486bcd782 ("wifi: rtw88: Add rtw8703b.c")
> >  Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> >  ---
> >  drivers/net/wireless/realtek/rtw88/rtw8703b.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20=20
>=20>  diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drive=
rs/net/wireless/realtek/rtw88/rtw8703b.c
> >  index 25456f0367b2..1920277d626f 100644
> >  --- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
> >  +++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
> >  @@ -959,7 +959,7 @@ static void query_phy_status_ofdm(struct rtw_dev=
 *rtwdev, u8 *phy_raw,
> >  val_s8 =3D phy_status->path_agc[RF_PATH_A].gain & 0x3F;
> >  pkt_stat->rx_power[RF_PATH_A] =3D (val_s8 * 2) - 110;
> >  pkt_stat->rssi =3D rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
> >  - pkt_stat->rx_snr[RF_PATH_A] =3D (s8)(phy_status->path_rxsnr[RF_PAT=
H_A] / 2);
> >  + pkt_stat->rx_snr[RF_PATH_A] =3D phy_status->path_rxsnr[RF_PATH_A];
> >=20=20
>=20>  /* signal power reported by HW */
> >  val_s8 =3D phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
> >=20
>=20Mind explaining why did you resend this?
>

Ignore this email I misread the driver name.

Sorry.

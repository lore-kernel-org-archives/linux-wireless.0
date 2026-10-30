Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377385;
	b=2uW79XF7364sUoru9sFDB/bE+xDSyJlTs+FbenpO4zjy0bEnURP3oDaRros8zer0+MwW
	 XgE4BB4ozmY1BTFge6nph2M1zwkPvL/t91uIJhuZRy5/8IbSBp1Q9YXWogRtLH7e0AesQ
	 v54gei2E8I5ezqQ9hdToS9+kDoDvkn382BjGMwr+Gp5TmeifAhj0Y6IJAM+5xMElEyWxX
	 NZ/Kn1OdY6TanzMz9+YxWQwhyU6DPRy7x7UrbeCmNfxYanDMV2zsp8tVDUP01sA1m32lM
	 ZdZzDokw1iWrPUCW223sRF9poEty63I4pYT6cXxm7hkNcErCkQQBHpNCC/hWL9B+slQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377385;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=NUAlT/mfqIGpNEfFOjDdTkobzVzrPdeXJsRuK6pgwqw=;
	b=WZQ6PQ5wq1p4j0IQwTShRPxyDSwoewsRhFsR9AaYNOuygW095atjTvdz5kCuClFttckq
	 u6ZbypISCAbFZ3qz/S2dXKmfhNaA4CCFpclgLDu9APKihfVeJOXuYHYEQEnQrB5qnmE6h
	 m4j1p5kIqfrYce5vagsjPjJE0DTc+UkhE/oSX25JIy8HOespioc0dZDLeA4z779Eb7UBP
	 FQthmxbPYnD2ZcTUDaQwioqP36uVqDz7j4v5ITDmkkz28lEMlXD9CnV9i0OyaPDFSvY1m
	 EAy9wYzskG7iRyXbCMtc5ix9fJaVHdKJlMj8s3sOwlxN4prFh7dTXhbNbOCuk/GTvsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IZzRfX1A;
	arc=none smtp.remote-ip=91.218.175.250
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53410606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 16:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53410606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IZzRfX1A
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=USiWebNAZxwrsn3gPO+qaXyNBHhXDNdUkPKJ8DQ/5Y4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793377381; v=1; x=1793982181;
 b=IZzRfX1AmJLqcrQdUzs2Cl8zaJhzUrvU2u0a/DDN9lJOiGu0286T6QhQ0mfNIwKYBVAlzVKK
 BNR+J7awoeUu2L9c9LwUuru7q4yQbA/EvvgqZ/duf9FbLLEl51LvgKeJipbmjGqBhb7rRPBpV4c
 rpRwilY1lePXMuNv5RXZmECc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aa47b306ce4c97cd;
	Fri, 30 Oct 2026 16:23:01 +0000
X-Mizu-Trace-ID: aa47b306ce4c97cd
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
Date: Fri, 30 Oct 2026 16:23:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <6a4c37826646abbf833e49aadee7701a3dd4e96a@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v9 3/3] wifi: rtw88: time the countdown
 downloads from the TBTT
To: "Mehmet Fide" <mehmet.fide@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261026152940.1274382-4-mehmet.fide@gmail.com>
References: <20261026152940.1274382-1-mehmet.fide@gmail.com>
 <20261026152940.1274382-4-mehmet.fide@gmail.com>

Hi Mehmet,

Looking at this patch again, I found something I missed on v8.

October 26, 2026 at 4:29 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:

> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wire=
less/realtek/rtw88/fw.c
> index 2d81aaeed0d7..9ba4f1c244ec 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c

[ ... ]

> +static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_=
vif *vif,
> +                          bool start)
>  {
>       u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +     u64 tsf =3D rtw_fw_read_tsf(rtwdev);
>       s64 delay;
> +     u32 rem;
> +
> +     if (start) {
> +             div_u64_rem(tsf, interval, &rem);
> +             rtwdev->csa_tbtt =3D tsf - rem + interval;
> +             /* a TBTT just passed may have sent the first count */
> +             if (rem < RTW_CSA_TBTT_MARGIN_US)
> +                     rtwdev->csa_tbtt -=3D interval;

As far as I can see, the TSF is only read here once the whole page
download and the H2C are done:

        rtw_ops_bss_info_changed()
          rtw_fw_download_rsvd_page()
          rtw_send_rsvd_page_h2c()
          rtw_fw_csa_start()
            rtw_fw_csa_queue(rtwdev, vif, true)

You measured about 3.3 ms for a download on USB, and on PCIe it is just a
DMA and some register polling. So most of the 10 ms margin lies before
the download started. A TBTT there sent the old beacon, but it is still
taken as the one that sent the first count, and with the usual beacon
interval the work replaces that count before it is ever sent.

With a count of 2 the first fetch already carries count 1. So if I read
it right, the work then finds ieee80211_beacon_cntdwn_is_complete() true
and calls ieee80211_csa_finish() before any beacon with the CSA element
went out. Before this patch the first work ran a full interval after the
download, so the count 1 beacon went out first. With bigger counts the
first count just gets lost.

Could the TSF also be read before rtw_fw_download_rsvd_page(), so that
only a TBTT after the download started is taken as one that may have
sent the first count? Maybe this could also be checked on the 8822CE
once it arrives.

Best regards,
Luka Gejak

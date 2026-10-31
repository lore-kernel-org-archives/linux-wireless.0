Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430614;
	b=4r1ueYkuJELxr+tycswQ67T+Z9sSS8RBJCob3yyMNXVrXZDZaSRuBL5wUuCxeHx0w+ll
	 9SiM41GrV4qjKXc6OUopyWMlCjiQ+Vf9ThJG/r9vSDHSIVPuAKdOn9W5yMTXZQxhOIwzc
	 pwJlPzLF3P2yI08ZjPm+j0EK+J4xsHjrkVzgsWeBQBCP8SZOB4IypZAULxDq6iD2CiyYI
	 UjmCZhxcFfLgOsS6iqtFEsTrhj+iOVOr0fxlLP971vNy8QpetqLmDAnwfJ9Zxq+qYxJiY
	 ndZ1ju/z6mkvyksZYnAvwz34+13EBuWLYQHlrJDulInUWaV9ODfyswZ5fb95iQBs74g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430614;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=eAVXvX87/WHUUPKyFhZm2Litd8Z6ldBOAQDaY4yqNK0=;
	b=dNVxK8wcytbaxPN3Ns2gQuY+z1WZdFYF9pZyG+Io8TzB9Gfgo4Sf4MndtMViWZXKjfNr
	 NYRoSTEUqn1yzRZEA6pgcl4dOept9kUyji6SSG6sjX9PjUJptVjAu+Z5iMkKWT3jsUbxn
	 ECPU4eYoOfuAIsEWIngL6yvMWdVled98thk/27GVKwx2HXvHwe5wdqK+uTA25kA6dn69n
	 bQHe1fz2LaiorqbJYh0BcJa00v0isqQHGgz1pQVfVFanoRiQSN+jmDUkyFcv8wRjDPEj2
	 PTUe7hDDD9beMUgQtg/uI6MCy9YmHK7bBXMpPLzVD4FPUwJCPN0Yks+IiRkDVQWF8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rpNaKFP4;
	arc=none smtp.remote-ip=95.215.58.108
Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569DF606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 569DF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rpNaKFP4
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wvbry51m2Qi/h9hHY19EI1iXWYMaXF6j4XqIDZq5JTc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793430611; v=1; x=1794035411;
 b=rpNaKFP4bjYcyefv4auE07Y1m0PUE9KACGpGYQ112whRyBVYvNw38e+ametxu7P5PZDB87YH
 rINQtZkiJbl8dwMTk+SGAP14PezK0Xmv9vh2bO3s99k4eX+y3eNX+uOmzqBub8kYjxYwJJ1iO0i
 YwSvfRaOkkqUPt1l7M/j1qzg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 86eb064c1a62eea8;
	Sat, 31 Oct 2026 07:10:10 +0000
X-Mizu-Trace-ID: 86eb064c1a62eea8
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
Date: Sat, 31 Oct 2026 07:10:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <aa2500ed53d315edb7d6622dac3350fdd92b879b@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 2/4] wifi: rtw88: sdio: Track running state
 and cancel TX worker on stop
To: "Alastair D'Silva" <alastair@d-silva.org>,
 linux-wireless@vger.kernel.org, "Ping-Ke Shih" <pkshih@realtek.com>,
 "Kalle Valo" <kvalo@kernel.org>
Cc: "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Jernej
 Skrabec" <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 linux-kernel@vger.kernel.org, "Alastair D'Silva" <alastair@d-silva.org>,
 stable@vger.kernel.org
In-Reply-To: <20261031033526.474710-3-alastair@d-silva.org>
References: <20261031033526.474710-1-alastair@d-silva.org>
 <20261031033526.474710-3-alastair@d-silva.org>

Hi Alastair,

Thanks for the new version. One comment below.

October 31, 2026 at 4:35 AM, "Alastair D'Silva" <alastair@d-silva.org> wr=
ote:

> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wi=
reless/realtek/rtw88/sdio.c
> index e39284b71837..253467250ee6 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c

[ ... ]

> @@ -1069,20 +1072,38 @@ static int rtw_sdio_start(struct rtw_dev *rtwde=
v)

[ ... ]

> +     sdio_release_host(rtwsdio->sdio_func);
> +
> +     queue_delayed_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work=
, 0);
>
>       return 0;
>  }

I brought up this rearm on v6, but looking at the callers again I think i=
t
may run a bit too early. rtw_sdio_start() is called from rtw_power_on(),
so the worker can start on whatever is parked before rtw_core_start() is
done with the device:

        rtw_core_start()
          rtw_power_on()
            rtw_hci_start()             <- worker queued here
            rtw_fw_send_general_info()
            rtw_coex_init_hw_config()
          rtw_sec_enable_sec_engine()
          set_bit(RTW_FLAG_RUNNING, rtwdev->flags)

The parked frames got their TX descriptor in rtw_sdio_tx_write() before
the stop, with the macid and sec type of that session. So if I read it
right, after an interface down/up or an idle IPS cycle they can go out fo=
r
a station that is gone, and maybe even before rtw_sec_enable_sec_engine()
has run. Resume from WoWLAN looks similar, rtw_wow_stop() starts the
HCI while the WoWLAN firmware is still loaded and rtw_wow_swap_fw()
follows right after.

PCI drops what is left in its rings in rtw_pci_stop(), through
rtw_pci_dma_release(). Maybe doing the same here would be safer, purging
rtwsdio->tx_queue[] with ieee80211_purge_tx_queue() and clearing
tx_queue_stopped[] with a wake of those queues, instead of the rearm.
What do you think?

The stop/start cycling in the cover letter was also run on 7.2.10, where
tx_handler_data->work is still a work_struct and the 8723BS HISR mask is
not there yet, so I guess the board ran a backport. Was this version run
on the board as posted?

Best regards,
Luka Gejak

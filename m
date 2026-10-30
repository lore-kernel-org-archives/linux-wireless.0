Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377134;
	b=3A5kZh20zFsWGRrPzMHTYfDJo0d6K4UlcRxjFFhiabay1viHT2xHBBtGs6L+9zqzVZ0J
	 UiJ5r5qJzDf5CSKCn10Gk1qE9SBCMiFuWdfLr7bVuiqGnMRiLbswGTxJbGvpiX3CtXwBP
	 HmsMtXF4CCb82IzKsUdwSL83fXCW1/MxQxFtuwZxpZP9MUsAiGNWY/p4CR0GPlcCRcBDe
	 a86AoDbd8Nn/NAxa/GJfHSZGuOclgzUyiUbtB8MUwnBkvryPzxlA8B5iEjatQdTb2Ohvz
	 A0/yx5MgICRR31YfNYUGEkhnwLfi2/zTD4c6fBQCvbsoBhcN6y0SmC2Lpwx02MdYEwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377134;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=w6CRK9ZUQ9vY+TEjuQM4awYsJbBCzkCJTbebWH8tG9g=;
	b=BkN4OatScgAZUTuWqo+ZWbeofcO8Nh2NbqfOXjE7ifxCFxV728Zy64cdQUYMavR3y9z0
	 fzHP5ObYtZh0cITAIxhytBqF41U+BXsLK0AnTLMV/H1kFiZGHRADTUf2MjCOyaX16O+ZZ
	 tagv4WBxCf5a+cMBg3QiorcTHimLS5uvS4OrpDW1KGTCSkLvIcJC9VBPFY9dc2BNaHEKf
	 cdy4xvuG//bZLIYgRwMkiqfI/qX/+s/5hx3+dLoTSrQZYt4WD8ZnoCF+4nxwAFCwL4y29
	 f7o+sTLplpdCOcpeNq+/ztT8LpyaVE2w4fyn3IZwODNR5JDlHDH51CpmPs7wxnrmMMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NfnmNoSB;
	arc=none smtp.remote-ip=91.218.175.183
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3499606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 16:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3499606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NfnmNoSB
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H5S0RJ0v3v5oHlSSsOKqjycgN8Yi0MBUBxD1R/NF83U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793377130; v=1; x=1793981930;
 b=NfnmNoSB0rQ3xWv4zpSKl2CYXdCFbGkX+AYYBistGl0beAexPhiqo0r9PvNjgi+r2+hQ1ENv
 BtOCWzOdLsqTzK8njs6C+ZXD2U3E4wcBdPY0JPsb6XrsxrXVkCgk/I64+kLqdqOnyfHn+xHRNoY
 IfXI92cX+n50+XDQON2DpLgo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8a5ed25ab98c0f46;
	Fri, 30 Oct 2026 16:18:50 +0000
X-Mizu-Trace-ID: 8a5ed25ab98c0f46
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
Date: Fri, 30 Oct 2026 16:18:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <7ea86f5208f259f01ce8c18b7701f2a3e41e0fca@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v9 2/3] wifi: rtw88: support channel switch in
 AP mode
To: "Mehmet Fide" <mehmet.fide@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261026152940.1274382-3-mehmet.fide@gmail.com>
References: <20261026152940.1274382-1-mehmet.fide@gmail.com>
 <20261026152940.1274382-3-mehmet.fide@gmail.com>

Hi Mehmet,

Thanks for the v9, the resume part looks good to me. One comment below.

October 26, 2026 at 4:29 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:

> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wi=
reless/realtek/rtw88/main.c
> index 0f23498b5c96..48e8cad221b9 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1550,11 +1550,13 @@ void rtw_core_stop(struct rtw_dev *rtwdev)

[ ... ]

>       clear_bit(RTW_FLAG_FW_RUNNING, rtwdev->flags);
> +     rtwdev->csa_vif =3D NULL;
>
>       mutex_unlock(&rtwdev->mutex);
>
>       cancel_work_sync(&rtwdev->c2h_work);
>       cancel_work_sync(&rtwdev->update_beacon_work);
> +     cancel_delayed_work_sync(&rtwdev->csa_beacon_work);

I think there is a small window here that can leave a countdown stuck.
In the firmware recovery path this runs without the wiphy lock, so a
channel switch waiting on the mutex can get it while it is dropped here.
If its rtw_fw_csa_start() queues the work before the cancel above, the
work is cancelled but csa_vif stays set. The BSS_CHANGED_BEACON replay
after the restart then returns early, since csa_vif already matches, and
the countdown never finishes.

Maybe clear csa_vif again at the end of rtw_core_stop(), once the mutex
is taken back?

Best regards,
Luka Gejak

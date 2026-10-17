Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBAD48097B
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233682; cv=none; b=QPxoGDt5KEcryzyswmFkNr/YVB2Xbt5E0V8Rp5rWFneRQoUchk9ycpqX/wEEgVNiYJ6UikPVkeBslXi5JltQOYCYBqe9KeuYern0hO2pMxDUTEbI2kVeLvhCzhdtZJMLiST/OpXwVYwuNqzZxw5mH/P12ojKnH4KpbbZEz+n9IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233682; c=relaxed/simple;
	bh=hW7ilkepWpkuj0rIHYQhV3XIofFcnCk//ZuxPfk0BmI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=M+3ZnBSV5AdtXOx7f0Ii4j7OaGBIwzdyxADhYh3JBVTE1qqXRHD9nTZ6ceGFPWeESstMpqYKuue+Q3go04PVBGA/YG3SfJhdDCbHhm4hs0kN5iE9qo4j1bRTjjWT2oJ6yPGrSaoDnG4+/E7jI0s7gyPeFxMAEMWxge+kWvcqmbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ohxBPIfY; arc=none smtp.client-ip=95.215.58.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ohxBPIfY"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hW7ilkepWpkuj0rIHYQhV3XIofFcnCk//ZuxPfk0BmI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792233677; v=1; x=1792838477;
 b=ohxBPIfYl/wrqAJ9F2+OytEK6bbeNKpVw24c+k4clLpRYJE5KQXLR7V/D14/ezyiiJCuaEWI
 6VFqpPSbPn0B/Alxo7gi12CMcDBXU7KHzM/EbofGioobMEpPPUjWz9XwKOfaIWlQ8774aVdWEmr
 66iz5ggS/51H+pCtb4FPrRew=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3011c513a0b9dcab;
	Sat, 17 Oct 2026 10:41:17 +0000
X-Mizu-Trace-ID: 3011c513a0b9dcab
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Oct 2026 12:41:16 +0200
Message-Id: <DM71TCO0TBZI.1W7JBUVH0CMG7@linux.dev>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Carl Quist" <equalizerjr@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261016214105.255517-1-equalizerjr@gmail.com>
In-Reply-To: <20261016214105.255517-1-equalizerjr@gmail.com>

Hi Carl,

On Fri Oct 16, 2026 at 11:41 PM CEST, Carl Quist wrote:
> Allow 8723d to operate a station and an AP interface concurrently, using
> the combination already enabled for 8822c: one station plus one AP on the
> same channel.
>
> Without it, the AP interface cannot be brought up while the station is
> active (hostapd: "Could not set interface ap0 flags (UP): Device or
> resource busy"), so an RTL8723DE laptop cannot share its Wi-Fi
> connection.
>
> Tested on RTL8723DE [10ec:d723], firmware 48.0.0, kernel 7.2.5, with
> hostapd 2.12 on a second (AP) interface with its own MAC address:
>
> - the AP ran beside the associated station on 2.4 GHz channel 1 (HT20)
>   for about four hours and served a smartphone client;
> - the AP was started and stopped repeatedly without affecting the
>   station;
> - with the AP running, the station was disconnected and reconnected
>   four times; it re-associated within one second each time and the AP
>   stayed up.
>
> Assisted-by: LLM
> Signed-off-by: Carl Quist <equalizerjr@gmail.com>
> ---
>
> Notes:
>     An AI coding assistant (Claude Opus 5.5) helped investigate this, wri=
te the
>     change and run the tests above; I reviewed the change and tested it o=
n my
>     own RTL8723DE laptop.
>
>  drivers/net/wireless/realtek/rtw88/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wire=
less/realtek/rtw88/main.c
> index 0f23498..c64a3ba 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2299,7 +2299,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct =
ieee80211_hw *hw)
>  	hw->wiphy->max_scan_ssids =3D RTW_SCAN_MAX_SSIDS;
>  	hw->wiphy->max_scan_ie_len =3D rtw_get_max_scan_ie_len(rtwdev);
> =20
> -	if (rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8822C) {
> +	if (rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8822C ||
> +	    rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723D) {
>  		hw->wiphy->iface_combinations =3D rtw_iface_combs;
>  		hw->wiphy->n_iface_combinations =3D ARRAY_SIZE(rtw_iface_combs);
>  	}

Where does the AP beacon fit in the reserved pages?

This chip has 8 pages of 128 bytes, while rtl8822c has 16, so the 8822c
never had to squeeze a beacon in next to the station pages.

A station vif always adds five reserved packets in
rtw_add_rsvd_page_sta() and each one is counted after
rtw_fill_rsvd_page_desc() adds the 40 byte tx descriptor. Four of them
take one page, rtw_lps_pg_dpk_hdr is 169 bytes and takes two, so 6 of
the 8 pages are gone before the beacon is even considered. The beacon is
first in the list and its descriptor counts too:

		total_page +=3D rtw_len_to_page(iter->len + tx_desc_sz,
		                              page_size);

That leaves 2 pages, so the beacon has to stay <=3D 216 bytes. Past that
rtw_build_rsvd_page() fails with "rsvd page over size" and
rtw_fw_download_rsvd_page() returns before rtw_download_beacon() runs.
rtw_ops_bss_info_changed() ignores the error, so hostapd thinks the AP is
up but no beacon ever reaches the firmware.

I ran this on an RTL8723DU with your patch applied. A stock hostapd WPA2
beacon came to 188 bytes and 28 bytes of extra IE still fit. At 29 bytes
the driver logged "rsvd page over size: 9" and "failed to build rsvd page
pkt" while hostapd still reported the AP as enabled. Scans still list the
SSID because probe responses go out over the normal path, so the failure
is easy to miss.

A longer SSID, WPS or a vendor IE all add bytes to the beacon, so this is
easy to reach in everyday usage.

Can the station pages be trimmed while an AP is present, or maybe this
combination should only be used on the chips with the bigger page budget?

Best regards,
Luka Gejak

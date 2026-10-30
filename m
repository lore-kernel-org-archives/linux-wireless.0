Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372283;
	b=xQBIJ6lWU4HUT9hukeOn1TsiGZfUThsVPwFyg6X8V7agcu1Uv3kiyJzowxBbO2P9b90z
	 ok+FCaHIxDQuRGqgzHQQZBjRTMPY/Ru0f1WlhCLnOF78coEFg57rMbI2opeDzn27FXkSp
	 RDty5cMVVXX+g6x5efw14cTO568eXEHPyc8FFL1yjYpP0xeey1vLkO1CvW6djxzXZc6cB
	 RDUCvBla3NM2nyFP290qm7p9DFNuYZ0lgptA2Q/KdJiQAhKR/y+eh56nMObTIQoQUDIwE
	 pkM626R70oZjWUqL/9qMh9va58jW6f0shlC/U0DT2aCQ0oRSz+MEufFF37nAUR459GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lMYFM+Zt1gqiegJOnl2VwohuI1862HHbUPjpxG1xRl4=;
	b=qujiWaVLS10duh2HuKX4/fiFMJ8YKG2xpBB2dc90wo9a2NTsPeYbtlJtY3IisQVN+VNm
	 pHiWhFqpowu5JHhBKs+aYJJMUjm3hUJxI2cwka1S3fUnc2iH4n3VEfdanUMhHk+d0lSWc
	 wjvSTk5cjcANRCZ82yICiqpcsXRjsbr8e0rPzEUGMxb00rhvu0SvL9U3NHjg+8V0qYWQB
	 +UH382NpHUY6ccNP3cfLQ4+QpCIKtiC+kUQGPdY4dkNPMWrd65bHY5PhfNk7CBueLBevQ
	 IF2SeFcmX+fAm3XdvhVK1ve0zfTIoMpds9bebaPyYMKlx2EQ2eaQXMLPHBCm0frIemg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NCEae3Uv;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36A1606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D36A1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NCEae3Uv
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c5358fc28so639051f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 07:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793372281; x=1793977081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lMYFM+Zt1gqiegJOnl2VwohuI1862HHbUPjpxG1xRl4=;
        b=NCEae3Uvyd7Z3IqVsQ8hSThCxIDkwGDNeZAB7pAPdjvalYGkwSVX4t43zR50RkLTHo
         5ELlKN3zIsbfJxxDOl/wrjbEUBb2UAW+QM10f2uwi+P9VerwegkKl6TQDGBrQMIE56yC
         4O6f4SnuQw2WP+SVtw54EqSBDOW63Q4XynHnhEIEGMIM+jYNJP1vSFFcvpgFfjnMH6pc
         eU9eUt5NUhDzg72nvSX4BhG+4Mkh3AkTPqQo+hoDaBm/Rqv6EZZtS8rlDZTBnUi/qM4E
         9ON9DfteroorxasDnu4z9PF+OckJGEiOrDjWSpREAH4RaFhei2gkfTCCfvmymS2CtAaJ
         +tSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793372281; x=1793977081;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lMYFM+Zt1gqiegJOnl2VwohuI1862HHbUPjpxG1xRl4=;
        b=1VKa5VmxsrGZs5eIRQ9wKvhaBQJmA4nprjD/6ArVuAR7bYJ6z2BL4krQcBeOVnad06
         UBFTVxNWMrtwGHn/2JgtAaiQe57JNwWPgKx0Qix7H6lgQQE5p/V9xP5xeu0x/fRL7Or1
         xHzaMJWCcLB9n6Bwely7cDS2XP8KLfXEj8ruy7BIrm438roVwpk5d58zglowrjzdmGuK
         ZGrAeDXqzPexuwOy8B6K4OSniZSdjWcAFJEdXpKRETJZXM3XXYnu1RBkmMfZPyFABdDK
         it91NLWcDcr7nzpkyTvfZB30QyrA8Z1yw16ECZ5kOt5sCsvCjEDNc52fN2DSIO0XfM7X
         8MtQ==
X-Gm-Message-State: AFq9FYJIq59iqSsIlItW+neyy4a8vOgj68/nGuFV1DYNu325Xt9AF7Ti
	Fr0bgDZvTqrdxZvm2t7cglxvTLvwIIVezjwDCXlTdNx2GC/3El4sFr07oso+xA==
X-Gm-Gg: AYBFou2csFAAXLPY5eigO8+uzYu9DbiuojI7MbBYe6Vi4owE1NEi+Fjg46iWfQh0Kfb
	i5Y4ygryJvDdKljdSnOa5XN+zq5fl/t8QRDl/n4yr9CI4xmXk9iZuLHncrUzsBclrTI2Xr3Lu2B
	EQkhHj4hKLYw4JONtZBeM0Sg8baeGcuEgHw3JoyGuW1yHx3Gdo6INK5WR+t6YAfz0uCBgjkBla4
	mb2bRzQOl+v4FoifSajgrxtMjfRDU0BgoiwfcaGWEKACdexHQ8njPW6VXl610s3O/lIdpk0ZTVe
	3XnG81jmG4LjdIv2O8BNLnreOIre9tIMnX2QD67UTD1gVabxqmb7pWvBsTKpdYyno+OMlsRrtWR
	0pCOVC3Guo4uVehx7JOiV/XE2yZoY5Pev4OJp5qQtD/YMLhLDUmSk/oIfXVnS4QyR3JU+6OVPUo
	6fk/C9/6prAQ+Qvv3q/F5936MFoN2oNh6xq6ajKHJG++9g2jQdd2B5PBuNE3n6X+OpRSVXfHneU
	7dnlL3b4h28d+wWs94BjYVdErA7dWCVHGjFrUgowXf+GPYfx//s8G/1S3eqNO3sFwFOY1AIUQIY
	11fU3hN8efLv8dj4jZmFMjrMq4X/GKXYhN/U
X-Received: by 2002:a05:6000:47ca:b0:48e:7508:bbf8 with SMTP id ffacd0b85a97d-48e7508bd71mr1134504f8f.27.1793372281051;
        Fri, 30 Oct 2026 07:58:01 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8e5f4sm3723638f8f.40.2026.10.30.07.57.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 07:58:00 -0700 (PDT)
Message-ID: <15240b8b-31f0-4587-a7a6-28cd4d36775b@gmail.com>
Date: Fri, 30 Oct 2026 16:57:58 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] wifi: rtw88: 88xxa: adapt channel sensing to receiver
 gain
To: linux-wireless@vger.kernel.org
References: <20261029055212.84711-1-hjf3108@gmail.com>
 <20261029055212.84711-6-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261029055212.84711-6-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2026 07:52, Ho Jie Feng wrote:
> Implement adaptivity for 88xxa, since they support it in
> the hardware.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>

This patch makes scans while connected to a network much slower:

[2026-10-30 16:28:31.822427]: wlp3s0f3u2 (phy #5): scan started
[2026-10-30 16:29:00.622378]: wlp3s0f3u2 (phy #5): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 
								  2457 2462 2467 2472 5180 5200 5220 5240 5260 
								  5280 5300 5320 5500 5520 5540 5560 5580 5600 
								  5620 5640 5660 5680 5700 5720 5745 5765 5785 
								  5805 5825, ""

During the scans I see a lot of "timed out to flush queue 1" (and 3)
in dmesg. You need debug_mask=0x80000000 to see these.

Pinging the router during the scan:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=157 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=194 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=107 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=139 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=154 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=186 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=12639 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=11612 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=10588 ms
64 bytes from 192.168.1.1: icmp_seq=12 ttl=64 time=7822 ms
64 bytes from 192.168.1.1: icmp_seq=14 ttl=64 time=21134 ms
64 bytes from 192.168.1.1: icmp_seq=15 ttl=64 time=20110 ms
64 bytes from 192.168.1.1: icmp_seq=16 ttl=64 time=19086 ms
64 bytes from 192.168.1.1: icmp_seq=17 ttl=64 time=18062 ms
64 bytes from 192.168.1.1: icmp_seq=18 ttl=64 time=17038 ms
64 bytes from 192.168.1.1: icmp_seq=19 ttl=64 time=16014 ms
64 bytes from 192.168.1.1: icmp_seq=20 ttl=64 time=15014 ms
64 bytes from 192.168.1.1: icmp_seq=21 ttl=64 time=13967 ms
64 bytes from 192.168.1.1: icmp_seq=22 ttl=64 time=12942 ms
64 bytes from 192.168.1.1: icmp_seq=23 ttl=64 time=11918 ms
64 bytes from 192.168.1.1: icmp_seq=24 ttl=64 time=10895 ms
64 bytes from 192.168.1.1: icmp_seq=25 ttl=64 time=9871 ms
64 bytes from 192.168.1.1: icmp_seq=26 ttl=64 time=8847 ms
64 bytes from 192.168.1.1: icmp_seq=27 ttl=64 time=7823 ms
64 bytes from 192.168.1.1: icmp_seq=35 ttl=64 time=1.61 ms
64 bytes from 192.168.1.1: icmp_seq=36 ttl=64 time=2.10 ms
64 bytes from 192.168.1.1: icmp_seq=37 ttl=64 time=1.87 ms
^C
--- 192.168.1.1 ping statistics ---
37 packets transmitted, 27 received, 27.027% packet loss, time 36658ms
rtt min/avg/max/mdev = 1.611/9123.175/21133.788/7187.269 ms, pipe 21

Without this patch:

[2026-10-30 16:34:18.354110]: wlp3s0f3u2 (phy #7): scan started
[2026-10-30 16:34:31.141463]: wlp3s0f3u2 (phy #7): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 
								  2457 2462 2467 2472 5180 5200 5220 5240 5260 
								  5280 5300 5320 5500 5520 5540 5560 5580 5600 
								  5620 5640 5660 5680 5700 5720 5745 5765 5785 
								  5805 5825, ""

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=317 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=134 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=157 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=4.41 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=202 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=122 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=145 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=168 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=190 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=106 ms
64 bytes from 192.168.1.1: icmp_seq=11 ttl=64 time=36.8 ms
64 bytes from 192.168.1.1: icmp_seq=12 ttl=64 time=2.45 ms
64 bytes from 192.168.1.1: icmp_seq=13 ttl=64 time=3.84 ms
64 bytes from 192.168.1.1: icmp_seq=14 ttl=64 time=1.78 ms
64 bytes from 192.168.1.1: icmp_seq=15 ttl=64 time=6.42 ms
64 bytes from 192.168.1.1: icmp_seq=16 ttl=64 time=148 ms
64 bytes from 192.168.1.1: icmp_seq=17 ttl=64 time=2.10 ms
64 bytes from 192.168.1.1: icmp_seq=18 ttl=64 time=27.8 ms
64 bytes from 192.168.1.1: icmp_seq=19 ttl=64 time=103 ms
64 bytes from 192.168.1.1: icmp_seq=20 ttl=64 time=2.71 ms
64 bytes from 192.168.1.1: icmp_seq=21 ttl=64 time=30.9 ms
64 bytes from 192.168.1.1: icmp_seq=22 ttl=64 time=1.52 ms
64 bytes from 192.168.1.1: icmp_seq=23 ttl=64 time=2.06 ms
64 bytes from 192.168.1.1: icmp_seq=24 ttl=64 time=5.16 ms
64 bytes from 192.168.1.1: icmp_seq=25 ttl=64 time=138 ms
64 bytes from 192.168.1.1: icmp_seq=26 ttl=64 time=162 ms
64 bytes from 192.168.1.1: icmp_seq=27 ttl=64 time=79.3 ms
64 bytes from 192.168.1.1: icmp_seq=28 ttl=64 time=204 ms
^C
--- 192.168.1.1 ping statistics ---
28 packets transmitted, 28 received, 0% packet loss, time 27043ms
rtt min/avg/max/mdev = 1.516/89.407/316.521/84.581 ms

(100-300 ms is normal for RTL8812A when power saving is enabled.)

My network is on channel 13, with 40 MHz width, WPA2-PSK.

> ---
>  drivers/net/wireless/realtek/rtw88/main.h     |   1 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  10 ++
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  10 ++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 123 ++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   5 +
>  5 files changed, 149 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index d59f6e323adf0..796fea308fdf7 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -1787,6 +1787,7 @@ struct rtw_dm_info {
>  	bool is_bt_iqk_timeout;
>  
>  	s8 l2h_th_ini;
> +	s8 l2h_th_lb;
>  	enum rtw_edcca_mode edcca_mode;
>  	u8 scan_density;
>  };
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> index c8008cf43da9d..d93c4776e0303 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> @@ -945,6 +945,8 @@ static const struct rtw_chip_ops rtw8812a_ops = {
>  	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
>  	.cfo_init		= rtw_phy_cfo_xcap_init,
>  	.cfo_track		= rtw88xxa_cfo_track,
> +	.adaptivity_init	= rtw88xxa_adaptivity_init,
> +	.adaptivity		= rtw88xxa_adaptivity,
>  };
>  
>  static const struct rtw_page_table page_table_8812a[] = {
> @@ -999,6 +1001,11 @@ static const struct rtw_hw_reg rtw8812a_dig[] = {
>  	[1] = { .addr = REG_RXIGI_B, .mask = 0x7f },
>  };
>  
> +static const struct rtw_hw_reg_offset rtw8812a_edcca_th[] = {
> +	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
> +	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
> +};
> +
>  static const struct rtw_rfe_def rtw8812a_rfe_defs[] = {
>  	[0] = { .phy_pg_tbl	= &rtw8812a_bb_pg_tbl,
>  		.txpwr_lmt_tbl	= &rtw8812a_txpwr_lmt_tbl,
> @@ -1089,6 +1096,9 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
>  	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
> +	.edcca_th = rtw8812a_edcca_th,
> +	.l2h_th_ini_cs = 10,
> +	.l2h_th_ini_ad = -17,
>  
>  	.coex_para_ver = 0, /* no coex code in 8812au driver */
>  	.bt_desired_ver = 0,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> index 17d3677ca463c..f7391f6aa3039 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> @@ -891,6 +891,8 @@ static const struct rtw_chip_ops rtw8821a_ops = {
>  	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
>  	.cfo_init		= rtw_phy_cfo_xcap_init,
>  	.cfo_track		= rtw88xxa_cfo_track,
> +	.adaptivity_init	= rtw88xxa_adaptivity_init,
> +	.adaptivity		= rtw88xxa_adaptivity,
>  };
>  
>  static const struct rtw_page_table page_table_8821a[] = {
> @@ -944,6 +946,11 @@ static const struct rtw_hw_reg rtw8821a_dig[] = {
>  	[0] = { .addr = REG_RXIGI_A, .mask = 0x7f },
>  };
>  
> +static const struct rtw_hw_reg_offset rtw8821a_edcca_th[] = {
> +	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
> +	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
> +};
> +
>  static const struct rtw_rfe_def rtw8821a_rfe_defs[] = {
>  	[0] = { .phy_pg_tbl	= &rtw8821a_bb_pg_tbl,
>  		.txpwr_lmt_tbl	= &rtw8821a_txpwr_lmt_tbl,
> @@ -1193,6 +1200,9 @@ const struct rtw_chip_info rtw8821a_hw_spec = {
>  	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
> +	.edcca_th = rtw8821a_edcca_th,
> +	.l2h_th_ini_cs = 10,
> +	.l2h_th_ini_ad = -17,
>  
>  	.coex_para_ver = 20190509, /* glcoex_ver_date_8821a_1ant */
>  	.bt_desired_ver = 0x62, /* But for 2 ant it's 0x5c */
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> index 586bb57a10061..aff62d61f4719 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> @@ -2040,6 +2040,129 @@ void rtw88xxa_cfo_track(struct rtw_dev *rtwdev)
>  }
>  EXPORT_SYMBOL(rtw88xxa_cfo_track);
>  
> +#define EDCCA_TH_MAX_88XXA		0x7f
> +#define EDCCA_L2H_CAP_88XXA		10
> +#define EDCCA_L2H_INI_NORMAL_88XXA	20
> +#define EDCCA_DBG_PORT_88XXA		0x209
> +#define EDCCA_DC_BACKOFF_88XXA		2
> +#define EDCCA_LB_START_88XXA		(EDCCA_L2H_H2L_DIFF - 30)
> +#define EDCCA_LB_RETRY_88XXA		(EDCCA_LB_START_88XXA + 18)
> +
> +static void rtw88xxa_set_rf_mode_rx(struct rtw_dev *rtwdev, u32 data0,
> +				    u32 data1)
> +{
> +	u8 path;
> +
> +	for (path = RF_PATH_A; path < rtwdev->hal.rf_path_num; path++) {
> +		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 1);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_ADDR, RFREG_MASK,
> +			     0x18000);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA0, RFREG_MASK,
> +			     data0);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA1, RFREG_MASK,
> +			     data1);
> +		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 0);
> +	}
> +}
> +
> +static void rtw88xxa_set_lna(struct rtw_dev *rtwdev, bool enable)
> +{
> +	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A)
> +		rtw88xxa_set_rf_mode_rx(rtwdev, 0x3f7ff,
> +					enable ? 0xc26bf : 0xc22bf);
> +	else
> +		rtw88xxa_set_rf_mode_rx(rtwdev, 0x0002f,
> +					enable ? 0xfb0bb : 0xfb09b);
> +}
> +
> +static u8 rtw88xxa_edcca_count(struct rtw_dev *rtwdev)
> +{
> +	u8 cnt = 0;
> +	int i;
> +
> +	rtw_write32(rtwdev, REG_DBGSEL, 0);
> +	for (i = 0; i < 3 &&
> +	     rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_CCA_BUSY; i++)
> +		usleep_range(3000, 3500);
> +
> +	rtw_write32(rtwdev, REG_DBGSEL, EDCCA_DBG_PORT_88XXA);
> +	for (i = 0; i < 20; i++)
> +		if (rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_EDCCA_BUSY)
> +			cnt++;
> +
> +	return cnt;
> +}
> +
> +static s8 rtw88xxa_edcca_search_floor(struct rtw_dev *rtwdev)
> +{
> +	s8 l2h = EDCCA_LB_START_88XXA;
> +
> +	rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
> +	msleep(30);
> +
> +	while (l2h < EDCCA_L2H_CAP_88XXA && rtw88xxa_edcca_count(rtwdev) > 1) {
> +		l2h++;
> +		rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
> +	}
> +
> +	return l2h;
> +}
> +
> +void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +	u32 dbgsel = rtw_read32(rtwdev, REG_DBGSEL);
> +	s8 l2h;
> +
> +	rtw_write32_clr(rtwdev, REG_TX_PTCL_CTRL, BIT_DIS_EDCCA);
> +
> +	rtw88xxa_set_lna(rtwdev, false);
> +	l2h = rtw88xxa_edcca_search_floor(rtwdev);
> +	if (l2h >= EDCCA_LB_RETRY_88XXA)
> +		l2h = rtw88xxa_edcca_search_floor(rtwdev);
> +	rtw88xxa_set_lna(rtwdev, true);
> +	rtw_write32(rtwdev, REG_DBGSEL, dbgsel);
> +
> +	dm_info->l2h_th_lb = l2h + EDCCA_DC_BACKOFF_88XXA;
> +	rtw_phy_set_edcca_th(rtwdev, EDCCA_TH_MAX_88XXA, EDCCA_TH_MAX_88XXA);
> +
> +	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY, "EDCCA L2H floor %d\n",
> +		dm_info->l2h_th_lb);
> +}
> +EXPORT_SYMBOL(rtw88xxa_adaptivity_init);
> +
> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +	int igi_diff = EDCCA_IGI_BASE - dm_info->igi_history[0];
> +	s8 l2h_lb = dm_info->l2h_th_lb;
> +	s8 l2h, h2l;
> +
> +	/* toggle the ADC mask to work around an EDCCA hang */
> +	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A) {
> +		rtw_write32_set(rtwdev, REG_FPGA0_RFMOD, BIT(10));
> +		rtw_write32_clr(rtwdev, REG_FPGA0_RFMOD, BIT(10));
> +	}
> +
> +	if (dm_info->edcca_mode == RTW_EDCCA_ADAPTIVITY) {
> +		l2h = min(dm_info->l2h_th_ini + igi_diff, EDCCA_L2H_CAP_88XXA);
> +		h2l = l2h - EDCCA_L2H_H2L_DIFF;
> +	} else {
> +		l2h = EDCCA_L2H_INI_NORMAL_88XXA + igi_diff;
> +		h2l = l2h - EDCCA_L2H_H2L_DIFF_NORMAL;
> +	}
> +
> +	l2h = max(l2h, l2h_lb);
> +	h2l = max_t(s8, h2l, l2h_lb - EDCCA_L2H_H2L_DIFF);
> +
> +	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
> +
> +	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY,
> +		"EDCCA mode %d, IGI 0x%x, L2H %d, H2L %d\n",
> +		dm_info->edcca_mode, dm_info->igi_history[0], l2h, h2l);
> +}
> +EXPORT_SYMBOL(rtw88xxa_adaptivity);
> +
>  MODULE_AUTHOR("Realtek Corporation");
>  MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
>  MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> index 09b72d33f62e1..b8719c278df73 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> @@ -139,6 +139,9 @@ struct rtw_jaguar_phy_status_rpt {
>  
>  #define RF18_BW_MASK		(BIT(11) | BIT(10))
>  
> +#define BIT_DBG_CCA_BUSY	BIT(3)
> +#define BIT_DBG_EDCCA_BUSY	BIT(29)
> +
>  void rtw88xxa_efuse_grant(struct rtw_dev *rtwdev, bool on);
>  int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map);
>  void rtw88xxa_power_off(struct rtw_dev *rtwdev,
> @@ -173,5 +176,7 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
>  void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
>  			     struct rtw_bfee *bfee, bool enable);
>  void rtw88xxa_cfo_track(struct rtw_dev *rtwdev);
> +void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev);
> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev);
>  
>  #endif


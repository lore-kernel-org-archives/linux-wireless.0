Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384255;
	b=NItTCi24kfXalxZLB2zLmnmwCgWrD9oaQ6o2NP1FbjGHGOoRkAcv+C1WsF/SbbOjsqry
	 X6nYQtYnUUJA+mI17C56OysxNjpUGxGo+Jm6GeGV+7AjI4PuTOXVf+AeGLGtwZT5oMH7E
	 7EWPXFieatOmtEFbLBGGKRDkxVSwVx3UhN8V6IWFP+O3TjoJ4IGYr1fgSITp1Ns2Z7IhB
	 Dmt9InUeJD/BaxSgkiQPEXYOWF+zPPj4SQWA80D2YO+l/agr2sME5iGp0KPTpkMEhr8YV
	 +3Qc8AqRrCEDj9Ht2wRuKFaubOuZx5k3YivAphRmdtAVjexDH3J6FtN6WhNr21+Pvbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384255;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=P20Sssx6yjJUYGIDtxb2MekE1dkGAS2a+bVdnxR+A5o=;
	b=FNGB7PZPtwTdujg3w6hQhGN/qKb4cQH70XtVFN4DJEUkwm+dWWAg5og/MlzopBrdpE1b
	 1jmU+csjT8qUfONpur0iarBSHuo81ozS64mMUNBPHOWQvvNC7/7xsZpBf9yFd3wH7Hs7Z
	 wSNdoF4GGVTPYdhmTLaMzEFRXf79trC3AGXCftdCpZaPKYV+XnKXnBA9vw2lacBTQx+wZ
	 3lOnGKp3yKlZPQcHgoz/5AMrk4jJjHYn+7YrCJnYG/xbtcx22Vnb3dmR1X22htNnJgA9K
	 myanVaJHqYUP9B99QvcX2w5UNIY7GL45VY1f2VTyJV+8hz4NKpSlds6Tv5450oiexRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jTLLsFfY;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82561606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 18:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82561606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jTLLsFfY
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so571867f8f.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793384254; x=1793989054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P20Sssx6yjJUYGIDtxb2MekE1dkGAS2a+bVdnxR+A5o=;
        b=jTLLsFfYXBiUSEMoVtR09XM8GfPg4iYCaKbWo9OruZYbtTBD8ki2MBYNG0cxoUkfxz
         HvLpNotsTw11Oim4hDyO3ulBtyFEzmH2nmaR9/Qh3wT/hF69kSDM/leGwVLP7nP6lw/b
         hgM/UZQ9ASwdyvRKghbMQ0/Cej6v5jziW6BJ3YsHcI4nTSwuP+NI1ZhsBdCgHX4DgJ0p
         c1qIgiaySXMtLJolWetTAFVQFqXJ6B3Q4ayx8d79s1Ir0DRk6LxcD4bVoGq98/KX3XO/
         9AtA1OWVDbTJLHt5VmzfTkJK/O6DonawbhLceu94lpZgBqtwIIEu9sOQRXJzRKx3D1yb
         zlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384254; x=1793989054;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P20Sssx6yjJUYGIDtxb2MekE1dkGAS2a+bVdnxR+A5o=;
        b=KFtnObpe0gBGDVqfgtGFKAvO3Ek6xb+ywiB+C7+d78eWGWQSP+siuZHhU8e835RJj5
         TqjQitkCERyylmW+nITg6uYQb1ivfbNEKcUBRKVacGgQtmQuWVpP7nxk7QTnn5h1LCK3
         CHYsCKKt/w+EghjNs9FlIkNihQTSUDi1g2+tuiF0MaIVLP2YXBt0NvXeJUTUrQoOueRQ
         7Xyo8dJ7igZ1fVSMUrVg/GKdYCYkAisjpZAvZyruLaKV966KzPWEpzJOBjhExAAzw9sg
         VBnWgLuyDnv42fXk2i69PiiX+fy7fDT8EQl4SfLNM4gLJMRVCr81E4OnrItRHoe4cpMY
         mDrA==
X-Gm-Message-State: AFq9FYLQYfMIWTbJyZaSNpX4sNBV2qdzy8fTcPdNU/+ZiiNK7murzHzL
	+zMUIk4aM2N51r4eqEoURt/DZV2PANYSyTouK3ynYI5YinA2H6XKxel1
X-Gm-Gg: AYBFou02l+U9/qz3YbR67GDHBvnCkeKeacNElrsiJ2zh7I8xuTDLaPWpTDwbhkRsmI5
	t3hvocPTsPrqbEU/f6lhVe0icCISMcPNI5oXi+Nj1TflZhh85rtodzB4/A63rw7rPsNv7ku2IAf
	2/QsmACd1/GZSfQv4Cgl7Ylj+OhsVCqzXHxqPdsUJV6ANWf9W/tvGKi5vQJf/ZMOX5SPA7Od4As
	rrD1U9lUjG1vp4iXiIOm94x9G6/mG+hRWq1s8HPdQ4kNe9Z11lB9anz6MjvGhJnpaOnvrQmmHwq
	OWEmK0Og+hfUd7CcEuDgSt3KtQjBjOC6MA355kG/ucDZRkd+9xx2XOhc6NrsppTdoxuR1eWWggb
	Zh5taBcmH7GEVe7pB5QCRYJWufWJtWDMwsBkDpZj80j9tZWc0fx6mx8zF+hS0hS2AdriVXKhw5o
	7rJfeNUkl1/0L5vCgF5xvK/CUNFLkde4kJpJ3Xi6pUet4BTa1Xh8GGcsl1WTDgbzJVtPVNuAP1K
	rMkCgDcqUBa8gyaWWb9sJO+hlriIyT/rcAibugoqoKJFKVZH00wX5TX9GzkN3F5D8lOLX7vHZzv
	eVb9QnWpjjb4NOw5N0Wrol93KTvKTYDwg0hpdNtamzG0B/TZCexxJOjjeIpyuUfGuNcjXaYSWyC
	Q8fg=
X-Received: by 2002:a05:6000:178f:b0:48d:f14a:9177 with SMTP id ffacd0b85a97d-48e6e4faeacmr7358484f8f.56.1793384253663;
        Fri, 30 Oct 2026 11:17:33 -0700 (PDT)
Received: from ?IPV6:2a02:8086:cd5:c900:c69f:4b72:77ee:5fe1? ([2a02:8086:cd5:c900:c69f:4b72:77ee:5fe1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba5dc2sm4380862f8f.54.2026.10.30.11.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 11:17:33 -0700 (PDT)
Message-ID: <e2e00074-6787-4c76-a6ac-5e17d37c1e76@gmail.com>
Date: Fri, 30 Oct 2026 18:17:31 +0000
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
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on
 WCN3990
To: shunsuke@nagashi.ma, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>,
 Fabricio Akio <fabricioakio@gmail.com>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
Content-Language: en-US
From: Conn O'Griofa <connogriofa@gmail.com>
In-Reply-To: <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 01:17, Shunsuke Nagashima via B4 Relay wrote:

>   - The firmware sends its ADDBA Request frames unprotected. The AP does
>     not answer them, and no Block Ack agreement is set up, in both the
>     2.4 GHz and the 5 GHz band. On a 5 GHz WPA3 AP, iperf3 to a wired
>     host gave 22.6-31.6 Mbit/s up and 21.6-21.7 Mbit/s down, against
>     280.2-283.0 / 264.5-272.3 Mbit/s with WPA2 on the same AP. A
>     WPA2/WPA3 transition network gave the same low rate (23.4/22.7
>     Mbit/s), because wpa_supplicant chose SAE with PMF there.
>
>   - On 5 GHz, the protected Deauth sent at disconnect carried CCMP PN 0
>     (56 of 56 in one capture). One AP dropped it, kept the old
>     association and answered the next association with status 30, so a
>     reconnect took 24.3-24.4 s instead of about 5 s. Another AP accepted
>     the PN 0 Deauth. On 2.4 GHz the Deauth carried a live PN even
>     without the flag. I could not tell whether the band or the AP's
>     HT/VHT capability makes the difference.
>

I can confirm the same problem happens on a PCI bus hw1.1 revision 
QCA9377 in an Inspiron 5570 laptop (originally installed), primarily 
testing the 5GHz band due to 2.4Ghz being congested in my area:
ath10k_pci 0000:02:00.0: qca9377 hw1.1 target 0x05020001 chip_id 
0x003821ff sub 1028:1810
ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.2.1-00021-QCARMSWP-1 api 6 
features wowlan,ignore-otp crc32 42e41877

Note that the MFP flag is not listed; I also checked the latest api 5 
firmware and the flag is also missing. Without any changes, the driver 
performs extremely poorly (~50Mbps) when PMF is negotiated with the 
default or latest api 5 firmware, and confirmed to be an issue on my ISP 
router and also a separate OpenWrt router using an ath11k chipset. Prior 
to discovering this patch set, my workaround was to allow WPA3 
Transition Mode on my routers and force PMF disabled on the client via 
NetworkManager in order to coax the connection into WPA2 mode with PMF 
disabled, allowing speed parity with Windows using WPA3 (~300Mbps).

By adapting your patch to also set ".peer_pmf_support = true" for my 
hardware, WPA3-SAE (i.e. with PMF enabled) now runs at full speed 
(~300Mbps).

Further context is available here (not my thread, but other users have 
reported the same issue with this hardware and I posted this patch with 
the flag added for my hardware): 
https://bbs.archlinux.org/viewtopic.php?id=308424

Regards,
Conn O'Griofa



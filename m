Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792464479;
	b=U+RbCVmlF1yzfaugYtYxgKoE8TG2pNyTWP6bGDYJYspeGUvkNIbBo5+KLVwonD6BjzTH
	 jDSkn3IHn/yEOdv9RAmf9AkjVRrfvOQhRATfsYeAWXBOxwVHVds3MJbwu98OovvPJtvXR
	 K5Cn556TEYSYhtChpeBueti7PJmCKDFkTdDJwDNzq4hSBzNeM7e6qTyOXFA3kqEQ69FbV
	 Q9HXWW/fmpoNop+wcLBUlh/6o70LA0COY4Xvl0ICGfJkML8sRSMzSDAnDD9LcULvTQQA+
	 BfxCudoa2Ijosd2itg3AZQ0AxVqYjESJQzSqzwEindkCF9ja9Z+kExUcfWEjgkdbcDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=262A8gCU3R+nsMKHC0ROKoLNJtacXiiDwGq2rzQbdsg=;
	b=4LNahVFBAjDv4UiRx8+real8JTiPVSMRzta0TeQgUeUbXEci6HGqxqOd8xboRraImcrM
	 QPaIKlQd1vYhxNZni5xz+mD+Bz05ZjWfrfcdlYVyNEt9NYUGNwutzejNJFv6hLpAT0nF7
	 JU1x7lgonNDv6SnHrj3pHijWVcRUHfLcgc3hBO5cQyE2YY9qYZwd+xsLOVJNyGeem9hrI
	 8UOSuGjiZD+vDMtO4FzJhtts6bM3+AQ4nNRBoOUAjuIxwKh0I7alZABxqZq3AjleObj0w
	 1wHwMq0zreqFX+D2YT9MOfIseJAnYOVatdcqXp7pXVy1OUlWm7lN04pPqvHUz6SSA5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nagashi.ma;
	spf=pass smtp.mailfrom=nagashi.ma;
	dkim=pass header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=fXAkdqJz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E77F606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 02:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E77F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=fXAkdqJz
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c45551fa84eso151857166b.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 19:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792464477; cv=none;
        d=google.com; s=arc-20260327;
        b=mBhGevu4wB3d/xKKBl1FU2UUPJi//0zj9/qEjrLronzvGCPp5GV8903UxbIhZQkvAx
         tqjRp+GbrBJfBj31YeikVxvFSVQYyD2sSlMnd37kDzdk1x6DUqDenQnEvJ+ajeQZy9IA
         0MoDBxAC/3a8hjLnEpF/1DJe5d9M26wkYYZjDJmNODWs8PNsDHKRQ6fv8teIJ2m9w+iQ
         9U4Hl9QBcUdxDsl3TRuU9DLm3xymV4uOQEoLRhCrAJ9W9q3nDDDTvTJXFCUneKwbhNxL
         rosEZ9mCsnMEl54OUBTRloiIy75xiGZ739Pus/jw04RpwcLpAj2IHRLcgvBph8k7UEBg
         EyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=262A8gCU3R+nsMKHC0ROKoLNJtacXiiDwGq2rzQbdsg=;
        fh=rDxBD6tLkJOfeLfqV3Wp9FxzVVLc6zamYuwi7PAZOdA=;
        b=qdGTxbL4GVOswyvcs7QUosFwD2blVirPi+7ykgg+bfNRfjl6aabPOAM04bXsLQ4Gy+
         qmYNz/0DSfxbnq+/6H8gyLJgbO8qe3fpk8CAkfz86AtDF/X76mAoFI21NmGJjKi7aH9P
         k1rPeQiVmKhsPBXwfCka7doI1HsLbe6rqrKBKWzhP46akMUug42l0wopKIWc5NbS4ag7
         2K86MP0FVID6IWJZNetzcAPfALT4m3CAaxav9ZRtM/9KUu9ao6n0ad5uqbZrSADAqa1M
         9j+Tm6TzPgxSeBiagpoM8OpWj+WzXhY9o4sP2sKtcLrDIDFLgyxJniHX4DrAR7op4ePx
         cDQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nagashi.ma; s=ggle-ngsma; t=1792464477; x=1793069277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=262A8gCU3R+nsMKHC0ROKoLNJtacXiiDwGq2rzQbdsg=;
        b=fXAkdqJzvQuUBW9qPB8S04MDheV0eWxfHGJ+RehyNkav0Tf+BRNBce84cb8uhSVQ/X
         TOTmJo2HhW5VDdrOWK2R3UWMIQXQLk2ByC7UuSnz2PbpohuA9uR6gHENB76x21stx93I
         fymFJMg9H74cdUSubolATOvMb1VJj2QfFVIP2Y7FuaWXiAxf+AQKprW/ZUoHRiO6FsAX
         3LIpNW0eyT7ArWNI4roEHqHZQjId1uS2MG0es/m+XAOr/1hlH+kxt2T172sWl0rc9TgR
         j1smMOt5mRFvTEorGWhwu3pYXfWqQEiUZhphygzSmSdLaIT5tscRBPC3ZYYufKMYK383
         HdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464477; x=1793069277;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=262A8gCU3R+nsMKHC0ROKoLNJtacXiiDwGq2rzQbdsg=;
        b=xG58ouTRfrilQ5AhFUwVp+4U+/XeGpPoRjkPVDJImE4lNoIeRR4ISKzICMRvGJtqDj
         3xB+f9Sm6hsgjaBNjs6ksiHZa1jQcN6raxGug5GPEbd+w4wFpcbyCF8lh/GU772LAs+M
         A290x5oSiV0blMqHnmAPQh3h7FGsBr8HDxDI0vYjU0H7gsWaqiM+dqdMZ40fadjB092k
         yGnxlkpuwXv0+Cft+ZQ7XUcaQ8+G9GKWdfcAYfo6Y0O3nG7PML/vnPEesmSIkNt2nnOu
         lPUfwV9bOwybzedzxI1ERRj2lHW1u6fdA0Jy40XvgV0+OKQU6xXQkl6Cl9YtaqHtN1qB
         u5sg==
X-Forwarded-Encrypted: i=1; AKwUvBzept6xMP91sSOzvV8r+WmJcpAkmVHmqmg9mkq7oXyvo+mnR+14QzG4avGNfXKRZGxDovhqHp3DyS7H5gvKaQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLYM4N4vA3QzaHn3Ixw5zJTTAqYdJrwxyhpFd6owtwV2CNYEZb5
	hjAX5fyLDu9Mh3BSZdvzRr2Bygtas9BPdS+eHqYk9xpTCPoO89xGo8vLSXiNDedz7AFlFWBFQig
	TMylTvCMQn75xj+Z0PTmTQfVQVDmQNfMPklTYq4Cj
X-Gm-Gg: AYBFou2ewdYZp7g8vRkuxvkrA7zAI1K2KkntXI8hUNkrg9Xc5baE4krvgod7Mqx3n4T
	Cqf7qNjsuOk+5J8g2Gycn9HBLYwkg00A2SvtlstWrrfr3tl0fKF0w8esrXA8tRDCgVm0z5/+Rxl
	4jZoLdXDYg5miIro4T5gTrI8tTKKh0DZyngJTRKcr+H3VgvwzQrtJLyiAED3wsd+1C50G/mDDRJ
	rHYTLTQVe6Kt1a3kLMWbJt03I8ADSuc52llLkIPYW+p+I5AGUwDlhYinmGvmy+ZB0vw/ui4vK7D
	6jPNCxCv8nkMCB63IdC046+jBM/N/Kr/y4aS5FSomDwLBaH/VVajltBbrxSfSd01+hSSsX3W94t
	kDnU/OR8TxQSsjovSCCiRJq3VITjMSaWlz5P+jzPS5sCtfnwh0wICxGk9af8Pkrb9JbsyXeLgcr
	TybrGNJVU=
X-Received: by 2002:a17:907:fd8b:b0:c40:dead:7466 with SMTP id
 a640c23a62f3a-c419e538580mr642966966b.20.1792464477048; Mon, 19 Oct 2026
 19:47:57 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma> <a523eda4-5708-4427-a044-a61c0386e5a9@gmx.de>
In-Reply-To: <a523eda4-5708-4427-a044-a61c0386e5a9@gmx.de>
From: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Date: Tue, 20 Oct 2026 11:47:31 +0900
X-Gm-Features: AclHuK8Iv6DX-6YiVsBJ9gddXv3oItLrT6nCv_vwkm2KhJ4WNt8Fui0S2e66i0g
Message-ID: <CACB3TCJVoFbMEpbtvuO5c-udCoZgDvMBeH0RXUXp90hab3Dh2g@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Heidelberg <david@ixit.cz>, Fabricio Akio <fabricioakio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Aleksei,

On 10/20/26 1:04 AM, Aleksei Kharlamov wrote:
> I independently found the same issue while investigating connectivity
> issues on fairphone 4 (WCN3988, qcom,wcn3990-wifi, slightly patched
> kernel v7.2.0-sm6350, firmware WLAN.HL.3.3.1-01704-QCAHLSWMTPLZ-1).

Thank you for the report. It is good to hear that the same flag helps
on WCN3988 and on a different firmware branch. I have only tested on
WCN3990 with HL.2.0 firmware.

If you have time, could you try this patch itself (instead of your own
version) on the Fairphone 4 and reply with a Tested-by if it works?
WCN3988 uses the same WCN3990 entry in ath10k_hw_params_list, so the
patch should apply to your device as it is. Station mode only is fine.

I worked through this together with Claude (AI). English is hard for
me, so the English was written with AI help. My results come from my
own device tests on my comma four.

Thanks,
Shunsuke

2026=E5=B9=B410=E6=9C=8820=E6=97=A5(=E7=81=AB) 8:04 Aleksei Kharlamov <alek=
sei.kharlamov@gmx.de>:

>
> Hello,
>
> On 10/16/26 02:17, Shunsuke Nagashima via B4 Relay wrote:
>  > ath10k sets the PMF flag in the peer assoc command only when the
>  > firmware file advertises ATH10K_FW_FEATURE_MFP_SUPPORT. That check cam=
e
>  > with commit 90eceb3b5fb0 ("ath10k: set peer MFP flag in peer assoc
>  > command"), because at that time "only firmwares 10.1.561 and above hav=
e
>  > support for MFP". The WCN3990 firmware-5.bin files in linux-firmware d=
o
>  > not set that feature bit, so the flag is never sent on WCN3990, althou=
gh
>  > mac80211 negotiates PMF with the AP. ath11k and ath12k set the flag fo=
r
>  > every MFP station.
>
> I independently found the same issue while investigating connectivity
> issues on fairphone 4 (WCN3988, qcom,wcn3990-wifi, slightly patched
> kernel v7.2.0-sm6350, firmware WLAN.HL.3.3.1-01704-QCAHLSWMTPLZ-1).
>
> Setting PMF peer flag (my patch is crude and very similar to yours)
> significantly improves the connection performance (please keep in mind
> that fp4 seems to currently have multiple other issues, such as missing
> a correct "board" file). I only tested station mode.
>
> Thanks,
> Aleksei
>

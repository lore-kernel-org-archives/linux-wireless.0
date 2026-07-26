Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AEE3BB9FD
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785103936; cv=none; b=EdXKZHZjsjnSXpilFGM9/etdg1rprAwBCchSCsnIk+9AY+WQuGuUYIUx/Dl7rE4WqXL7sa5Dkjmils5Iw44pEsGnd6zLym6THKCRKVPOfJeGPcoxdiTWInhn1eDLdSVqGj+IBc139cZ7Cp4/dtol3sv92d39ho0xKRMzlNtyCjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785103936; c=relaxed/simple;
	bh=XirBAzOzE0ihAUqfnuAp2o8HAi5p7wNO+MkVNs1T5Uo=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=RFrGGpnN3OvSkRvThGfp7CU35Svze1Cs/Ato0HCHq125fIIndbXOmi0mQajsdxDNlzeUJUwbvHk7sxQKqak2yCsbdhD+MrJqjbwq4ETbPyQUQmqjiuxCw8ESBQu3JoGVF6k7VOciQ0/5LWxr8pS62uXVmkqdDKeQAuB+42IL9FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BnTXVWgg; arc=none smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BnTXVWgg"
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-456f7012050so2364079fac.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785103934; x=1785708734;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XirBAzOzE0ihAUqfnuAp2o8HAi5p7wNO+MkVNs1T5Uo=;
        b=mtzUjQsDKvLC6oSstoJx9yFAOnKTxyHzpO5bl6j+EsOQwzU95OkyuWxXK4E68OD1+3
         6wmiyQUhJ3AD6zZlouDV5mqy4It6TUIbjywntdLiQWjUGu6hMoAnjT3OcmImbPDni/mN
         DjF0OJ5tH+FwGQUu6cwtVB0H6aNwOP9V1ekZRyyQqvvIoak1RmCRo7iNVH8DcHVNt9zr
         ztHF6XF4cZiuC+57BDLaiP8V7OGM73f7v/xVd5tYXJyUDU1i8NWdDetxcer8vSW8KPts
         TKjYZ9mfQVfy1HxRSITBG69bCXkz/ragm49tpEmRO5munR3pX61i3DWPAVGNkMf+s9Mn
         tc/A==
X-Gm-Message-State: AOJu0YxbvOmpacBAH5FKiYsYVoAityGtkD7/RQowNmRHLDI4c3mEDCS7
	uOaCQAes3Xa43q9Acmp+nGXs/4OH2iXPcQ8V7C0BTGo1EBhMiwBK5p2XKGLWO8dOsmyBUwm+XeR
	V9C2gAJoSuqLEDjvcfL8olMomm7dRyjRhKIPyJuDmcc7uCa75spMBl5ut/bviRJzg6BMl43xsIk
	8sqRtU3kLHTvfZpfndggnRFYqJKDGrYG7M5X7SERx3JptcvdrR+kLVEFzepo/yNeI0rZCoJgElK
	UehgnhEvrGOJIpWonosL7y8cGKR
X-Gm-Gg: AR+sD119BZ8e+fItWt1MOGRotb0eoylYq2+TfAo6IMp2IgY1kRmblRkHdGN6rV1eln0
	CWhXm1GBaFWulwLJO8o+I09tYbWVDW98JFpLC43AN0XpxiGX3IUGtDUjZddbjqs8MWI053+1baI
	PPH4GWdNGgpVc+ZENtoWJiVHwD3D+ARGuqMV71GNo4p6wrSs/eRqhmj7/mXsmlJX5Beity2U8Ih
	eerrlGRsVAqy5Fuf2XQyVzHYq2AZdaO1jzWA7q5w55g8KoO5md2prcXFpqgL4XTynMp6gqLE+Lh
	mniwYUaSlQ2bGFdZ5fD9YCL39ZPFNDDe7QPl7rwgRrFS1N28XAXaYCiFTvlmk40yt5q/1H5G6is
	Af5PQHCElbiuLwYMN9BMAq0GbG5Yat98w+/WdFk3zGPWijgLyeIbnUlW2tzBJ44vecekYtVIDm3
	ypuTQ+r+PTdk1QCxSUD749hiEAoFcTtcYesJP8rZk=
X-Received: by 2002:a05:6808:1185:b0:4ab:224d:6dd6 with SMTP id 5614622812f47-4ab5e3d97ccmr7368382b6e.15.1785103934244;
        Sun, 26 Jul 2026 15:12:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-457673b64d7sm1222921fac.10.2026.07.26.15.12.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 15:12:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69cd6606b19so1937187a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785103931; x=1785708731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XirBAzOzE0ihAUqfnuAp2o8HAi5p7wNO+MkVNs1T5Uo=;
        b=BnTXVWggQYIyPQbgksCDh2STiuOyT/5V01FfDNoYRAHwHEAI7A8dtDoLlyV+86JOqg
         7p0+n8yLkmuNDeO3Lwv1QxbuuQF1/tuRr3rjtu5SVB5tW2e97UR6nytrhHYohhUuayD6
         MRUaR4ByHKDWDHCLXbORewcCDYfQ4B5jcipfg=
X-Received: by 2002:a05:6402:5188:b0:69f:4c65:8696 with SMTP id 4fb4d7f45d1cf-69fc100510dmr2460866a12.11.1785103931597;
        Sun, 26 Jul 2026 15:12:11 -0700 (PDT)
X-Received: by 2002:a05:6402:5188:b0:69f:4c65:8696 with SMTP id 4fb4d7f45d1cf-69fc100510dmr2460856a12.11.1785103931164;
        Sun, 26 Jul 2026 15:12:11 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb5958ea0sm1918044a12.31.2026.07.26.15.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 15:12:10 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>
Date: Mon, 27 Jul 2026 00:12:09 +0200
Message-ID: <19fa07c4ea8.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <78e9e3c667a7e356cfd2f736fd5852c91bd7cbf4.camel@sipsolutions.net>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
 <20260726192541.2816743-11-arend.vanspriel@broadcom.com>
 (sfid-20260726_212621_952206_40730C54)
 <78e9e3c667a7e356cfd2f736fd5852c91bd7cbf4.camel@sipsolutions.net>
User-Agent: AquaMail/1.59.0 (build: 105900627)
Subject: Re: [PATCH -next 10/10] wifi: cfg80211: convert cookie output to input parameter
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 26 juli 2026 21:38:03 schreef Johannes Berg <johannes@sipsolutions.net>:

> On Sun, 2026-07-26 at 21:25 +0200, Arend van Spriel wrote:
>> The tx_control_port op is excluded: its cookie pointer is nullable
>> (passed as NULL when dont_wait_for_ack is set), so the nullable
>> pointer semantics are still required.
>
> Well, kind of? Since we guarantee non-zero cookies, we could just pass
> zero for this case, maybe that'd be nicer here?

Crossed my mind as well. Will look into it.

Gr. AvS




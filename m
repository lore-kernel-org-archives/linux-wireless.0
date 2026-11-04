Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796501;
	b=MMSRgfZ79CdryOTmcWf7wBzsZrJnQfs/JwGM2LmHIG5QhysAYFh7uFeXgj1BOV7+6lhE
	 Yg0hUQFw31BA+lIfnMoolAOByPC/bQa8PpU+Fw+Ty20nmRCWUlcizIwKclSQFfKoPMCOS
	 5Q/plW/9ExefLAIzr7s315EjTeqcJ5azz+Cj/v6HgHqFTirR4LC0W7nHgUA2Z9h6Bdh0P
	 cIUgq9vSjzYzBTd0pFz+lVuxwlxcRBHVGKs27yhjh7t/19nZjC+/P5jdogZB32+6HgrVr
	 SOiau7o6iQEPfqea5IgYdrDC4SLledOO1zgZVCkDfkrWzlUQuNwwKtbx6J7j2wuPnfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796501;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=V7HWz81Cw/lBYwQmJS9ygbMpFshI8F04HNLRxHQhFgs=;
	b=yu+k5DgnOKINaPH0R4nuUhcFVnYXL+7ErPdfRs/aDifam3uaN+iZKQ8dtnGA2dBjfJzd
	 kpc7dvzXLTcVRGgNRqv4B+nA8o1QJVJ+UrQ8LZS2BvJB3eY2deEYvTa8kstTzuPB8lfFt
	 j3F5dtGc8VvqeN80oqdicHNL5kSg23U1Z/qOysdic3tH6W1S/1yVBtUojO/g0RAcJoGs8
	 z+Ky3+Aww8AhKETsDTv2jJWXJTT63vGRzyoVG6vT5G6suYMY153MzcGGNAnOr8V/exH3o
	 iJ5QqVZLymTDlmGGktpVGrEt88l8YmzxLSZMrtGLX46+vjqxXAYN+PF1/Rt4jjRnLlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jMMplbLl;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898E8606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 12:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 898E8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jMMplbLl
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdb45e96d2bso273651a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 04:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793796500; x=1794401300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V7HWz81Cw/lBYwQmJS9ygbMpFshI8F04HNLRxHQhFgs=;
        b=jMMplbLlexFn7o35FrwSSMvOPhFz4JTEV2BNsVre0u4Cr1kpBmHoxavH3QIk6v3hoD
         4OcTblqFe+lpkT8GGUwCMQXN+BJ+GTNlWkGDJF1CyKYAF6CxcMt2R9kjKAWtb/OnXHEn
         PUwpKcAXdMh+VcXojhz/IRSvnEhNGnR0gfi4c76YL8EXNtbdGb7+HBubvbDM8pyxHvnS
         xsHh31agzFLMWKkx+Wgs/ep7r0S/89Q/iDoyNfRNCy7lDyYDZX8rA5M6ZyjompK1ZPcm
         k/2FPiaeR8CzdzWU9T2efz3voCQv4meF3+B+D0CUBZxWWMOp2GfAibLJeIgORpPjKim2
         gzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793796500; x=1794401300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=V7HWz81Cw/lBYwQmJS9ygbMpFshI8F04HNLRxHQhFgs=;
        b=VWrcLix4hvawMyHCbz1WsJAf7NVFUpqhETV4GyeIV8mh1H6YUYXMDjgEcCdmHwaQAs
         ICcmNUqzV7G4fGeqUGA+phA1LfG0rUWS22gB+Rb+z7qQIyFj/TAteWDUmoivWot/mr21
         gsqpKSM92Oj959GuXv82uWRoFHNT0pRY6V7vQ/FXpqzfLRCzJsyOKRjhh4JAcvylTUpb
         aSrnYZKa9L4WT+Ekpf4zMTr2/dgJFdeUwjV+LjrRUVhWPUviLKi8Oi2foQ6ob2vgcPjr
         31Ex3Oo0eXdAynvg+G5jEomx3PxUBHtXC9G8145cgqlqFcvL8j+mvyCRp8ldDiARfBF1
         XNcw==
X-Gm-Message-State: APuU4Z8SQwQbe+nwKQoT85on4AIHdVlHnrSF1fQCk82q5Ld2HzmBvB6X
	6oGEP2/kHaKy+x3tsDp69+rHZ6H+YPoVCDbDyLFA1az4jQTynE2vKB9B8eES9w==
X-Gm-Gg: AYBFou2rWAnRO5srQ80nilyEaKhFyKIQwm9XWEQs0FWKfv9Ceg7mzVrLNSh3a3+UjxZ
	/cbhA30pkZTy3ExmCDuJsAq9ndtmWt3wF9Tu+pQ+6V9Cc8gPQkD672sv5BM2e+8juGoJP6OT1c6
	Gxz3/AzMZgt4KRwpunUZSiqXSrv9rZIKvJoAd3X15rw348KhERA4H+W12JOLkeFjugb1ch5uqaS
	AzUFUIHomdZLVpprLWMfsGlCLxw0X/c+wCuawfi1L1IkEQzuTfKIij2Xqm7wYhq7QXCz+8Ymzi3
	3DYXnCAXl1xshgvch1c9C5Mf5tcKJbwTbTIXnZYDjmZhhxMVXwai/z9FZ0GdWx594eJm8+2x8qR
	dg5lDUGDUP5t1z1XhRljaagnPaW3PjgJ2BqY7/OqMoHKcjMLnVjVPvvtJ0Ld/DdB5zqv56YsToV
	hOdkZwHa+meDkOwnhK4bOLjVEjoZC7m2IxrYI3caAyx+wIaA3eZ1pjmq7aD5FZJtfjp8p6tRUtC
	i5P/V3mzR10crOT5cDT5EtTNhxfn7bJoxElL/+5DsoioU3euxlrQAbD1FbgxIKaSgZX9Fgxcmk9
	48sGD2Uztx3BQmrNeYok7YBX/cRA4HFS3UQdPxz8cfwOIuiw4zHUUC9THyd+tljGn9GxUEsUcXY
	wkthhPfu6XHiWvp+eDWiBbGCqtw==
X-Received: by 2002:a17:90b:440e:b0:3b0:a518:ffe2 with SMTP id 98e67ed59e1d1-3b0a519047emr516840a91.40.1793796499759;
        Wed, 04 Nov 2026 04:48:19 -0800 (PST)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3b07c896cc6sm9030034a91.9.2026.11.04.04.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 04:48:18 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v2 6/7] wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
Date: Wed,  4 Nov 2026 20:47:59 +0800
Message-ID: <20261104124759.41307-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <08bfa108-3e8a-40fb-a901-99031b284236@gmail.com>
References: <20261031070950.425176-1-hjf3108@gmail.com> <20261031070950.425176-7-hjf3108@gmail.com> <08bfa108-3e8a-40fb-a901-99031b284236@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 03/11/2026 19:41, Bitterblue Smith wrote:
> On 31/10/2026 09:09, Ho Jie Feng wrote:
>> Implement adaptivity for 88xxa, since they support it in
>> the hardware.
>>
>> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
>
> This version doesn't have the high latency during scans anymore.
> However, the message "firmware failed to leave lps state" appears
> a lot more often now. It stops if I disable EDCCA.

It seems to be caused by the firmware waiting for EDCCA to clear
before fully waking up.  I have also encountered this error message,
but it does not seem to cause any other issues apart from the line
being printed in dmesg.

If this is an issue maybe leaving this patch out might be better.

Alternatively, the timeout for the firmware to wake up can be increased,
although according to this commit:
https://github.com/lwfinger/rtw88/commits/1086d09c051f0cff369ccc6a71e3a89706e6efd2/
it didn't help much

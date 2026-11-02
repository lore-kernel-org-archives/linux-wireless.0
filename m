Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793591297;
	b=R0TS44RkwuTvxChdkueCWCvJXimgIPLXWaeWCkyFUJ6h89pI3MBnK9EhntRkdFKClYgP
	 w+UEGP6TmF4N6hBLP52XTuOq1Bss4hbmaMMLFn9mDYjy6QsvXzHKZRz8Se3f77SmnFxvW
	 Ymo5br5JN/7/Ym3oawR6uzRtqFR0c6qfBCX7OsptAaby6piZ59j/yfGCkqmczNC/gxpPl
	 p4qYQvKgnFmlctjhBpPgPR2QpMCH1fmveOXZeT1I1Cx+qbmTo4lmkczQCOM16aku56K4f
	 gHdAFmvYcL5eZ00hCXwVEFWMel/s2U00qCMlCKQwAKc8oal072DQIydlQ+0nEPjyuZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793591297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=B3x9s/6EVM4gCHk/aCUx2i0TPJIArf9E/dcZEMYK5gY=;
	b=v6/ATA38N+atKMM+DfOi04oXxJkwgkFYcSGhGwctZRIUXT1v3PLnbieBfps6GGbQiY1U
	 Z4A2jcLA1JUEGfBfqCUpGrXS+3KC9+ggwrc92l9Yzuj60Y/Q/+3VY8wfU1xMQbJBgKPSE
	 KuhZRuV/kuMZZ+t872UuSHU2QYFkLCFZNeSn2vbdOakQKKHXXJi+1n8XK4xicjL3hltW4
	 xEpiFmULWZAaQSbDR7SpHLNYutVDzRYBEuKxNp8tTOYy76pH7T7D4ypnkhTkCZnTiJmMB
	 PI2HcxouK7yg6oWj/moZby4OxB2RUEeg/o0JOIZKSwFKg7P1Efxu+/5/kzdm8MLlO+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XbxRaqhj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5CE606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 03:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F5CE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XbxRaqhj
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-48e2d5a69c4so1485033fac.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 19:48:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793591296; cv=none;
        d=google.com; s=arc-20260327;
        b=GF+PLCcIiX/MApubowST1LCk5jGj9YRCfsTBIp8kdTvkGt5rr/94N+CZ9//JFgCLay
         IP2MPcsKYa6cRKd5iLOOvjK1+rYWdaZVy65QGG/IbjprKkefTOUIUag0cPbosC0EFaL7
         jlAxrQjpXghqDRcKbfqjOEYcgWnYLjQ2kcZKWsFbA596eO2h1STECQriyCdOBnB7fufV
         Y4MT6ICiDK7i7MxmfxqYqOTKzmdgcuCN2Af+oV5H4x2fd2Wwk/xMG44TYIRf3W+aGu/n
         zvZsfTJ6Q71wQkdUfnI5yO5lXizAa4rvtbGM5qprXGshw6+J6Y5iZtZI87+XcL5E+oLl
         9sfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=B3x9s/6EVM4gCHk/aCUx2i0TPJIArf9E/dcZEMYK5gY=;
        fh=MF5yF9oZ48h1KKiO1ISy64SXw/sNj4co2dotvbXMxYI=;
        b=AnvsWSGnu6gIC4KQ062jZBQAU+c5a2XZOzVM2fDR79a0f2tRiahQ/t/bAr8cpBu08N
         cC8IBvtOYV9AnyxszS2vWrWJlURjPKAFnunYf/UTtbPtVjAuK3KYb6Na9y3qGmO71a7a
         FeXuoz9yjXR/H2L/oJhS0JUgC14JL4CkB8bEjbCB+sexAQpbA0Hb0JDRkwwYTT1+Ol0p
         L42wI+rMb3uREKxPCWa+DvsBfKlnPkbqaZYhYv+FoUzhMf95+Kt+9Onk0hZ8BNm5jujg
         SFwqzukgW+BwEwtHHOVcJYNFBSDAyZTL9bKkhMSnjZSPJAg+bIzf0iFzwGweykXGJvX5
         nlrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793591296; x=1794196096; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3x9s/6EVM4gCHk/aCUx2i0TPJIArf9E/dcZEMYK5gY=;
        b=XbxRaqhjyZPHnOLuz5IQAsGQ+QJEaAtAtE2tosO0JsxtYHFMXdSbskTPTa2qs5KvVE
         A3oMTr7NhR+XCiF7dmDRysULfqadzeSJHsf+zX/2uXZzukkXQdIh6wVRqyZBm4HtoZTs
         CJKfKnSieqd3f9DXjs6c82ojjhoAAjktIG3HF85VMUp52J9yE55YPDiUD8hjjm4/RR2R
         CP4BjMCD91nc5IHstkI9q5cgjqpfkOIi29Iy/ULND20RydHgtxfXcOtWs6xmRYo0/bR4
         oCwKjFP8uBZDTN9NwneamumR4kIdzkYtXlAVYB0Cv2jL55PI+mxy53MCP9sgl7laYGB8
         7Fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793591296; x=1794196096;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B3x9s/6EVM4gCHk/aCUx2i0TPJIArf9E/dcZEMYK5gY=;
        b=uCG/OBwngFAAcJzFSj2vJaefAvvnadVQUTQngchzZvdXUxingqSYNHrsFx4oSNlNUg
         MB0srdZ47ikKS87TZaRsC3iu14CGKE6nqpBHV8yNk6mNsfPGWMFzxUMn/5V8a24vUiMD
         eLfVSgrcGpoMLhLJkg0zBYU0M0Nk8w2qZ6Nt+6rXInAhu4AujUKViR/1BYVbkLEhEbV1
         eGTQ1ZbUTCjsNdWSdwC+TB2/ftFfUjvOi1WTxIanoYKdgBsOWX2cfze08xkh3fX5b6Y2
         r6EiFlhR0tgYZoxJfAcip+e89DwWJuHtAmxHYBAv+ySEoPQci126gDATSp0UzJrQXylB
         h0YA==
X-Gm-Message-State: AFq9FYIGxeOxT03Qh7AyeUngv3+F6V0MbAGk1eoW7Bjgo6IfvgW9KzWw
	SizxYJUhdIVstOu0L+ueyDVfrWfTEbIfNeyM6SHcvMlcKARL9ZPP8AX+erH3uCGgZhiHSMv2Tpi
	PRVa4uo+LVEjqbhKLTVZlz626PfCbcos=
X-Gm-Gg: AYBFou3yPNKVBQa3rllVqFz/c0rDpwoWT0CsjbMiqB8016iKuDzrSD/UKbZTwEzjfWn
	msJx0A7rfe/87EHqMdymNbl803eDkbBqsBP+eD/9CBqMyyAImRkodILNi8fozNOGd2N/GNOfszH
	UOQ3ZjfScEhZjcmmvH7TDbCAO+feYdS5FpBCw73W+alHq+KmWKyElFmYz3Pk82A+z8OUepIPBag
	pc9DzkbLEau641zI58Z/1ut4NdHMFNJCxrYasbyfOC0Tl6ZFlNpbhIKGEua1tNnX7C1TkMGuAnR
	WQSwRb55UAIrDTNbOUrgk+NLcP9EenXtBmQ+PPWFMv1g1s6//IQQ06C83hl3y4OIPu8H4MG3wzz
	FT+lke/e3puQWU8YsFFRm8dIKWqbwhrhTrPTS/u+lEMXLXhA8kWsJdybeSa6ScklGKA6wyvI=
X-Received: by 2002:a05:6870:bacd:b0:4a8:5c86:20bd with SMTP id
 586e51a60fabf-4a90764ca98mr5961924fac.14.1793591296222; Sun, 01 Nov 2026
 19:48:16 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102033244.9330-1-hjf3108@gmail.com> <7065bd99615f46c59171e0fe1672f3a1@realtek.com>
In-Reply-To: <7065bd99615f46c59171e0fe1672f3a1@realtek.com>
From: Jie Feng <hjf3108@gmail.com>
Date: Mon, 2 Nov 2026 11:47:39 +0800
X-Gm-Features: AclHuK_ILmnjasIrqA0E37vh7pe4UmdcP9K-PuCscZr5IG3089kvsOO8-3MExPw
Message-ID: <CABOQOSWhp2E1ZiiO8OVzbetH0267m5qA2aoTeOwYaP8s6C+ANQ@mail.gmail.com>
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Luka Gejak <luka.gejak@linux.dev>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Hans Ulli Kroll <linux@ulli-kroll.de>, 
	Kalle Valo <kvalo@kernel.org>, neo_jou <neo_jou@realtek.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 11:36, Ping-Ke Shih <pkshih@realtek.com> wrote:
>
> Ho Jie Feng <hjf3108@gmail.com> wrote:
> > When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
> > into a new buffer. That buffer was also handed to mac80211, as one
> > additional TX completion.
> >
> > Report TX status only for the original frames, and free the aggregate
> > buffer without passing it to mac80211.
> >
> > In the case the ieee80211_purge_tx_queue is called, the frame is
> > passed to ieee80211_report_used_skb. Since it fulfills none of the
> > conditions within the function, the frame is freed as normal without
> > a TX status in that case too
>
> Miss a period. I'll add it while getting merged.
Thanks, will be more careful about this.

> >
> > Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>
>

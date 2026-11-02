Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793585664;
	b=ZDs845Uobv+ns1MFVXeecPJ4bftMRAfd+zSBAZeWWo2iBknK062zdKvo+VWSNWSQ1LbY
	 NBvuIpJkj9mE+M00CBgrRVWB5IllBEhraz1sf7YP8CPHKp1BQ8bXXynaSB/TohIkrox3t
	 1DY9TGtG6pvRVtJmhE0ebHkrQx8o3DpWWJXOgcvNW1mcn6X2GsfDkJfCSN6ETlqOHAkoy
	 CWwmvvdICl+jWI5aEEPMWv5kSa+f1Yy4TTsNQrPyO8Tp6W6Lmb5oolMliFozFNafJW5xP
	 b7NqdC1pInpT2H5i6/Ms0T7etGsHgNVeC9cZovElsqRuwcm63hQZp3KH5vvXX2NKmiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=J7MH/48r4Ni/jzs6ijJK/lnj/9Uw/DovSxpncCh69tY=;
	b=it5EVLG0qD1CamHhlTTMRBSQ5jFqjDdujK/iHJl3NsSdtSndcDRGxtkTkE9tmbDbs2TK
	 nlyj7xKk4df4HokW4CVyNhWq5HSQo79YqTipcwo6huhSgVTa9TJ2ohvdwZpLCvPb2ZyBo
	 0cCdyEh2cLA/RvL4ouJicv5YK3UVYzwkq7wB6fp7PPqvwvybRGsb/z41i92LkPXUdq5uA
	 KCsLsvjZmBJQG06ZSsAY9m+oURThvD1Mu6veRPwePNNzvqB4C/gRKdPh6ifLQLRokC40w
	 HMP0ofneqQZ/ARzDRvL8wyJiHOYIFFXWwNW3D2JxQXvNYSCo1rRZQzJpTVoPSD76CGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EIy0iLWW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E110606A338
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 02:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E110606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EIy0iLWW
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4a85c656c58so1550772fac.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 18:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793585662; cv=none;
        d=google.com; s=arc-20260327;
        b=fwOHUQhOH1DZ2BHmFcT4rrJ4fr8HQcNGIyzbSBR5BQrvBThR2K9AES9IWxFkZTU4fh
         QFP46WKfPHgFeqhyerQcni6U5zImV1pFDtcu3BczV+O6YiD5DS3evT+xMGoc9rEwL/BG
         XGO1lAkjWrWAiaiLoYJZ+lLyLOGGGwGbyjKAk+or0r2nIDyZ0pCN4iNVJlwTzNXzTvZZ
         wCerqJUpPv+ctc1q7+E3EhIaydOZcAy/Ldt592e6fUwIWVxXgeWHqVMLCWkCb93eFMEh
         vFPSgBfrBfoUwZF77LlmXhD+u0T4hyu9ik5HVtiJGBCj/ShYW1T63YDLQ0UmApsoe51q
         BYzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J7MH/48r4Ni/jzs6ijJK/lnj/9Uw/DovSxpncCh69tY=;
        fh=mdO8khatn45S12dhZE515XG4X+D8/ujBG6paOOwupdg=;
        b=pAyrOlKc6fh+SVzOeGpZ8UnHazK34lkAbuKaPkoUXxyfHaX+4JMD0aM2CbIY+tT6Yx
         pn0Hr5BgVxivDyo3229tLBLTeNloHgqS1GnIJSmEzV6iBkJUxKX9hGa5YiJz4chfHyx2
         VQkXGRHZYDT7uCC9MpAh3Im73MmvRaHxUkUczWo9a80rrEGGC7RdAYuuSLzOfyKx2v9a
         2ErXsOJgfsvg4hxDYf6d9ame5huUQ+MZA1u22+XfYByk2F9oXUaXWY7OoRHkIXvYe/gH
         TABwS5suqkLKOZEqcKgYmLndmLJKh09meKg0r1na0Verjo8A99h/bxrBzihJapCoFC45
         7SFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793585662; x=1794190462; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J7MH/48r4Ni/jzs6ijJK/lnj/9Uw/DovSxpncCh69tY=;
        b=EIy0iLWWc/ueA+1nbLeuNzfCDQ1KKufPJKyskcFmycme1YFSiKbQ9aZWFz0yH2lRGA
         DTbZ1DQ59/ZmHGnr+hKYuEfRowd6mA+Nm2jK3Lu1jdcpno7FHI0QUG6x4ZuMdq3JXxMy
         V5NoCK5GugtC87aJJIgRW9la0lYmRFyt1JWTzklfq1g+tQ6HgC2RmTqIFQ0QJY59UiBY
         hDXwqrS2WgnHyDn5uaaw0kY7HLK1C/zO3UfWR75cFaJkWLEAZ59ZBUSYqkcylXafgX7e
         5XcJMB4YUmE9kXolmJpabu2PGjlVrdvNeclK02CP/fr9+sBGDAbnbNDGMmicL69Kvw27
         Bd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793585662; x=1794190462;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=J7MH/48r4Ni/jzs6ijJK/lnj/9Uw/DovSxpncCh69tY=;
        b=njC4Sb07CUCytrz3KBJxoSRdd1yhmEFO677EeDtwF3oiO26ocolLIcWf7ARjUGq+so
         Dkzg2R+10xUsJTZKgI652FKaN+9j2A7mMBOFPC9krnHNq3AYkluCDcKvrmheo8gdJAun
         Whhbb6TwFgqoOsIbzh3/azUjgkOWEVgpO5DukTtrc3KUbHFlqNISwUXIj4xKMGvBFz6q
         myOiW2LOArMKjHX+vA5flvOtTJDzDJbSLm+FEKo3zOoUc/GfZxbVq8zhh7AIU8EkjAJj
         zZ1gyw4Q14CBQ4SGG4CfBzhwT775BhE98XhKJejINfkmRa7yKl/ASXFGfRdpunKjaRjm
         LKlQ==
X-Gm-Message-State: AFq9FYKkvD1ZGijcFpQSc0v5UVH9bYQZgNDeCspVKFsMAFti7dTkQo+t
	KyW8baul0zw04WE6ZSzuaFzkj9qRW6nIMgx+FarLUwf54MZYhf1yW3pS5KBpueZ1pzn5V/b7hix
	CTAnQJ7HX6OX2qcRlMODxS/V3KbgIvzc=
X-Gm-Gg: AYBFou04yM4LZm6NYZg7GV/VTKhQVCyI3yX1vprBNZGvSyLC1dVrnJxiOeEdE/wdl5j
	hRBWKaWaGCzWxcWZLb+X8bbni8W/2+6/c1FYy+AeBcjW+BCIqu+x2LJ2j3A8uNSnpl58vl//cvm
	2lXFsy6OeQw2PdKjUdB/b98oCXJomRHAAqy5FtgrKnA6r/70NzOfMrEX2pB2TqGsq6SXuUP3/oG
	qi9hgOBGCk/o1JV6huwY6Y/wp10RfCVZpltoaixVoYwna/d99XNLjVxiB5vm1PVBDHyVs7mAe66
	xeELTT0JiutXdY2QkKngqG3EJK1kdRJxhU3CmpLrfOlJ5sc0T3MSde/sT5f51Kq8xvV9libCe3B
	5K7WPGvoxOSomjd4H+b2Hm4bS0ifuQsSqeGM2FWmQZJZ9YyeOBjOhoBQAAxGft17yMQBGO0A=
X-Received: by 2002:a05:6870:899d:b0:4a7:6dc:af65 with SMTP id
 586e51a60fabf-4a90761c954mr5103199fac.10.1793585662487; Sun, 01 Nov 2026
 18:14:22 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030165451.365591-1-hjf3108@gmail.com> <2d53d5420be945fc9bdfbea5542b61db@realtek.com>
In-Reply-To: <2d53d5420be945fc9bdfbea5542b61db@realtek.com>
From: Jie Feng <hjf3108@gmail.com>
Date: Mon, 2 Nov 2026 10:13:46 +0800
X-Gm-Features: AclHuK_MCrZszNRjWmbMr9BiDOUVzGyr9u-wzmxnrLzdDFuwUYkS6e5HNCVKkjk
Message-ID: <CABOQOSWOqGEu7xHH1ap=MYqFd_oH7oAhQqCq6Ch622ipHdF5Nw@mail.gmail.com>
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>, 
	neo_jou <neo_jou@realtek.com>, Hans Ulli Kroll <linux@ulli-kroll.de>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Nov 2026 at 11:44, Ping-Ke Shih <pkshih@realtek.com> wrote:
>
> Ho Jie Feng <hjf3108@gmail.com> wrote:
> > When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
> > into a new buffer. That buffer was also handed to mac80211, as one
> > additional TX completion.
> >
> > Report TX status only for the original frames, and free the aggregate
> > buffer without passing it to mac80211.
>
> The rtw_usb_write_port() might be failed and call ieee80211_purge_tx_queue()
> to purge txcb->tx_ack_queue list. Should we check if the tail skb of
> txcb->tx_ack_queue (or just check skb_head) is drv_frame=true?
I traced ieee80211_purge_tx_queue to ieee80211_report_used_skb, and
based on the code here:
https://elixir.bootlin.com/linux/v7.3/source/net/mac80211/status.c#L759

I don't think it fulfills any of the conditions, so drv_frame=true entries
should just go through a normal skb free path.

> > @@ -431,6 +436,9 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
> >                 goto queue;
> >         }
> >
> > +       /* report TX status only for the original frames */
> > +       rtw_usb_get_tx_data(skb_head)->drv_frame = true;
>
> If we can just check drv_frame by skb_head, just declare a local
>    struct rtw_usb_tx_data *skb_head_tx_data.
Is this still needed if ieee80211_purge_tx_queue works?

> > +
> >         while (skb_iter) {
> >                 unsigned long flags;
> >
>
>

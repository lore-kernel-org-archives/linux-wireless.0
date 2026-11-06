Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793950778;
	b=diEETK+jXc6B1ukHewBxCNe79vu7IqgLsEm/F308XY0+AOp0z+2SMUEGiFhbO4glWo0U
	 cjr55czd9DPro5SJ2qEEOFPRjSf3Cg7sClePyXKp+qMTVup8s5zrJaP6U2N9KetUKfael
	 r6C6yFliYAa8edAa/D/fWiDUKN8aOiNWY9uNi86xHKWxcIItyUIjD1EinwhMPehVbCGlW
	 5fMAKXxAGlzXUvpTSpueDSh3c8mBEo6IiyxXCp4ryoXV/MViEtkgd+odyGXadV8eYPPf6
	 IQa/2gwMDdi+9uK4EbX4gG+6QM7usRciljk0lJVO73x/qZelTwP0DstPBNBsZjGpFrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950778;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=jpn9Nn8H0lLUkrlh0Uzhon9pi76xy9YB87jH9BJ57KQ=;
	b=Es1gmuB/vXiPCG6bn4gBwDhM+AkvgRpzTdYYjw1nY4w0IS5pqfSbypSELcNvpXAaBF62
	 pHPMtLAHPUj/QIDoDg+e38P2QwgQFLlNyhrEyrwEO8mQL+Z9676KdLB8lr6fgvjXgeO49
	 VG6ACqbfMkmN2eEwJA16O89cuSt9+XreG4fZ4nbuJCR7fU1/UULlHoOj/XZs0EYgE0l/F
	 suipyxpYMKImGDnrbACNfH76sUwAlUv2BuudvbPUbm9oaYIUawkb8nGH57afAr0PdFMh4
	 DiQkcGw4PXAguuHKn5bI7pgru7h4eQnoOGKKjskIxOqpTqDiTk/NLWEYOgO6+1vBSuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vCzJI2aH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.47
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AB4606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40AB4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vCzJI2aH
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-843a4ca671eso137811a34.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:39:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793950777; cv=none;
        d=google.com; s=arc-20260327;
        b=f4AwkY+8E5fb2ggf/k0hASpS2mSyt6p7UTmuk+AuXRv5qsJ0t7BwCIw3pQCszXthoa
         SpiTrk+PPEZz7uOaMUmxUXVi+U5fn9UBpVxuVUGNpwO/atSHSvTSVDRk0v4H0ou+q9j+
         SdR+UrtiE68knMtKmjcHlXTo6XHwrgH1hNQi0Misb7QSvjsDNsfBcjnh8hDeg2xH9Clj
         hKubYqL5c/7tAT0DRwPghDgG4h0CQE89o1OEp4/UpqFV5FtHjcoIO+Nm00OVDoJHxu7G
         dTkEn8lgcD+8T4L8MkIBZzg6jAS0gSlQOYnl/Rcfk85G9LIVkqHrzE3C3uhmjDlp53CE
         QrKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jpn9Nn8H0lLUkrlh0Uzhon9pi76xy9YB87jH9BJ57KQ=;
        fh=Gb8RSDLQoV+qgJjwh3JErt+C3hloosFkdHxORzYl2ZY=;
        b=ZoxHGRjTvz+vtBb+YTt+BXx1bmpeQQslbUJ+xBnvLC9Qhdz2XjVGBzz9fheT6g06rN
         m9aavLJHpPJt2WKJ/iVN1YN9+o5GBTJQXVDCvdeU0NMqIzVN5yJDuA/98plhlbGvTmK7
         Plp1gjLZ1sB4rO5767xbHzmhTIs6BlUUhk/SVG5kmI0IxdSWdJvwMExkuLwyl4x3cTnK
         JqM2kOEBDnNxV4WizFceFE1Lb6xulOHHoFq9fncH1BH3+6OPhGs5lZj8IUK/RdvUBKnK
         vCHYDT9i6urB2REwP/z5WYWtsoiBXu8G9f/38CBRlCUSwdilAKUGy2AwZLKvqiMSQOIu
         udvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793950777; x=1794555577; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jpn9Nn8H0lLUkrlh0Uzhon9pi76xy9YB87jH9BJ57KQ=;
        b=vCzJI2aHFtklJDK06/7ZsMueNyaoJAwrhxQkA3YHH0NTU18KkI4zEaeAz4AXWnUTsR
         bx8c8XNM3SXMNfCEuzWFpBbslEMwbfwhkJLsOOtWARFeAcYOGfHHwsPDijGvcCcj5JAI
         8nVOtHJEn6SCayGLZhi/lwvStBqdQ38a+Voxihvq8UMkpSlrJ7EroiTG4ncdaQCYadfu
         YASdIp+htOdquVAFT9mKFvl0wR0SDwlgRS4g5iVHJ6D09NZZtAiN/m3MyrJJXkGkIwDb
         N39Bz9dfAzvrGdkzu7DfoOhOnEXJlO1bxHM/qrUyAjdH9q3ynACBoXJmo2zTAiagXTC4
         +sKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793950777; x=1794555577;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jpn9Nn8H0lLUkrlh0Uzhon9pi76xy9YB87jH9BJ57KQ=;
        b=qaUdqATms19L9n6Go9dIn9LTGST5oqjMejHeh3gq1xBXCggKia4GrUvryFiW2THLcL
         GQwF4MWQH65PGT+mnJNK74+6V8T5HrxJaGtHg6Uh1urrdRszHcnNTJDnC3FD0XQADldX
         M9pwvNToKJRNI1xOv5tbxrcEz3hlSzdTE6Ax6Op2Swiqk+IbvzKUJjRDX34R9NCDIOb6
         1WrpBfTT5q8FNqUZ0PYIdnlt0aw8x8PzjvTwzUtxcTfA/WmhoKTqCAsgP8R9eDzSOjXQ
         mZ0/DbEqBgfOgnApxy5WiHlIu5m94Rxn9858CRh+gkwP1NxYFrtdEC1VM1KEYSQa3Rb6
         peIA==
X-Gm-Message-State: APuU4Z8f7rmrcHp+4VTzRGTDDDUWmEILziwr6Hro4T4CIhEUGFPmkTVd
	9b44E6tvQRXbDm7o9TmY46Ifg0Ycfs5VvfE+Wpqf7v/3a1BeXDnzSOlhQrC4Clko692VnGPhNrW
	XUkASph4mdKRyHBCFV1UhBO3pBC+XSPs=
X-Gm-Gg: AYBFou0vpjyBDYaSlHfeM39JmBC0lGVnwvIbWxex4rL6QT6whweuKvGfh++Dah1Qe2H
	KJqQfnsKjwOpuLI8Fe4QHqT2+GlZO7fIGIQoSZeNwec8Fa8OB9YkAal+j/R/5jgCL/1CgCQhF1p
	X4B9b/mNT0y30TC0FeEl3oHyumXcZVgy5/yoLlIvFLrcwsBiB9Va7LQ8B3hJC18dnQ5Fju8o/cy
	WeVdvUUqvPKvqRJKkvDwdpu4B+urm6Jd3DJsEJ8t0fkFKYF4O4rdSo+c/kueQ0BIcSlVNF9vGdm
	79plKWjoR4LQgWGRlzRGgCZYcT8WLJolIzLkb0EuErmfG8UY1TE7WwcIW6IMQYwNJnBekk2Kxlm
	oTYRnvpyshsbppG9qIStzZEErZGnpbF87VTrVmZ7RDLw3X5du6u0ggDOeWNpLy95PHOK6BQ==
X-Received: by 2002:a05:6830:927:b0:822:527e:f653 with SMTP id
 46e09a7af769-85f1cf54f12mr2069036a34.13.1793950772190; Thu, 05 Nov 2026
 23:39:32 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031165117.2868671-1-hjf3108@gmail.com> <20261031165117.2868671-8-hjf3108@gmail.com>
 <20261105082005.GG64923@wp.pl>
In-Reply-To: <20261105082005.GG64923@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Fri, 6 Nov 2026 15:38:55 +0800
X-Gm-Features: AclHuK8nmg7m-b4ispPhCZZ7hjpD4-RJNjn--QVR3SJWw_mJXHttddE5nKdeFC8
Message-ID: <CABOQOSUyRiVBY+A3c-4tqcaq6Kc66XRsW1mU=Mhdx=gFkE+q6g@mail.gmail.com>
Subject: Re: [PATCH wireless-next v2 7/7] wifi: rt2x00usb: use a threaded NAPI
 with GRO for RX
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Nov 2026 at 16:20, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Sun, Nov 01, 2026 at 12:51:14AM +0800, Ho Jie Feng wrote:
> > GRO makes sense now that RX aggregation is enabled, since multiple
> > frames arrive at once.
> >
> > This code is referenced from commit 5323d3e50c20
> > ("wifi: mt76: mt76u: use a threaded NAPI for the RX path")
> >
> > Test results:
> >    before after
> > TX 30.5   30.5
> > RX 80.9   161.7
>
> What is the explanation for this gain?
GRO merges more TCP segments, so the TCP stack sends fewer
ACKs for this thing, so fewer TX frames.



> I tested on my devices and do not see RX performance gain.
> I would expect some benefits, but I don't see any and wonder why.
> Maybe on your setup CPU get saturated on single thread ?
> Or maybe I'm not testing traffic that benefits from this?
For my system, the number of TX frames per second is bottlenecked by
how fast TX status can be read over the control transfers. I tested on both
the VM and on bare-metal (not the VM host), and they come back
in around 250-350us according to usbmon captures.

Both are on AMD, so it might just be the xhci controller being slow
for these transfers. I found some evidence of this in this message:
https://lore.kernel.org/all/20261103072849.623325cd.michal.pecio@gmail.com/

> > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  7 ++-
> >  .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  6 ++-
> >  .../net/wireless/ralink/rt2x00/rt2x00usb.c    | 49 ++++++++++++++++---
> >  3 files changed, 52 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > index 4c83168e9c169..25262b96c6941 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > @@ -955,9 +955,14 @@ struct rt2x00_dev {
> >       /**
> >        * Scheduled work for TX/RX done handling (USB devices)
> >        */
> > -     struct work_struct rxdone_work;
> >       struct work_struct txdone_work;
> >
> > +     /*
> > +      * NAPI context for RX done handling (USB devices).
> > +      */
> > +     struct net_device *napi_dev;
> > +     struct napi_struct napi;
> > +
> >       /*
> >        * Powersaving work
> >        */
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> > index 8f02b62cecdf6..6226bcbf24e5b 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> > @@ -847,7 +847,11 @@ static void rt2x00lib_rxdone_skb(struct queue_entry *entry)
> >       rx_status->bw = rxdesc.bw;
> >       rx_status->antenna = rt2x00dev->link.ant.active.rx;
> >
> > -     ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
> > +     if (rt2x00dev->napi_dev)
> > +             ieee80211_rx_napi(rt2x00dev->hw, NULL, entry->skb,
> > +                               &rt2x00dev->napi);
>
> The docs for ieee80211_rx_napi() states:
>
> "Must not run concurrently with
> ieee80211_tx_status_skb() or ieee80211_tx_status_ni()."
>
> So we would need to either introduce lock similar like mt76 or
> assure ieee80211_ts_status() and ieee80211_rx_napi() are done
> in the same thread.
Thanks, I had forgotten to revisit this after the prototype works.
> Regards
> Stanislaw
>
>

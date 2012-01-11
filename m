Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43634 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622Ab2AKIu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 03:50:29 -0500
Received: by mail-wi0-f182.google.com with SMTP id hm4so308721wib.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 00:50:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120110222524.GF19790@pandem0nium>
References: <CAK80WHZZp=NxVigOZWgECF6Z1Apdzc3dPCXyYRn98QizALTh=g@mail.gmail.com>
	<20120110222524.GF19790@pandem0nium>
Date: Wed, 11 Jan 2012 10:50:28 +0200
Message-ID: <CAK80WHY+cCy0z6s1UchOf_vwL-3Am8Q-SPACJLNnWTXknDqM5A@mail.gmail.com> (sfid-20120111_095035_032599_92810DDC)
Subject: Re: DFS implementation status update
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	kgiori@qca.qualcomm.com, mcgrof@frijolero.org,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <coelho@ti.com>, Assaf Azulay <assaf@ti.com>,
	"Divinsky, Yonatan" <yoni.divinsky@ti.com>,
	Igal Chernobelsky <igalc@ti.com>, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Simon,


>
> Do you plan to support IBSS/Ad-Hoc as well?
>

For now we don't have such plans.


>
> I guess you're implementing the channel switch part for now, any plans
> on the rest of 802.11h? (station measurement, TPC, etc).
>

Same here, for now the main implementation is the channel availability
check, radar event and the channel switch mechanism.

>
> Do you plan to allow band selection or channel selection? For example,
> it would be desirable to only select indoor channels or outdoor channels,
> exclude weather channels (5600-5650 MHz) or only select a specific subband where
> high tx power is allowed.
>

For now we use random channel selection after radar event, but later
on this can be changed to more sophisticated algorithms.

> I'm also not sure if pre-selecting a start channel is conforming to
> ETSI EN 301 893 V1.5.1 - as I'd interpret it (but I might be wrong), a
> channel should always be randomly selected from the available channel list
> (4.7.2.6 Uniform Spreading) - there is not test specified for this though (Annex A).
>
> I'm also missing the channel switch announcement for associated clients in your
> flow chart, but maybe you skipped this to keep it simple. It looks like a good approach,
> I'm really looking forward to your patchset.
>

Yep, you're right the CSA is left out for the simplicity ;)


-- 
Thanks,
Victor.

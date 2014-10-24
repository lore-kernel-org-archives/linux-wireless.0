Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:32926 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaJXTNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 15:13:18 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so1749710wgg.30
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 12:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544A7871.7020005@mailservices.uwaterloo.ca>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
Date: Fri, 24 Oct 2014 12:13:16 -0700
Message-ID: <CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com> (sfid-20141024_211325_276221_B9D14EEF)
Subject: Re: strange MPDU loss pattern
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not completely unsurprising - the initial channel estimate and
such is done at the beginning of each packet and stays constant. So if
there's some varying channel conditions that change that during the
duration of a packet, the tail end is going to end up having less SNR
and may end up getting more errors.


-adrian

On 24 October 2014 09:04, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Hello,
>
> We study the effects of 802.11n frame aggregation on throughput. We noticed
> a
> strange pattern in the MPDU loss within an aggregated frame. It seems that
> the
> second half of the MPDUs (those with higher sequence numbers) in an
> aggregated frame
> are more likely to be lost. Is this a known fact or is there any explanation
> for it?
>
> For example if 32 frames are aggregated with sequence numbers 100 to 131.
> Frames with sequence numbers 100-115 are more likely to be received
> correctly
> than 116-131.
>
>
> Best,
> Ali
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

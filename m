Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36404 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJXTXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 15:23:53 -0400
Received: by mail-ob0-f170.google.com with SMTP id nt9so929992obb.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 12:23:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
Date: Sat, 25 Oct 2014 00:23:52 +0500
Message-ID: <CADxDmp5f0U3nzf68jkfcBadUEgv6pGRpd1UtpW-8bo_qjFvpaw@mail.gmail.com> (sfid-20141024_212357_337201_23A79085)
Subject: Re: [ath9k-devel] strange MPDU loss pattern
From: Kamran Nishat <kamran.nishat@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Ali Abedi <a2abedi@uwaterloo.ca>,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

But for this channel conditions should be changing at the scale of 100
micro secs consistently.

On Sat, Oct 25, 2014 at 12:13 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> It's not completely unsurprising - the initial channel estimate and
> such is done at the beginning of each packet and stays constant. So if
> there's some varying channel conditions that change that during the
> duration of a packet, the tail end is going to end up having less SNR
> and may end up getting more errors.
>
>
> -adrian
>
> On 24 October 2014 09:04, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>> Hello,
>>
>> We study the effects of 802.11n frame aggregation on throughput. We noticed
>> a
>> strange pattern in the MPDU loss within an aggregated frame. It seems that
>> the
>> second half of the MPDUs (those with higher sequence numbers) in an
>> aggregated frame
>> are more likely to be lost. Is this a known fact or is there any explanation
>> for it?
>>
>> For example if 32 frames are aggregated with sequence numbers 100 to 131.
>> Frames with sequence numbers 100-115 are more likely to be received
>> correctly
>> than 116-131.
>>
>>
>> Best,
>> Ali
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

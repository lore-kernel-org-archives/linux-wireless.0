Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46534 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1KYSkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:40:21 -0500
Received: by iage36 with SMTP id e36so4896257iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:40:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd8GU8F2EV1zjZP5NG_QvfYaLr7wPz3OE49mX+-Mrx15XA@mail.gmail.com>
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	<CAPjQAd8GU8F2EV1zjZP5NG_QvfYaLr7wPz3OE49mX+-Mrx15XA@mail.gmail.com>
Date: Fri, 25 Nov 2011 22:40:20 +0400
Message-ID: <CAG5dHkRaRe4HZmK401DSqD5hqpZ9yrKfUs-gOjPypSNzFn7khQ@mail.gmail.com> (sfid-20111125_194025_241521_A8AB149D)
Subject: Re: [RFC v2 0/8] mesh power saving implementation: indication
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2011 05:40, Javier Cardona <javier@cozybit.com> wrote:
> Hi Ivan,
>
> Good work!  Comments inline.
>
> On Mon, Nov 21, 2011 at 6:40 AM, Ivan Bezyazychnyy
> <ivan.bezyazychnyy@gmail.com> wrote:
>> We have updated our patches and also we would like to add some words
>> what our work is about.
>>
>> Based on the latest IEEE 802.11s standard the power saving mechanism
>> can be divided into the following implementation phases:
>> * indication of mesh STAs' power modes in frames;
>> * a buffering and identification sending frames in mesh STA;
>> * Mesh Awake Window implementation;
>> * Peer service periods.
>
> My recommendation would be to implement this bottom up.  That is,
> start by implementing the Extensible synchronization framework
> (Section 13.12.2, 802.11mb D10.0), as power save will not work without
> syncronization.  After that, continue as...
>
> 13.13.8.4 Operation in light sleep mode for a mesh peering
> 13.13.4 TIM transmissions in an MBSS (and buffering)
> 13.13.6 Mesh awake window
> 13.13.9 Mesh peer service periods
>
> Only after this is implemented I would advertise this capability in
> beacons and make it configurable via userspace (i.e. what you've done
> in this patchset).  That approach would also make it easier to test;
> only after you get the TSF right you should attempt to implement the
> awake windows and so on.
>
> Does that make sense to you?
>
Thanks. Definitely that makes sense, but we have to better understand
the first part about synchronization. We will study it.

Best regards,
Ivan

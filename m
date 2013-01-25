Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46416 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AYWIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 17:08:41 -0500
Message-ID: <51030260.2040004@candelatech.com> (sfid-20130125_230844_939216_8893C8DD)
Date: Fri, 25 Jan 2013 14:08:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sam Leffler <sleffler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Increasing throughput on 3-radio system?
References: <5102CADE.2010900@candelatech.com> <CA+yqC4b2_q5Nn2t7C-5JdAfxR-QA8KtBgqE_sw91ZfNwt-k+LQ@mail.gmail.com> <5102D0C7.50907@candelatech.com> <CAJ-VmonmYNGK42DuCLStjvSswdvkzeHUAwH+fsZQL5BdxwGgjA@mail.gmail.com>
In-Reply-To: <CAJ-VmonmYNGK42DuCLStjvSswdvkzeHUAwH+fsZQL5BdxwGgjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2013 01:55 PM, Adrian Chadd wrote:
> Hi,
>
> Strong enough out of band RF is still going to bleed over and it may
> saturate the receive amplifiers before it hits the chip and the
> configurable analog band-pass filter.
>
> Hence the suggestion to always TX at the same time. That way you don't
> have the problem of TX from one radio being strong enough to
> saturation. You can tune the PHY (via magic handwavy parameters that
> strangely enough are partially described in the ANI code :-) to reduce
> its sensitivity to blocker signals, but it doesn't help you if the
> signal is close enough by to trigger the wideband / out of band
> interference check. If you try and receive during that you're going to
> have very poor behaviour.

Could you point me to which registers/vars/keywords in (ath9k) ani
do this?  I'd like to play around with them a bit.

As for transmitting at the same time, is that even possible
using multiple ath9k NICs in a PC?  It would seem to me that you'd
need some kind of low-level communication between the hardware/firmware
on the NICs themselves to accomplish that?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


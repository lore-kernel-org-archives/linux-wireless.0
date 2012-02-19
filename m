Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46338 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2BSWbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 17:31:12 -0500
Received: by wics10 with SMTP id s10so2546339wic.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 14:31:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomgWo=QRemDv5-NHfne9Oj128A_Qn6Xu4UVzJAMRMgXhg@mail.gmail.com>
References: <CACct8en2C+fuL81mLwdNUXvvAzyKjj5yjmcWGg_tWHAzQkeF8w@mail.gmail.com>
	<CAJ-VmomgWo=QRemDv5-NHfne9Oj128A_Qn6Xu4UVzJAMRMgXhg@mail.gmail.com>
Date: Sun, 19 Feb 2012 14:31:10 -0800
Message-ID: <CACct8ekj6sq6AeN-mGGyoCa2qfA-kttsVZ2a2i_VGn7BdkOqCQ@mail.gmail.com> (sfid-20120219_233115_974199_FA268316)
Subject: Re: ath5k : Where does the actual CSMA take place?
From: Yiannis Yiakoumis <gyiakoumis@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

Thanks for the explanation. I am a bit confused though. You are saying
that the DMA starts when there is a txop, is this correct?
So, does DMA take place on a per packet basis? If so, what does start_tx_dma do?

To trace things, I am sending a 10-packet train through a raw socket.
All packets go to the tx queue (length reaches 11) and then I start
receiving TX interrupts. Does each DMA request gets completed before
the next come, or tx_dma just posts the requests and these are
processed later?

When all 10 packets have been through tx_dma I start getting
interrupts. The first is a TXEOL and the rest TXDESC.
My understanding is that the time between the tx_dma and the TXDESC of
a packet, captures both DMA and wireless transmission - could somebody
comment on that?

Thanks,
Yiannis

On Tue, Feb 14, 2012 at 9:46 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> The way it works is pretty straightforward (from the surface.)
>
> * The radio signals whether the air is free or busy;
> * The QCU handles the frame queuing;
> * The DCU handles arbitrating between different TX queues, based on
> whether the NIC is currently RXing or whether the air is busy;
> * There's a bunch of timers in each DCU to implement
> contention/backoff (see AR_D_* registers in the FreeBSD/madwifi HAL, I
> don't know what they're called for ath5k.)
> * The DCU then gates the QCU and kicks off DMA.
>
> So the hardware is what decides when to trigger the TX DMA. In fact,
> for later NICs, they may start DMAing the frame _just before_ the
> IFS/backoff counters reach 0, just in case it wins the opportunity to
> talk over the air.
>
> You just setup everything to allow the NIC to begin TX DMA when it's
> ready to send things. :-)
>
> HTH,
>
>
> Adrian
>
>
> On 14 February 2012 12:06, Yiannis Yiakoumis <gyiakoumis@gmail.com> wrote:
>> Hi,
>>
>> I am reading the code and trying to understand what forces the packet
>> out of the card, or to be more clear, what runs CSMA/CA and when
>> detects a tx opportunity pushes the packet down to the phy. I can
>> track the packet all the way until it gets to start_tx_dma(), but I am
>> not clear what is the actual call that sends it out, and how this
>> relates with QCU (I am on a 5212). I suspect that it's within the
>> tasklet_schedule but wasn't able to find the details.
>> Also, does QCU get involved on a packet-per-packet basis, or does it
>> just set the initial values to the device's registers?
>>
>> Any help is much appreciated..
>>
>> Thanks,
>> --
>> Yiannis .
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Yiannis .

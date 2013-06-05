Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:34833 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3FEXTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 19:19:23 -0400
Received: by mail-qc0-f169.google.com with SMTP id c10so847233qcz.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 16:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306052335.25953.chunkeey@googlemail.com>
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com>
	<CAB-Tk73mTDsvf+MCEq5xfUBUtE4c6KfL2nkAcZe2LCY5pF=7RQ@mail.gmail.com>
	<CAJ-Vmok5yLZvstvYHi35ALWG3q8sVYLx_1PuhL31unOjxrg-4g@mail.gmail.com>
	<201306052335.25953.chunkeey@googlemail.com>
Date: Wed, 5 Jun 2013 16:19:22 -0700
Message-ID: <CAJ-Vmom6cmf-c-TJs5s9AvT953m0+tANVj_AxnSYwUCzegyPWQ@mail.gmail.com> (sfid-20130606_011927_057180_5A63C62B)
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "C.B. Wang" <wtwangcb@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh cool! I'm glad they included a half/quarter rate clock change bit.

Just make sure you test it with adjacent channel interference; it may
underclock the MAC/PHY but that doesn't necessarily mean that the
analog filter is being changed.


Adrian

On 5 June 2013 14:35, Christian Lamparter <chunkeey@googlemail.com> wrote:
> Hello Adrian
>
> On Wednesday, June 05, 2013 08:08:14 PM Adrian Chadd wrote:
>> I think that the zydas mac doesn't officially support 5/10mhz operation.
> Just checked, it looks like the bandwidth control is very similar to ath9k.
>
> The settings is controlled by Bit 3 and 2 in AR9170_PWR_REG_CLOCK_SEL (0x1d4008)
> 00 <-- default
> 01 <-- half
>
> There's a new firmware branch for this new feature:
> <https://github.com/chunkeey/carl9170fw/tree/halfandquarter>
>
> The patch for the carl9170 driver will come later... Once mac/nl/cfg80211
> and userspace have support for the 5/10 MHz channel bandwidth.
>
> So, if you [(Mr.?) Wang] is interested, please help us testing
> and integrating the stack patchset into the kernel - NOW -:
> "Add support for 5 and 10 MHz channels"
> <http://www.spinics.net/lists/linux-wireless/msg107116.html>
>
>> > I've read the "otus" vendor driver and found that in the source file
>> > /HalPlus/OTUS_FB50/hpreg.h on
>> > line 1915,the comment says "Temporary discard channel that BW < 20MHz
>> > (5 or 10MHz)   */
>> >                             /*   Our architecture does not implemnt it"
>> > I think either the driver does not implement the 5/10 channels or
>> > worse,the ar9170 chip does not support 5/10 mhz channel at all.
> I think "architecture" could be just the software. At least an
> ath9k spectral analyzer confirmed that at least the PHY can operate
> on 10 MHz channels in the 5GHz band.
>
>> > But 802.11j has 10mhz channel support.To comply with the 802.11j
>> > standard,the chip should support 10mhz channel width.
> Oh, I don't have a 802.11j copy handy, is it a mandatory or optional
> feature?
>
>> > Also the ar9170 MAC was indeed designed by ZyDaS berfore
>> > the company was taken over by Atheros.
> Do you know any 5 GHz solution from ZyDaS that sold as 802.11j
> compliant?
>
>> > It has some problems with long distance links.
> True, but again look at the vendor driver. I think it should
> be very easy to implement "set coverage class". The slot time
> can be set by "AR9170_MAC_REG_SLOT_TIME" register and the ack
> timeout should be in "AR9170_MAC_REG_ACK_EXTENSION". That's
> all the information I have. So what are you waiting for ;)
>
> Regards,
>         Chr

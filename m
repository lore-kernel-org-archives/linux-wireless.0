Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37863 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EPScR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 14:32:17 -0400
Received: by dady13 with SMTP id y13so1333219dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 11:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygftxidR_r-t16K1g9CNPhL+EkMdPyKftkWoSk+Fzf+Rog@mail.gmail.com>
References: <CA+7oygccmq9DY+dR-=__4z_rZ4Sa9d8zmz+6=zX-xsTKdWkFWQ@mail.gmail.com>
	<CAOpc7mEKLM1wjKmdde3YqTuB0edoOFBcH=dK5s5V1y5t7v=wMQ@mail.gmail.com>
	<CA+7oygftxidR_r-t16K1g9CNPhL+EkMdPyKftkWoSk+Fzf+Rog@mail.gmail.com>
Date: Wed, 16 May 2012 14:32:16 -0400
Message-ID: <CA+7oygddbQpoPmc=A05AGyPfq9YyhdeejwYfpS0sGXD=9CeZqA@mail.gmail.com> (sfid-20120516_203225_051101_FF1A3619)
Subject: Re: AR9280 reported signal strengths are flat (comparison with
 bcm4322 included)
From: George Nychis <gnychis@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

Thanks a bunch for your response!  I had read about ANI before on the
list, it would be interesting to know if this is the cause for this.
It definitely seems plausible. I will dig around the ath9k code and
see if I can narrow down this to the cause.


On Wed, May 16, 2012 at 2:31 PM, George Nychis <gnychis@gmail.com> wrote:
>
> Hi Holger,
>
> Thanks a bunch for your response!  I had read about ANI before on the
> list, it would be interesting to know if this is the cause for this.  It
> definitely seems plausible. I will dig around the ath9k code and see if I
> can narrow down this to the cause.
>
> - George
>
>
> On Wed, May 16, 2012 at 2:08 AM, Holger Schurig
> <holgerschurig@googlemail.com> wrote:
>>
>> This is probably due to ANI (adapative noise immunity). I think ath9k
>> does too much here, in other words: it doesn't just kick in if there
>> are too strong signals there. Instead it seems to always adjust the
>> input attenuator, needed or not.
>
>

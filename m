Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63271 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab2EQDgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 23:36:02 -0400
Received: by pbbrp8 with SMTP id rp8so1958175pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 20:36:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygcX6_d4anpCKGRG1f7ugcr4Pm19O_+Vogbj13W55PuczA@mail.gmail.com>
References: <CA+7oygccmq9DY+dR-=__4z_rZ4Sa9d8zmz+6=zX-xsTKdWkFWQ@mail.gmail.com>
	<CAOpc7mEKLM1wjKmdde3YqTuB0edoOFBcH=dK5s5V1y5t7v=wMQ@mail.gmail.com>
	<CA+7oygftxidR_r-t16K1g9CNPhL+EkMdPyKftkWoSk+Fzf+Rog@mail.gmail.com>
	<CA+7oygddbQpoPmc=A05AGyPfq9YyhdeejwYfpS0sGXD=9CeZqA@mail.gmail.com>
	<CA+7oygcX6_d4anpCKGRG1f7ugcr4Pm19O_+Vogbj13W55PuczA@mail.gmail.com>
Date: Wed, 16 May 2012 23:36:01 -0400
Message-ID: <CA+7oygenvx9nMSbFimbkzmyBuc+mPV4ot-UmBuor3Zc2BLQLGg@mail.gmail.com> (sfid-20120517_053637_721038_792EFEFA)
Subject: Re: AR9280 reported signal strengths are flat (comparison with
 bcm4322 included)
From: George Nychis <gnychis@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, I believe that I forced ANI to be disabled and I still see this
same behavior.

To disable ANI on my AR9280, I added this to __ath9k_hw_init() in hw.c
  if (AR_SREV_9280(ah))
    ah->config.enable_ani = false;

I believe this works because in ath9k_hw_post_init() I have checked
that ah->config.enable_ani is set to false.  Therefore,
ath9k_hw_ani_setup() and ath9k_hw_ani_init() are never called.

Unfortunately, I still see this same flat line trend without strong
signal strengths near the device.


On Wed, May 16, 2012 at 2:35 PM, George Nychis <gnychis@gmail.com> wrote:
>
> BTW- is ANI _not_ applied on broadcast traffic?  I notice that
> monitoring the signal strength of beacons does not show this behavior.
>  Maybe not applied for localization reasons?
>
> - George
>
>
> On Wed, May 16, 2012 at 2:32 PM, George Nychis <gnychis@gmail.com> wrote:
> > Hi Holger,
> >
> > Thanks a bunch for your response!  I had read about ANI before on the
> > list, it would be interesting to know if this is the cause for this.
> > It definitely seems plausible. I will dig around the ath9k code and
> > see if I can narrow down this to the cause.
> >
> >
> > On Wed, May 16, 2012 at 2:31 PM, George Nychis <gnychis@gmail.com> wrote:
> >>
> >> Hi Holger,
> >>
> >> Thanks a bunch for your response!  I had read about ANI before on the
> >> list, it would be interesting to know if this is the cause for this.  It
> >> definitely seems plausible. I will dig around the ath9k code and see if I
> >> can narrow down this to the cause.
> >>
> >> - George
> >>
> >>
> >> On Wed, May 16, 2012 at 2:08 AM, Holger Schurig
> >> <holgerschurig@googlemail.com> wrote:
> >>>
> >>> This is probably due to ANI (adapative noise immunity). I think ath9k
> >>> does too much here, in other words: it doesn't just kick in if there
> >>> are too strong signals there. Instead it seems to always adjust the
> >>> input attenuator, needed or not.
> >>
> >>

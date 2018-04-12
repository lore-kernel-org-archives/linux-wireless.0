Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:54542 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752829AbeDLTZ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 15:25:29 -0400
Received: by mail-wm0-f43.google.com with SMTP id r191so404411wmg.4
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 12:25:29 -0700 (PDT)
Subject: Re: second wifi card enforce CN reg dom
To: solsTiCe d'Hiver <solstice.dhiver@gmail.com>,
        Dan Williams <dcbw@redhat.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
 <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com>
 <5ACF0F5A.3090301@broadcom.com>
 <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
 <5ACF3A28.4060303@broadcom.com>
 <CALLGbRLJLxu92S2bYFOk9oJCLanES4Fu6e-9bh9oAupEC0Uw5w@mail.gmail.com>
 <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com>
 <CAE4vF2fvumVELT5rScptjVC4JOqw5cqEu7yLrYZ64ci=5R6ZRQ@mail.gmail.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ACFB2A6.5050009@broadcom.com> (sfid-20180412_212533_614867_2315642D)
Date: Thu, 12 Apr 2018 21:25:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAE4vF2fvumVELT5rScptjVC4JOqw5cqEu7yLrYZ64ci=5R6ZRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems you are already pissed off, but could you please reply inline 
instead of top posting. Its a drag to scroll up and down.

On 4/12/2018 7:05 PM, solsTiCe d'Hiver wrote:
> Hi.
>
> I thought I made myself clear.
> I leave in France. My system(s) is/are set up to use FR as default
> regulatory domain.
>
> But when I plug in that tp-link card, I am restricted to use CN
> regulatory domain. Why am I the only one to see this as a problem ?

unlikely you are the only one.

> I know that one can only have one regdom defined on the system. I have
> set it up myself. So why is it changed behind my back by some card or
> whatever ?

so:
	Alfa = rt2800usb = FR
 > country FR: DFS-ETSI
 > (2402 - 2482 @ 40), (N/A, 20), (N/A)
 > (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
 > (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
 > (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
 > (57000 - 66000 @ 2160), (N/A, 40), (N/A)
	TP-Link = ath9k_htc = CN
 >country CN: DFS-FCC
 > (2402 - 2482 @ 40), (N/A, 20), (N/A)
 > (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
 > (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
 > (5735 - 5835 @ 80), (N/A, 30), (N/A)
 > (57240 - 59400 @ 2160), (N/A, 28), (N/A)
 > (59400 - 63720 @ 2160), (N/A, 44), (N/A)
 > (63720 - 65880 @ 2160), (N/A, 28), (N/A)

The FR setting may or may not be your doing. You seem to indicate having 
done 'iw reg set FR'. So as to why it changed behind your back is 
because that card indicates it is certified to work in CN regulatory 
domain and your system is configure to work in FR domain. So the 
regulatory code in the kernel has to take action and as Steve explains 
it creates an intersection domain named '98'.

 > country 98: DFS-UNSET
 > (2402 - 2482 @ 40), (N/A, 20), (N/A)
 > (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
 > (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
 > (57240 - 59400 @ 2160), (N/A, 28), (N/A)
 > (59400 - 63720 @ 2160), (N/A, 40), (N/A)
 > (63720 - 65880 @ 2160), (N/A, 28), (N/A)

So it is not as you say that your Alfa device now operates in CN domain, 
but in the 98 domain. As you can see it creates rules different from FR 
and CN picking the lowest power of the two.

> Like I said, I am left with the option, to disable crda, or to use 2
> systems, one for each card !

So yeah, plugging multiple cards in a system limits your options, but 
you still have channels to operate in unless you are otherwise 
restricted by AP(s) used.

Regards,
Arend

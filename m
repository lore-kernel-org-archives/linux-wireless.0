Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44158 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751156AbdBWNl2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 08:41:28 -0500
Date: Thu, 23 Feb 2017 14:38:13 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Tahia Khan <tahia.khan@gmail.com>,
        outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osusl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Outreachy kernel] Re: [PATCH v2] staging: wilc1000: renames
 struct tstrRSSI and its members u8Index, u8Full
In-Reply-To: <1ffdd756-aaa4-5e1e-b72f-3e5d1f2daeb2@broadcom.com>
Message-ID: <alpine.DEB.2.20.1702231437150.3073@hadrien> (sfid-20170223_144207_143175_D4FCCC0E)
References: <20170222171403.GA20626@coolbox> <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com> <20170223035400.GA9378@coolbox> <alpine.DEB.2.20.1702230804410.2203@hadrien> <1ffdd756-aaa4-5e1e-b72f-3e5d1f2daeb2@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 23 Feb 2017, 'Arend Van Spriel' via outreachy-kernel wrote:

> On 23-2-2017 8:08, Julia Lawall wrote:
> >> Thanks for the feedback Arend, I really appreciate it. I've decided to go with
> >> these changes in my follow-up patch request:
> >>
> >> - rename tstrRSSI to 'rssi_history_buffer' as Aren suggested since it makes the
> >> purpose of the struct clear
> >> - remove Hungarian notation from all tstrRSSI members' names
> >> - change type of u8Full to bool since it's only ever 1 or 0
> >> - change name of as8RSSI to 'samples' since this buffer is only ever used to
> >> compute an average, and the "rssi" prefix is implied by the struct's name
> >> - rename str_rssi to rssi_history in the network_info struct for clarity
> >>
> >> Since my reasoning for these changes deviates from just "renaming to
> >> avoid camel casing" (as in the original checkpatch.pl warning), would it still
> >> make sense to submit all this in a single patch? I know my commit message
> >> needs to change but I wonder if this is too much detail.
> >
> > I would strongly suggest not to do it all in a single patch.  Even if these
> > changes are not very complicated conceptually, there is always a chance of
> > doing things wrong.  Taking the problems one by one will improve the chance
> > that the result is correct.  Also, the results will be easier for you and
> > others to review if each patch only does one thing.  And easier to revert
> > if needed later if something goes wrong.
>
> It is all related to cleaning up stuff in a single struct which I
> consider "one thing" here. To me it looks a bit silly if you rename one
> struct member when it is obvious that the other two need to be renamed
> as well. The only somewhat sensible split I see here is: 1) rename the
> struct itself, 2) rename the struct members, and 3) rename str_rssi
> member in struct network_info.

OK.  I guess I mainly saw the change of type as being different.

julia


>
> Regards,
> Arend
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1ffdd756-aaa4-5e1e-b72f-3e5d1f2daeb2%40broadcom.com.
> For more options, visit https://groups.google.com/d/optout.
>

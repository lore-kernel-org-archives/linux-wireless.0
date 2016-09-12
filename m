Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbcILQHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 12:07:55 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Hanno Zulla <abos@hanno.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        anthony.wong@canonical.com, linux-wireless@vger.kernel.org
Subject: Re: Support of rtl8723bs
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
        <1473683031.2930.3.camel@hadess.net> <wrfjtwdli39u.fsf@redhat.com>
        <5b920339-abcd-0fc4-f054-039155c531a0@lwfinger.net>
        <cd991918-0bfa-a9a3-15e5-aa8561db2c65@hanno.de>
        <1473695458.6389.3.camel@hadess.net>
Date: Mon, 12 Sep 2016 12:07:53 -0400
In-Reply-To: <1473695458.6389.3.camel@hadess.net> (Bastien Nocera's message of
        "Mon, 12 Sep 2016 17:50:58 +0200")
Message-ID: <wrfj4m5lhzja.fsf@redhat.com> (sfid-20160912_180758_726915_B00F70F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bastien Nocera <hadess@hadess.net> writes:
> On Mon, 2016-09-12 at 17:48 +0200, Hanno Zulla wrote:
>> Hi,
>> 
>> > Longer term I think it makes sense to add SDIO support to rtl8xxxu.
>> > The
>> > differences between the USB version and the SDIO version are rather
>> > small.
>> 
>> 
>> This is beyond my expertise, sadly.
>> 
>> Is there a good blueprint / example of a previous case where a USB
>> driver had SDIO support added that one might learn from?
>
> I don't know on top of my head, sorry. Best look in the kernel sources
> directly.

The issues I am aware of is to start out changing the register access
macros into function pointers and stick them all into the fileops
structure. Provide a set of SDIO ones to match the USB ones. Then you
will need some code to detect the device, as that part will obviously be
different from the USB device detection.

I know there are a few issues to look out for in the hw register init
files to look out for too, that does some special casing for SDIO, but
that should be limited. I am happy to point someone in the right
direction on that when they get to that.

Cheers,
Jes

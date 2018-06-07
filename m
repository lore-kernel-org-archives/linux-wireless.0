Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45743 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932503AbeFGN0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Jun 2018 09:26:19 -0400
Received: by mail-wr0-f196.google.com with SMTP id o12-v6so9834441wrm.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2018 06:26:18 -0700 (PDT)
Subject: Re: [PATCH resend 0/2] NFC: pn533: Fix DMA related USB errors
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-usb@vger.kernel.org,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-wireless@vger.kernel.org
References: <20180601132200.25973-1-hdegoede@redhat.com>
 <20180601161918.GA10471@kroah.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <b1e88495-a5a9-5290-f901-95520afa1d70@redhat.com> (sfid-20180607_152624_413873_9DF68C76)
Date: Thu, 7 Jun 2018 15:26:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180601161918.GA10471@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 01-06-18 18:19, Greg Kroah-Hartman wrote:
> On Fri, Jun 01, 2018 at 03:21:58PM +0200, Hans de Goede wrote:
>> Hi All,
>>
>> These 2 simple bug-fixes seem to have fallen through the cracks,
>> hence this resend.
>>
>> Greg (gkh) despite a ping to Samuel about a month ago I still have not
>> had any response from the NFC people to these fixes. Since these are
>> really fixes for USB urb mis-handling, perhaps you can take these
>> upstream through the USB tree?
> 
> Can you respin these against my usb-next branch of usb.git?  I applied a
> big pn533 fix to make it actually work again, which causes your patches
> to not be able to be applied at all :(

Right, so it looks like your patch:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit?id=dbafc28955fa6779dc23d1607a0fee5e509a278b

More or less duplicates my first patch, so that one can be dropped.

There still is an issue of wrong GFP flags triggering an oops.

I will send a rebased v2 of that.

Regards,

Hans

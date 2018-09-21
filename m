Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:65168 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbeIUMd6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 08:33:58 -0400
Date: Fri, 21 Sep 2018 12:01:16 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Nathan Chancellor <natechancellor@gmail.com>
CC: <valdis.kletnieks@vt.edu>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Remove unnecessary pointer check
Message-ID: <20180921120116.603b1de6@ajaysk-VirtualBox> (sfid-20180921_084640_169655_6BC0C7E7)
In-Reply-To: <20180921053911.GA5170@flashbox>
References: <20180920212648.25181-1-natechancellor@gmail.com>
        <32473.1537507532@turing-police.cc.vt.edu>
        <20180921053911.GA5170@flashbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>

On Thu, 20 Sep 2018 22:39:11 -0700
Nathan Chancellor <natechancellor@gmail.com> wrote:

> On Fri, Sep 21, 2018 at 01:25:32AM -0400, valdis.kletnieks@vt.edu
> wrote:
> > On Thu, 20 Sep 2018 14:26:49 -0700, Nathan Chancellor said:  
> > > Clang warns that the address of a pointer will always evaluated
> > > as true in a boolean context:
> > >
> > > drivers/staging/wilc1000/linux_wlan.c:267:20: warning: address of
> > > 'vif->ndev->dev' will always evaluate to 'true'
> > > [-Wpointer-bool-conversion]
> > >         if (!(&vif->ndev->dev))
> > >             ~  ~~~~~~~~~~~^~~
> > > 1 warning generated.
> > >
> > > Since this statement always evaluates to false due to the logical
> > > not, remove it.  
> > 
> > Often, "just nuke it because it's now dead code" isn't the best
> > answer...
> > 
> > At one time, that was likely intended to be checking whether ->dev
> > was a null pointer, to make sure we don't pass request_firmware() a
> > null pointer and oops the kernel, or other things that go
> > pear-shaped....
> > 
> > So the question becomes:   Is it safe to just remove it, or was it
> > intended to test for something that could  legitimately be null if
> > we've hit an error along the way (which means we should fix the
> > condition to be proper and acceptable to both gcc and clang)?
> > 
> >   
> 
> I certainly considered whether or not removing the check versus fixing
> it was the correct answer. Given that this check can be traced back to
> the initial check in of the driver in 2015, I figured it was safe to
> remove it (since a null pointer dereference would most likely have
> been noticed by now).
> 
> Most patches addressing this warning just remove the check given that
> it's not actually changing the code, such as commit a7dc662c6a7b
> ("ASoC: codecs: PCM1789: unconditionally flush work"). However, if
> the driver authors and/or maintainers think that this check should be
> something else (maybe checking that the contents of dev is not null
> versus the address, I'm perfectly happy to submit a v2 with this
> change.
> 

The 'if' condition was intended to check the validity of net_device
structure, but i think its not required here.
The device pointer used in request_firmware(), was received in
the probe functions and different from the one checked in 'if'
condition.

Thus its safe to remove the 'if (!(&vif->ndev->dev))' condition
block.
      

Regards,
Ajay

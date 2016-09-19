Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756640AbcISNl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 09:41:56 -0400
Date: Mon, 19 Sep 2016 15:42:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-wireless@vger.kernel.org,
        Aditya Shankar <Aditya.Shankar@microchip.com>,
        Ganesh Krishna <Ganesh.Krishna@microchip.com>,
        luisbg@osg.samsung.com
Subject: Re: staging: wilc1000: kernel Oops while opening the device
Message-ID: <20160919134201.GA25769@kroah.com> (sfid-20160919_154200_823701_C9CB31DE)
References: <c12338f5-0a50-bb55-0b83-0fa705237cf8@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c12338f5-0a50-bb55-0b83-0fa705237cf8@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2016 at 02:06:02PM +0200, Nicolas Ferre wrote:
> Hi all,
> 
> While using the wilc1000 driver with latest 4.8-rc7, I
> have difficulties to open the device and actually use it as I have
> this kernel Oops right after the loading of the firmware (wilc1003_firmware.bin).
> 
> If I revert back the driver to its b9811891a9f60ca9c314dcab3244c65930c4cf37 state,
> it works okay. I did this because I tend to think that it might be related to the latest
> move on this driver to "completion" or "work queues".
> It seems to be a regression from 4.7.

Ick, not good at all.

Any chance you can run 'git bisect' to see if you can find the offending
patch?

I thought the maintainers were testing this driver over time :(

thanks,

greg k-h

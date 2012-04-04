Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47660 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290Ab2DDC6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 22:58:10 -0400
Received: by bkcjk13 with SMTP id jk13so363100bkc.8
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2012 19:58:08 -0700 (PDT)
Message-ID: <1333508285.24637.2.camel@cumari> (sfid-20120404_045844_879671_8A1DA190)
Subject: Re: wl1271 watchdog interrupt
From: Luciano Coelho <coelho@ti.com>
To: Troy Kisky <troy.kisky@boundarydevices.com>,
	Gary Thomas <gary@mlbassoc.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Apr 2012 05:58:05 +0300
In-Reply-To: <4F7BA34C.2030001@boundarydevices.com>
References: <4F6A7FD0.8090404@boundarydevices.com>
	  <4F71CDC7.2010207@mlbassoc.com> <1333355941.16990.23.camel@cumari>
	 <4F7BA34C.2030001@boundarydevices.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 18:26 -0700, Troy Kisky wrote: 
> On 4/2/2012 1:39 AM, Luciano Coelho wrote:
> >>> wl12xx: ERROR watchdog interrupt received! starting recovery.
> >>> wl12xx: Reading FW panic log
> >>> wl12xx: ERROR command complete timeout
> > This is a firmware bug.  Can you please take the contents
> > of /sys/bus/platform/drivers/wl12xx_driver/wl12xx/fwlog and send it to
> > us so we can take a look at what's going on?
> Sorry, it isn't a firmware bug. It was a configuration problem on my 
> part. The defconfig
> file I was using was enabling a TVOUT driver which this board doesn't 
> have. When
> the driver wanted to blank the screen, it was turning off my slow clock 
> to my WL1271.
> 
> When the WL1271 later becomes idle, it goes into a low power state which 
> depends upon
> slow clock. So please tell your firmware guys, "never mind."

Okay, cool that you found the reason for the problem. :) I thought it
was a firmware problem because all the symptoms show that the chip
stopped responding. :)


> >> wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x23923
> > This tells us where the PC was when the crash happened.  I'll ask our
> > firmware team to analyze this.
> "Never mind...."

Cool!

Now, Gary, do you still have the same (or a similar) problem with your
setup?

-- 
Cheers,
Luca.


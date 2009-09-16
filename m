Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galiil.marvell.com ([199.203.130.254]:28503 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbZIPU0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 16:26:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andrey Yurovsky <andrey@cozybit.com>
CC: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Dan Williams <dcbw@redhat.com>
Date: Wed, 16 Sep 2009 13:20:40 -0700
Subject: RE: [PATCH] libertas: Add auto deep sleep support for
 	SD8385/SD8686/SD8688
Message-ID: <477F20668A386D41ADCC57781B1F704306DB9CFDB7@SC-VEXCH1.marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
 <45e8e6c40909151641o423cbc70y22033061505661b6@mail.gmail.com>
In-Reply-To: <45e8e6c40909151641o423cbc70y22033061505661b6@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

> -----Original Message-----
> From: Andrey Yurovsky [mailto:andrey@cozybit.com]
> Sent: Tuesday, September 15, 2009 4:41 PM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar Karwar; Dan Williams
> Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
> 
> Hi Bing.  This is not specific to the actual implementation of the
> deep sleep commands in your patch but,
> 
> On Tue, Sep 15, 2009 at 4:45 PM, Bing Zhao <bzhao@marvell.com> wrote:
> > +       Path: /sys/kernel/debug/libertas_wireless/ethX/
> 
> Is the sysfs interface really necessary?  It seems like yet another
> non-standard configuration option to keep track of.

Actually the debugfs interface is used in the patch.

Some information (such as the interface name and path) in README file is out of date. We just copy-and-paste it for the new deepsleep command. We need a separate patch to clean up the REAME file and keep it up to date. 

> 
> Deep sleep seems to pretty much "turn off" the wifi card (as far as
> the user is concerned) so how about a simpler approach: enter deep
> sleep when the interface is brought down (ifconfig wlanN down) and
> exit deep sleep when it's brought up.  Do this only when deep sleep is
> supported/possible.  Alternately, maybe this belongs as an rfkill
> feature?

Entering/exiting deep sleep doesn't have to depend on wlanN interface's up and down. User can still put the chip into sleep when wlanN is up. And, with auto deep sleep feature, the driver automatically wakes the chip up for sending user commands (for example, scan) and put the chip back to sleep after certain time period of inactivity. The deepsleep command through debugfs interface provides the flexibility of deep sleep options.

The rfkill shuts down the RF transmitter of the device but most of other modules may be still functioning. The deep sleep shuts down most of the modules (including the RF) on the chip to save as much power as possible.


Regards,

Bing

> 
>   -Andrey

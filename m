Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:54296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZI1W0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 18:26:49 -0400
Received: by fg-out-1718.google.com with SMTP id 22so898192fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 15:26:52 -0700 (PDT)
Date: Tue, 29 Sep 2009 00:23:49 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: ath5k, wifi enable hotkeys
Message-ID: <20090928222349.GA2416@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090705123105.GE2132@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 05, 2009 at 08:31:05AM -0400, Bob Copeland wrote:

Hi,


> Try latest wireless-testing or 2.6.31-rc1; there may already be a fix
> for your hardware thanks to recently added rfkill support.

got around to give 2.6.30* more testing. LED now works nicely but that is about the
only thing that works.

Tried computers linked in Ad-Hoc mode with WEP. 2.6.30 and 2.6.31.1 work nicely
on the other end.

On the ath5k end it seems like 2.6.31 choked after resume from suspend or when interface 
was reconfigured. 

2.6.31.1 does not work at all on this netbook. LED indicates activity but network does
not get associated. "iwlist scan" does display available networks.

After having tried 2.6.31.1 I have to cold-boot 2.6.30.x to get the ath5k working again,
simple reboot does not do it.

> 
> > Also, while the hotkey works how do query the current on/off status of it 
> > in Linux?
> 
> There's the /dev/rfkill device (see http://git.sipsolutions.net/rfkill.git)
> and I believe there are files under /sys/ as well which show the state but
> I don't have the details handy (/sys/class/rfkill/xxx/state?).

has that been merged into 2.6.31* ? 

The /sys/.../rfkill files are there but could not figure out anything that changes 
when hitting the hotkey.

Besides, I would think the LED will indicate rfkill status?

Richard

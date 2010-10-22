Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31005 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0JVHtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 03:49:32 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9M7meqF009976
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 02:49:31 -0500
Subject: Re: [PATCH v2] wl1271: Fix warning about unsupported RX rate
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287414729.20107.68.camel@chilepepper>
References: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1287412289.20107.66.camel@chilepepper>
	 <1287414729.20107.68.camel@chilepepper>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 10:49:06 +0300
Message-Id: <1287733746.2905.19.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-18 at 18:12 +0300, Luciano Coelho wrote:
> On Mon, 2010-10-18 at 16:31 +0200, ext Luciano Coelho wrote:
> > On Thu, 2010-10-14 at 11:00 +0200, Teemu Paasikivi wrote:
> > > While scanning, it is possible that beacon and probe response frames are
> > > received on other band than configured to the driver. In rx status
> > > handling this has caused "Unsupported RX rate from HW" warnings. This
> > > patch changes the wl1271_rate_to_index function to take the band of the
> > > received frame as a parameter instead of using value configuret to
> > > wl->band.
> > > 
> > > Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> > > ---
> > 
> > Applied, thanks!
> 
> Hmmm... I'm now getting loads of these:
> 
> [  465.265594] wl1271: ERROR Unsupported RX rate from HW: 15
> 
> ...when scanning with my beagle board.  I have also included the 11n
> patches by Shahar and Ido's "optimizations and fixes".
> 
> Teemu, I had to merge your patch on top of Ido's and Shahar's patches.
> Can you check your patch in the wl12xx/master tree and confirm that it
> is okay? To me it looks good, but you never know ;)
> 
> 

Ok, I checked this with a beagle board and it looks like that it's
caused by the firmware marking some packets received during scanning as
being received from 5 GHz band. After some testing I have pinpointed the
problem being caused by the firmware nvs file used. It's just annoying
that those errors are being emitted when scanning. I suppose that the
message could be changed from "ERROR" to "WARNING".


Br,

Teemu



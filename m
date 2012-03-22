Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965257Ab2CVWbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 18:31:20 -0400
Date: Thu, 22 Mar 2012 15:31:07 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: jerome huang <jerome.syno@gmail.com>,
	"Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
Message-ID: <20120322223107.GA8877@xanatos> (sfid-20120322_233126_036940_8CA624EE)
References: <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
 <4F581AF8.4080001@lwfinger.net>
 <CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
 <4F585BA9.6020903@amd.com>
 <2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
 <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
 <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
 <4F58F2D0.5060805@lwfinger.net>
 <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
 <4F59800B.80407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F59800B.80407@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2012 at 09:59:07PM -0600, Larry Finger wrote:
> On 03/08/2012 09:28 PM, jerome huang wrote:
> >
> >It still got no any result if I wait for 30 sec (or longer) between
> >(original) step 2 and 3.
> >I double confirmed that it always does not work for steps: plugin ->
> >up ->  scanning
> >and always works for steps: plugin ->  up ->  down ->  up ->  scanning.
> >
> >And sometimes it works for next down->up->scanning, sometimes it doesn't.
> >
> >Is the change of firmware loading in kernel 3.3 made by rtlwifi only,
> >or ring expansion in xhci is also necessary?
> 
> The only changes are in the rtlwifi drivers. I don't have a USB 3
> device, thus I have no idea what might work there. I wrote something
> incorrect earlier. The new code is not in mainline 3.3, but it is in
> the wireless-testing git tree. If you want to try this, and don't
> want to get the whole tree, the new code is in the bleeding-edge
> compat-wireless package. Otherwise, I could send you the patches.

Larry, if the driver doesn't cancel an URB that the device doesn't
respond to, then it will just be left on the endpoint ring.  If the
driver then tries to queue new transfers to that same endpoint, but the
device keeps NAKing the uncancelled transfer, then the endpoint ring
would fill up with unanswered transfers.

Perhaps some userspace or kernel portion is forgetting to cancel URBs
before moving onto the next thing?  You said you moved to asynchronous
transfers, so maybe the problem lies there?

Jerome, the xHCI ring expansion patches have been merged for 3.4, so you
can test with Linus' latest tree and see if they help.  If the ring
expands indefinitely, then there's probably an issue with the rtlwifi
drivers.

Sarah Sharp

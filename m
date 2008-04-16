Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYDPT3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 15:29:07 -0400
Subject: RE:  iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Marcus Furlong <furlongm@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fu5iel$c45$1@ger.gmane.org>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 15:26:02 -0400
Message-Id: <1208373962.5161.5.camel@localhost.localdomain> (sfid-20080416_202924_813649_E75E010E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-16 at 20:01 +0100, Marcus Furlong wrote:
> On Wednesday 16 April 2008 19:28 in
> <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>,
> Chatre, Reinette wrote:
> 
> > On , Marcus Furlong  wrote:
> > 
> >> Hi,
> >> 
> >> Have had a look through bugzilla and not sure if any of the
> >> existing bugs
> >> are exactly the same as mine, so thought I'd post here first
> >> to make sure
> >> I'm not missing anything obvious.
> >> 
> >> Kernel 2.6.25-rc9 (although the same thing seems to happen on 2.6.24
> >> kernels, so I stuck with the ipw driver and 2.6.23 til now)
> >> Using iwl3945 firmware 2.14.1.5
> >> 
> >> Machine doesn't associate with any AP (although it does seem to see
> >> the closer ones) and I get lots of the following errors:
> >> 
> >> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> >> 
> >> Also, and unsure if this is related or not, the mouse and
> >> keyboard behave
> >> erratically when the iwl3945 module is loaded. Both keyboard
> >> and mouse lock
> >> up, but store all input in a buffer and spurt it out after a
> >> few seconds.
> >> After between 1-10 minutes the machine hangs and the Caps Lock
> >> and Scroll
> >> Lock lights flash on and off (not the Num Lock one though).
> >> 
> >> Dmesg log is available here using netconsole on a wired
> >> connection, up to
> >> the point where it crashes:
> >> 
> >> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwlwifi-output.bz2
> >> 
> >> I also reloaded the module with debug=0x43ffb after booting,
> >> so the output
> >> becomes more verbose at that stage.
> > 
> > Looks like the device is being brought up and down a lot ... are you
> > perhaps running wpa_supplicant or some other user application that is
> > doing this? Could you please give more information about what you were
> > doing when these errors started to appear?
> 
> Yes, wpa_supplicant is running as part of the boot process. Should I use
> some other application? (Do wireless-tools support WPA?) Or should I just
> load the module on it's own and give the dmesg output from that?

wpa_supplicant shouldn't be bouncing the device much.  It appears to
only bring the device up when it adds the interface (either at start
time or later via the control interface) and bring it down only when the
interface is removed (on shutdown or when removed via the control
interface).

Dan



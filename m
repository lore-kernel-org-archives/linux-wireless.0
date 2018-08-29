Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.media.mit.edu ([18.85.44.157]:38199 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbeH3B5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 21:57:38 -0400
Date: Thu, 30 Aug 2018 07:58:37 +1000
From: James Cameron <quozl@laptop.org>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Mylene JOSSERAND <mylene.josserand@free-electrons.com>,
        Stefan Pappalardo <stefan.pappalardo@gmx.de>,
        Carlo Caione <carlo@endlessm.com>
Subject: Re: rtl8723bu: low signal, fails to associate
Message-ID: <20180829215837.GD7778@us.netrek.org> (sfid-20180829_235847_813779_F2E01C4F)
References: <20180824013645.GB761@us.netrek.org>
 <bd9ef21e-b0f6-f947-b14d-cbb8abf4efdb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bd9ef21e-b0f6-f947-b14d-cbb8abf4efdb@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 04:19:01PM -0400, Jes Sorensen wrote:
> On 08/23/2018 09:36 PM, James Cameron wrote:
> > G'day Carlo, Mylene, and James,
> > 
> > Thanks for your earlier reports about RTL8723bu.  Have you any more
> > recent experiences you might share?
> > 
> > I'm evaluating a sample laptop which worked fine with Windows 10, but
> > not very well with Ubuntu 18.04, and kernel v4.15 or kernel v4.18.4.
> > 
> > The laptop is by Hena, model NT16-PRO-C-E, with a wireless device on
> > internal USB (0x0bda:0xb720) which loads rtl8xxxu, identifying as
> > RTL8723BU.
> > 
> > http://dev.laptop.org/~quozl/z/1ft0qv.txt (dmesg)
> > 
> > Symptoms are low RSSI on scan, very short range, and often a failure
> > to associate over a distance of two metres in a radio quiet location.
> > 
> > Symptoms began after first power off, which suggests that device
> > registers programmed by the previous operating system Windows 10 had
> > not been reset by reboot into the Ubuntu 18.04 installer.  The device
> > worked fine in Ubuntu 18.04 before the first power off.
> > 
> > Jes, let me know if there is anything I can do to help.
> 
> It's been a while since I had time to look at the 8723bu support, and
> rtl8xxxu doesn't have BT coexist support. I notice that your laptop does
> load the bluetooth module for 8723bu which I believe fiddles with the
> antenna configuration and is likely to take control of the antennas. I
> suspect this is why you see low signal quality on the WiFi side.
> 
> If you blacklist the BT module, does it work better?

Thanks.  No, it doesn't work any better, or worse.

Method: add "blacklist btusb" to /etc/modprobe.d/blacklist.conf,
regenerate initramfs, and boot.

Also, a difference in symptom between cold and warm boot;

*  on cold boot after 15 seconds of power off, device connects but has
   short range, with received power at monitor of -76dBm,

   http://dev.laptop.org/~quozl/z/1fv7sW.txt (dmesg, cold boot, no btusb)

*  on warm boot with less than 5 seconds of power off, device does not
   connect, dmesg "authentication with xx:yy:zz:aa:bb:cc timed out",
   and probe request, authentication, and association packets are not
   seen by monitor,

   http://dev.laptop.org/~quozl/z/1fv8IO.txt (dmesg, warm boot, no btusb)

In both cases, scan results are normal, and similar signal level.  An
active scan for cold boot, and a passive scan for warm boot.

Monitor device is an ath9k about 30cm away; a radio quiet environment
on a farm.

Speculation; device registers are not being reset.  Would not have
been a problem for RTL8723BU on removable USB.

-- 
James Cameron
http://quozl.netrek.org/

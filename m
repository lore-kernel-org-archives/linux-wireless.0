Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47572 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3AXGpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 01:45:31 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so134516wic.11
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 22:45:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5100BEF7.4000107@gnoutcheff.name>
References: <5100BEF7.4000107@gnoutcheff.name>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 24 Jan 2013 17:45:10 +1100
Message-ID: <CAGRGNgWg=4CgjXpdceNfsy6X0_q=SFY8CegJsTf60yGd_NBuLQ@mail.gmail.com> (sfid-20130124_074535_249573_85E1755F)
Subject: Re: [ath5k] [bugreport] BIOS hang if wifi was connected before reboot
To: Daniel Gnoutcheff <daniel@gnoutcheff.name>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Thu, Jan 24, 2013 at 3:56 PM, Daniel Gnoutcheff
<daniel@gnoutcheff.name> wrote:
> Hello all,
>
> I have a Lenovo Thinkpad R61 7733A82 running Ubuntu 12.10 on kernel 3.7.4
> with an Atheros AR5212 PCI-Express wireless card which is reported in dmesg
> as:
>   ath5k: phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
>
> If I connect this card to some network and then perform a warm reboot
> without disconnecting from that network, then the system seems to lock up in
> the middle of the BIOS self-test.

My guess is that this is a bug in the BIOS itself, not an issue with
the Linux drivers, and I'd contact Lenovo support to see if this can
be fixed.

The obvious workaround is to have the shutdown scripts disconnect the
wireless network before the computer is rebooted, however, as you've
indicated below, this isn't the case any more.

> For example, if I stop NetworkManager and wpa_supplicant and issue the
> commands:
>   iw dev wlan0 set type ibss
>   ip link set dev wlan0 up
>   iw wlan0 ibss join gnoutchd 2412
>   shutdown -r now
> then the system appears to shut down correctly, and the screen blanks as it
> normally does when rebooting, and I can even hear the CD-DVD drive resetting
> itself, but then it locks up just before the point where I'd expect the BIOS
> splash screen to appear.

Ok.

> However, if I issue 'ip link set dev wlan0 down' *before* I reboot, then the
> system reboots perfectly.   Omitting the 'iw wlan0 ibss join' step also
> prevents the hang.
>
> If I'm within range of a WPA network, I can also reproduce the hang with
> something like
>   wpa_supplicant -c wpa_supplicant.conf -iwlan0 &
>   # wait for connection to complete
>   killall -SIGKILL wpa_supplicant
>   shutdown -r now
> I also get the hang if I leave wpa_supplicant running and if my initscripts
> never send it any signals (e.g. if its pid file is in /run/sendsigs.omit.d).
>
> However, if I give wpa_supplicant the chance to cleanup and disconnect (i.e.
> if I or my initscripts send it a SIGINT or a SIGTERM or a 'wpa_cli
> terminate'), then I don't get the hang.
>
> These are just the examples I've looked into closely.  I've also observed
> the same hang if I reboot while connected to any of a variety of wifi
> networks that I use, which include both open networks and WPA networks.
>
> This bug is present in a kernel v3.7.4 and wireless-testing commit
> 9d9540984a75ec4d0e59a33ce7d34581fd5b561b, but I've also seen in in kernels
> as old as 2.6.31.  I have installed the latest BIOS update available for
> this machine.

It sounds like it's definitely a BIOS bug.

> Up until recently, it seems that NetworkManager would always disconnect upon
> shutdown and thus avoided this bug, but this changed in Ubuntu 12.10.  FWIW,
> I've attached the dmesg log for connecting to a WPA network and then
> disconnecting from it cleanly.  Please let me know if there's anything I can
> do to help debug this.

Have you raised a bug with Ubuntu's Network Manager maintainers about this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

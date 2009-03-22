Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:58305 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZCVAeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 20:34:02 -0400
Received: by ewy9 with SMTP id 9so1152461ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 17:34:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com>
References: <49C12DFA.80308@giuppi.com>
	 <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>
	 <49C2D537.6080406@giuppi.com>
	 <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com>
	 <49C39A83.5090004@giuppi.com>
	 <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com>
Date: Sun, 22 Mar 2009 01:33:59 +0100
Message-ID: <fcf1801b0903211733l3e0e7d9eu60e5c93be8026b04@mail.gmail.com> (sfid-20090322_013414_392705_E8EF1C75)
Subject: Re: rtl8187 bug report
From: "Info[at]Giuppi" <info@giuppi.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <gst@remote-exploit.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hi!
>
> Could you please test if you can see packets originating from your
> network in Kismet or Wireshark?
> Also, did you use the included airmon-ng script to enable monitor
> mode, or did you just do "ifconfig wlan0 down; iwconfig wlan0 mode
> monitor, ifconfig wlan0 up"? (The two are significantly different, as
> airmon-ng uses iw/nl80211 to enable monitor mode on a separate
> interface - it would be good if you tried it both ways.)
>
> Thanks,
> G=E1bor (.NetRolller 3D)
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>

A short summary of my first quick test.

I use airmon-ng script to enable monitor mode. iw tool is version
0.9.9-nogit. No beacons from wep networks are shown. I've downloaded a
couple of so called "security distros", backtrack4 and nubuntu,
shipped with rtl8187. Same behaviour about weps.
I haven't had the time to investigate the "old way" of enabling
monitor mode on those live cd.

I've followed your advice about "ifconfig wlan0 down; iwconfig wlan0 mo=
de
monitor, ifconfig wlan0 up" on my ubuntu installation. My surprise to
see beacons growing from the wep network.
Kismet works fine, too.

With wlan0 in monitor mode, I've used airmon-ng to create a mon0
monitor interface, just to see what could happen. And the result was
mon0 worked fine, too.

So I've disconnected the usb dongle and unloaded possible related
modules by hand and by "make unload" from compat wireless setup
scripts.
Then I've reconnected the usb device and created the mon0 interface
with airmon-ng, this time without enabling monitor mode on wlan0. mon0
still worked fine. I'll check again after a system reboot.

I hope that makes any sense to you. Thanks for your reply
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

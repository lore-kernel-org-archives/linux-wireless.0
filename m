Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:14825 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbZD0UDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2009 16:03:32 -0400
Received: by rv-out-0506.google.com with SMTP id f9so92464rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2009 13:03:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904251431.02196.alf@mypals.org>
References: <200904251431.02196.alf@mypals.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Apr 2009 13:03:17 -0700
Message-ID: <43e72e890904271303q7f4c956fv176deb6e33fe3a56@mail.gmail.com> (sfid-20090427_220337_310284_0204BBD8)
Subject: Re: Problems with ADM8211 driver
To: Alf <alf@mypals.org>, Michael Wu <aluminum.tape@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 25, 2009 at 1:31 PM, Alf <alf@mypals.org> wrote:
> I have a D-Link PCI card with a ADM8211 driver:
>
> =C2=A000:07.0 Network controller: ADMtek ADM8211 802.11b Wireless Int=
erface
> =C2=A0 =C2=A0(rev 11)
>
> A few years ago I used it in Linux with the out-of-tree driver withou=
t any
> problems. =C2=A0I now have need of the card again in Linux, but the c=
ard doesn't
> want to associate with the AP. =C2=A0I tried the card under Windows a=
nd it worked
> well, so I know it's not hardware or configuration issues.
>
> I am using kernel 2.6.29.1 with version 29 of the wireless_tools pack=
age and
> wpa_supplicant 0.6.9. =C2=A0I have disabled wpa_supplicant and have t=
ried
> configuring the card directly with iwconfig:
>
> =C2=A0iwconfig wlan0 essid (ssid) channel 1 mode managed \
> =C2=A0 =C2=A0key (some hex junk)
>
> In the end, iwconfig reports:
>
> =C2=A0wlan0 =C2=A0 =C2=A0 IEEE 802.11b =C2=A0ESSID:"(ssid)"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Mode:Managed =C2=A0Frequency:2.412=
 GHz =C2=A0Access Point: Not-Associated
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Tx-Power=3D27 dBm
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Retry min limit:7 =C2=A0 RTS thr:o=
ff =C2=A0 Fragment thr=3D2352 B
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Encryption key:(some hex junk) =C2=
=A0 Security mode:open
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Power Management:off
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Link Quality:0 =C2=A0Signal level:=
0 =C2=A0Noise level:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rx invalid nwid:0 =C2=A0Rx invalid=
 crypt:0 =C2=A0Rx invalid frag:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Tx excessive retries:0 =C2=A0Inval=
id misc:0 =C2=A0 Missed beacon:0
>
> There are a few weird things I'm observing:
>
> - The signal level and noise level are both at 0.
>
> - Even when scanning, the signal strength is very low even though the=
 AP is
> 4 feet away (Quality=3D0/100 =C2=A0Signal level:19/100). =C2=A0Window=
s reports a strong
> signal.
>
> - The kernel log only reports the following problems:
>
> =C2=A0Apr 25 11:22:17 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44=
 try 1
> =C2=A0Apr 25 11:22:17 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44=
 try 2
> =C2=A0Apr 25 11:22:18 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44=
 try 3
> =C2=A0Apr 25 11:22:18 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44=
 timed out
>
> =C2=A0(the AP mac address is correct)
>
> - When the card is loaded, there is a significant pause (about 15 sec=
onds)
> when I first try to do something with the card. =C2=A0For example, if=
 I load the
> module and use iwconfig as outlined above and then run iwconfig again=
 to see
> the configuration, it takes about 15 or 16 seconds for it to display.=
 =C2=A0Also,
> if any services (like ssh) want to bind the address when it first com=
es up,
> sshd takes about 15 seconds to start. =C2=A0But, once this delay has =
happened,
> everything else works fine. =C2=A0For example, if I run iwconfig agai=
n, it
> displays the information immediately.
>
> Would any of you have any pointers on how to debug the problem with t=
his
> card and fix it? =C2=A0I'm running a custom kernel, so I can reconfig=
ure or patch
> as necessary. =C2=A0(Distribution is Linux From Scratch; =C2=A0all ot=
her similar
> systems with wireless networking work just fine.)

May want to try wireless-testing or compat-wireless to see if the
issue is still present. This driver is old and the maintainer is no
longer active so your best bet is to try the latest and see if someone
is willing to help you with random bits of troubleshooting.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

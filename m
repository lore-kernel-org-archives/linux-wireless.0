Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:38114 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYCaCfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 22:35:16 -0400
Received: by rv-out-0910.google.com with SMTP id k20so768147rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 19:35:15 -0700 (PDT)
Message-ID: <183c1cc10803301935p16647709u837f3fb3377c687d@mail.gmail.com> (sfid-20080331_033520_618791_A6A87D8C)
Date: Sun, 30 Mar 2008 22:35:15 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with iwl4965 and kernel 2.6.24.4
In-Reply-To: <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com>
	 <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com>
	 <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 27, 2008 at 12:27 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Thursday, March 27, 2008 7:41 AM, John Goulah  wrote:
>
>  >>  It appears I am still having some issues here with associating.
>  >>  Could this be on the driver end of things?  It doesn't happen with
>  >> another  box (other drivers)
>  >>
>  >>  I can disassociate:
>  >>  $ sudo iwconfig wlan0 ap off
>  >>  $ iwconfig
>  >>
>  >> wlan0     IEEE 802.11  ESSID:"goulahnet"
>  >>           Mode:Managed  Frequency:2.412 GHz  Access Point:
>  >> Not-Associated           Tx-Power=14 dBm
>  >>
>  >>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>  >>           Link Quality:0  Signal level:0  Noise level:0
>  >>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>  >>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>  >>
>  >>
>  >>
>  >>  What I was doing before is showing Invalid:
>  >>
>  >>
>  >>  $ sudo iwconfig wlan0 ap any  (same for auto here)  $ iwconfig
>  >>
>  >> wlan0     IEEE 802.11  ESSID:"goulahnet"
>  >>           Mode:Managed  Frequency:2.412 GHz  Access Point: Invalid
>  >> Tx-Power=14 dBm
>  >>
>  >>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>  >>           Link Quality:0  Signal level:0  Noise level:0
>  >>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>  >>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>  >>
>  >>
>  >>
>  >>
>  >>  It does seem a bit random, and I did have it working there for a
>  >>  while, but it looked like if issue ctrl-C to wpa_supplicant  it got
>  >>  into this state, or a reboot.
>  >>
>  >>  Anything I can try here?
>  >>
>  >>
>  >>
>  >
>  >
>  > Quick followup, one thing I've found is that I can scan as root and
>  > see my access point in the list:
>  >
>  >          Cell 09 - Address: 00:15:E9:FA:E2:DB
>  >                    ESSID:"goulahnet"
>  >                    Mode:Master
>  >                    Frequency:2.462 GHz (Channel 11)
>  >                    Channel:11 Quality=84/100  Signal level=-50 dBm
>  > Noise level=-127 dBm
>  >                    Encryption key:on
>  >                    IE: WPA Version 1
>  >                        Group Cipher : CCMP
>  >                        Pairwise Ciphers (1) : CCMP
>  >                        Authentication Suites (1) : PSK
>  >                    IE: IEEE 802.11i/WPA2 Version 1
>  >                        Group Cipher : CCMP
>  >                        Pairwise Ciphers (1) : CCMP
>  >                        Authentication Suites (1) : PSK
>  >                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
>  >                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24
>  > Mb/s; 36 Mb/s
>  >                              48 Mb/s; 54 Mb/s
>  >                    Extra:tsf=00000208dd78c752
>  >
>  >
>  >
>  >
>  > One time, that even got me associated.  But after removing the module
>  > and trying again to be sure, I'm still showing "Invalid"
>  >
>  > This seems a bit odd to me-  Ideas are appreciated, I'm happy to
>  > debug where appropriate -
>
>  The driver and wpa_supplicant is able to provide more debugging
>  information. Could you please capture debugging from both and submit a
>  bug to http://www.intellinuxwireless.org/bugzilla/?
>
>  wpa_supplicant debugging is obtained by running it with -ddt option
>  driver debugging is obtained by loading driver with debugging enabled
>  (modprobe iwl4965 debug=0x43fff)
>
>  If possible, please annotate logs to indicate what you did at the time.
>


I just wanted to follow up before posting a bug.   I ran the module in
debug mode, but I don't see (in dmesg) any info in terms of the
initial associating to the AP problem.  Running wpa_supplicant did
give some info, but the only problem with that after you are
associatied is on disconnect it makes you lose the AP association
(perhaps this is a separate bug in itself)

One piece of info I did pickup while using wpa_supplicant is:

  wlan0: association frame received from 00:15:e9:fa:e2:db, but not in
associate state - ignored


Let me know where to go from here; if you still want the
wpa_supplicant info I can post a bug for that, but the more major
problem seems that I have to explicitly tell iwconfig what my AP mac
address is, it wont associate otherwise even though "iwlist scan"
turns it up just fine, but I'm not having much luck producing useful
info here.


Thanks,
John

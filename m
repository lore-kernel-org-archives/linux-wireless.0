Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:41053 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbYC0D1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 23:27:37 -0400
Received: by rv-out-0910.google.com with SMTP id k20so2212786rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2008 20:27:32 -0700 (PDT)
Message-ID: <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com> (sfid-20080327_032741_381088_72ABB851)
Date: Wed, 26 Mar 2008 23:27:32 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with iwl4965 and kernel 2.6.24.4
In-Reply-To: <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 5:04 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Wednesday, March 26, 2008 11:49 AM, John Goulah  wrote:
>
> >
> > $ iwconfig
> > lo        no wireless extensions.
> >
> > eth1      no wireless extensions.
> >
> > sit0      no wireless extensions.
> >
> > wmaster0  no wireless extensions.
> >
> > Warning: Driver for device wlan0 has been compiled with version 22
> > of Wireless Extension, while this program supports up to version 20.
> > Some things may be broken...
> >
> > wlan0     IEEE 802.11  ESSID:"goulahnet"
> >          Mode:Managed  Frequency:2.412 GHz  Access Point:
> >          Not-Associated Tx-Power=0 dBm
> >          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
> >          Link Quality:0  Signal level:0  Noise level:0
> >          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >
> >
> >
> > Is this warning a problem?  Does this mean I need to get a newer
> > iwconfig (I'm on debian etch, Wireless-Tools version 28)
>
> I don't know if it is necessary. In the above iwconfig output it does
> not look as though you are associated though.
>



It appears I am still having some issues here with associating.  Could
this be on the driver end of things?  It doesn't happen with another
box (other drivers)

I can disassociate:
$ sudo iwconfig wlan0 ap off
$ iwconfig
wlan0     IEEE 802.11  ESSID:"goulahnet"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=14 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



What I was doing before is showing Invalid:


$ sudo iwconfig wlan0 ap any  (same for auto here)
$ iwconfig
wlan0     IEEE 802.11  ESSID:"goulahnet"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Invalid
          Tx-Power=14 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0




It does seem a bit random, and I did have it working there for a
while, but it looked like if issue ctrl-C to wpa_supplicant  it got
into this state, or a reboot.

Anything I can try here?



Thanks!
John

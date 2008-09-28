Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:30619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYI1T2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 15:28:06 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1200592fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 12:28:04 -0700 (PDT)
Message-ID: <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com> (sfid-20080928_212812_717614_05E6B5C7)
Date: Sun, 28 Sep 2008 15:28:04 -0400
From: Paul <paul14075@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables aireplay-ng and others to work
In-Reply-To: <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
	 <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtap interface works exactly as it should (allows me to capture
packets whether in managed or monitor mode), but it is still
insufficient for the packet injection feature of aireplay-ng (and >
others) to work.

As I understand it, the ipw2200 will not allow for sending of the
injection packets unless it is in Managed mode.  For whats it worth
the injection packets are typically *raw* [replayed] 802.11 encrypted
data frames containing ARP request packets.  aireplay-ng will listen
on the rtap interface for what it believes to be an encrypted ARP
packet (which it surmises from the length of the frame payload, and
the broadcast wlan address), and then it 'replays" this packet
repeatedly on the eth1 (or wifi) interface.

But in Managed mode, aireplay-ng still does not work, saying:

> "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
> ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
> 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
> injection support was not found either."

The error sugegsts going to Monitor mode, but in monitor mode the
injection packets cannot be sent at all, which I understand is a quirk
specific to this particular Intel wifi chipset.  After applying this
patch, the injection packets *can* successfully be sent while in
*managed* mode.

Basically, if I was going to audit my own wifi access point, by trying
to obtain the WEP key without knowing it, I'd do this:

iwconfig eth1 channel <CHANNEL#>
iwconfig eth1 ap <BSSID>
iwconfig eth1 key s:fakekey
iwconfig eth1 mode Managed

This essentially tricks it into going into managed mode, even though I
don't know the WEP key.  At this point, iwconfig reports that I am
associated with the AP.  Next step is to use aireplay-ng to listen on
the rtap interface for an ARP packet, which it then "replays" on the
wifi interface about 300 times a second (in order to generate a lot of
encrypted traffic on the network, which allows one to record many WEP
initialization vectors (IV's) which are then used in heuristic crypto
attacks to obtain the key).

Before applying the patch, the injection would not work, displaying
the above error.  After the patch, it works great.

Thanks,
Paul



> On Sat, Sep 27, 2008 at 11:15 PM, Zhu Yi <yi.zhu@intel.com> wrote:
>> On Sat, 2008-09-27 at 14:45 -0600, Paul wrote:
>>> I made this patch using bits and pieces from various other "ipw2200
>>> injection patches".  I can not take credit for the content, as I
>>> basically just changed the line numbers in the .diff files.  However I
>>> applied this patch to the version of ipw2200 included in kernel
>>> 2.6.27-rc6  (i believe it's ipw2200-1.2.2) and it worked like a charm.
>>>
>>> Previously I was unable to inject wifi packets using aireplay-ng due
>>> to this error:
>>>
>>> "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
>>> ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
>>> 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
>>> injection support was not found either."
>>>
>>> However, after switching to Monitor mode, even though aireplay would
>>> ACT AS IF it was working, it wasn't.
>>
>> Isn't the rtap_iface does the same thing? Did you try it?
>>
>> Thanks,
>> -yi
>>
>>
>

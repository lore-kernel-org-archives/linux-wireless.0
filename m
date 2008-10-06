Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYJFJNi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 05:13:38 -0400
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables
	aireplay-ng and others to work
From: Zhu Yi <yi.zhu@intel.com>
To: Paul <paul14075@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com>
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
	 <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
	 <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 17:11:56 +0800
Message-Id: <1223284316.2510.721.camel@debian.sh.intel.com> (sfid-20081006_111343_274436_FA74EFEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-09-28 at 13:28 -0600, Paul wrote:
> The rtap interface works exactly as it should (allows me to capture
> packets whether in managed or monitor mode), but it is still
> insufficient for the packet injection feature of aireplay-ng (and >
> others) to work.
> 
> As I understand it, the ipw2200 will not allow for sending of the
> injection packets unless it is in Managed mode.  For whats it worth
> the injection packets are typically *raw* [replayed] 802.11 encrypted
> data frames containing ARP request packets.  aireplay-ng will listen
> on the rtap interface for what it believes to be an encrypted ARP
> packet (which it surmises from the length of the frame payload, and
> the broadcast wlan address), and then it 'replays" this packet
> repeatedly on the eth1 (or wifi) interface.

The rtap interface does use the managed mode firmware. This is what we
call the promiscuous mode. It allows the STA to receive data frames not
direct to the STA and management frames in this BSS network. So nothing
prevents you to Tx in the rtap interface. But the current driver
implementation makes the Tx handler Rx all the frames (apply filter
also) the stack provides. My suggestion is if you can add an option so
that the prom_net->hard_start_xmit handler could call ipw_tx_skb() to
inject frames.

> But in Managed mode, aireplay-ng still does not work, saying:
> 
> > "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
> > ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
> > 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
> > injection support was not found either."
> 
> The error sugegsts going to Monitor mode, but in monitor mode the
> injection packets cannot be sent at all, which I understand is a quirk
> specific to this particular Intel wifi chipset.  After applying this
> patch, the injection packets *can* successfully be sent while in
> *managed* mode.
> 
> Basically, if I was going to audit my own wifi access point, by trying
> to obtain the WEP key without knowing it, I'd do this:
> 
> iwconfig eth1 channel <CHANNEL#>
> iwconfig eth1 ap <BSSID>
> iwconfig eth1 key s:fakekey
> iwconfig eth1 mode Managed
> 
> This essentially tricks it into going into managed mode, even though I
> don't know the WEP key.  At this point, iwconfig reports that I am
> associated with the AP.  Next step is to use aireplay-ng to listen on
> the rtap interface for an ARP packet, which it then "replays" on the
> wifi interface about 300 times a second (in order to generate a lot of
> encrypted traffic on the network, which allows one to record many WEP
> initialization vectors (IV's) which are then used in heuristic crypto
> attacks to obtain the key).
> 
> Before applying the patch, the injection would not work, displaying
> the above error.  After the patch, it works great.

I understand the current ipw2200 driver doesn't support packet
injection. But the sysfs entry in your patch doesn't seem clean to me.
If you can put together a patch to make the rtap interface be able to
inject packets, I'd like to accept it.

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.tpgi.com.au ([203.12.160.61]:39124 "EHLO
	mail4.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbXKUNcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 08:32:52 -0500
Message-ID: <474432E8.90304@hotmail.com> (sfid-20071121_133336_650901_28ABC18D)
Date: Thu, 22 Nov 2007 00:30:16 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	   David Miller <davem@davemloft.net>,
	   Johannes Berg <johannes@sipsolutions.net>,
	   Daniel Drake <dsd@gentoo.org>, jt@hpl.hp.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	jt@hpl.hp.com, Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com>
In-Reply-To: <47443035.1070702@hotmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Shaddy Baddah wrote:
=> Please find this in-lined below (with key protected):
> 
> # iwconfig eth2
> eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: Invalid
>           Bit Rate=1 Mb/s
>           Encryption key:<too big>
> 
> # iwconfig eth2 essid dixieland key "GGGGGGGGGG"
> # iwconfig eth2
> eth2      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 
> GG:GG:GG:GG:GG:GG
>           Bit Rate=24 Mb/s
>           Encryption key:<too big>
> 
> #
> 


Interestingly, after performing the above actions, I am now getting 
additional log messages:

SoftMAC: Open Authentication completed with GG:GG:GG:GG:GG:GG
Kernel unaligned access at TPC[100df410] 
ieee80211softmac_handle_assoc_response]
Kernel unaligned access at TPC[100df548] 
ieee80211softmac_handle_assoc_response]
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
[ieee802]
Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
[ieee802]
Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
[ieee802]
Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
[ieee802]
Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
[ieee802]
Kernel unaligned access at TPC[100ee624] do_rx+0x394/0x5ec [zd1211rw] 

Kernel unaligned access at TPC[100ee62c] do_rx+0x39c/0x5ec [zd1211rw] 

Kernel unaligned access at TPC[100ee638] do_rx+0x3a8/0x5ec [zd1211rw] 

Kernel unaligned access at TPC[100ee668] do_rx+0x3d8/0x5ec [zd1211rw] 

Kernel unaligned access at TPC[100ee670] do_rx+0x3e0/0x5ec [zd1211rw] 



Hope this helps,
Shaddy

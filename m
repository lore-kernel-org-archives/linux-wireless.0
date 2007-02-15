Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:44788 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965133AbXBOIRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 03:17:52 -0500
Received: by wr-out-0506.google.com with SMTP id i31so595069wra
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 00:17:52 -0800 (PST)
Message-ID: <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
Date: Thu, 15 Feb 2007 10:17:50 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: nl80211 userspace
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1171479846.3709.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1171479846.3709.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think it would be nice to have ifconfig for all interface
configuration as they have done in openbsd, it's better to have one
tool for all. What do you think ?

2007/2/14, Johannes Berg <johannes@sipsolutions.net>:
> Hi,
>
> I've been playing a bit with parsing a modified nl80211 header file to
> get a tool and
>
>  http://git.sipsolutions.net/pynl80211.git/
>
> is what I currently have. It doesn't
> actually send netlink messages yet but that ought to be trivial to add,
> I'm too lazy right now to look up all the exact binary stuff. Python
> does have a "struct" module that can be used to pack things into binary
> so it's really easy :)
>
> Anyway. The repository contains a modified nl80211.h and the tool relies on
> a lot of things to be correct in it, see parse.py.
>
> Examples:
> $ ./wificonf.py help configure
> ./wificonf.py configure ifindex [ssid=...] [transmit_power=...] [frag_threshold=...] [channel=...] [rx_sensitivity=...]
>         ifindex: interface name or index
>         ssid: string (1-32 bytes)
>         transmit_power: u32
>         frag_threshold: u32
>         channel: u32
>         rx_sensitivity: u32
> $ ./wificonf.py help set_roaming_control
> ./wificonf.py set_roaming_control ifindex roaming_control
>         ifindex: interface name or index
>         roaming_control: kernel, userspace
> $ ./wificonf.py configure eth1 ssid="my ssid" channel=7 frag_threshold=580
> TODO: construct a netlink message with command number 9
> and the following attributes
>         1: 4
>         18: 'my ssid'
>         20: 580
>         12: 7
> $ ./wificonf.py set_fixed_bssid eth1 0:1:2:3:4:ff
> TODO: construct a netlink message with command number 17
> and the following attributes
>         1: 4
>         15: '\x00\x01\x02\x03\x04\xff'
>
> (ifindex is looked up via sysfs: /sys/class/net/<name>/ifindex)
>
> Obviously parsing the response netlink message is missing too :)
>
> Included also is a check shell script that will use wificonf's parser to
> make sure the header file was parsed correctly wrt the numbers of the
> constants (since I don't have a C parser built into it.)
>
> johannes
>
>


-- 
As you read this post global entropy rises. Have Fun ;-)
Nick

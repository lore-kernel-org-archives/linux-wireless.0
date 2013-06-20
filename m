Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3382 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010Ab3FTIdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 04:33:38 -0400
Message-ID: <51C2BE54.20509@broadcom.com> (sfid-20130620_103351_920745_152AD8C3)
Date: Thu, 20 Jun 2013 10:33:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Chris Adams" <cma@cmadams.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
References: <20130619160911.GB4784@cmadams.net>
 <51C1DDEB.3090701@lwfinger.net> <20130619164227.GC4784@cmadams.net>
 <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
 <20130619175850.GD4784@cmadams.net> <51C21B7C.2030005@broadcom.com>
 <20130619211108.GG4784@cmadams.net>
In-Reply-To: <20130619211108.GG4784@cmadams.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 11:11 PM, Chris Adams wrote:
> Once upon a time, Arend van Spriel <arend@broadcom.com> said:
>> Can you make a capture using a wireless sniffer (using your thinkpad maybe)?
>
> How would I go about doing that?  I've done lots of network debugging
> with tcpdump and such, but not much wireless stuff.
>

I use wireshark these days. If you install that you can use the steps 
below and select the wireless interface in wireshark to capture. I use 
wlan0 as interface name, but it may be different for you.

1. disable network-manager so it won't interfere.
2. bring the interface down
$ sudo ifconfig wlan0 down
3. change interface type to monitor
$ sudo iw dev wlan0 set type monitor
4. bring up the interface
$ sudo ifconfig wlan0 up
5. start wireshark and select wlan0
$ gksudo wireshark

It will complain that running wireshark as root is not secure. If you 
care about that, you should read [1].

Regards,
Arend

[1] 
http://wiki.wireshark.org/Security#Administrator.2Froot_account_not_required.21


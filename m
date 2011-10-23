Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2521 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1JWKEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 06:04:41 -0400
Message-ID: <4EA3E6AD.4030701@broadcom.com> (sfid-20111023_125616_555791_AB418DF6)
Date: Sun, 23 Oct 2011 12:04:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nico Schottelius" <nico-linux-20111017@schottelius.org>,
	"Eric Dumazet" <eric.dumazet@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org> <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org> <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org> <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch>
In-Reply-To: <20111022015945.GC26186@ethz.ch>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2011 03:59 AM, Nico Schottelius wrote:
> Hey Arend,
> 
> it seems that your patch really solves this problem.
> 
> I've got a new one now, though :-)
> 
> After several suspend/resume cycles, my card often reconnects to my AP
> that is only several meters (2) away. If the connection is established,
> I've a very laggy connection to the AP:
> 
> 64 bytes from 192.168.42.1: icmp_req=1154 ttl=64 time=10839 ms
> 64 bytes from 192.168.42.1: icmp_req=1155 ttl=64 time=9841 ms
> ...
> 64 bytes from 192.168.42.1: icmp_req=1164 ttl=64 time=2814 ms
> 64 bytes from 192.168.42.1: icmp_req=1165 ttl=64 time=16785 ms
> 64 bytes from 192.168.42.1: icmp_req=1166 ttl=64 time=20767 ms
> 
> Attached are the usual suspect outputs.
> This time I'm on 2.432 Ghz.
> 
> Cheers,
> 
> Nico
> 

Hi Nico,

I see three different AP's in this log. Could you indicate what AP you
have issues with.

[13087.196234] wlan0: RX AssocResp from 00:03:52:e3:0e:10 (capab=0x11
status=0 aid=3)
[13087.196238] wlan0: associated

[17148.068771] wlan0: RX AssocResp from 00:18:39:50:07:f3 (capab=0x421
status=0 aid=4)
[17148.068776] wlan0: associated

[19010.367351] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=0x611
status=0 aid=2)
[19010.367355] wlan0: associated

With the suspend/resume cycles early in the dmesg log it seems brcmsmac
gets disassoc/deauth before going to sleep. When things start to get
flaky this does not seem to happen and I see a lot of deauth reason=2 in
the log. If I am correct that would mean previousAuthNotValid. Not sure
why we see that. Will try to reproduce this tomorrow.

Gr. AvS


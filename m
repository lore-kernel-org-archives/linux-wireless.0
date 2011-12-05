Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45960 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab1LEKh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 05:37:58 -0500
Date: Mon, 5 Dec 2011 12:37:51 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Haohui Liao <liaohaohui@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] Wireless stalled after a few minutes with Linux
 Kernel 3.1
Message-ID: <20111205103751.GA3775@jouni.qca.qualcomm.com> (sfid-20111205_113802_537607_F18DEB97)
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
 <4EC7E739.4080404@broadcom.com>
 <CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
 <CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
 <CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 03, 2011 at 10:55:40PM +0800, Haohui Liao wrote:
> Dear Linux Wifi developers,
> 
> Regarding https://bugs.archlinux.org/task/27406
> 
> > The following is a portion of my wpa_supplicant.conf
> >
> >    ssid="LINUX-LINK"
> >    proto=WPA2
> >    key_mgmt=WPA-PSK
> >    pairwise=TKIP
> >    group=TKIP

That's pretty strange configuration.. Do you have any particular reason
for using TKIP as the pairwise cipher with WPA2? CCMP would be much more
likely configuration for WPA2 in general..

> Just wondering if I am the only one still doing the following from command line
> to connect to wifi?

I'm sure you are not the only one.. And in this particular case, I don't
see how that would make a difference.

> wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B
> iwconfig wlan0 power off
> dhcpd wlan0
> 
> If I do that, I will get wifi stall on wpa_supplicant when there is a
> rekeying with the Linux 3.1.x kernel.  It does not happen to Linux
> 3.0.x.  I have been searching on Internet around with no indicator.
> Just trying to ask if I did anything wrong? or everyone just uses
> NetworkManager?

Would you be able to provide some more details on what exactly you mean
with "wifi stall"? Are you sure this is related to rekeying?

May I ask why you have configured the station to force PTK rekeying
every 10 minutes? While TKIP is not really the most secure design out
there, the proper way of addressing this would be to use CCMP instead of
frequent rekeying with TKIP..

-- 
Jouni Malinen                                            PGP id EFC895FA

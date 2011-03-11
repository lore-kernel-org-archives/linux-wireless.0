Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42814 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1CKVYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 16:24:48 -0500
Message-ID: <4D7A931E.4080808@openwrt.org>
Date: Fri, 11 Mar 2011 22:24:46 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Chris_Dos=E9?= <chris.dose@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Unusual saw-wave like ping times from linux wireless AP to MacBook
 Pro, iPhone
References: <AANLkTi=de0vzqA-+CpmK1V88Ypj6TN4C+a4j4=KiyTJX@mail.gmail.com>
In-Reply-To: <AANLkTi=de0vzqA-+CpmK1V88Ypj6TN4C+a4j4=KiyTJX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-11 10:17 PM, Chris Dosé wrote:
> I have a ubuntu 10.04 based wireless router running hostapd 0.7.3, the
> latest compat-wireless ath9k.  The same experiments were tried using
> hostapd 0.6.9 and ath9k from 2.6.32 and 2.6.35 as well.  also, hostapd
> was tried in g mode and n mode, with wpa/wpa2 on and off, and with
> high throughput on and off. I always get the same (or similar)
> results.
> 
> The symptoms are like this: pinging a macbook pro, or an iphone, from
> the AP results in an almost perfectly regular saw-wave like pattern.
> The ping time starts at 50ms, steadily rises every subsequent ping
> until it reaches somewhere over 200ms, then abruptly resets back to
> 50ms, and rises again.  Graphing it in excel shows it is strangely
> very precise.  Between all the different version I've tried, I've seen
> slight variations on this, running the latest versions of everything
> now it seems like it starts closer to 1ms and rises to 200ms then
> starts over.
> 
> Pinging another wireless device on my network (an HP wireless printer)
> results in very fast, steady 5ms ping times.  So it's not ALL wireless
> clients, just some.  In this case it seems apple products, but I have
> nothing else currently to test with.
That's perfectly normal. These devices are going in powersave mode and
only wake up when they're notified to do so via beacons. Until they wake
up, frames are buffered on the AP.

- Felix

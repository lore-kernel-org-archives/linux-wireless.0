Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54103 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758275AbYLKTXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 14:23:16 -0500
Date: Thu, 11 Dec 2008 21:22:51 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <hrogge@googlemail.com>
Subject: Re: [RFC] mac80211: Add HT rates into RX status reporting
Message-ID: <20081211192251.GA5170@jm.kir.nu> (sfid-20081211_202322_429284_946C2370)
References: <20081211161741.GA27460@jm.kir.nu> <1229015789.8081.40.camel@johannes.berg> <20081211181545.GB32500@jm.kir.nu> <1229019768.8081.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229019768.8081.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 07:22:48PM +0100, Johannes Berg wrote:
> On Thu, 2008-12-11 at 20:15 +0200, Jouni Malinen wrote:
> > Yes. FreeBSD radiotap definition uses 0x80 as a flag in the rate field
> > for indicating that it is an MCS index, not bitrate.

> Ugh. Nobody will dissect that properly.

Actually, wireshark seems to have code to dissect that..

> Do you actually need this
> information in userland _now_? Otherwise, Dave Young is moving the list
> elsewhere and then we can properly define this in radiotap rather than
> going with some other set. 0x80 in flags (not rate) is used to indicate
> short-GI in wireshark, and it's all very confusing... I'd rather see a
> new "HT rate" field added to radiotap.

Well, yes, I do need it like yesterday. I really want to have a reliable
sniffer that I can trust on providing correct information about received
frames. I can obviously handle a personal patch that adds this, but it
gets more complex when asking others to capture some frames for you..

Anyway, I will move the radiotap parts into a separate patch and leave
it to others to decide whether that should go in now or not. The best
option (if John is willing) would likely be to get the first part
(mac80211 driver API addition and ath9k fix/cleanup) in and pushed
upstream while the radiotap parts would be maintained only in
wireless-testing for the time being.

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:41509 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab0L0UDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 15:03:09 -0500
Message-ID: <20101227220302.63544sgi04qmue4g@hayate.sektori.org>
Date: Mon, 27 Dec 2010 22:03:02 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 0/6] zd1211rw: add support for AP mode
References: <20101226112404.31775.77854.stgit@fate.lan>
 <20101227162850.560526dlr20mibwk@hayate.sektori.org>
In-Reply-To: <20101227162850.560526dlr20mibwk@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
>
> I think problem is that hostapd/mon.wlan2 is getting monitor packets  
>  in wrong order. This causes hostapd to receive null-function packet  
>  from b43 at wrong time resulting 'Data/PS-poll frame from not   
> associated STA xx:xx:xx:xx:xx:xx' message and disassociation. I  
> pretty  much don't have any idea why this happens and how to fix it.  
> I have  attached wireshark capture with monitor packets in wrong  
> order.

Figured out the bug. Appears to be at zd1211rw/zd_mac.c:filter_ack() line:
		for (i=1; i<position; i++) {

This should be:
		for (i=1; i<=position; i++) {

Otherwise ack_wait_queue is never fully emptied by ACK packets.

I have also made other cleanups/fixes on zd1211rw that are not related  
to AP-mode. Should I post AP-mode as own set and fixes as own?

-Jussi


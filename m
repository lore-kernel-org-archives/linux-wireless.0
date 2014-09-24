Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:57566 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaIXOve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 10:51:34 -0400
In-Reply-To: <5422C6E0.3080002@broadcom.com>
References: <53FDACD1.8090805@msgid.tls.msk.ru> <53FDF8EB.4050905@broadcom.com> <54169D4F.2090607@broadcom.com> <541EEF17.7020806@msgid.tls.msk.ru> <542145B1.4030202@msgid.tls.msk.ru> <54216BF1.3060500@broadcom.com> <20140923134419.GA19016@ubuntu-hedt> <54217AA5.2060803@broadcom.com> <542182BE.2000606@msgid.tls.msk.ru> <542183A6.4070207@msgid.tls.msk.ru> <20140923143124.GC19016@ubuntu-hedt> <54219984.2080601@msgid.tls.msk.ru> <5421AF5C.6000106@broadcom.com> <5421B78E.4050908@msgid.tls.msk.ru> <5422C6E0.3080002@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
From: Michael Tokarev <mjt@tls.msk.ru>
Date: Wed, 24 Sep 2014 18:51:23 +0400
To: Arend van Spriel <arend@broadcom.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Message-ID: <8d3f6516-9578-406c-9444-6fe1ba982ea6@email.android.com> (sfid-20140924_165143_178212_FFAE7402)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>I looked at the log. I see download commence because the packets 
>received of 1562 bytes length. So within one second I see little over 
>200 packets so approx. 3Mbps which is not impressive but I don't know 
>what can be expected.

When it works it goes 50+ Mbps. I always tested at the same place and the signal there is good. D/load speed is 11Mb/sec steady. When it works. Today after powercycle it worked fine at 11 megabytes per second, I transferred several gigs of data.

> Indeed after that it stalls and we only seem to 
>receive small packets of 179 bytes that seem to end up in 
>cfg80211_mgmt_rx. It could be that the hardware is somehow bogged and 
>can not receive at higher modulations as management frames are 
>transmitted at lower rates. The hardware will drop packets that are 
>having FCS (aka. checksum) errors. The brcmsmac is missing some code to
>
>read fcs error count from hardware, but I will get back to you with a 
>patch that we can use to confirm this.

I see. Today I ordered an intel wifi  card (which also works at 5MHz) and will swap bcm4313 with it. Since the notebook has to be disassembled for this (it doesn't have separate window for wifi card), and the procedure is rather complex I don't want to do it more times than necessary... ;)

Thanks! 

/mjt from android phone

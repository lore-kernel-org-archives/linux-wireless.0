Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdcbef.dreamhost.com ([208.97.132.145]:55470 "EHLO
	spunkymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757007AbZEVPiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 11:38:10 -0400
Message-ID: <4A16C6DC.7070502@hiramoto.org>
Date: Fri, 22 May 2009 17:38:04 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] hostapd not sending beacons, and no traffic.
References: <4A168B8A.4070609@hiramoto.org> <4A16AD12.2020200@hiramoto.org>
In-Reply-To: <4A16AD12.2020200@hiramoto.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karl Hiramoto wrote:
> more info on this enabling debug in ath9k
>
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                                
> ath9k: receive FIFO overrun interrupt                            
> ath9k: 0xf0010071 => 0x10000                                     
> ath9k: disable IER                                               
> ath9k: new IMR 0x10000                                           
> ath9k: 0x10000 => 0xf0010071
> ath9k: new IMR 0x918104b4
> ath9k: enable IER
> ath9k: AR_IMR 0x918104b4 IER 0x1
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
> ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
>
>   
Some more info.   If i rate limit the interface, this bug never occurs.
tc qdisc add dev wlan0_0 root handle 1: cbq avpkt 1000 bandwidth 20mbit


If i restart hostapd, the interface comes back OK..  Or anything that 
calls ath_reset() will make it come back.


Reproducing this downloading a http large file, without QOS it's always 
reproduceable.   Usually It occurs before 2MB is downloaded.

This is on a 266 mhz IXP425.  So maybee some kind of race happening here..

--
Karl

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758839AbYB2XwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:52:15 -0500
Subject: Re: ath5k in ad-hoc mode and encryption
From: Dan Williams <dcbw@redhat.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <m3k5kn9x9l.fsf@maximus.localdomain>
References: <m3k5kn9x9l.fsf@maximus.localdomain>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 18:49:24 -0500
Message-Id: <1204328964.6730.3.camel@localhost.localdomain> (sfid-20080229_235219_932398_DA1EC919)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-03-01 at 00:08 +0100, Krzysztof Halasa wrote:
> A simple question I hope.
> 
> I want to experiment with point-point encrypted wifi link. Have 2
> machines with AR5212, 5213, 5213A+RF2112A or something like that.
> 
> iwlist enc / iwlist keys says:
> wlan0     2 key sizes : 40, 104bits                                             
>           4 keys available :                                                    
>                 [1]: off                                                        
>                 [2]: off                                                        
>                 [3]: off                                                        
>                 [4]: off                                                        
>           Current Transmit Key: [1]                                             
> 
> iwlist auth:
> wlan0     Authentication capabilities :                                         
>                 WPA                                                             
>                 WPA2                                                            
>                 CIPHER-TKIP                                                     
>                 CIPHER-CCMP                                                     
>           Current Authentication algorithm :                                    
>                 open                                                            
>                 shared-key   
> 
> iwlist wpakeys:                                                
> wlan0     2 key sizes : 40, 104bits                                             
>           4 keys available :                                                    
> Error reading wpa keys (SIOCGIWENCODEEXT): Operation not supported              
> 
> 
> Now, is it possible to use, for example, CCMP cipher with 256-bit key?
> How do I set the key and CCMP mode?
> 
> Or, how do I set 104-bit and WPA+TKIP?
> 
> IOW, how do I set it up?

You use wpa_supplicant with an ad-hoc WPA config (ie,
key_mgmt=WPA-NONE).  I don't think iwconfig has the ability to set TKIP
& CCMP keys, thought it might have grown that ability when I wasn't
looking.

Dan

> 
> I noticed "iwconfig wlan0 key XXXXX" (104 bits) make the transmitting
> card encrypt data, but the receiving card doesn't seem to decrypt them
> (tcpdump shows encrypted traffic on receiving wlan0 and nothing
> works).
> 
> Perhaps there is some faq or example?


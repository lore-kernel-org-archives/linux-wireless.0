Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39748 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZEXJnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 05:43:50 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so2576454ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 02:43:51 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] Alignment between rt2500pci and mac80211
Date: Sun, 24 May 2009 11:43:48 +0200
Cc: Eric <eric@lente.dyndns.org>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <4A190304.9050002@lente.dyndns.org>
In-Reply-To: <4A190304.9050002@lente.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905241143.48549.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My knowledge about this part of mac80211 is very limited,
so perhaps Johannes or somebody else on the linux-wireless mailinglist
can answer below questions (I already added them to the CC list). :)

> As posted already in:
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5150&sid=ba55e2676ff5ff92ab36e7e16c29e7de
> Rafaello discovered an alignment problem between rt2500pci and mac80211 
> while operating with hostapd in master mode.
> I did some debugging to find the cause of this problem and discovered 
> that inside the net/mac80211/tx.c:__ieee80211_tx_prepare() function 
> __ieee80211_parse_tx_radiotap() is being called, which in itself does an 
> skb_pull with iterator.max_length (being 14 in my case).
> I think this is one of the causes of an alignment offset of 2 bytes of 
> the skb->data pointer (IF !IS_ALIGNED((int)skb->data,4)), as 
> dma_map_single requests require at least alignment at the 4 byte 
> boundary (on x86 at least, corrrect me if I'm wrong, as 
> http://www.mjmwired.net/kernel/Documentation/DMA-API.txt only talks 
> about the cache line boundary).
> Another cause is the __skb_queue_tail() call inside 
> __ieee80211_tx_prepare(), unfortunuatly I couldnt always reproduce the 
> latter one.
> 
> I have a few questions:
> Is there any agreement between mac80211 and maintaing alignment at all?
> Should anything coming back from mac80211 be rechecked for device 
> specific alignment ?
> 
> According to the comment inside __ieee80211_parse_tx_radiotap(), that 
> function should only be called for injected packages, however I couldn't 
> discover (yet) where exactly the flag IEE80211_TX_CTL_INJECTED is 
> set.Forcefully skipping that part causes the frame to fail, so 
> apparently it's neccesary, however I fail to see the logic behind it.
> Is this something the driver explicitly flags / needs?
> 
> All the the debugging was done on the daily wireless-testing tree from 
> linuxwireless.org.
> 
> 
> Any comments / insights would be appreciated :-)
> 
> 
> kind regards,
> 
> Eric
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> 



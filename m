Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60142 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1HYQcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:32:12 -0400
Received: by ewy4 with SMTP id 4so1078904ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 09:32:11 -0700 (PDT)
Subject: Some confusing segment of Beacon
From: pangyunong <029012@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 00:26:19 +0800
Message-ID: <1314289579.3210.27.camel@Yunong> (sfid-20110825_183221_091277_BA27AD78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I'm output the sk_buff at ieee80211_beacon_get_tim() in mac80211/tx.c

but I'm confused about some segments.

According to the book, 802.11 wireless networks: the definitive guide,  

-----------------------------------------------------------------------
Frame Control segment:
The two bytes in my condition should be 0000 0000 1000 0000 to indicate
that it is a management Beacon frame. 

However, the two bytes I obtain is      1000 0000 0000 0000 
------------------------------------------------------------------------

------------------------------------------------------------------------
Beacon Duration:
Two bytes in book should be 0000 0000 0010 0110 to indicate 100 ms
between two beacon from the 32th bytes but I calculate that segment
starts from 31th bytes. 
-------------------------------------------------------------------------



------------------ What I add into ieee80211_beacon_get_tim()---------

    printk("\n===============get_tim====================\n");  
    printk("     len = %u\n", skb->len);
    printk(" datalen = %u\n", skb->data_len);
    printk("mac len = %u\n", (unsigned int)skb->mac_len);
    printk("hdr len = %u\n", (unsigned int)skb->hdr_len);
    printk("     head= %u\n", (unsigned int)skb->head);
    printk("network head= %u\n", (unsigned int)skb->network_header); 
    printk("mac  head= %u\n", (unsigned int)skb->mac_header); 
    printk("data head= %u\n", (unsigned int)skb->data); 
    printk("tail head= %u\n", (unsigned int)skb->tail); 
    printk("end  head= %u\n", (unsigned int)skb->end); 

-----------------------------------------------------------------------

Hence, I’m wondering whether there are errors in my approach of
interpreting the data bytes. 



Yunong Pang
Regards,




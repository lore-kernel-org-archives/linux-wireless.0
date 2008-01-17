Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:39515 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYAQPhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:37:42 -0500
Received: by nf-out-0910.google.com with SMTP id g13so57592nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 07:37:40 -0800 (PST)
Message-ID: <478F766B.6030504@gmail.com> (sfid-20080117_153745_375525_EC1C1861)
Date: Thu, 17 Jan 2008 16:38:19 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
References: <47494851.4070504@gmail.com>	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>	 <1196268612.6058.157.camel@johannes.berg>	 <f6ca9fed0801110052ja95e86s9f1842846f0dd8fc@mail.gmail.com>	 <1200068256.3861.172.camel@johannes.berg>	 <f6ca9fed0801160208x40acfb91p8446298fda9e7726@mail.gmail.com> <1200508694.8708.24.camel@johannes.berg>
In-Reply-To: <1200508694.8708.24.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hmm.
>
> Not really very helpful. Do you have the WEP key that was in use at that
> time? 
no .. (have not stored it somewhere)
> Also, did the message actually occur during this dump?
>
>   
Yes and not only once ;)
> Is there any way to get the FCS of packets up to mac80211 from the
> iwlwifi drivers, or is it already snipped off by the firmware?
>
> Maybe you have a separate device you could capture traffic with?
> Preferably not iwlwifi, it seems to have trouble in monitor mode, at
> least my iwl4965 doesn't really seem to see traffic in foreign BSSes.
>
>   
Unfortunately no. I remember you sending a patch "adding proper monitor 
mode to iwl4965" .. has this ever been ported to iwl3945 ?
> Could you amend the failing printk to something like:
>
> DECLARE_MAC_BUF(mac1);
> DECLARE_MAC_BUF(mac2);
>
> [...]
>
> printk(KERN_DEBUG "WEP decrypt failed (ICV, A1=%s, A2=%s, seq=%x, wepidx=%d\n",
> 	print_mac(mac1, hdr->addr1), print_mac(mac2, hdr->addr2),
> 	le16_to_cpu(hdr->seq_ctrl), keyidx)
>
> Then start a packet capture and wait until the message occurs. Once it
> does, quickly run "iwlist key" as root to know what keys are currently
> in use and send me both the keys and the failing packet.
>
>   
Can do this (next week)
> Also, please see if maybe the printk is correlated (in time) with
> rekeying, the wpa_supplicant output (maybe with -dd) should tell you.
>
>   
I cannot say for sure now but last time I looked at the wpa_supplicant 
-ddd output while this was happening nothing was printed at all. But I 
will do this again and let you know.

thx


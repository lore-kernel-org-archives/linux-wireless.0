Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50322 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756421AbXHTRg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 13:36:28 -0400
Message-ID: <46C9D11B.4020001@lwfinger.net>
Date: Mon, 20 Aug 2007 12:36:27 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
References: <1187346385.23489.157.camel@johannes.berg>	 <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg>	 <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg>	 <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg>	 <46C752FE.4030706@lwfinger.net> <1187611793.6090.102.camel@johannes.berg>
In-Reply-To: <1187611793.6090.102.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2007-08-18 at 15:13 -0500, Larry Finger wrote:
> 
>> The rest of the call trace is available if needed. The crash occurred when ieee80211_key_free was
>> trying to unlock the mutex key_idx. I added printk's to dump the pointer to sdata at the point where 
>> that mutex is initialized and where the key is freed. The mutex that errs was inited.
> 
> Ho humm, yes, I'm dumb, patch below but I'll fold it into my key patch.
> Sorry about that, classic use-after-free condition here.

The patch fixed the crash. The reason for the "lost AP" is that WPA isn't working for b43legacy, 
with or without your patches. It used to work and I have no idea why it fails now.

Thanks,

Larry


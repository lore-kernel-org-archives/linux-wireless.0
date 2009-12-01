Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:51816 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568AbZLAVaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:30:02 -0500
Message-ID: <4B158ADF.7060700@gmail.com>
Date: Tue, 01 Dec 2009 22:30:07 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <4B14594E.2090307@free.fr>
In-Reply-To: <4B14594E.2090307@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/09 00:46, Benoit PAPILLAULT wrote:
> Gertjan van Wingerde a écrit :
>> The L2 padding fixes patch has grown a bit and now consists of 4 separate
>> patches to clean the L2 padding code up and to fix a number of bugs at the
>> same time.
>>
>> 	1. rt2x00: Further L2 padding fixes.
>> 	2. rt2x00: Remove SKBDESC_L2_PADDED flag.
>> 	3. rt2x00: Reorganize L2 padding inserting function.
>> 	4. rt2x00: Only remove L2 padding in received frames if there is payload.
>>
>> ---
>> Gertjan.
> 
> Thanks Gertjan for the patches, I know that padding is a bit of
> nightware. I've testing your tree and here are the results:
> 
> 1. On TX : It fails for control frames with hdrlen=10 since it will
> produce l2pad = 2 in your case, where it should be 0. In all other
> cases, it works!
> 

Hmm. That's strange, as patch 3 of the series should have handled this. Basically this patch
checks if a frame actually has payload, and refrains from inserting l2pad and payload alignment
in that case.

How did you detect this failure?
What did you observe on the "wire", i.e. how was the frame malformed because of this?

Also, would it be possible to get some of the skb details of a frame that fails?


> Solution : padding is only needed for data frames for rt28x devices, so
> I think it's better to something like rt2xqueue_padpos
> [http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=95ddf076c13062d1026025d97ba511f880a1792d]
> 

I'm still not fond of using detailed ieee 802.11 frame format knowledge to do this. I prefer
to use standard mac80211 functions with a bit of detection on the actual skb.

---
Gertjan.

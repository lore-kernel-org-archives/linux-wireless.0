Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44733 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbcC2QQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 12:16:47 -0400
Subject: Re: Question on rhashtable in worst-case scenario.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <56F9941A.3080501@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56FAAA6D.3070806@candelatech.com> (sfid-20160329_181708_555021_6CC5B70B)
Date: Tue, 29 Mar 2016 09:16:45 -0700
MIME-Version: 1.0
In-Reply-To: <56F9941A.3080501@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like rhashtable has too much policy in it to properly deal with
cases where there are too many hash collisions, so I am going to work on
reverting it's use in mac80211.

Thanks,
Ben

On 03/28/2016 01:29 PM, Ben Greear wrote:
> Hello!
>
> I have a use case for mac80211 where I create multiple stations to
> the same remote peer MAC address.
>
> I'm seeing cases where the rhashtable logic is returning -16 (EBUSY)
> on insert (see sta_info_hash_add).
> This is with the 4.4.6+ (plus local patches) kernel, and it has the patch mentioned
> here:
>
> https://lkml.org/lkml/2015/12/3/307
>
> If I understand the code properly, my use case is going to be worst-case scenario,
> where all of my items in the hash have the same key (peer mac addr).
>
> I have my own secondary hash to handle most of my hot-path lookups, but I still need
> the main hash to at least function in a linear-search manner.
>
> Any idea what I can do to get rid of the EBUSY return code problem, or how
> to debug it further?
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


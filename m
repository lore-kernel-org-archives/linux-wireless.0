Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46617 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009Ab1JARAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 13:00:20 -0400
Message-ID: <4E874745.1010908@emobix.co.uk> (sfid-20111001_190023_839902_4B429F72)
Date: Sat, 01 Oct 2011 18:00:53 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E81F8C8.4010909@lwfinger.net> <4E860CDB.9040207@emobix.co.uk> <201109302106.12028.chunkeey@googlemail.com> <4E873944.70104@lwfinger.net>
In-Reply-To: <4E873944.70104@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 17:01, Larry Finger wrote:
> Ian,
>
> Most of the skb assignments in r8712u are aligned OK and most aligned on
> 512-byte boundaries, but there was one that had the minimal offset of 14
> bytes. The attached patch should fix it. Does it help?

Hi Larry,

Very many thanks for looking at this - I tried to look in to it
myself but realised I don't have a good understanding about what's
going on.

I won't have access to my problematic ARM system until Monday, but
I've tried this on Blackfin with musb and there's no change in
operation unfortunately.

But - I added some printk() debug in this area of the code and it
seem amsdu_to_msdu() is never called, on Blackfin or on x86 - even
when the driver is fully active and transferring data on an x86 PC.

Ian

-- 
Ian Jeffray    ian@emobix.co.uk    Tel: +44 (0) 141 221 8449
emobix Limited, Suite 5/5, 29 St Vincent Place, Glasgow, G1 2DT
Registered in Scotland; Company No. 371276 - VAT No. 983 4833 78

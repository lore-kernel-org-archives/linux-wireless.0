Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45103 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbXCSKzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 06:55:03 -0400
Message-ID: <45FE6C02.5050605@warmcat.com>
Date: Mon, 19 Mar 2007 10:54:58 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070318101535.251183750@warmcat.com> <20070318101549.331461113@warmcat.com> <200703190156.07984.flamingice@sourmilk.net>
In-Reply-To: <200703190156.07984.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

> I've mostly made comments about style issues. There are only comments on the 
> first instance of any style problem so please check the rest of the code for 
> the same problems.

Thanks for this feedback Michael.  I have changed all the style problems 
my eyes could see, assisted by visiting every = in the patch.

> Hm, this could be integrated into the switch statement below, but it doesn't 
> really matter much.

It's also very handy for...

> Have you looked into padding issues with radiotap headers? For example, if 
> there is a 1 byte field which is then followed by a 4 byte field, there needs 
> to be 3 bytes of padding after the first field, but if the field after were 2 
> bytes long, the padding would only be 1 byte (according to my understanding 
> of the radiotap specs).

I googled for radiotap specs but I didn't find anything useful.  I added 
some small code to enforce the alignment rules you mention above.

I found there was no docs in ./Documentation about 80211, I added a 
small explanation and examples about injection including this alignment 
Gotcha so the knowledge isn't lost.

> We could avoid this check altogether by spinning this code into a different 
> function and setting the xmit handler appropriately depending on if we're 
> initializing/switching to a monitor interface or not. Not entirely sure if 
> it's worth it, but I thought I'd mention it.

Yes, that method would be marginally better, but there is only a single 
int getting tested in the main path and even that is marked up as 
unlikely().  So I leave it as it is for now.

-Andy

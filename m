Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36325 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0GLPRx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:17:53 -0400
Message-ID: <4C3B321F.2020609@openwrt.org>
Date: Mon, 12 Jul 2010 17:17:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Rate control & USB
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
In-Reply-To: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-12 12:48 PM, Ivo Van Doorn wrote:
> The problem here is that we have lost the per-sta statistics. However using the
> single TX status reports, we can count the number of frames which are sent for
> a given STA during the poll interval. We can then determine the percentage of
> frames sent for that STA, We can then add the percentage of the retry and ACK
> count to each STA. Throughout poll interval the rate algorithm would send all
> frames to the same STA with the same TX rate, but between polls, the rate will
> be updated.
> 
> Overall these changes will not make the optimal use of PID or
> Minstrel, but it would
> at least improve the situation for USB.
> 
> Any thoughts about this solution?
I don't know how minstrel could work with this approach. Before it
starts to use a rate, it has to sample it first. How can you sample
rates with your tx status feedback approach?

- Felix

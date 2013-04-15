Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43578 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3DOO1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:27:24 -0400
Message-ID: <516C0E40.3020502@openwrt.org> (sfid-20130415_162727_416971_E76F39A5)
Date: Mon, 15 Apr 2013 16:27:12 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] mac80211: improve the rate control API
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>  <1365890626-86895-2-git-send-email-nbd@openwrt.org>  <1365890626-86895-3-git-send-email-nbd@openwrt.org> <1366033473.8361.26.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366033473.8361.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-15 3:44 PM, Johannes Berg wrote:
> On Sun, 2013-04-14 at 00:03 +0200, Felix Fietkau wrote:
> 
>> +EXPORT_SYMBOL(rate_control_set_rates);
> 
> I don't think that needs to be exported (at least not now)?
Just thought I'd let driver-implemented rate control modules access it
as well if they want to.

> I suspect that the answer to my question in patch 2 lies here, if the
> rate control updates the table then would it not just update the table
> when the protection mechanism needs to be changed? There should be
> triggers for that, rather than having to check the "use_cts" variables
> on every packet, and if they aren't complete that should be fixed?
I guess we could do some further work on that, but for now I wanted to
keep things simple by having only the rate control module touch the
table (and not have it care about CTS protection).

- Felix

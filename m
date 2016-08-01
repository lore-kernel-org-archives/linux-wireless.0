Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33707 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbcHAMaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 08:30:18 -0400
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
To: Johannes Berg <johannes@sipsolutions.net>
References: <20160713200755.26839-1-yanivma@ti.com>
 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
 <1470045822.3389.24.camel@sipsolutions.net>
Cc: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org,
	Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <75fef3ce-41a6-5845-e9be-d7ff052a07da@gmail.com> (sfid-20160801_143043_891877_B6633558)
Date: Mon, 1 Aug 2016 21:30:12 +0900
MIME-Version: 1.0
In-Reply-To: <1470045822.3389.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年08月01日 19:03, Johannes Berg wrote:
>
> But why is that behaviour *correct*? We still support 40 MHz bandwidth
> things, we just don't use them if we disable HT40.

I could not fully understand your concern...

Do you mean we have 2 bugs about disabling HT40 ?

1) bits in HT capabilities IE
2) HT40 still enabled even if it was disabled by wpa_supplicant or 
hostapd with disable_ht40

And do you mean 1) and 2) should be fixed at one time ?
Indeed, currently on the view point of opposite peer, HT40 was enabled 
even though it was disabled because both 1) and 2) are wrong.
But if only 1) was fixed, this causes unmatch.

Now I do not recognize bug 2).
Do you have any information about 2) ?

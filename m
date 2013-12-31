Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33367 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3LaQdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 11:33:13 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so4765568eek.41
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 08:33:12 -0800 (PST)
References: <1388448016-10210-1-git-send-email-bogdan@nimblex.net>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1388448016-10210-1-git-send-email-bogdan@nimblex.net>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C7C499DD-BAB4-4F69-AFFF-3C9349F9D95F@gmail.com> (sfid-20131231_173318_817422_6BDF2252)
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	Bogdan Radulescu <bogdan@nimblex.net>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] Add STA mode support for devices based on Ralink RT5350
Date: Tue, 31 Dec 2013 17:33:09 +0100
To: Bogdan Radulescu <bogdan@nimblex.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bogdan,

> On 31 dec. 2013, at 01:00, Bogdan Radulescu <bogdan@nimblex.net> wrote:
> 
> Signed-off-by: Bogdan Radulescu <bogdan@nimblex.net>
> 
> ---
> drivers/net/wireless/rt2x00/rt2x00dev.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 9dd92a7..606e968 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1236,7 +1236,7 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>     */
>    if_limit = &rt2x00dev->if_limits_ap;
>    if_limit->max = rt2x00dev->ops->max_ap_intf;
> -    if_limit->types = BIT(NL80211_IFTYPE_AP);
> +    if_limit->types = BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_STATION);
> #ifdef CONFIG_MAC80211_MESH
>    if_limit->types |= BIT(NL80211_IFTYPE_MESH_POINT);
> #endif
> 

I'm sorry, but this cannot be correct. All, this patch does is allowing multiple AP and STA interfaces exist next to each other. This is something that is simply not possible with this device.

Why do you think that STA mode is not supported for the RT5350?

---
Gertjan
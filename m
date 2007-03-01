Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:22694 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXCAOLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 09:11:32 -0500
Received: by wr-out-0506.google.com with SMTP id 37so45276wra
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2007 06:11:32 -0800 (PST)
Message-ID: <43e72e890703010611o33b2a5b3kc43cadd2a11a5287@mail.gmail.com>
Date: Thu, 1 Mar 2007 09:11:31 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [TRIAL BALLOON] rework wireless Kconfig
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1172755537.11911.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1172755537.11911.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/1/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch
>  * kills NET_RADIO
>  * adds two new wireless driver menus for pre-802.11 and 802.11
>  * makes WIRELESS_EXT visible (to avoid the arguments we had in
>    commit c1783454a31e05b94774951b0b5d1eb9075ebfb4)
>  * changes everything that depended on NET_RADIO to select WIRELESS_EXT
>
> By removing NET_RADIO, these changes pave the way to making wireless
> extensions optional when cfg80211 can fully take over for some drivers
> and you don't have any older drivers that still require wext.
>
> These conflict with other changesets (notable Ivo's) but they should be
> easy to respin once those get in. This also depends on removing wext
> netlink, but it's trivial to do them w/o removing netlink wext of
> course. Though I think that the rtnetlink wext option shouldn't be under
> drivers so I'd move it in the case we don't want to remove it.

Makes sense.

> --- wireless-dev.orig/net/wireless/Kconfig      2007-03-01 14:18:51.854246483 +0100
> +++ wireless-dev/net/wireless/Kconfig   2007-03-01 14:19:19.614246483 +0100
> @@ -29,3 +29,11 @@ config NL80211
>
>           If unsure, say Y.
>
> +config WIRELESS_EXT
> +       bool "Wireless extensions"
> +       default n
> +       ---help---
> +         This compiles code for the wireless extensions.
> +
> +         Say N if you can unless you have external modules
> +         that rely on it.

I'd say we put more descriptive text here and explain a little of how
cfg80211 is supposed to replace it with nl80211.

  Luis

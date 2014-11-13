Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39999 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbaKMNgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 08:36:25 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH] cfg80211: remove net-pf-16-proto-16-family-nl80211 module alias
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141113132252.GB1926@redhat.com>
Date: Thu, 13 Nov 2014 22:36:17 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <252AB6B9-9D33-4932-B75F-D3B2B057D3C0@holtmann.org> (sfid-20141113_143628_880399_E72FDEAE)
References: <20141113123313.GA1926@redhat.com> <1415882683.2021.3.camel@sipsolutions.net> <20141113132252.GB1926@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

> With the alias cfg80211 module is loaded on systems without the wireless
> hardware when user-space use nl80211 to discover if there are wireless
> devices, what is considered as resources wastage. On systems with
> wireless hardware cfg80211 module will be loaded anyway.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> net/wireless/core.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index a4d2792..badcabe 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -34,7 +34,6 @@
> MODULE_AUTHOR("Johannes Berg");
> MODULE_LICENSE("GPL");
> MODULE_DESCRIPTION("wireless configuration support");
> -MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);

NAK.

We want to auto-load cfg80211 when userspace asked for nl80211 netlink family.

Regards

Marcel


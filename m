Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59018 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbYJVTfL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:35:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:35:11 -0700
Date: Wed, 22 Oct 2008 05:35:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: update regulatory sample code
Message-ID: <20081022123505.GI6190@tesla> (sfid-20081022_213516_232409_76FDBB17)
References: <1224701752.30459.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224701752.30459.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 11:55:52AM -0700, Johannes Berg wrote:
> Update the same code for the recent changes. I did this as a
> separate patch to avoid removing a lot of sample code only
> to add it back again in the next patch.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  Documentation/networking/regulatory.txt |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> --- everything.orig/Documentation/networking/regulatory.txt     2008-10-22 20:51:50.000000000 +0200
> +++ everything/Documentation/networking/regulatory.txt  2008-10-22 20:54:12.000000000 +0200
> @@ -131,7 +131,7 @@ are expected to do this during initializ
> 
>         r = zd_reg2alpha2(mac->regdomain, alpha2);
>         if (!r)
> -               regulatory_hint(hw->wiphy, alpha2, NULL);
> +               regulatory_hint(alpha2);
> 
>  Example code - drivers providing a built in regulatory domain:

Should we mention how currently this should be avoided unless
your regulatory definition is also intersected with hw capabilities
and that the same channels are the ones that are registered to cfg80211?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0LUKxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 05:53:47 -0500
Subject: Re: [PATCH 2/2] cfg80211: pass DFS region to drivers through
 reg_notifier()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292864555-28661-4-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
	 <1292864555-28661-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:53:43 +0100
Message-ID: <1292928823.3563.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:
> This grants drivers access to the DFS region that a
> regulatory domain belongs to.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  include/net/regulatory.h |    5 +++++
>  net/wireless/reg.c       |    4 ++++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
> index 9fcb603..3ed16c5 100644
> --- a/include/net/regulatory.h
> +++ b/include/net/regulatory.h
> @@ -40,6 +40,10 @@ enum environment_cap {
>   * 	99 - built by driver but a specific alpha2 cannot be determined
>   * 	98 - result of an intersection between two regulatory domains
>   *	97 - regulatory domain has not yet been configured
> + * @dfs_region: If CRDA responded with a regulatory domain that requires
> + *	DFS master operation on a known DFS region (NL80211_CFLAG_DFS_*),
> + *	dfs_region represents that region. Drivers can use this and the
> + *	@alpha2 to adjust their device's DFS parameters as they wish.

The alpha2 is pretty useless -- I don't think you should advocate using
it. I think it can even be "99" or something at this point.

johannes


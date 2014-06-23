Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62542 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaFWTPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 15:15:10 -0400
Received: by mail-pd0-f174.google.com with SMTP id y10so5990075pdj.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 12:15:09 -0700 (PDT)
Date: Mon, 23 Jun 2014 12:15:04 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	wireless-regdb@lists.infradead.org
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
Message-ID: <20140623191504.GD1390@garbanzo.do-not-panic.com> (sfid-20140623_211517_601454_D6850E48)
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Adding wireless-regdb.

Regulatory folks:

if two cards are present on a system, in the worst case consider
two different cards for AP mode, and one has a DFS region set for the
country its on but the other does not, do we want to use the DFS region
for both? DFS would not be allowed on system unless the DFS region is
set. DFS operation requires a card to explicitly support DFS though so
even though it can be set as an intersection each card would still
require DFS suport for that region.

As I see it this will depend on what we want cards to do if the DFS
region is unknown for a region. If the DFS region is not known can
we use any DFS algorithm? If we cannot then I think a DFS intersection
would require agreement on the DFS region. That would also mean though
that when shipping products if a system is built with one card that has
DFS for ETSI for example, and then a secondary card is present and its
regulatory domain does not have DFS then the first card would not be
able to operate on the DFS. I think this is reasonable given that 
the two cards must at least agree on the regulatory domain, otherwise
the folks doing system integration probably did a bad job at thinking
of things ahead of time. Even though this can be technically true I
foresee folks this misconfiguration happening in the future and folks
beingp puzzled by this as an issue. This means this should be documented
for folks selling devices in a combined wifi system.

As such NACK for now.

  Luis

On Wed, Jun 11, 2014 at 01:08:34PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If one is UN-SET, use the other.  Seems this would
> be more correct that what we have now.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> Someone that understands this code better than I
> do should review this well before it is considered
> for upstream.  I'm not sure it is actually needed.
> 
>  net/wireless/reg.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 785e516..b87035f 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -727,8 +727,15 @@ static enum nl80211_dfs_regions
>  reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
>  			 const enum nl80211_dfs_regions dfs_region2)
>  {
> -	if (dfs_region1 != dfs_region2)
> +	if (dfs_region1 != dfs_region2) {
> +		pr_info("intersect-dfs-region, region1: %d  region2: %d\n",
> +			dfs_region1, dfs_region2);
> +		if (dfs_region1 == NL80211_DFS_UNSET)
> +			return dfs_region2;
> +		if (dfs_region2 == NL80211_DFS_UNSET)
> +			return dfs_region1;
>  		return NL80211_DFS_UNSET;
> +	}
>  	return dfs_region1;
>  }
>  

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0LIOHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:07:09 -0500
Subject: Re: [PATCH] cfg80211: update information elements in cached BSS
 struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291903524-8000-1-git-send-email-s.neumann@raumfeld.com>
References: <1291902830.3540.8.camel@jlt3.sipsolutions.net>
	 <1291903524-8000-1-git-send-email-s.neumann@raumfeld.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 15:07:07 +0100
Message-ID: <1291903627.3540.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 15:05 +0100, Sven Neumann wrote:
> When a cached BSS struct is updated because a new beacon was received,
> the code replaces the cached information elements by the IEs from the
> new beacon. However it did not update the pub.information_elements
> and pub.len_information_elements fields leaving them either pointing
> to the old beacon IEs or in an inconsistent state where the data is
> replaced by the new beacon IEs but len_information_elements still has
> its value from the first beacon.
> 
> Fix this by updating the information elements fields if they are
> pointing to beacon IEs.
> 
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/scan.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 503ebb8..ea427f4 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -464,6 +464,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>  		if (res->pub.beacon_ies) {
>  			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
>  			size_t ielen = res->pub.len_beacon_ies;
> +			bool information_elements_is_beacon_ies =
> +				(found->pub.information_elements ==
> +				 found->pub.beacon_ies);
>  
>  			if (found->pub.beacon_ies &&
>  			    !found->beacon_ies_allocated &&
> @@ -487,6 +490,14 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>  					found->pub.len_beacon_ies = ielen;
>  				}
>  			}
> +
> +			/* Override IEs if they were from a beacon before */
> +			if (information_elements_is_beacon_ies) {
> +				found->pub.information_elements =
> +					found->pub.beacon_ies;
> +				found->pub.len_information_elements =
> +					found->pub.len_beacon_ies;
> +			}
>  		}
>  
>  		kref_put(&res->ref, bss_release);



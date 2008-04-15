Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13564 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780AbYDORBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 13:01:16 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH RFC] mac80211: Fixes n-band association problem withcertain APs
Date: Tue, 15 Apr 2008 10:01:13 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F038E39C1@orsmsx411.amr.corp.intel.com> (sfid-20080415_180126_099769_C515EA61)
In-Reply-To: <1207943021.13354.76.camel@johannes.berg>
References: <1207867745-26538-1-git-send-email-reinette.chatre@intel.com> <1207943021.13354.76.camel@johannes.berg>
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two structures named wmm_info and wmm_param, they are used
while
Parsing the beacon frame. (Check the function ieee802_11_parse_elems).
Certain APs like D-link does not set the fifth bit in WMM IE. I was able
to see it thought packet capture. And this patch fixes this problem by
copying the wmm_info to wmm_ie, which enables the "wmm" flag in
iee80211_send_assoc.


Abhijeet
 

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Friday, April 11, 2008 12:44 PM
To: Chatre, Reinette
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org;
ipw3945-devel@lists.sourceforge.net; Kolekar, Abhijeet
Subject: Re: [PATCH RFC] mac80211: Fixes n-band association problem
withcertain APs

On Thu, 2008-04-10 at 15:49 -0700, Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> 
> For WME(221) tag in beacon frames from certain n-only aps*
> 5th bit is not set.So while parsing the beacon frame the wmm_info*
> structure is used instead of wmm_param. wmm_info structure is*
> never used to set bss->wmm_ie. While sending the association request
to
> n-only ap it checks for wmm_ie. If it is set then only
ieee80211_ht_cap
> is sent during association request.So n-only association fails.
> This patch fixes this problem by copying the WME information from
wmm_info
> to bss->wmm_ie and thus enabling n-band association.

I haven't got a clue. I didn't even know there where two things,
wmm_param and wmm_info.

> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---
>  net/mac80211/mlme.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 83e8b49..ec2f722 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2668,7 +2668,18 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
>  			bss->wmm_ie_len = elems.wmm_param_len + 2;
>  		} else
>  			bss->wmm_ie_len = 0;
> -	} else if (!elems.wmm_param && bss->wmm_ie) {
> +	} else if (elems.wmm_info &&
> +		    (!bss->wmm_ie || bss->wmm_ie_len !=
elems.wmm_info_len ||
> +		     memcmp(bss->wmm_ie,
elems.wmm_info,elems.wmm_info_len))) {
> +		kfree(bss->wmm_ie);
> +		bss->wmm_ie = kmalloc(elems.wmm_info_len + 2,
GFP_ATOMIC);
> +		if (bss->wmm_ie) {
> +			memcpy(bss->wmm_ie, elems.wmm_info - 2,
> +			       elems.wmm_info_len + 2);
> +			bss->wmm_ie_len = elems.wmm_info_len + 2;
> +		} else
> +			bss->wmm_ie_len = 0;
> +	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
>  		kfree(bss->wmm_ie);
>  		bss->wmm_ie = NULL;
>  		bss->wmm_ie_len = 0;

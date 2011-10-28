Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab1J1LxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 07:53:15 -0400
Message-ID: <4EAA979D.7090108@redhat.com> (sfid-20111028_135322_768922_7292A12A)
Date: Fri, 28 Oct 2011 07:53:01 -0400
From: Bill C Riemers <briemers@redhat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: disable powersave for broken APs
References: <1319795987.8931.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319795987.8931.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure how patching this patch will stop the abort in iwl-core.c.   Unless of course the aid value set here ends up as what is tested in iwl-core.c.   BTW.  Is it 2007 or 0x2007.   The ieee80211_softmac.c code is using 0x2007.  While it could just be coincidence, I would expect these two should be the same constant...

I won't be able to test the code as it will take about 1-2 hours for a kernel build, and I am checking out of my hotel in about 30 minutes.   However, my colleague mentioned he was seeing the same problem on his home network.   So I will ask him if my previous build fixed his problem.  If so it probably really is the exact same problem, and I can ask him to test this new patch.

Bill

On 10/28/2011 05:59 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> Only AID values 1-2007 are valid, but some APs have been
> found to send random bogus values, in the reported case an
> AP that was sending the AID field value 0xffff, an AID of
> 0x3fff (16383).
>
> There isn't much we can do but disable powersave since
> there's no way it can work properly in this case.
>
> Cc: stable@vger.kernel.org
> Reported-by: Bill C Riemers<briemers@redhat.com>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
> Bill, please test this patch and see if you still see the
> warnings, or you can revert your iwlwifi changes and test
> then, it should work.
>
> John, please wait for Bill to test before you apply, just
> to confirm it fixes the issue.
>
>   net/mac80211/ieee80211_i.h |    1 +
>   net/mac80211/mlme.c        |   18 ++++++++++++++++--
>   2 files changed, 17 insertions(+), 2 deletions(-)
>
> --- a/net/mac80211/ieee80211_i.h	2011-10-28 11:03:50.000000000 +0200
> +++ b/net/mac80211/ieee80211_i.h	2011-10-28 11:51:48.000000000 +0200
> @@ -393,6 +393,7 @@ struct ieee80211_if_managed {
>
>   	unsigned long timers_running; /* used for quiesce/restart */
>   	bool powersave; /* powersave requested for this iface */
> +	bool broken_ap; /* AP is broken -- turn off powersave */
>   	enum ieee80211_smps_mode req_smps, /* requested smps mode */
>   				 ap_smps, /* smps mode AP thinks we're in */
>   				 driver_smps_mode; /* smps mode request */
> --- a/net/mac80211/mlme.c	2011-10-12 17:11:31.000000000 +0200
> +++ b/net/mac80211/mlme.c	2011-10-28 11:57:50.000000000 +0200
> @@ -637,6 +637,9 @@ static bool ieee80211_powersave_allowed(
>   	if (!mgd->powersave)
>   		return false;
>
> +	if (mgd->broken_ap)
> +		return false;
> +
>   	if (!mgd->associated)
>   		return false;
>
> @@ -1489,10 +1492,21 @@ static bool ieee80211_assoc_success(stru
>   	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
>
>   	if ((aid&  (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
> -		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
> -		       "set\n", sdata->name, aid);
> +		printk(KERN_DEBUG
> +		       "%s: invalid AID value 0x%x; bits 15:14 not set\n",
> +		       sdata->name, aid);
>   	aid&= ~(BIT(15) | BIT(14));
>
> +	ifmgd->broken_ap = false;
> +
> +	if (aid == 0 || aid>  IEEE80211_MAX_AID) {
> +		printk(KERN_DEBUG
> +		       "%s: invalid AID value %d (out of range), turn off PS\n",
> +		       sdata->name, aid);
> +		aid = 0;
> +		ifmgd->broken_ap = true;
> +	}
> +
>   	pos = mgmt->u.assoc_resp.variable;
>   	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt),&elems);
>
>
>


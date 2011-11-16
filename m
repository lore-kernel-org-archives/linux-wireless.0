Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1KPViU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 16:38:20 -0500
Subject: Re: [RFC] cfg80211: more correct support of multi-essid bss-es
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com> (sfid-20111116_150041_059201_735F0AD7)
References: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com>
	 (sfid-20111116_150041_059201_735F0AD7)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 22:38:18 +0100
Message-ID: <1321479498.4502.27.camel@jlt3.sipsolutions.net> (sfid-20111116_223824_518972_EEA683C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 15:00 +0100, Dmitry Tarnyagin wrote:
> More correct implementation of the same idea as in the
> "cfg80211: merge in beacon ies of hidden bss" commit.
> 
> The patch implements linked list of aliases for bss (alias is a bss
> with the same key information but with different ESSID).

I think you mean here not "different SSID", but "possibly hidden SSID"?
Otherwise the code doesn't make much sense -- if the SSID is really
incompatible it doesn't seem to get stuffed into the same node?

> Ie update rules when new beacon/proberesp is coming:
>  - Beacon updates target bss and aliases with empty beacon ies list.
>  - Probe response ies updates only target bss structure.
>  - Beacon ies of incoming probe response are filled with
>    beacon ies taken from an alias.

Wow, thanks.

> +++ b/net/wireless/scan.c
> @@ -191,6 +191,8 @@ static void __cfg80211_unlink_bss(struct
> cfg80211_registered_device *dev,
>  				  struct cfg80211_internal_bss *bss)

(rfc patch only but just FYI something caused line-wrapping here)

> @@ -355,8 +357,8 @@ static bool is_mesh(struct cfg80211_bss *a,
>  	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
>  }
> 
> -static int cmp_bss_core(struct cfg80211_bss *a,
> -			struct cfg80211_bss *b)
> +static int cmp_bss_noessid(struct cfg80211_bss *a,
> +			   struct cfg80211_bss *b)

can we call it "ssid", not "essid" please? :)

> +static void
> +cfg80211_bss_update_list(struct cfg80211_registered_device *dev,
> +			 struct cfg80211_internal_bss *prev,
> +			 struct cfg80211_internal_bss *res,
> +			 int force)
> +{
> +	struct cfg80211_internal_bss *bss;
> +
> +	cfg80211_bss_update_bss(dev, prev, res, force);
> +	list_for_each_entry(bss, &prev->list_aliases, list_aliases)
> +		cfg80211_bss_update_bss(dev, bss, res, force);
> +}
> +
> +static void
> +cfg80211_bss_insert(struct cfg80211_registered_device *dev,
> +		    struct cfg80211_internal_bss *alias,
> +		    struct cfg80211_internal_bss *res)
> +{
> +	list_add_tail(&res->list, &dev->bss_list);
> +	if (alias)
> +		list_add_tail(&alias->list_aliases, &res->list_aliases);
> +	rb_insert_bss(dev, res);

Hm the fact that sometimes list_aliases is the anchor and sometimes not
is a bit confusing, but I think I understand it.

Wasn't there a case where an existing BSS entry is replaced by a new
one?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62792 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3CFQRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 11:17:47 -0500
Received: by mail-ob0-f174.google.com with SMTP id 16so3643547obc.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 08:17:46 -0800 (PST)
Message-ID: <51376C28.5030208@lwfinger.net> (sfid-20130306_171754_468345_CBFF802F)
Date: Wed, 06 Mar 2013 10:17:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory leaks in cfg80211 and mac80211
References: <51365EBC.9080602@lwfinger.net>  (sfid-20130305_220821_742055_EAAAA72D) <1362562265.8457.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362562265.8457.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 03:31 AM, Johannes Berg wrote:
> Larry,
>
> Hmm, not sure I understand. What part is kmemleak() having issues with?
> This seems like it would hide genuine issues? This is typically stored
> in a list and/or hash-table, so there should be references? Or does
> kmemleak have issues with pointers to the "middle" of blocks?

As I understand it, a kmemleak scan cannot find pointers to all objects. I don't 
understand the details. My approach is to run a scan, note the possible leaks, 
unload the drivers indicated, and rerun the scan. If that driver freed a block, 
it will disappear from the second scan, thus it is a false positive. It can 
safely be annotated with a kmemleak_no_leak() call. If the block still appears 
in the scan, or new ones appear, those are real leaks.

> Hmm. I looked and found one possible leak, which this should fix:
>
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -723,6 +721,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>
>   			if (found->pub.hidden_beacon_bss &&
>   			    !list_empty(&found->hidden_list)) {
> +				const struct cfg80211_bss_ies *f;
> +
>   				/*
>   				 * The found BSS struct is one of the probe
>   				 * response members of a group, but we're
> @@ -732,6 +732,10 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>   				 * SSID to showing it, which is confusing so
>   				 * drop this information.
>   				 */
> +
> +				f = rcu_access_pointer(tmp->pub.beacon_ies);
> +				kfree_rcu((struct cfg80211_bss_ies *)f,
> +					  rcu_head);
>   				goto drop;
>   			}
>
>
> However, that's a corner case, I don't think you ran into it. Since you
> also didn't note any warnings, we can also discount a few cases that
> would be code bugs and would leak.
>
> I wonder if this is related to the first warning? The "new" object in
> the first block would typically take ownership of the "ies" object.

I did not get any warnings.

I will fix the one false positive that I noted, add the patch for your corner 
case above, and rerun.

Thanks,

Larry




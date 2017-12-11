Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44138 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752790AbdLKLqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:46:13 -0500
Message-ID: <1512992771.26976.73.camel@sipsolutions.net> (sfid-20171211_124617_743418_F4D4C2BE)
Subject: Re: [PATCH v2 1/5] mac80211_hwsim: wait for deferred radio deletion
 on mod unload
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 12:46:11 +0100
In-Reply-To: <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-21 at 13:17 +0100, Benjamin Beichler wrote:
> 
> +	/*wait for radios with deferred delete*/

please add spaces there

> +	spin_lock_bh(&hwsim_delete_lock);
> +	while (!list_empty(&delete_radios)) {
> +		pr_debug("mac80211_hwsim: wait for deferred radio remove\n");
> +		spin_unlock_bh(&hwsim_delete_lock);
> +		flush_work(&list_entry(&delete_radios,
> +				       struct mac80211_hwsim_data, list)
> +			   ->destroy_work);

This can't possibly be right ... you're locking the list_empty which is
a trivial pointer comparison, but not the actual list_entry() ...

I'd also prefer you actually didn't leave the problem in part as you
describe - and a new workqueue probably isn't that much overhead and
should introduce *less* new code than this, so IMHO that's worth it.

johannes

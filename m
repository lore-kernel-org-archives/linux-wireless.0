Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEB1C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D2E2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfDZKOc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:14:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55288 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDZKOc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 06:14:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxsD-0000w4-Va; Fri, 26 Apr 2019 12:14:30 +0200
Message-ID: <cb1c3fcafc7addf0ed8d8d946658801472ad8a1b.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Handle bss expiry during connection
From:   Johannes Berg <johannes@sipsolutions.net>
To:     chaitanya.mgit@gmail.com, linux-wireless@vger.kernel.org
Cc:     Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Date:   Fri, 26 Apr 2019 12:14:29 +0200
In-Reply-To: <20190426095448.3169-1-chaitanya.mgit@gmail.com> (sfid-20190426_115515_498106_D6934494)
References: <20190426095448.3169-1-chaitanya.mgit@gmail.com>
         (sfid-20190426_115515_498106_D6934494)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-26 at 15:24 +0530, chaitanya.mgit@gmail.com wrote:
> From: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
> 
> If the BSS is expired during connection, the connect result will
> trigger a kernel warning. Ideally cfg80211 should hold the BSS
> before the connection is attempted, but as the BSSID is not known
> in case of auth/assoc MLME offload (connect op) it doesn't.
> 
> For those drivers without the connect op cfg80211 holds down the
> reference so it wil not be removed from list.
> 
> Fix this by removing the warning and silently adding the BSS back to
> the bss list which is return by the driver (with proper BSSID set).
> The requirements for drivers are documented in the API's.

This looks good, mostly :-)

>   * @bssid: The BSSID of the AP (may be %NULL)
>   * @bss: Entry of bss to which STA got connected to, can be obtained through
> - *	cfg80211_get_bss() (may be %NULL). Only one parameter among @bssid and
> - *	@bss needs to be specified.
> + *	cfg80211_get_bss() (may be %NULL) but it is recommended to store the
> + *	bss from the connect_request and hold a reference to it and return
> + *	through this param to avoid warning if the bss is expired during the
> + *	connection, esp. for those drivers implementing connect op.
> + *	Only one parameter among @bssid and @bss needs to be specified.

So while we're at it, we should probably amend the documentation to say
that the reference to the BSS passes from the driver to cfg80211, right?

> +	/* bss is not NULL, so even though bss might have expired, the driver
> +	 * is still holding a reference to it.
> +	 */

is -> was? It's our reference now.

>  	if (params->bss) {
> -		/* Make sure the bss entry provided by the driver is valid. */
>  		struct cfg80211_internal_bss *ibss = bss_from_pub(params->bss);
>  
> -		if (WARN_ON(list_empty(&ibss->list))) {
> -			cfg80211_put_bss(wdev->wiphy, params->bss);

That's why we had a put_bss() here.

> +		/* Meanwhile if BSS is expired then add it back to the list as
> +		 * we have just connected with it.
> +		 */
> +		if (list_empty(&ibss->list))
> +			cfg80211_bss_update(rdev, ibss, ibss->pub.signal);

But I think this adds *another* reference, which is wrong? We do need
one reference (the original one the driver gave us) but not a second
one?

Also, not sure the last argument (signal_valid) is right?

Basically all that really just means that cfg80211_bss_update() is
probably not the right function to call. It also updates the timestamp,
which is not true, we haven't received updated information we just used
it and thus held on to it.

I think we should probably just instead of a "cfg80211_bss_relink()"
function exposed, and that just does something like

        list_add_tail(&new->list, &rdev->bss_list);
        rdev->bss_entries++;
        rb_insert_bss(rdev, new);

        rdev->bss_generation++;

though I'm not - off the top of my head - sure about
cfg80211_combine_bsses() being needed or not.

Maybe the copy we do in cfg80211_bss_update() isn't so bad, but then I'd
probably expose it without the signal_valid part and signal/timestamp
updates, and just copy the information raw there? However, the "if
(found)" part should never be possible here, right? Actually, maybe it
is, if we got a *new* entry in the meantime, but then we'd override the
newer information with the older, which is kinda bad?

johannes


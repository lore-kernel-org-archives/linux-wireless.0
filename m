Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907F8C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 13:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB3120874
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 13:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbeLQNlu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 08:41:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:52418 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbeLQNlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 08:41:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gYt9Y-0002bq-D0; Mon, 17 Dec 2018 14:41:48 +0100
Message-ID: <f0b62de5cc2c04099fcf55c299c87541d24226b3.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211: Add Automatic Channel Selection (ACS)
 offload for AP
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ahmad Masri <amasri@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date:   Mon, 17 Dec 2018 14:41:46 +0100
In-Reply-To: <1544968691-20679-2-git-send-email-amasri@codeaurora.org>
References: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
         <1544968691-20679-2-git-send-email-amasri@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Setting aside Kalle's question for a second (though you should address
them, probably before mine!)...


> + * @NL80211_ATTR_CHAN_DEF: attribute for nesting chan_def parameters
> + *	as defined in &enum nl80211_ch_def_attr. The new attribute allows
> + *	userspace to send a list of struct cfg80211_chan_def. For example, ACS
> + *	command uses this attribute for sending a list of channels, for more
> + *	details see &NL80211_CMD_ACS.

I don't think this makes sense. Just have an NL80211_ATTR_CHANNEL_LIST
or so, which is like a NLA_POLICY_NESTED_ARRAY, and then inside we can
reuse the existing top-level attributes for how to define a channel.

That'll save you most of the parsing code too.

>  /**
> + * enum nl80211_acs_status - ACS status
> + *
> + * status to be used to inform userspace about the result of the ACS offloaded
> + * measurement.
> + *
> + * @NL80211_ACS_SUCCESS: The ACS operation finished successfully
> + * @NL80211_ACS_FAILED: Failed to run the ACS. Userspace should choose a channel
> + *	by itself.
> + */
> +enum nl80211_acs_status {
> +	NL80211_ACS_SUCCESS,
> +	NL80211_ACS_FAILED,
> +};

It seems like a "successful" flag attribute would be sufficient.

> +	dev_put(netdev);

> +	dev_hold(dev);

Don't do that. Need to cancel the operation if the netdev is removed
instead.

johannes


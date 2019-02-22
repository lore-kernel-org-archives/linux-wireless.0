Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815FFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B5D82075A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfBVMl3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:41:29 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37908 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVMl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 07:41:29 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxA8r-00030s-4F; Fri, 22 Feb 2019 13:41:25 +0100
Message-ID: <b4a8237564db96d0be471ea93bf32e321adf6d72.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: Include the PMK and PMKID in
 NL80211_CMD_EXTERNAL_AUTH
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Feb 2019 13:41:23 +0100
In-Reply-To: <20190206080234.15750-1-luca@coelho.fi>
References: <ffc4c9e611784b1367e187d092b846381a4cfdc0.camel@sipsolutions.net>
         <20190206080234.15750-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +++ b/net/wireless/nl80211.c
> @@ -13098,6 +13098,12 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
>  	if (!info->attrs[NL80211_ATTR_STATUS_CODE])
>  		return -EINVAL;
>  
> +	if ((info->attrs[NL80211_ATTR_PMK] &&
> +	     !info->attrs[NL80211_ATTR_PMKID]) ||
> +	    (info->attrs[NL80211_ATTR_PMKID] &&
> +	     !info->attrs[NL80211_ATTR_PMK]))
> +		return -EINVAL;

This constitutes a netlink API change, so no, can't be right? PMKID was
perfectly reasonable to pass by itself before.

johannes


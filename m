Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AABC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E8CF2147D
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E8CF2147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbeI0Cjg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:39:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46180 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbeI0Cjg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 22:39:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5GMh-0004CB-2J; Wed, 26 Sep 2018 22:24:55 +0200
Message-ID: <1537993482.28767.34.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: add policy attribute range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 26 Sep 2018 22:24:42 +0200
In-Reply-To: <20180926200630.23399-1-johannes@sipsolutions.net> (sfid-20180926_220654_781731_7A389A4D)
References: <20180926200630.23399-1-johannes@sipsolutions.net>
         (sfid-20180926_220654_781731_7A389A4D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Another thing to note:

Given the union of validation_data pointer and min/max, we'll always get
into this:

> +	/* validate range */
> +	if (pt->min || pt->max) {

if validation_data is set, but of course end up taking the default case,
where nothing further happens:

> +		default:
> +			/* no further validation */
> +			validate = false;
> +			break;
> +		}
> +
> +		if (validate && (value < pt->min || value > pt->max)) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla,
> +					    "integer out of range");
> +			return -ERANGE;
> +		}
> +	}
> +
>  	return 0;

I'm not *entirely* happy with this, but I haven't been able to come up
with a way that doesn't do this, doesn't duplicate the nla types list
(NLA_{U,S}{8,16,32,64}) in the code, and also loads the attribute value
only if validation is needed.

johannes

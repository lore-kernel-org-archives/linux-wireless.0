Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333E8C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 16:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E375920830
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 16:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="g3ZU0pSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbfDJQz0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 12:55:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45161 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733255AbfDJQzZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 12:55:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id e24so1815394pfi.12
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2019 09:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rSwWj7ycbcGs//hS44v0ZM2yVXq+nTOUAj5tJ5Zx4nA=;
        b=g3ZU0pSKlbQM1rCwwQ1/vDwRdhj+GcjrDj/zoXdkRSb4K3lTCqo5xmGFF5RBJhWqd5
         McPwmY4xNWQlsr2M7AxtjfcKcADwfmbEZqGDPpa0kL75C3TwPZ5LBVfuvT4RDUdm6Aes
         J+luEL8/LKnGFipXKmA+iQuwz1/LLr8eV1Vhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSwWj7ycbcGs//hS44v0ZM2yVXq+nTOUAj5tJ5Zx4nA=;
        b=ba1RsfPP1avaOoY7MhtVO6T86L///EegdFoUTwV/8kzSSR4r4JPlV89qLVYZkDIYgL
         54FcFKwB4m409DRViXQJi2UhEL81kOt0+EC6nWb28pAv62tvdSlqSyyBrmhaJWLfqT7i
         C+KweMOXemSF8Cv3SQsOQOkUGgWgW9f+y9xscP2J9bVUCMfMD5F3d9nZvE56oZOK/gD2
         FLXlosCAteh9grWpKeOh1h3e7GRkl54Ju5zHbVbTMuBpwP5+UOknUdi8aVFrWLM/wwmF
         FVrgFAYffZuJgsnrxE72MXvre+tG3kYXOty57pz0H8D4nIVp33SJgwHdoletYzI9mrun
         csYg==
X-Gm-Message-State: APjAAAUnMjXLjVeXUM8/yfGAtyIuMDeohbNR5fGM4nYwMnuhjTjM5SnO
        2AL3Y7AXpQ3eNxYo7OxITYDudA==
X-Google-Smtp-Source: APXvYqxyS3wI3glHCFjMbA/5RcGB8nQUwmepdJcxC2jvBydaz5wowhXoRX6VDXdMcPB5q2ikBovuEg==
X-Received: by 2002:a63:2b4c:: with SMTP id r73mr42812477pgr.181.1554915325057;
        Wed, 10 Apr 2019 09:55:25 -0700 (PDT)
Received: from [10.40.10.244] (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id o5sm113189268pfa.135.2019.04.10.09.55.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 09:55:24 -0700 (PDT)
Subject: Re: [PATCH 2/6] netlink: make validation more configurable for future
 strictness
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Johannes Berg <johannes.berg@intel.com>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
 <20190404065408.5864-3-johannes@sipsolutions.net>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <86911e8d-2818-67f8-058b-ab2f4db33e55@cumulusnetworks.com>
Date:   Wed, 10 Apr 2019 09:55:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190404065408.5864-3-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/3/19 11:54 PM, Johannes Berg wrote:
> @@ -280,6 +287,12 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  		break;
>  
>  	case NLA_UNSPEC:
> +		if (validate & NL_VALIDATE_UNSPEC) {
> +			NL_SET_ERR_MSG_ATTR(extack, nla,
> +					    "Attribute not understood");

I found that confusing when I did a trial run for a new route attribute.
How about "Unsupported attribute"?

> +			return -EINVAL;
> +		}
> +		/* fall through */
>  	case NLA_MIN_LEN:
>  		if (attrlen < pt->len)
>  			goto out_err;

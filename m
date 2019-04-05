Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C350C10F00
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 386B6217D4
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="gQMrPIEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfDEPWw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:22:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40774 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfDEPWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 11:22:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so8498283wre.7
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2019 08:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pjN9pOy8EcCrNT4qsi7YbNbhSh3wYxmas6ORnJXQFvk=;
        b=gQMrPIEO7unqF/BaVq6KNqhM7wCVF+I7lhT9qc8HvwfXQpuLybOhEnDbVKaJYBx1Ij
         H40dEc/rAV1yvsu94wrf1/RSNnIk97aoIGm/apOdQPt5NkyG+VNX+k0Kvb4C/CCFPzNM
         phFMVPmltsOQMZc+x242dZSvR5rgSVDgpJbC9dQ5Hmiry9BaYk7lHdgpha6OawpBFqCS
         ScAOyLu0LwFJyesfs2b4peZ9hLFz3ORHw/GcxQjWOaTJns8Pm0t8B4/rULLk4jm6H+fs
         S3fe5gZiELZ66eOGlC5sEbYnoYTEXLCaT3tXPhvIqYvvunRTp8tehMmOXSCNNpwRoE0Z
         MWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pjN9pOy8EcCrNT4qsi7YbNbhSh3wYxmas6ORnJXQFvk=;
        b=LVWSWjbWZuciK3pTROxxl3StKFmnthmguzAX3AGUdVwENz+smszXYQVYRr2QXjQZ7d
         H5luwySrwg04cga7T5lSU5pxfOFKX1BH1P1TLs+MGkl60QBuKT/TvjDVJ/0ErZcyILIc
         nsKuAah86+SuJOQlSX5zLDtLvG4FcTtwRiZDb4F/2zsDSPPIeWRdza/sQVnHs60j14U4
         0afKoadW/oEK7p9/7HOXeQEagjRm4jmHuUCuYoVGCnoPPC8wqpdK11J17Ahfq4UR49dP
         9Dw7fzD8yDe3LLL5xrENRdVt16oKJcG1dhfCVcgcBqiJoFPzOUhNlPnvey9t593bCz5/
         i6vA==
X-Gm-Message-State: APjAAAXqwhAVgSkhbaW4BOM5WsPWaYymA9YYnE3i/AcajbxJHEkBlxdk
        QXLQGMyACgmF+c7k0b2JbD6xlw==
X-Google-Smtp-Source: APXvYqzG7KbrX8nPAGCGmTHIGJjAFvNMAIeo2MCDZWi/ELRh16kYqaAVX91yR6yRXYCjcUQXgZMaMQ==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr2101154wru.299.1554477770113;
        Fri, 05 Apr 2019 08:22:50 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:e198:c5f6:df71:ff7b? ([2a01:e35:8b63:dc30:e198:c5f6:df71:ff7b])
        by smtp.gmail.com with ESMTPSA id 7sm78081128wrc.81.2019.04.05.08.22.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 08:22:49 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 4/6] netlink: add strict parsing for future attributes
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
 <20190404065408.5864-5-johannes@sipsolutions.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c85732ca-892e-a1f2-0a52-cbf383a47ab5@6wind.com>
Date:   Fri, 5 Apr 2019 17:22:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190404065408.5864-5-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Le 04/04/2019 à 08:54, Johannes Berg a écrit :
[snip]
> As we didn't want to add another argument to all functions that get a
> netlink policy, the workaround is to encode that boundary in the first
> entry of the policy array (which is for type 0 and thus probably not
> really valid anyway). I put it into the validation union for the rare
> possibility that somebody is actually using attribute 0, which would
> continue to work fine unless they tried to use the extended validation,
> which isn't likely. We also didn't find any in-tree users with type 0.
OVS_TUNNEL_KEY_ATTR_ID seems to be one if I'm not wrong.


Regards,
Nicolas

Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D09EC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BB521726
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="iPtKOrGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfDEPkg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:40:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37398 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbfDEPkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 11:40:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id v14so7696696wmf.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2019 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYIFAM4gpOGLMZVKpMAEKa1fT7KJ8i/pO3hsBh9NyyY=;
        b=iPtKOrGme1dHCq3XKkmjUFps5cWD8hH/cJzy2AadOx7Of1tFvOti80dnqmimWpNp/V
         v46YJ8Qeu+2EjAWftERZgCIq1L3DAeiwQRxUpzzWWy993uUnisNDu32NbsaEK1S1o6ls
         LHqpv+9BDI/8ML7zdKU9grkapPpe++SwVL7Msd4fPjbGmqi4/46TqW+q8pElMuRUl24p
         IFAVkMSULi81XLg68WcyoLcQbqQzklKuQEELyOlTpetCoow7LAKirp7A2Q5ozivht1m6
         1P0p1pd5hsQNGV0OP3nKSz3i0rCxG87Ba7VuiXKwycecswgTxhYyNOx85GEL6AKV6q8C
         Jptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HYIFAM4gpOGLMZVKpMAEKa1fT7KJ8i/pO3hsBh9NyyY=;
        b=QJpYZnxySmkFmTV9R6gyqHCMrBvKwc2OvfhNiwyCsZjcM1P3+x+TTI7mJ/fdh1X9Ut
         2JGHs0XlmZadH+XZbr3YSxwauYH8daNuxyyPQwX9UNZwvWnJc0CsmXBgvfmM+iWLjiY+
         wJCj8nepUE++fNInVZYiwxEg7Ed8wvVpSRCk6nNWA/aF8d/niyOvFrlbBU/NeoseIy0/
         r/RYEMMreJVm1SVF2pOsbZJLx+gn/4hJ2iZYf6IzIoXy9dQCqHMHwaHC/M6rRbIzfR+7
         Z7VKHI2pFC/Nl6MyLzwziYYFVtikl5YD4kUbQhApl8w+MmqP7+hus6ejPAH9mQVWoCmr
         FK/Q==
X-Gm-Message-State: APjAAAW/yaztEmTlJpJ1m9222sAF4VevrMvOw9Q7d9PE8nIHK+kfh8MT
        nDK5KhUkbmPX4FapB1Yh1FxIzA==
X-Google-Smtp-Source: APXvYqxKQ0TKTePKQ5w2lOUqX35PmZ9FldlNH0DL+YxEq/gvoCeZu7iHMihvNt8Em4wcBmMIpxZ4pw==
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr7639441wmf.56.1554478833909;
        Fri, 05 Apr 2019 08:40:33 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:e198:c5f6:df71:ff7b? ([2a01:e35:8b63:dc30:e198:c5f6:df71:ff7b])
        by smtp.gmail.com with ESMTPSA id v192sm3214376wme.24.2019.04.05.08.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 08:40:32 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 4/6] netlink: add strict parsing for future attributes
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
 <20190404065408.5864-5-johannes@sipsolutions.net>
 <c85732ca-892e-a1f2-0a52-cbf383a47ab5@6wind.com>
 <aa7040c0cdb233fbb55fbe34673406a0c7356c74.camel@sipsolutions.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ef625946-5874-c029-b6ba-a0cb7f32160d@6wind.com>
Date:   Fri, 5 Apr 2019 17:40:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <aa7040c0cdb233fbb55fbe34673406a0c7356c74.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Le 05/04/2019 à 17:31, Johannes Berg a écrit :
> On Fri, 2019-04-05 at 17:22 +0200, Nicolas Dichtel wrote:
>> Le 04/04/2019 à 08:54, Johannes Berg a écrit :
>> [snip]
>>> As we didn't want to add another argument to all functions that get a
>>> netlink policy, the workaround is to encode that boundary in the first
>>> entry of the policy array (which is for type 0 and thus probably not
>>> really valid anyway). I put it into the validation union for the rare
>>> possibility that somebody is actually using attribute 0, which would
>>> continue to work fine unless they tried to use the extended validation,
>>> which isn't likely. We also didn't find any in-tree users with type 0.
>>
>> OVS_TUNNEL_KEY_ATTR_ID seems to be one if I'm not wrong.
> 
> Indeed, good find.
> 
> I guess I'll change the commit message, but all it really means is that
> OVS can't use any validation function etc. for OVS_TUNNEL_KEY_ATTR_ID,
> which seems like a reasonable trade-off.
Yes I agree.

There is three others 0-attribute, but filled only by the kernel
(NETLINK_DIAG_NONE, PACKET_DIAG_NONE and UNIX_DIAG_NONE).

Nicolas

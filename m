Return-Path: <SRS0=580q=BW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6F9C433E1
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 20:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D756320781
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 20:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHLU1T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLU1T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Aug 2020 16:27:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6A8C061383;
        Wed, 12 Aug 2020 13:27:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A856129399B4;
        Wed, 12 Aug 2020 13:10:33 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:27:17 -0700 (PDT)
Message-Id: <20200812.132717.2156609895191607727.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH] ipv4: tunnel: fix compilation on ARCH=um
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f400c3f1-8bb3-b8bb-a0c0-8cae9e2179a5@gmail.com>
References: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
        <f400c3f1-8bb3-b8bb-a0c0-8cae9e2179a5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 13:10:33 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 12 Aug 2020 13:01:16 -0700

> 
> 
> On 8/12/20 12:08 PM, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>> 
>> With certain configurations, a 64-bit ARCH=um errors
>> out here with an unknown csum_ipv6_magic() function.
>> Include the right header file to always have it.
>> 
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/ipv4/ip_tunnel_core.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
>> index 9ddee2a0c66d..4ecf0232ba2d 100644
>> --- a/net/ipv4/ip_tunnel_core.c
>> +++ b/net/ipv4/ip_tunnel_core.c
>> @@ -37,6 +37,7 @@
>>  #include <net/geneve.h>
>>  #include <net/vxlan.h>
>>  #include <net/erspan.h>
>> +#include <net/ip6_checksum.h>
>>  
>>  const struct ip_tunnel_encap_ops __rcu *
>>  		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
>> 
> 
> Already fixed ?
> 
> commit 8ed54f167abda44da48498876953f5b7843378df
> Author: Stefano Brivio <sbrivio@redhat.com>
> Date:   Wed Aug 5 15:39:31 2020 +0200
> 
>     ip_tunnel_core: Fix build for archs without _HAVE_ARCH_IPV6_CSUM

Indeed, this patch added a dup include, I've reverted it.

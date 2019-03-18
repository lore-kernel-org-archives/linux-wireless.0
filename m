Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E8FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 04:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC0120857
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 04:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LvkHtNSu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LvkHtNSu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfCRE7D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 00:59:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbfCRE7C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 00:59:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF8EA6077A; Mon, 18 Mar 2019 04:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552885141;
        bh=XLbGpVewknCHe69MjgaElQwikk6kEgoM0vtdGHk2XWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LvkHtNSuMrQsAWSZWjfU+CTGcIOE05/o4o/grauti5im88NDHCGr1kmJBxS8ZzWqu
         zNeUxj8Kh/mux5Feg4PUFN3Yf3YQjdTO5alaymBS4o/IDjjVEUUcVms8pPH+pVW67K
         pbq7HiYn/ouJNMirwIPzuAROBF5EJtsh5OxLWwgw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 4D3066074F;
        Mon, 18 Mar 2019 04:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552885141;
        bh=XLbGpVewknCHe69MjgaElQwikk6kEgoM0vtdGHk2XWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LvkHtNSuMrQsAWSZWjfU+CTGcIOE05/o4o/grauti5im88NDHCGr1kmJBxS8ZzWqu
         zNeUxj8Kh/mux5Feg4PUFN3Yf3YQjdTO5alaymBS4o/IDjjVEUUcVms8pPH+pVW67K
         pbq7HiYn/ouJNMirwIPzuAROBF5EJtsh5OxLWwgw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 18 Mar 2019 12:59:01 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] fq: fix fq_tin tx bytes overflow
In-Reply-To: <13392e1203be4ddd97c4e0e6b6a6c48ce97aae6f.camel@sipsolutions.net>
References: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org>
 (sfid-20190313_040846_202389_4E584F4C)
 <13392e1203be4ddd97c4e0e6b6a6c48ce97aae6f.camel@sipsolutions.net>
Message-ID: <fa575f93f3936aa3be1cf6b14f87e511@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-15 17:38, Johannes Berg wrote:
> On Wed, 2019-03-13 at 11:08 +0800, Yibo Zhao wrote:
>> Currently, we are using u32 for tx_bytes in fq_tin.
>> If the throughput stays more than 1.2Gbps, tx_bytes
>> statistics overflow in about 1 min.
>> 
>> In order to allow us to trace the tx_bytes statistics
>> for longer time in high throughput, change its type
>> from u32 to u64.
> 
> Hmm. 64-bit values are kinda expensive on 32-bit architectures. How
> badly do you need this? I mean ... worst case you just have to capture
> every 30 seconds or so if you're doing really high throughput with HE 
> or
> something?
> 
> johannes

Hi Johannes,

I understand your concern. Yes, I am using high end AP for throughput 
test. I'd say 1.2 Gbps is not the worst case since we can achieve max 
1.4Gbps according to our test. AFAIK, for most throughput cases, 1min is 
the minimum requirement. And I think, with more and more high end 
products(even higher throughput) on the ways to the market, it is highly 
possible that 30s is not a safe time before overflow.

-- 
Yibo

Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53D0C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9800A20663
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MxNhC8Yx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9800A20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbeK3CYJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:24:09 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42215 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbeK3CYI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:24:08 -0500
Received: by mail-ot1-f68.google.com with SMTP id v23so2041914otk.9
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2018 07:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TdiQh/B2fjOh0VB1EkQfq6T3ZlnlggVW6+YKlP27q2s=;
        b=MxNhC8YxbP7mq+zZuyHhaZ5zpY7HiOEDqnKOcOVfe8EgEk3U2GZRTTZZohmeQVfpPe
         OqIhXJSSqu4XyBRkQnUFkW463Ns6WWF1SP6sJmP/qKQzNjh838ddxTsUbOktMAdyEh/H
         vC3MNyVNgAzkKSWisR1UM9wuFzb24eUIPMESGgh1w5CEFV8ystmVikOsHuEsrs+6tPMv
         zGbfUfiiegbclVZxuhu1ArKFmlgQF1eLNCqbTkhpRNoPGhwDKa4mXnLJDvlt3pqX2m7m
         d+H9w6sZ9im+30fZHxbEaVe10R0NSW1Q41OitBoGiaNRtjYYC8Vr8DZ/ihj3rnYli+pO
         SvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdiQh/B2fjOh0VB1EkQfq6T3ZlnlggVW6+YKlP27q2s=;
        b=Qr3hKuiSMLC86Xli5Dka7rt8CX2xS/3BqidM7cQeTZxg5DYICx2InDrw0mIP1V4hU4
         tZG1s1EGPfZM5NtgOXB51nQYgwY3u1THbamadvgl54opb0iajuksu8GQAxwGcQ+sG0u5
         EVCe6hH96SFSrHWWMpoOJ7Lyby23AjOYEbKLZY3Rn1OaoxMCLnDK1+Zlv+3ZOk5ymPg1
         fKyi2iaRP9UD1QY8DnZ33A6yt2r0WlRzRKROlUO1VHvSiNH0Me+jyyao1g7yQ+7QtaYH
         ubLnc8ddwOQVfraCT6+kW45sNJWmAomdU0jTUCiT5IqU1tg+cbqzEe4AHIPSTZmWBX2m
         Vb7w==
X-Gm-Message-State: AA+aEWY5r0OI474OTKIDRgE79JVjlHVgMrII0207NI7qEU0+WX3OpqSl
        z1Opk93gskskqqwQlM/aveBVgQ6N
X-Google-Smtp-Source: AFSGD/VMg5himjSnUPB7mlizgGPtB2p6N7HJSRb3p59VoJCIOwTi46yCbRsyVk9+qpAD/axcAE51fQ==
X-Received: by 2002:a9d:1421:: with SMTP id h30mr1077112oth.321.1543504706602;
        Thu, 29 Nov 2018 07:18:26 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id q25sm810832otg.70.2018.11.29.07.18.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 07:18:24 -0800 (PST)
Subject: Re: Fix for memory leak in the wireless extensions layer
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <e0ce06aa-9a9a-d763-4b29-57e976dc1cc4@lwfinger.net>
 <20181129125052.GL3149@kroah.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5ad0bb90-bf87-653d-22de-ae8a2a46fdcd@lwfinger.net>
Date:   Thu, 29 Nov 2018 09:18:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181129125052.GL3149@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/29/18 6:50 AM, Greg Kroah-Hartman wrote:
> On Wed, Oct 31, 2018 at 01:49:21PM -0500, Larry Finger wrote:
>> Greg,
>>
>> Is the fix for a memory leak in the wext compat layer queued for stable? It
>> is in kernel:HEAD as commit 848e616e66d4592fe9afc40743d3504deb7632b4
>> ("cfg80211: fix wext-compat memory leak")
>>
>> I just receiv3ed a complaint about a leak for a system that is running
>> Ubuntu's kernel 4.19.
> 
> That would be very odd as commit
> 848e616e66d4592fe9afc40743d3504deb7632b4 is in 4.19, it was in 4.19-rc7.
> 
>> Unfortunately, this commit has a "fixes" line, but not a Cc for Stable.
> 
> It could have gone into the 4.18-stable tree, but that is now
> end-of-life, sorry.

Too bad, but thanks for the reply.

Larry


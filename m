Return-Path: <SRS0=BaLT=AI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0BBC433E2
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Jun 2020 15:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8385321883
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Jun 2020 15:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="aNmpMkyD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgF0P2N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Jun 2020 11:28:13 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:51244 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgF0P2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jun 2020 11:28:13 -0400
Received: from [192.168.254.4] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 63FC813C2B0;
        Sat, 27 Jun 2020 08:28:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 63FC813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1593271692;
        bh=VIElPMOaz+an56oWfXmIMgNHcT684wvDDGVPb5pBwek=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=aNmpMkyD8WEBke1ruUJbDpl4IdBHK0YCxipoc9ek7MBs4B9YP5vcNsm+sZcKRNb2R
         x0i9X25QGIgpJblixHaThic0C5XH3ZXprr4FLgyzAHfhVlNy3OylaWBQrW/pS95U53
         jMv0+idZ8mUJqql3aJaogDZD/Wo7mWpIdE9mkoEQ=
Subject: Re: [PATCH] ath10k: Add history for tracking certain events
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
References: <1593238973-23237-1-git-send-email-pillair@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <926301ed-e27f-0d8f-0177-6484bfffa40c@candelatech.com>
Date:   Sat, 27 Jun 2020 08:28:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1593238973-23237-1-git-send-email-pillair@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 06/26/2020 11:22 PM, Rakesh Pillai wrote:
> For debugging many issues, a history of the
> below mentioned events can help get an idea
> of what exactly was going on just before any
> issue occurred in the system. These event
> history will be collected only when the host
> driver is run in debug mode (i.e. with the
> config ATH10K_DEBUG enabled).

This should be disabled by default unless user specifically pokes some debugfs
value to turn it on so that it does not impact performance.

Thanks,
Ben

>
> Add history for tracking the below events
> - register read
> - register write
> - IRQ trigger
> - IRQ Enable
> - IRQ Disable
> - NAPI poll
> - CE service
> - WMI cmd
> - WMI event
> - WMI tx completion
>
> This will help in debugging any crash or any
> improper behaviour.


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

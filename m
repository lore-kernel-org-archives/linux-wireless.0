Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD04C433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 07:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF0423CD2
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 07:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="fWDtSl+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgFVHVK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:21:10 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:44489 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726850AbgFVHVJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 03:21:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592810469; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LtqtboOK6ga5wTGMQdEHMkpkXIVVgI9iUpx7mHXJ1oc=;
 b=fWDtSl+LHDoXQhHpkPcEsw29a5Vzgz954HK+kbvqWLOGDGqGeeS7txconAegUfH9IrJYXwKJ
 zXQcg85pWQpdS334k7ujBlsVDIKHNuU0mMWBbr3rVxhyuvQkk4v+Q2msG7f5Fr95JLEwS3/9
 r4g4Fu/GEiOw3myLTWMVmMsN5IQ=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5ef05bd4a6e154319fc41d98 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Jun 2020 07:20:52
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B74C2C433CA; Mon, 22 Jun 2020 07:20:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pradeepc)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77411C433C6;
        Mon, 22 Jun 2020 07:20:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 22 Jun 2020 00:20:51 -0700
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix 6ghz starting frequency
In-Reply-To: <1592807869-781-1-git-send-email-pradeepc@codeaurora.org>
References: <1592807869-781-1-git-send-email-pradeepc@codeaurora.org>
Message-ID: <ef5ead91d87183cdc02e6b5bb717b7ba@codeaurora.org>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-06-21 23:37, Pradeep Kumar Chitrapu wrote:
> Fixes channel to frequency mappings per latest specification
> IEEE P802.11ax/D6.1
> 
> Fixes: d1a1646c ("cfg80211: adapt to new channelization of the 6GHz 
> band")
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> ---
Please ignore this patch..
Just observed similar patch which is already in review
https://patchwork.kernel.org/patch/11615085/

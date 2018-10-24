Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20849C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D88552081B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X6t+N10a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X6t+N10a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D88552081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbeJXRvP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:51:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbeJXRvP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:51:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 927DE60C64; Wed, 24 Oct 2018 09:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540373035;
        bh=+2EJKKePApjYt7bObh0A0tVhLa4nvH8McFGF6v1WJ58=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X6t+N10aAA9GUDMOKaCU0M/nUm/13mAk5KdsCQ/4ok8HdU3XPxHWZyNzRaTAUzJ2m
         YomhmQ9zuxuGCQDN00OuHlTA+44P2QURoFUc+lhwn+LBAvIjrSoO0ZmXKAav/zTtPL
         mnLnxSXtqu7G0aDSHZDAzMytigY+UYBjuYNO357U=
Received: from x230.qca.qualcomm.com (37-33-153-140.bb.dnainternet.fi [37.33.153.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A5362601A0;
        Wed, 24 Oct 2018 09:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540373035;
        bh=+2EJKKePApjYt7bObh0A0tVhLa4nvH8McFGF6v1WJ58=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X6t+N10aAA9GUDMOKaCU0M/nUm/13mAk5KdsCQ/4ok8HdU3XPxHWZyNzRaTAUzJ2m
         YomhmQ9zuxuGCQDN00OuHlTA+44P2QURoFUc+lhwn+LBAvIjrSoO0ZmXKAav/zTtPL
         mnLnxSXtqu7G0aDSHZDAzMytigY+UYBjuYNO357U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A5362601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] wireless: airo: potential buffer overflow in sprintf()
References: <20181024083334.a6pxsifew3iztuun@kili.mountain>
        <87sh0vsox6.fsf@codeaurora.org>
        <20181024090721.uxgwo6h6p3h6u5vp@mwanda>
Date:   Wed, 24 Oct 2018 12:23:51 +0300
In-Reply-To: <20181024090721.uxgwo6h6p3h6u5vp@mwanda> (Dan Carpenter's message
        of "Wed, 24 Oct 2018 12:07:21 +0300")
Message-ID: <87o9bjsno8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Wed, Oct 24, 2018 at 11:56:53AM +0300, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> 
>> > It looks like we wanted to print a maximum of BSSList_rid.ssidLen bytes
>> > of the ssid, but we accidentally use "%*s" (width) instead of "%.*s"
>> > (precision) so if the ssid doesn't have a NUL terminator this could lead
>> > to an overflow.
>> >
>> > Fixes: e174961ca1a0 ("net: convert print_mac to %pM")
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > ---
>> > Static analsysis.  Not tested.
>> 
>> IMHO this part (after "---" line) is important information and should be
>> part of commit log. I can fix that.
>> 
>
> In my experience most maintainers disagree (with varying degrees of
> intensity).

Heh, why would adding four words explaining the background of the patch
to a commit log would be a bad thing? :) Well, I guess I just view
things differently.

-- 
Kalle Valo

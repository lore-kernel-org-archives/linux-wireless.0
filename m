Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F30C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 05:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1DE2146D
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 05:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AIijKgw0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jo9qyeUC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B1DE2146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbeKNP7N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 10:59:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbeKNP7N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 10:59:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0EFD36028D; Wed, 14 Nov 2018 05:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542175048;
        bh=RfzFkm5iQoYwrpP2qeNi7Q2aLnGUYu3TgezVoYB6900=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AIijKgw0Fa2fDr4QBByqdfKO0pT5z/ULkUoHynW+xiyNhSPHWSkw9yebqOLVNow1U
         ebs2OB/qnSnfJHsIX+vJoooA8gJvdbISzcwHwDA0e0nVr5WUbXe/bpSngGfsYc2Q0x
         a6jhNxKKl8OcECfpgMuo9MIlzo1pRfQSsHhwZd3w=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AEA8F6028D;
        Wed, 14 Nov 2018 05:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542175047;
        bh=RfzFkm5iQoYwrpP2qeNi7Q2aLnGUYu3TgezVoYB6900=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jo9qyeUCauDg3XbMaMm3vljDJdInmpeCJPxQv8ih+2MEKxO5ONRgktJ3RDTZRnRH9
         Xg7oUOxB9/A5OfXo1e0+hBaDf7WYOKL4ntkQVInIfo4gaFs2+BtxHXwQ59eZWdSsqk
         GnjNrMjP0o69TNOLQV0E6giuxMf+qxQMI1hHQSTA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 14 Nov 2018 11:27:27 +0530
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] iw: ack signal support for tx ack packets
In-Reply-To: <077070b29fd720cad4b43f33babf7335c5a66818.camel@sipsolutions.net>
References: <1532010590-475-1-git-send-email-bpothuno@codeaurora.org>
 <092e18e05296d9e2e7e8580603ac8b1d@codeaurora.org>
 <077070b29fd720cad4b43f33babf7335c5a66818.camel@sipsolutions.net>
Message-ID: <a46f0593a89aac430ff0083952de0b9e@codeaurora.org>
X-Sender: bpothuno@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

Seems to be v5 patch is applied on "Jul 19 19:59:50 2018" but i couldn't 
get acknowledgement for it.

commit id "d227267148275c63041aca62f4da5d5f07354a82"

kindly ignore my earlier comments.

Regards,
Balaji.

On 2018-11-13 00:32, Johannes Berg wrote:
> On Mon, 2018-11-12 at 21:56 +0530, Balaji Pothunoori wrote:
>> Hi Johannes,
>> 
>> Now that corresponding driver patches are merged, could you please let
>> me know if anything is left from our end for merging this patch?
> 
> Oh, I marked this as "changes requested" since I thought the updates we
> discussed on the kernel side would require changes here (IIRC we talked
> about changing some names?)
> 
> If it applies and compiles as is, I guess best if you just resend, 
> since
> I no longer have it in patchwork and am on vacation this week.
> 
> johannes


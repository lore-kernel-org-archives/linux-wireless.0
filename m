Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32D1C004D2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 22:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9783C206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 22:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fIPPEcI/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fIPPEcI/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9783C206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbeI2FNE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 01:13:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeI2FND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 01:13:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D646960B73; Fri, 28 Sep 2018 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538174827;
        bh=IRC1rFUDG28b7qAj+0ce67tbc8/ZgWt2qigZRwMuQtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fIPPEcI/sF/hYUYgfqsgtcrlhVpvuKT5gEH5/cPFMOxruSgJNhTrQnQ6KWTME3srI
         9ab0bk6NjJ8bAfsenq72xJycnq/NiM+Nl0WhicbZp1jj5m8PSf5RreYFSq/dH4T2LN
         qk4jowzATXpNFpU+bGCBxQWT4AIdLAryWlpaVTAs=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 60423605FD;
        Fri, 28 Sep 2018 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538174827;
        bh=IRC1rFUDG28b7qAj+0ce67tbc8/ZgWt2qigZRwMuQtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fIPPEcI/sF/hYUYgfqsgtcrlhVpvuKT5gEH5/cPFMOxruSgJNhTrQnQ6KWTME3srI
         9ab0bk6NjJ8bAfsenq72xJycnq/NiM+Nl0WhicbZp1jj5m8PSf5RreYFSq/dH4T2LN
         qk4jowzATXpNFpU+bGCBxQWT4AIdLAryWlpaVTAs=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Sep 2018 15:47:07 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <25469b4a-219d-f941-15ad-a1c95308dd69@candelatech.com>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
 <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
 <87lg7lfxtw.fsf@toke.dk> <34bac7851e6c9d3194cef87bd952c388@codeaurora.org>
 <25469b4a-219d-f941-15ad-a1c95308dd69@candelatech.com>
Message-ID: <df1c4f9bde7682646c901305d1c0ab5d@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 12:57, Ben Greear wrote:
> On 09/28/2018 12:47 PM, Rajkumar Manoharan wrote:
>> On 2018-09-28 08:25, Toke Høiland-Jørgensen wrote:
>> 
>>> So this just uses the calculated airtime based on rate and size? 
>>> Wasn't
>>> there supposed to be an airtime usage value reported by the firmware? 
>>> :)
>>> 
>> Firmware interface changes are in progress. Airtime for sta/tid will 
>> be reported via
>> htt tx-compl and rx ind messages. Meantime I thought it would be 
>> useful to use Kan's changes
>> for ATF validation in ath10k using existing firmware. :)
> 
> Maybe you can get the firmware guys to report the tx rate in the 
> tx-completion
> (like I have been doing for years in my ath10k-ct firmware)?  Then let 
> the host
> do the air-time calculating?
> 
> I'll give them firmware patches if the want :)
> 
Ben,

As you know, it needs cleanup in firmware to free up space for new 
interface
changes. Most of time we try to leverage rsvd/unused slots. I am aware 
of that
you did a lot of clean up in CT firmware which is quite hard in official
firmware as it also has to support prop. releases. Kalle can answer much 
better.

-Rajkumar

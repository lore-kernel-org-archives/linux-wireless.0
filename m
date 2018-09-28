Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9347DC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0F22172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nOM3WR7v";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SrDErUCd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E0F22172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbeI1RLE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:11:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbeI1RLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 13:11:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C16AC60B13; Fri, 28 Sep 2018 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538131672;
        bh=WnJSidF+slLqZQUbpB8uDTVTZezQkN9z/ZmLR0l+cww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nOM3WR7vfUGCCKi4QRMUsdAT9BbIKQyHYXLnAq1LPHVrdsFkl2unViFJ/6K7I4/98
         1MwfbpRVocOqGP+D4Eio+LweFLPpC72jMXANrFgJZg8zm0fUv79R2V2rQIPV7lyYpU
         eBiy3Ti2j2JMZWKEtDdlirOCImBKFGI9JnDXRbrw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A49DB6053C;
        Fri, 28 Sep 2018 10:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538131671;
        bh=WnJSidF+slLqZQUbpB8uDTVTZezQkN9z/ZmLR0l+cww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SrDErUCdDQ4/nzGT6W9Kc911PAOP4ix5jGBy2lm+x2B/z+eDg//BHXczcp7NkYwha
         oAentQSdTBWbd3zVcwb2BXR8ZOnhz8VZ1TiwSm+R2EHT1AbiasHB2qKmLGu2woLyIE
         scAeSYSbjvHo0jcroF/+TxlKE99GrqYFJYPSGOFk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 28 Sep 2018 03:47:51 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Jonathan Morton <chromatix99@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
 <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
 <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
Message-ID: <586459da6ec36edc2284df8533915d62@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 03:35, Jonathan Morton wrote:
>> On 28 Sep, 2018, at 1:19 pm, Rajkumar Manoharan 
>> <rmanohar@codeaurora.org> wrote:
>> 
>>> This is going to break fairness; we only want to increase deficits 
>>> when
>>> all stations' deficits are negative. Hence the two loops. Did you see
>>> any problems with those specifically?
>> 
>> No. I didn't see any issue but the loop won't exit until one txq 
>> becomes positive.
>> Till then the lock won't be released. Hence I converged into single 
>> iteration.
> 
> The problem is that the fairness behaviour is changed when there are
> already positive txqs, but the first one happens to not be positive.
> That's why there were two loops.
> 
Yeah.. Understood. we can ignore the cleanup change.

-Rajkumar

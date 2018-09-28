Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A426CC43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59841206B7
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:51:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QkJBStqa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tcu8wYDy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59841206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbeI2CQZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 22:16:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54708 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeI2CQZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 22:16:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9715E601C3; Fri, 28 Sep 2018 19:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538164267;
        bh=n8DmFFFU55DyU9Dl731kF67vvW0FFaWHWDjQiyjxWPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QkJBStqadb1zlVW9w11dAIpx2NqKLTbVLmhXpVmfc9kzlFEEttRW+7OD5aETnynql
         PgEbWBAimXu/ZsatoBndg1se608yEj3fmNBZkcWpPOLfDsp2B7zGXWNJ4Jz4eyI9/t
         Asm3SDRIkYZXVxp1VShC1KfkCEYHslJB4e9E/h4A=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D50FF601C3;
        Fri, 28 Sep 2018 19:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538164266;
        bh=n8DmFFFU55DyU9Dl731kF67vvW0FFaWHWDjQiyjxWPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tcu8wYDye5Z5W+v9e34wIPlVauTg9A3cSQMG5gbZVPBWh1vuAKAaUrEU7N4iwnuk2
         rqfIQcPd3Q4OOm9lYeUrHHGb9/vZ/SnJegZIpkjEN7MNZa+n+G7koFgL1W8J36gft8
         BMyqzL5aAZnaL3a+AQnYn8zUU3I32lJ8pd5V6kVE=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Sep 2018 12:51:06 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
 <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
 <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
 <586459da6ec36edc2284df8533915d62@codeaurora.org>
 <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk>
Message-ID: <34effd2ca6423b33e3871de99022d757@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 04:02, Toke Høiland-Jørgensen wrote:
> On 28 September 2018 12:47:51 CEST, Rajkumar Manoharan
> <rmanohar@codeaurora.org> wrote:
>> On 2018-09-28 03:35, Jonathan Morton wrote:
>>>> On 28 Sep, 2018, at 1:19 pm, Rajkumar Manoharan
>>>> <rmanohar@codeaurora.org> wrote:
>>>> 
>>>>> This is going to break fairness; we only want to increase deficits
>>>>> when
>>>>> all stations' deficits are negative. Hence the two loops. Did you
>> see
>>>>> any problems with those specifically?
>>>> 
>>>> No. I didn't see any issue but the loop won't exit until one txq
>>>> becomes positive.
>>>> Till then the lock won't be released. Hence I converged into single
>>>> iteration.
>>> 
>>> The problem is that the fairness behaviour is changed when there are
>>> already positive txqs, but the first one happens to not be positive.
>>> That's why there were two loops.
>>> 
>> Yeah.. Understood. we can ignore the cleanup change.
> 
> Great! I'll fold in the rest, test it with ath9k and submit as a proper 
> patch :)
> 
Thanks. I am seeing higher CPU load. Did you observe similar behavior 
with ath9k.

-Rajkumar

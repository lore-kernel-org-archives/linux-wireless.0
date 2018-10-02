Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC714C64EBC
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 23:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7488820666
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 23:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CXC6yVIa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CXC6yVIa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7488820666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeJCFxT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 01:53:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeJCFxS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 01:53:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B2ABF60C4D; Tue,  2 Oct 2018 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538521654;
        bh=Og8C5Jt/8kykuMLeSICRinKLaLX2VVpQmt/advZ3dIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXC6yVIaEKSIGY5WWts9f57pTY9c6mZJlqDev/MDQjnwQTx2jkmf2QAZ5atfg4ycj
         5klGJi1HbAoFn1YzcFEJFoairY6b4xlRlgGXBcre4UJiUEgNsF9pyMPQUELt419Gns
         y5VesyOYSRksXxw42Fn7EfFAlI87MVdt8Sfg4QtU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 196A160B0D;
        Tue,  2 Oct 2018 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538521654;
        bh=Og8C5Jt/8kykuMLeSICRinKLaLX2VVpQmt/advZ3dIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXC6yVIaEKSIGY5WWts9f57pTY9c6mZJlqDev/MDQjnwQTx2jkmf2QAZ5atfg4ycj
         5klGJi1HbAoFn1YzcFEJFoairY6b4xlRlgGXBcre4UJiUEgNsF9pyMPQUELt419Gns
         y5VesyOYSRksXxw42Fn7EfFAlI87MVdt8Sfg4QtU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 02 Oct 2018 16:07:34 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <877ej0b2d8.fsf@toke.dk>
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
 <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org> <87a7nwbvwu.fsf@toke.dk>
 <a5a7e11d6913c32385cc74ea3d0e1c76@codeaurora.org> <877ej0b2d8.fsf@toke.dk>
Message-ID: <30cf3754fa970aa1af11791c2625a7c9@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-02 12:00, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>> I noticed a race condition b/w sta cleanup and kick_airtime tasklet.
>>>> How do you plan to exit kick_airtime gracefully during sta_cleanup?
>>> 
>>> Ah, right, there's a lot of stuff going on before we get to 
>>> purge_txq.
>>> Hmm, I guess we should either make sure we remove the station from
>>> active_txqs earlier in the sta cleanup process, or maybe it'd enough 
>>> to
>>> just check the removed flag in the tasklet?
>>> 
>>> Does the below patch fix the issue?
>>> 
>> 
>> No. Attaching backtrace. Any clue?
> 
> Ah, that's my bad. Just having a 'continue' there can make the function
> loop forever. Oops. Try something like this instead?
> 

But 'continue' also used in other places. Will give a try but I think 
that
calling drv_wake_tx_queue within iteration is dangerous as it alters the 
list. no?

-Rajkumar

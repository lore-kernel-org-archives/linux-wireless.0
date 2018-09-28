Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3901C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6DA216FA
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E6DA216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbeI1NkH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:40:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37910 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeI1NkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:40:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5n1z-00082Z-7S; Fri, 28 Sep 2018 09:17:43 +0200
Message-ID: <1538119050.14416.55.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>
Date:   Fri, 28 Sep 2018 09:17:30 +0200
In-Reply-To: <87bm9cyuou.fsf@toke.dk>
References: <20180905113402.7665-1-johannes@sipsolutions.net>
         <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk>
         <1536147683.3528.12.camel@sipsolutions.net>
         <1536147865.3528.14.camel@sipsolutions.net> <87efe8yvju.fsf@toke.dk>
         <1536150812.3528.15.camel@sipsolutions.net> <87bm9cyuou.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-05 at 14:50 +0200, Toke Høiland-Jørgensen wrote:

(uh, sorry, bit late ...)

> > The problem isn't so much how we handle it in mac80211 for the queueing,
> > but how we deal with things like A-MSDU and how we present it to the
> > driver ... for iwlwifi at least we'd really like to have only data
> > frames so we can map it directly to the hardware queue ...
> 
> Ah, I see. No, then just putting them at the head of a different TXQ
> probably won't work...
> 
> Are you mapping TXQs to hardware queues dynamically as they empty and
> re-fill? Presumably you'll have cases where you don't have enough HWQs?

Depends on the hardware. Newer hardware has basically unlimited HWQs
(something on the order of 512 IIRC).

Older hardware sort of maps them dynamically, but not too dynamic, we
also have 32 (ish) queues there. We only free them if we need a new one
and don't have one, and yes, theoretically we can run out and then we
may have to share a single hardware queue for multiple TXQs, but it
basically never happens in practice.

johannes

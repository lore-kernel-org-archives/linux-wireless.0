Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467F5C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 168CD2082B
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:21:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 168CD2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeJ3RNZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 13:13:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53884 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeJ3RNZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 13:13:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHPGi-0007Ct-Pz; Tue, 30 Oct 2018 09:20:56 +0100
Message-ID: <2ba2a4b3f3b83a46c8ec8f6c32a8659181a5370e.camel@sipsolutions.net>
Subject: Re: [PATCH v6 1/2] cfg80211: add peer measurement with FTM
 initiator API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Tue, 30 Oct 2018 09:20:34 +0100
In-Reply-To: <dad6cddb-7ee4-c987-2326-49eba72c193c@codeaurora.org>
References: <20181017123727.12547-1-johannes@sipsolutions.net>
         <dad6cddb-7ee4-c987-2326-49eba72c193c@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> > 
> > + * @ftm.max_bursts_exponent: maximum burst exponent supported
> > + *	(set to 0 if not limited; note that setting this will necessarily
> > + *	forbid using the value 15 to let the responder pick)
> 
> How can driver specify it only supports a single burst? (This is what our
> internal wil6210 implementation currently supports...)

Hah, good catch.

I'll make it unsigned and have -1 the "don't care"... That's annoying
though. Perhaps then we'll have a few drivers that support only 1 if
they should have more (or arbitrary), but that's a better bug ...

johannes


Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F90ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC3642150D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC3642150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbeJQSEa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:04:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:43102 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbeJQSEa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 14:04:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCile-0006eK-0o; Wed, 17 Oct 2018 12:09:30 +0200
Message-ID: <3a09443c022b04bc6534416a7f7e436314de653b.camel@sipsolutions.net>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Wed, 17 Oct 2018 12:09:16 +0200
In-Reply-To: <73dc838a-a703-e587-f1fd-bd492fa900af@codeaurora.org>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
         <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
         <1538942338.2928.21.camel@sipsolutions.net>
         <0c64b665-5dc6-df94-4d49-a3adfc12f745@codeaurora.org>
         <1539252323.3687.207.camel@sipsolutions.net>
         <73dc838a-a703-e587-f1fd-bd492fa900af@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-17 at 13:05 +0300, Lior David wrote:
> 
> On 10/11/2018 1:05 PM, Johannes Berg wrote:
> > 
> > > Thanks for the explanation. The send to same socket does sound more efficient.
> > > (In our internal implementation with vendor commands we were forced
> > > to send the results as broadcast...)
> > 
> > I suppose we can fix that, in the sense that we can add API to allow
> > vendor commands to know the socket to send back to etc.
> > 
> 
> I think that would be useful in general though as far as I know we don't have
> any pending feature that requires it right now.

Ok. For the record, I have no objection to somebody who needs this doing
it, but it's not entirely trivial so I'm not going to just do it now.

johannes


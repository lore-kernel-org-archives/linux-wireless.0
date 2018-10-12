Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C95C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D1D02086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D1D02086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbeJLReW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:34:22 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46700 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbeJLReW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:34:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAuHJ-0000Z5-V1; Fri, 12 Oct 2018 12:02:42 +0200
Message-ID: <1539338549.3141.8.camel@sipsolutions.net>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Fri, 12 Oct 2018 12:02:29 +0200
In-Reply-To: <1538942338.2928.21.camel@sipsolutions.net> (sfid-20181007_215915_302871_10D82211)
References: <20181001133511.25046-1-johannes@sipsolutions.net>
         <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
         <1538942338.2928.21.camel@sipsolutions.net>
         (sfid-20181007_215915_302871_10D82211)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2018-10-07 at 21:58 +0200, Johannes Berg wrote:
> 
> > > + * @partial: indicates that this is a partial result for this type
> > 
> > Is partial set to false for the last result of this measurement type? This may
> > be useful, for example if requesting multiple measurement types, user space can
> > start processing one measurement type before the entire session is completed.
> 
> Yes, that was the intent, e.g. for multiple FTM bursts, but I see how
> this might be misleading at this level. I'll clarify the documentation
> (and probably over in nl80211.h as well)

Actually, I changed my mind - I'll add a "final" bit as well, so
"partial" will be set on all of them.

johannes

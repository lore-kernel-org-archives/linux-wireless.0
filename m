Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3A8C10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270862075B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfDORDR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:03:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42684 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfDORDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 13:03:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hG50k-0001cv-Bv; Mon, 15 Apr 2019 19:03:14 +0200
Message-ID: <dd9897b2800d68e241b63996e964cc94bde0db51.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wireless: Support auth-at-ms timer in sta-info
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 15 Apr 2019 19:03:12 +0200
In-Reply-To: <a8865096-f19e-608f-13c2-08036876d316@candelatech.com>
References: <20190412213710.17292-1-greearb@candelatech.com>
         <cf95c43bcfe1bd4d8fbc8aca8ecc65dac9eeae0c.camel@sipsolutions.net>
         <a8865096-f19e-608f-13c2-08036876d316@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-15 at 09:32 -0700, Ben Greear wrote:
> On 4/15/19 4:15 AM, Johannes Berg wrote:
> > On Fri, 2019-04-12 at 14:37 -0700, greearb@candelatech.com wrote:
> > > From: Ben Greear <greearb@candelatech.com>
> > > 
> > > Report time stamp of when sta became authenticated.
> > 
> > You didn't actually implement this ;-)
> > 
> > Did you mean associated?
> > 
> > > + * @auth_at_ms: time in ms of the last assoc -> auth transition.
> > 
> > There's commonly not really such a transition?
> 
> Oh, I guess AUTHORIZED is only when doing .1x authentication?  My test case
> was (luckly?) doing that, so I didn't notice the bug.

Oh, you meant *authorized*... Most of the code uses "auth" ==
"authenticated" :-)

johannes


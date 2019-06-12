Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF82AC31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 19:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8DDD20B7C
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 19:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFLTLY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jun 2019 15:11:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54882 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfFLTLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jun 2019 15:11:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hb8eW-0006cP-OQ; Wed, 12 Jun 2019 21:11:21 +0200
Message-ID: <292712d7505871a093bd596d2e03ec7d811370f9.camel@sipsolutions.net>
Subject: Re: ROC event when CMD_FRAME duration expires
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 12 Jun 2019 21:11:18 +0200
In-Reply-To: <b2df99eab3cd3c287187dcf91725530dfa000213.camel@linux.intel.com> (sfid-20190611_225154_549360_F87329DC)
References: <b2df99eab3cd3c287187dcf91725530dfa000213.camel@linux.intel.com>
         (sfid-20190611_225154_549360_F87329DC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-06-11 at 13:51 -0700, James Prestwood wrote:
> Hi,
> 
> I see that the event CMD_CANCEL_REMAIN_ON_CHANNEL is emitted when a
> CMD_REMAIN_ON_CHANNEL duration expires, but this is not true for
> CMD_FRAME when sending offchannel and providing a duration. I see
> wpa_supplicant handles this with its own timeout, but couldn't the same
> event be emitted for CMD_FRAME if the duration expires?

I guess? I guess this is for a case where you actually have a wait after
the TX, for waiting for a response?

johannes


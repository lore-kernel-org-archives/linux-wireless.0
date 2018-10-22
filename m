Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA34EC67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 12:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9D3520853
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 12:07:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9D3520853
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbeJVUZj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 16:25:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbeJVUZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 16:25:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gEYzQ-0000zv-8O; Mon, 22 Oct 2018 14:07:20 +0200
Message-ID: <512247ba69be323b6cef3b17ccd6957343acebd1.camel@sipsolutions.net>
Subject: Re: Where to report mpdus tx vs failed?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Mon, 22 Oct 2018 14:07:02 +0200
In-Reply-To: <c46e9b859318574a3b5ce7e1dbdf48404892d101.camel@sipsolutions.net> (sfid-20181022_140655_057336_AC8FE227)
References: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
         <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
         <93888bdc-b27d-78db-7fde-e881fa74c99b@candelatech.com>
         (sfid-20181019_203237_292812_1EFD91C8) <c46e9b859318574a3b5ce7e1dbdf48404892d101.camel@sipsolutions.net>
         (sfid-20181022_140655_057336_AC8FE227)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-22 at 14:06 +0200, Johannes Berg wrote:
> On Fri, 2018-10-19 at 11:32 -0700, Ben Greear wrote:
> > 
> > I was hoping I could fit it into some existing stat.  It is sort of like
> > retries, so that will be my first attempt.
> > 
> > By investigating an RF sniff, I notice the 9880 ath10k (with my fw
> > and driver, at least), will retransmit about 30% of the frames when running
> > at least one of my test cases (small udp frame transmit to AP that can only do about mcs5 or mcs7
> > reliably at 3x3 nss).
> > 
> > I'd like to report this stat in my wifi test tool if nothing else, but
> > likely other people would make use of it as well.
> 
> 
> We have NL80211_STA_INFO_TX_RETRIES, shouldn't you be able to capture it
> there?

Or, per TID, NL80211_TID_STATS_TX_MSDU_RETRIES

johannes


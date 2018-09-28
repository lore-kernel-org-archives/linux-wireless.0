Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936D7C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517C2216FE
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 07:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 517C2216FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbeI1Nnv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:43:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37974 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbeI1Nnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:43:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5n5Z-00088B-TJ; Fri, 28 Sep 2018 09:21:26 +0200
Message-ID: <1538119273.14416.59.camel@sipsolutions.net>
Subject: Re: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Date:   Fri, 28 Sep 2018 09:21:13 +0200
In-Reply-To: <CANGSkXQ3Yo21vf+mqk+CpQ7z7rUtRi__eHoyFtbM3YBARuY8TQ@mail.gmail.com> (sfid-20180922_072928_899822_92639F6C)
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
         <1534246392.3547.26.camel@sipsolutions.net>
         <5B83C2FE.90000@redpinesignals.com>
         <1535527450.5215.8.camel@sipsolutions.net>
         <CANGSkXTnEV7efC8nY9MRK1q2Ky-Ao_6rLoLp75oj4cvCkguZGw@mail.gmail.com>
         <1535970059.3437.39.camel@sipsolutions.net>
         <CANGSkXTPejV11TVpauXn+t6g+rUQ8cYik8KAz7W1P-2Y-8XebA@mail.gmail.com>
         <CANGSkXR11ZxFoiZ7sbKTu8BnXSpTsiAhH=DOD=e9Zh8bquDC0A@mail.gmail.com>
         <1536668735.3224.145.camel@sipsolutions.net>
         <CANGSkXSD4dWKBLROMLT=oqCJLXV7R6HAWw9sfS=d1CBppAQhbw@mail.gmail.com>
         <CANGSkXQ3Yo21vf+mqk+CpQ7z7rUtRi__eHoyFtbM3YBARuY8TQ@mail.gmail.com>
         (sfid-20180922_072928_899822_92639F6C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Actually, we have missed this in code. Our module supports scanning on
> both bands at the same time.

Yeah, but we still have to support drivers that don't support this.

> Thanks for the info.
> And also we ran the scan on our dual band module by setting
> "SINGLE_SCAN_ON_ALL_BANDS" flag in
> driver and removing SCAN_HW_CANCELLED bit in mac80211 stack. We didn't
> see any issues in scan and
> as i mentioned earlier, I didn't observe "scan aborted".
> Can i resubmit patch with these changes?.

Were you able to try my patch instead? I tend to like the structure of
it better - i.e. how we fall back after cleaning up the state, rather
than directly in the middle.

Like I said above, I don't think we should take your patch - you've seen
a bug there, and if we just work around it by making your driver do
both-bands-at-once, we still have the bug...

johannes

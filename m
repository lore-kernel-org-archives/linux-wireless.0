Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8991C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B23A020833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfDIMCY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:02:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48102 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDIMCX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 08:02:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDpSI-0003Io-7s; Tue, 09 Apr 2019 14:02:22 +0200
Message-ID: <1ed09282bb0efb801a29d40eca7a09af077ad1d3.camel@sipsolutions.net>
Subject: Re: [PATCH v3 0/3] wireless: Add support to probe unexercised mesh
 link
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 09 Apr 2019 14:02:21 +0200
In-Reply-To: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
References: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-03 at 12:14 -0700, Rajkumar Manoharan wrote:
> Consider below mesh topology.
> 
>         MP1
>        /    \
>       /      \
>      MP2 --- MP3
> 
> Assume that even though MP1 & MP3 have direct mesh links, the path was
> established via MP2. (MP1 <-> MP2 <-> MP3). The 1-hop mesh link MP1 <-> MP3
> never be excercised till the current path is terminated. As of now, there
> is no option to send data frame to pick other than primary path. So mesh
> link metric between MP1 & MP3 never be updated. This series allows user
> to send data to 1-hop mesh peers through unexercised mesh path.
> 
> -Rajkumar
> 
> v3: Rebased the changes on TOT

Hmm. Please rebase again, and retest, because I just applied this and it
doesn't even compile ...

johannes


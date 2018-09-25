Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFD6C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8263120877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8263120877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbeIYNug (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:50:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45454 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbeIYNuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:50:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g4i14-0002F9-3b; Tue, 25 Sep 2018 09:44:18 +0200
Message-ID: <1537861442.3269.7.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] mac80211_hwsim: radio destruction fixes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Martin Willi <martin@strongswan.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Date:   Tue, 25 Sep 2018 09:44:02 +0200
In-Reply-To: <20180925074115.18169-1-martin@strongswan.org>
References: <20180925074115.18169-1-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-09-25 at 09:41 +0200, Martin Willi wrote:
> This small series fixes two issues for cleaning up hwsim radios. The
> first one is rather easy to hit when terminating namespaces with many
> hwsim radios. The second one affects destroy-on-close users only.
> 
> Given that the use of a work-queue for deferred cleanup with namespaces
> has been and still is tricky to get right, this series switches these
> users to a synchronous cleanup in hwsim;

Cool, thanks. I wasn't really even aware of this, most our usage is with
VMs, not namespaces.

> The removal of that work-queue
> is in a dedicated commit in case we want to skip that in backports.

Yeah, also I'll probably stick that into -next only.

johannes

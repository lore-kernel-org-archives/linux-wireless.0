Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E35FC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE03F2081C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE03F2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbeKFGFp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:05:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59298 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeKFGFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 01:05:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gJljI-0002yX-99; Mon, 05 Nov 2018 21:44:12 +0100
Message-ID: <b833d8c0987e838759dbf00d97d4989a267a10fb.camel@sipsolutions.net>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Date:   Mon, 05 Nov 2018 21:43:48 +0100
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-22 at 23:25 +0530, Tamizh chelvam wrote:
> Add infrastructure for per TID aggregation/retry count configurations
> such as retry count and AMPDU aggregation control(disable/enable).
> In some scenario reducing the number of retry count for a specific data
> traffic can reduce the latency by proceeding with the next packet
> instead of retrying the same packet more time. This will be useful
> where the next packet can resume the operation without an issue.

Not sure I understand this, how can you expect to control something on a
per-packet basis using this?

Sergey, looks like your A-MPDU control is already in here per RA/TID,
and A-MSDU could be added easily?

johannes


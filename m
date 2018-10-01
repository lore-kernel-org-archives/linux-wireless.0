Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16B8C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE732089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EE732089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbeJAQ4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:56:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56974 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbeJAQ4T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:56:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6vIH-0002X4-4N; Mon, 01 Oct 2018 12:19:13 +0200
Message-ID: <1538389142.3126.29.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: Add per peer statistics to compute FCS error
 rate
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Ankita Bajaj <bankita@codeaurora.org>
Date:   Mon, 01 Oct 2018 12:19:02 +0200
In-Reply-To: <1538060517-32208-1-git-send-email-jouni@codeaurora.org>
References: <1538060517-32208-1-git-send-email-jouni@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-27 at 18:01 +0300, Jouni Malinen wrote:
> From: Ankita Bajaj <bankita@codeaurora.org>
> 
> Add support for drivers to report the total number of MPDUs received
> and the number of MPDUs received with an FCS error from a specific
> peer. These counters will be incremented only when the TA of the
> frame matches the MAC address of the peer irrespective of FCS
> error.

Hmm. The error one seems mostly reasonable, I guess, but do we really
not having anything that's the total number of MPDUs already?

And then, I guess, what exactly would you want there? We might not
always even be able to provide that?

I'm also left wondering what the application here is - perhaps another
thing we could just implement in BPF with the hooks I previously posted
(but admittedly never finished)?

johannes

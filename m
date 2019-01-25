Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC287C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B11442146E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfAYMfX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:35:23 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56638 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAYMfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:35:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0ha-0000R6-Bf; Fri, 25 Jan 2019 13:35:18 +0100
Message-ID: <28fbd021a9ffd4065ae76fa26872f3041aa87262.camel@sipsolutions.net>
Subject: Re: [PATCH] iw: Add support for controlling tx power for per station
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Date:   Fri, 25 Jan 2019 13:35:17 +0100
In-Reply-To: <1547731764-14037-1-git-send-email-bpothuno@codeaurora.org>
References: <1547731764-14037-1-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 18:59 +0530, Balaji Pothunoori wrote:
> From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
> 
> This patch allows userspace to set transmit power,
> in mBm units, to a station associated to the AP.
> 
> To set a limit tx power of 2000 mBm:
> iw wlan0 station set <mac-addr> txpwr limit 2000

I would prefer if this was *dBm*, rather than mBm, and be allowed to
take float values, i.e. this would become "limit 20".

johannes


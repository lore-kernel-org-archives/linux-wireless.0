Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC980C10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C1D21473
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfDHMJN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:09:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53746 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHMJN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:09:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDT5L-0005uL-CD; Mon, 08 Apr 2019 14:09:11 +0200
Message-ID: <ad27a4098892dbd2ebd1954ba6f34ae0fea4600c.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Honor SW_CRYPTO_CONTROL in AP VLAN mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, mpubbise@codeaurora.org
Date:   Mon, 08 Apr 2019 14:09:10 +0200
In-Reply-To: <20190209140138.16692-1-alexander@wetzel-home.de>
References: <20190209140138.16692-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-02-09 at 15:01 +0100, Alexander Wetzel wrote:
> Restore @SW_CRYPTO_CONTROL when interface is in AP Vlan mode and don't
> override driver decision for unicast keys.
> 
> Fixes commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto
> controlled devices"), which should only have allow SW crypto fallback for
> group keys.

This confuses me.

The driver doesn't really know about AP_VLAN, so the original commit
intentionally did this, I think?

There was some kind of other fix related to this though?

johannes


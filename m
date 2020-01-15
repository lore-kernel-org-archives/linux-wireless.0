Return-Path: <SRS0=LItA=3E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82B0C33CB1
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 11:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8587124679
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 11:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgAOLaU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jan 2020 06:30:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40624 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbgAOLaU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jan 2020 06:30:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1irgsM-008wxT-L3; Wed, 15 Jan 2020 12:30:18 +0100
Message-ID: <b0978ab700c8b0551c0853763b57a79a1214f77b.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211: use src and dst addr attribute for control
 port tx/rx
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 15 Jan 2020 12:30:17 +0100
In-Reply-To: <20200110145424.4518-2-markus.theil@tu-ilmenau.de>
References: <20200110145424.4518-1-markus.theil@tu-ilmenau.de>
         <20200110145424.4518-2-markus.theil@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Markus,

First, I think you should squash these two patches, there's no point in
adding unused attributes :-)

> The respective arguments are optional on tx and included on rx.
> Therefore unaware existing software is not affected.

This may be true, but doesn't *new* hostapd have to know that this is
supported, or otherwise fall back to sending the frames as data frames?

Seems to me a (driver) capability for this is needed.

johannes


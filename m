Return-Path: <SRS0=HTPg=VH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E5EC73C7C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 09:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7368E2054F
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 09:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfGJJR4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jul 2019 05:17:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36092 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGJJRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jul 2019 05:17:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hl8jF-0002Ji-QK; Wed, 10 Jul 2019 11:17:33 +0200
Message-ID: <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-mmc@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Date:   Wed, 10 Jul 2019 11:17:31 +0200
In-Reply-To: <cover.1562734889.git.joe@perches.com> (sfid-20190710_070546_627944_047EEDD0)
References: <cover.1562734889.git.joe@perches.com>
         (sfid-20190710_070546_627944_047EEDD0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-07-09 at 22:04 -0700, Joe Perches wrote:
> These GENMASK uses are inverted argument order and the
> actual masks produced are incorrect.  Fix them.
> 
> Add checkpatch tests to help avoid more misuses too.
> 
> Joe Perches (12):
>   checkpatch: Add GENMASK tests

IMHO this doesn't make a lot of sense as a checkpatch test - just throw
in a BUILD_BUG_ON()?

johannes


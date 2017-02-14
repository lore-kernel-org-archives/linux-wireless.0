Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdBNIf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 03:35:27 -0500
Message-ID: <1487061321.4705.1.camel@sipsolutions.net> (sfid-20170214_093531_052095_12BA284F)
Subject: Re: [PATCH] iw: Fix bitrate output when no rate info found
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Feb 2017 09:35:21 +0100
In-Reply-To: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com> (sfid-20170214_062128_423199_C6B65399)
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20170214_062128_423199_C6B65399)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 14:21 +0900, Masashi Honma wrote:
> Previously, bitrate showed uninitialized buffer when no rate info
> found.

When would this happen?

I'm not really sure this is right - perhaps we don't have
RATE_INFO_BITRATE(32), but still have the MCS data?

How about we just add "(unknown)" or so and not return here?

johannes

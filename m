Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41208 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753478AbdBHIbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 03:31:25 -0500
Message-ID: <1486542683.4603.10.camel@sipsolutions.net> (sfid-20170208_093157_466416_C7A58831)
Subject: Re: [PATCH v2 2/3] mac80211: Make mesh failure moving average
 configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Wed, 08 Feb 2017 09:31:23 +0100
In-Reply-To: <1485893272-6893-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
         <1485893272-6893-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-31 at 12:07 -0800, Rajkumar Manoharan wrote:
> Currently mesh moving fail average is calculated based on constant
> weight factor. In worst case moving average reaches threshold by
> considering 16 msdu tx ack status and deactivates mesh path. Having
> a constant weight factor might not be suitable for all environments.
> So make it tunable parameter and also lower default weight to 10 so
> that mesh broken link calculation will consider more packet status
> (32 msdus ack status) before dropping mesh path.

I don't think this makes a lot of sense, and with a conversion to the
EWMA helpers it would probably not really be possible anyway.

johannes

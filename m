Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59124 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbdCVWF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 18:05:29 -0400
Message-ID: <1490220325.14145.0.camel@sipsolutions.net> (sfid-20170322_230655_987664_113B929E)
Subject: Re: [PATCH 4.11] genetlink: fix counting regression on
 ctrl_dumpfamily()
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>, netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 22 Mar 2017 23:05:25 +0100
In-Reply-To: <1490195313-13272-1-git-send-email-sgruszka@redhat.com>
References: <1490195313-13272-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-22 at 16:08 +0100, Stanislaw Gruszka wrote:
> Commit 2ae0f17df1cd ("genetlink: use idr to track families") replaced
> 
> 	if (++n < fams_to_skip)
> 		continue;
> into:
> 
> 	if (n++ < fams_to_skip)
> 		continue;

D'oh. I don't know how that ended up in there, tbh.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

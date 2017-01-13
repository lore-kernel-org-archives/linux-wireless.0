Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdAMJNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 04:13:49 -0500
Date: Fri, 13 Jan 2017 10:09:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 6/9] rt2800: fallback from mcs8 to mcs7
Message-ID: <20170113090909.GA4964@redhat.com> (sfid-20170113_101354_667031_582D999E)
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
 <1483707918-31480-7-git-send-email-sgruszka@redhat.com>
 <e3c3f693-3d34-ecfc-de13-855c1d75b849@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e3c3f693-3d34-ecfc-de13-855c1d75b849@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 12:10:48PM +0100, Felix Fietkau wrote:
> On 2017-01-06 14:05, Stanislaw Gruszka wrote:
> > If we do not fallback to lower rate, we are unable to calculate
> > correctly number of retries in TX status code.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> I think falling back from the lowest dual-stream to the highest
> single-stream rate is a really bad idea.

Ok, Kalle please drop this patch.

> Instead you should get rid of the assumption that fallback rates are
> ordered by their MCS index.

I think I will stay with the current code. With decreased retry
limit setting in other patch, problem is mitigated. For newer
chips there is retry count TX_STA_FIFO_EXT register, so I'll look
into that.

Thanks
Stanislaw

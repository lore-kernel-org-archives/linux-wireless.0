Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:29504 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbeDMSGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 14:06:21 -0400
Date: Fri, 13 Apr 2018 11:06:13 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt7601u: run calibration works after finishing
 scanning
Message-ID: <20180413110613.0c13f64f@cakuba.netronome.com> (sfid-20180413_200625_151901_9E1D9901)
In-Reply-To: <1523630678-8100-2-git-send-email-sgruszka@redhat.com>
References: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
        <1523630678-8100-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 13 Apr 2018 16:44:38 +0200, Stanislaw Gruszka wrote:
> When finishing scanning we switch to operational channel sill with
> SCANNING flag. This mean that we never perform calibration works after
> scanning. To fix the problem cancel and queue calibration works on
> .sw_scan_start() and .sw_scan_complete() routines.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

IOW the stack will potentially ask us to return to the original channel
before calling .sw_scan_complete()?  Hm.  That's unpleasant.

I'm not entirely on board with the patch.  Now normal channel setting
will happen while calibration is running.  Is that necessary?  Would it
not be sufficient to make sure work is scheduled
from .sw_scan_complete()?

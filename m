Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751115AbeDNK4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Apr 2018 06:56:09 -0400
Date: Sat, 14 Apr 2018 12:56:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt7601u: run calibration works after finishing
 scanning
Message-ID: <20180414105606.GA9245@redhat.com> (sfid-20180414_125613_630512_F66AF239)
References: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
 <1523630678-8100-2-git-send-email-sgruszka@redhat.com>
 <20180413110613.0c13f64f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180413110613.0c13f64f@cakuba.netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 13, 2018 at 11:06:13AM -0700, Jakub Kicinski wrote:
> On Fri, 13 Apr 2018 16:44:38 +0200, Stanislaw Gruszka wrote:
> > When finishing scanning we switch to operational channel sill with
> > SCANNING flag. This mean that we never perform calibration works after
> > scanning. To fix the problem cancel and queue calibration works on
> > .sw_scan_start() and .sw_scan_complete() routines.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> IOW the stack will potentially ask us to return to the original channel
> before calling .sw_scan_complete()?  Hm.  That's unpleasant.

I think the stack need to assure we start and end scanning on
operational channel, otherwise we would have possibility to be on
undefined channel during normal work.

> I'm not entirely on board with the patch.  Now normal channel setting
> will happen while calibration is running.  Is that necessary? 
> Would it not be sufficient to make sure work is scheduled
> from .sw_scan_complete()?

Yes, that would be sufficient, I'll post v2.

Thanks
Stanislaw

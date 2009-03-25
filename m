Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687AbZCYMcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:32:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 05:32:07 -0700
Date: Wed, 25 Mar 2009 18:01:54 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] mac80211: Fix bug in getting rx status for frames
	pending in reorder buffer
Message-ID: <20090325123154.GA29348@vasanth-laptop> (sfid-20090325_133212_948456_3B57FCAD)
References: <1237982651-6761-1-git-send-email-vasanth@atheros.com> <1237983408.4320.159.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1237983408.4320.159.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 05:46:48PM +0530, Johannes Berg wrote:
> On Wed, 2009-03-25 at 17:34 +0530, Vasanthakumar Thiagarajan wrote:
> > Currently rx status for frames which are completed from reorder buffer
> > is taken from it's cb area which is not always right, cb is not holding
> > the rx status when driver uses mac80211's non-irq rx handler to pass it's
> > received frames. This results in dropping almost all frames from reorder 
> > buffer when security is enabled by doing double decryption (first in hw, 
> > second in sw because of wrong rx status). This patch copies rx status into 
> > cb area before the frame is put into reorder buffer. After this patch, 
> > there is a significant improvement in throughput with ath9k + WPA2(AES).
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> I'll look at putting it there in the drivers right away for .31, this
> should probably get a Cc: stable@kernel.org too.
> 
> johannes
> 

I will resend the patch adding stable in Cc, thanks.

Vasanth

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:51324 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1CUH7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 03:59:49 -0400
Subject: Re: [PATCH] wl12xx: set the actual tid instead of the ac
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTik8DYUn7SuM_L2ciNnuBCK5TobOEcRBPm+gRnyw@mail.gmail.com>
References: <1300309434-15491-1-git-send-email-eliad@wizery.com>
	 <1300340306.11073.5784.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTik8DYUn7SuM_L2ciNnuBCK5TobOEcRBPm+gRnyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 09:59:40 +0200
Message-ID: <1300694381.22224.28.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 09:54 +0200, ext Eliad Peller wrote:
> On Thu, Mar 17, 2011 at 7:38 AM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > On Wed, 2011-03-16 at 23:03 +0200, ext Eliad Peller wrote:
> >> When passing a tx frame, the driver incorrectly set desc->tid
> >> with the ac instead of the actual tid.
> >>
> >> It has some serious implications when using 802.11n + QoS,
> >> as the fw starts a BlockAck with the wrong tid (which finally
> >> cause beacon loss and disconnection / some fw crash)
> >>
> >> Fix it by using the actual tid stored in skb->priority.
> >
> > How will the firmware handle the TIDs larger than 3, as currently to the
> > firmware it appears only TID's 0-3 are configured, and the rest are
> > whatever values happen to be there default?
> >
> that's a good question.
> according to the fw guys, the fw auto-maps the tid to the correct ac.
> the confusing thing is that ACX_TID_CFG actually gets AC as its input
> (in the queue_id param) rather than TID.
> thus, only 0-3 (ACs, not TIDs) are configured.
> 

Yes, so the TID's are most likely not configured in a way that the
firmware will be able to "auto-map". I think the at minimum the
ACX_TID_CFG must be revisited before this change can work.

-Juuso


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57431 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab3CDUoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:44:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so4141959eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 12:44:43 -0800 (PST)
Date: Mon, 4 Mar 2013 21:45:41 +0100
From: john <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
Message-ID: <20130304204541.GA8819@gobelin> (sfid-20130304_214458_251226_41A46791)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
 <1362427924.21028.42.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1362427924.21028.42.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 09:12:04PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > Currently it gets it from the sdata. This uses and updates the ad-hoc
> > masks of the ieee80211_tx_rate_control instead of copying them.
> 
> Is there any need to update them?
> 
> The change for "mask" seems to make it less efficient since it could
> otherwise be put into a register.
> 
Totally, this commit spares the 10bytes copy of mcs_mask but adds a less
efficient indirection to mask.
I thought of it but kept the symmetry with mcs_mask.
Apparently you wouldn't mind the dissymmetry so I will re-send using mask
by value, plus I wrote "updates .." where it is more like "lets the
ad-hoc masks get overwritten".
 
Karl

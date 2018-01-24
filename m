Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46592 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932891AbeAXKq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 05:46:28 -0500
Message-ID: <1516790786.2508.43.camel@sipsolutions.net> (sfid-20180124_114632_526491_E00AB379)
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Wed, 24 Jan 2018 11:46:26 +0100
In-Reply-To: <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
References: <20180124074051.19939-1-johannes@sipsolutions.net>
         <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-24 at 10:39 +0100, Benjamin Beichler wrote:

> sorry for introducing that error, but I'm a bit confused by the
> workqueue documentation.
> My assumption was, that deleting hwsim radios is reclaiming memory, and
> since this queue does nothing else it would save/necessary to set this flag.
> 
> Maybe a hint in the documentation, that a work item on a WQ_MEM_RECLAIM
> queue must not call flush of an !WQ_MEM_RECLAIM queue would be nice.
> Maybe it's kind of obvious, but there is also a reminder not to forget
> that flag, if a queue may have work items that reclaim memory

Yeah, honestly, I'm not really sure either. Clearly we can't set it,
but other drivers also set it...

I don't think it was *intended* for when you're freeing memory, since I
think reclaiming is what happens when you write out dirty buffers to
disk etc.

johannes

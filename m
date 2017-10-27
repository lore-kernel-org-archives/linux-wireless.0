Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60924 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdJ0Npt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:45:49 -0400
Message-ID: <1509111947.2283.0.camel@sipsolutions.net> (sfid-20171027_154623_672002_EBD82B98)
Subject: Re: wil6210: disallow changing RSN in beacon change
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Maya Erez <qca_merez@qca.qualcomm.com>
Date: Fri, 27 Oct 2017 15:45:47 +0200
In-Reply-To: <f48cbfcf31204a839d345927f712227f@euamsexm01a.eu.qualcomm.com>
References: <20171017194253.10212-1-johannes@sipsolutions.net>
         <f48cbfcf31204a839d345927f712227f@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-27 at 15:42 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > This is a code path that will never really get hit anyway, since
> > it's nonsense to change the beacon of an existing BSS to suddenly
> > include or no longer include the RSN IE. Reject this instead of
> > having the dead code, and get rid of accessing wdev->ssid/_len by
> > way of that.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> What's the conclusion, should I take this patch or drop it?

Drop, at least for now. I need to look into this and probably do things
in cfg80211.

johannes

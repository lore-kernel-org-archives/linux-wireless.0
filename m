Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59432 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbeH2BIB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 21:08:01 -0400
Message-ID: <1535490861.20033.8.camel@sipsolutions.net> (sfid-20180828_231435_221776_ED35095A)
Subject: Re: [PATCH] mac80211: do not aggregate frames if max_frags is set
 to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, sara.sharon@intel.com
Date: Tue, 28 Aug 2018 23:14:21 +0200
In-Reply-To: <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com> (sfid-20180828_230714_540221_B42ABCED)
References: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
         <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com>
         (sfid-20180828_230714_540221_B42ABCED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 23:07 +0200, Lorenzo Bianconi wrote:
> Do not try to aggregate packets in a A-MSDU frame if max_tx_fragments
> or max_amsdu_subframes is set to 1. 

Yeah that seems valid.

> Moreover take into account
> tail padding added on the first frame into flow backlog if
> ieee80211_amsdu_realloc_pad routine on the second frame fails.

That's not really right - the padding shouldn't have been added to the
first subframe in the first place as the last one shouldn't have padding
at all. There's also a separate bug in that the A-MSDU subframe length
should NOT include the padding.

My colleague Sara (CC'ed now) has a patch to fix all of this (we just
did that this morning). I'll send it out tomorrow morning. Can I bother
you to try that?

We'd have to fix the first point independently though, or I guess we can
roll that into our bugfix too, which would you prefer?

johannes

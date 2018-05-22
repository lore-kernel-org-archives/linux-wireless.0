Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34004 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbeEVUwP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 16:52:15 -0400
Message-ID: <1527022332.6787.51.camel@sipsolutions.net> (sfid-20180522_225219_156972_8A03D377)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 22:52:12 +0200
In-Reply-To: <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com> (sfid-20180522_224939_826247_CA9579F5)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         <1527019967.6787.45.camel@sipsolutions.net>
         <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
         <1527021608.6787.47.camel@sipsolutions.net>
         <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
         (sfid-20180522_224939_826247_CA9579F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-22 at 15:49 -0500, Denis Kenzior wrote:

> Okay, so we need to use NL80211_BSS_PRESP_DATA if we want to filter out 
> scan results that are coming from beacons, right?

You could do that, yes. In non-hidden cases you get the beacon/probe
response data combined, in hidden cases you may get the beacon data
separately and the (second, third, ...) entry with probe response data
will come with beacon data too.

I'm not really sure what value that would have though. In general, you
might want to not display hidden SSIDs as such or at all in the UI.

> So what's the practical use of the flush flag?  Or is that something 
> that was meant to be 'for-testing-only'?

I think you misunderstand? The value is that it ensures that nothing is
present in the list that was received *before* the scan.

johannes

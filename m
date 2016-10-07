Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33209 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752581AbcJGHrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 03:47:19 -0400
Message-ID: <1475826433.2015.25.camel@sipsolutions.net> (sfid-20161007_094723_395711_164E54AB)
Subject: Re: [PATCH v8] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>,
        "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Fri, 07 Oct 2016 09:47:13 +0200
In-Reply-To: <6c2abcf3f79b4cf6996b69e1a7aa590d@aphydexm01b.ap.qualcomm.com>
References: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1473675843.29016.18.camel@sipsolutions.net>
         <c6f1a958d7f941b5a7dc8564d3f1c371@aphydexm01f.ap.qualcomm.com>
         (sfid-20160916_083438_618523_AC15A50F) <1474981379.5141.37.camel@sipsolutions.net>
         <0b626d7836be4cce8ea4868538fe66d3@aphydexm01f.ap.qualcomm.com>
         <1475061661.4139.40.camel@sipsolutions.net>
         <6c2abcf3f79b4cf6996b69e1a7aa590d@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-07 at 07:42 +0000, Kushwaha, Purushottam wrote:
> > 
> > However, it seems pretty easy to solve by passing another bool that
> > indicates "all the same"?
> Yes . Thanks . 
> We are planning to get the following changes in 2 commits . Let me
> know your consent . 
> 1. cfg80211: Provision to allow the support for different beacon
> intervals. ( Would like to go with this in a separate commit as the
> current infrastructure also does not support the validation of
> radar_detect / num_different_channel ) . 
> 2. cfg80211 : Check radar_detect and num_different_channels with
> beacon interface combinations.
> 
Seems fine, no driver will be able to advertise the different BIs
inbetween the two patches anyway.

I think we might want to add another patch before or inbetween, that
converts the far-too-long argument list of the combination
iter/validation functions to a structure?

johannes

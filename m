Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52190 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934306AbcJXNfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 09:35:42 -0400
Message-ID: <1477316138.4085.19.camel@sipsolutions.net> (sfid-20161024_153545_602852_6B176390)
Subject: Re: [PATCH v3] cfg80211: Check radar_detect and
 num_different_channels with beacon interface combinations.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Mon, 24 Oct 2016 15:35:38 +0200
In-Reply-To: <9a1df5c048894351bbec2d502772b862@aphydexm01f.ap.qualcomm.com>
References: <1476371730-23027-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1477052876.4068.40.camel@sipsolutions.net>
         <9a1df5c048894351bbec2d502772b862@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-24 at 11:59 +0000, Undekari, Sunil Dutt wrote:
> > 
> > I've just sent out a few patches that, I think, implement the
> > necessary validation for just the beacon intervals, without all
> > this extra baggage. Please take a look and let me know what you
> > think.
> I understand that the new patches from you are in consistent with the
> existing design of validating the radar detection / channels by
> having this validation done in the cfg80211 drivers through
> cfg80211_check_combinations.

Ok, so we agree here, that's good :)

> With this approach , wouldn't the existing cfg80211 drivers behave
> the other way ? I mean , with these commits and the current cfg80211
> drivers ( do not advertise beacon_int_min_gcd and invoke
> cfg80211_check_combinations) , the validation for the different
> beacon interval shall succeed , but the current kernel ( cfg80211
> interface ) with the same driver fails the start of the AP / mesh. 
> Is it not breaking the backward compatibility ? Is this expected ? 

Any driver that supports combinations should also invoke
check_combinations. This doesn't appear to be true for mwifiex, but
that's already a bug/problem in that driver, it doesn't really change
much?

johannes

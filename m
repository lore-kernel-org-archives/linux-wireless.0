Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50988 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753819AbdERKkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 06:40:15 -0400
Message-ID: <1495104012.2553.3.camel@sipsolutions.net> (sfid-20170518_124018_755415_EC83D7AC)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Thu, 18 May 2017 12:40:12 +0200
In-Reply-To: <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com> (sfid-20170518_122908_051835_AC8F2BE6)
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
         <1495030794.2442.21.camel@sipsolutions.net>
         <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
         <1495099355.2553.1.camel@sipsolutions.net>
         <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
         (sfid-20170518_122908_051835_AC8F2BE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-18 at 12:29 +0200, Arend Van Spriel wrote:
> On 18-5-2017 11:22, Johannes Berg wrote:
> > On Thu, 2017-05-18 at 10:18 +0200, Arend Van Spriel wrote:
> > > 
> > > > We should therefore probably set the expectation that wpa_s -
> > > > if
> > > > it's new enough - always uses the offloaded functionality and
> > > > always sets the WANT_1X. Then this is even better with such
> > > > drivers, since they can immediately reject the connect()
> > > > command if
> > > > want_1x isn't set.
> 
> Getting back at this. With "always" you mean for every connect()
> regardless whether it is using 1X or PSK?

No, I just meant it would never use the non-offloaded functionality for
1X, as long as wpa_s was new enough to support it.

The same consideration kinda applies to (non-)offloaded 4-way-HS for
PSK though I guess, with some drivers (devices) not able to not offload
it.

> You mean adding a nl80211 command in which user-space can indicate
> what features it supports? Do you want to use the same feature bits
> on both sides to easily determine the combined feature set?
> ext_feature does not really have much overlapping so not sure if it
> adds value.

No, I meant that we have NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X
today, but then we might need also
NL80211_EXT_FEATURE_HOST_4WAY_HANDSHAKE_STA_1X.

Come to think of it though, I guess the fact that the NEW_KEY command
isn't support would already indicate that.

johannes

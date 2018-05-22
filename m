Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51274 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbeEVIVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:21:23 -0400
Message-ID: <1526977281.6787.8.camel@sipsolutions.net> (sfid-20180522_102142_731728_90542AC8)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 10:21:21 +0200
In-Reply-To: <5B03CC75.7060908@broadcom.com> (sfid-20180522_095331_635148_CE4BF2A3)
References: <20180522004602.19370-1-andrew.zaborowski@intel.com>
         <5B03CC75.7060908@broadcom.com> (sfid-20180522_095331_635148_CE4BF2A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-22 at 09:53 +0200, Arend van Spriel wrote:
> On 5/22/2018 2:46 AM, Andrew Zaborowski wrote:
> > Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
> > NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
> > from clients other than the connection owner set in the connect,
> > authenticate or associate commands, if it was set.
> > 
> > The main point of this check is to prevent chaos when two processes
> > try to use nl80211 at the same time, it's not a security measure.
> > The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
> > START_AP/STOP_AP.
> 
> Isn't this V2? What has changed since last time?

It was RFC before I guess.

Doesn't look different to me.

johannes

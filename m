Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32875 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752166AbdLALss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 06:48:48 -0500
Message-ID: <1512128925.4827.49.camel@intel.com> (sfid-20171201_124852_831424_692D904A)
Subject: Re: [PATCH 1/5] mac80211: always update the PM state of a peer on
 MGMT / DATA frames
From: Luciano Coelho <luciano.coelho@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 01 Dec 2017 13:48:45 +0200
In-Reply-To: <1509353300.2637.2.camel@sipsolutions.net>
References: <20171029095111.17078-1-luca@coelho.fi>
         <20171029095111.17078-2-luca@coelho.fi>
         <1509353300.2637.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-30 at 09:48 +0100, Johannes Berg wrote:
> On Sun, 2017-10-29 at 11:51 +0200, Luca Coelho wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > The 2016 version of the spec is more generic about when the
> > AP should update the power management state of the peer:
> > the AP shall update the state based on any management or
> > data frames. This means that even non-bufferable management
> > frames should be looked at to update to maintain the power
> > management state of the peer.
> > 
> > This can avoid problematic cases for example if a station
> > disappears while being asleep and then re-appears. The AP
> > would remember it as in power save, but the Authentication
> > frame couldn't be used to set the peer as awake again.
> > Note that this issues wasn't really critical since at some
> > point (after the association) we would have removed the
> > station and created another one with all the states cleared.
> 
> IIRC this caused a hwsim test failure - is that addressed yet?

FTR, I'm sending a separate patch with the hwsim fix, as we agreed, as
part of the patchset I'm sending today.

--
Luca.

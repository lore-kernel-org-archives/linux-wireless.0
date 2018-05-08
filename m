Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55758 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754856AbeEHMTg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 08:19:36 -0400
Message-ID: <1525781970.14830.11.camel@sipsolutions.net> (sfid-20180508_141950_047472_D01128F6)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 May 2018 14:19:30 +0200
In-Reply-To: <5AF1959E.6020605@broadcom.com> (sfid-20180508_141840_870131_A9A1B28D)
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
         <87in8b8ooy.fsf@purkki.adurom.net>
         <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
         <1525720752.22388.3.camel@sipsolutions.net> <5AF1959E.6020605@broadcom.com>
         (sfid-20180508_141840_870131_A9A1B28D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-08 at 14:18 +0200, Arend van Spriel wrote:
> On 5/7/2018 9:19 PM, Johannes Berg wrote:
> > On Sun, 2018-04-29 at 20:30 +0200, Andrew Zaborowski wrote:
> > > On 28 April 2018 at 15:07, Kalle Valo <kvalo@codeaurora.org> wrote:
> > > > Andrew Zaborowski <andrew.zaborowski@intel.com> writes:
> > > > > Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
> > > > > NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
> > > > > from clients other than the connection owner set in the connect,
> > > > > authenticate or associate commands, if it was set.
> > > > > 
> > > > > The main point of this check is to prevent chaos when two processes
> > > > > try to use nl80211 at the same time, it's not a security measure.
> > > > > The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
> > > > > START_AP/STOP_AP.
> > > > 
> > > > s-o-b missing.
> > > 
> > > True, thanks.  Also I was going to send this as an RFC.
> > > 
> > 
> > Looks fine to me, please resend if you want it in :)
> 
> Do we really want this? Is the referred chaos hypothetical or an actual 
> issue. Nothing stops me from doing an 'ifconfig down' so why should 'iw 
> disconnect' be any different. As far I can tell it does not affect my 
> testing environment, but particularly in such use-cases I can expect 
> issues adopting this change, which is also hypothetical of course ;-)

Yeah, it's a good question. But it might help with inadvertent issues,
like starting wpa_s which immediately disconnects if it finds something
connected. If that fails, perhaps you have a better chance of noticing
the error?

johannes

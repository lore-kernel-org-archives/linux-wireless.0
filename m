Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbeEGTTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 15:19:17 -0400
Message-ID: <1525720752.22388.3.camel@sipsolutions.net> (sfid-20180507_211920_932957_36B0514B)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from
 conn_owner
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 21:19:12 +0200
In-Reply-To: <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com> (sfid-20180429_203012_488292_838F025C)
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
         <87in8b8ooy.fsf@purkki.adurom.net>
         <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
         (sfid-20180429_203012_488292_838F025C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-04-29 at 20:30 +0200, Andrew Zaborowski wrote:
> On 28 April 2018 at 15:07, Kalle Valo <kvalo@codeaurora.org> wrote:
> > Andrew Zaborowski <andrew.zaborowski@intel.com> writes:
> > > Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
> > > NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
> > > from clients other than the connection owner set in the connect,
> > > authenticate or associate commands, if it was set.
> > > 
> > > The main point of this check is to prevent chaos when two processes
> > > try to use nl80211 at the same time, it's not a security measure.
> > > The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
> > > START_AP/STOP_AP.
> > 
> > s-o-b missing.
> 
> True, thanks.  Also I was going to send this as an RFC.
> 
Looks fine to me, please resend if you want it in :)

johannes

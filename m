Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33274 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaBDM1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:27:00 -0500
Received: by mail-bk0-f49.google.com with SMTP id v15so3172007bkz.8
        for <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 04:26:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391509638.26522.72.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	<1391431407.4488.9.camel@jlt4.sipsolutions.net>
	<1391509638.26522.72.camel@porter.coelho.fi>
Date: Tue, 4 Feb 2014 13:26:58 +0100
Message-ID: <CA+BoTQ=xoqfyNurLibYTqptYq88uCT2Sna3dVPQue8Uw-XNWvg@mail.gmail.com> (sfid-20140204_132704_661014_6C2EE428)
Subject: Re: [RFC 0/2] cfg80211: add channel switching awareness
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2014 11:27, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-02-03 at 13:43 +0100, Johannes Berg wrote:
>> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
>> > This makes it possible for more elegant channel
>> > switching behavior by moving the decision up to
>> > cfg80211.
>> >
>> > Until now mac80211 could start channel switching
>> > internally for STA, mesh and IBSS interfaces
>> > without userspace interaction. This bypassed
>> > interface combination checks at the very least.
>> >
>> > Now mac80211 requests cfg80211 to channel switch
>> > an interface, in a similar manner as userspace
>> > asks cfg80211 for a channel switch. This makes it
>> > possible to perform interface combination checks
>> > (albeit it is not implemented yet).
>>
>> Couldn't you just return the decision to mac80211? It would also have to
>> keep track of start/end of the CSA period, I guess, since a few things
>> that Ilan is working on shouldn't be allowed while the AP announces CSA.
>
> mac80211 could keep track of the start/finalize callbacks.  But I don't
> think that's a good idea, as I mentioned in the other email.
>
> I think mac80211 should keep the client CSA control and the userspace
> should control the host interfaces.  cfg80211 should keep track of the
> channel switches and be asked if the switch is okay (so it can take the
> interface combinations and regulatory into consideration).

Why does mac80211 need to keep CSA control? Does it solve anything?


> Maybe mac80211 could call a cfg80211_reserve_channel() function? If that
> call fails, it means the switch cannot be done.  If it succeeds,
> cfg80211 keeps the reservation.  Same thing if the switch is coming from
> userspace, nl80211 could call cfg80211_reserve_channel() in the same
> way.

The problem is you need RTNL for this to make any sense (interface
combinations need it). You can't make a directly callable cfg80211
function available in mac80211 that takes RTNL. It just won't work.
The only way I see it, is you need an asynchronous call with a
callback.


Michał

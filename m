Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36647 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2HZH61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 03:58:27 -0400
Received: by obbuo13 with SMTP id uo13so6629670obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 00:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345800585.4503.8.camel@jlt3.sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	<1345800585.4503.8.camel@jlt3.sipsolutions.net>
Date: Sun, 26 Aug 2012 10:58:26 +0300
Message-ID: <CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com> (sfid-20120826_095830_795795_DEF8FB5B)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 24, 2012 at 12:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-27 at 13:16 +0200, Johannes Berg wrote:
>
>> Comments welcome!
>
> Ilan pointed me to a problem here yesterday.
>
> Say we authenticate, then at that time we'll bind the virtual interface
> into an appropriate channel context. Now we associate, and keep that
> channel context. So far, so good.
>
> Now say we disassociate. At this point, the connection is gone, so we
> remove the channel context.
>
> Now if the supplicant wants to deauthenticate as well, we have no
> channel context to use for it. We could use remain-on-channel? Or we
> could create a new channel context? Or just ignore the deauth? I haven't
> found a good solution yet... We also can't rely on the supplicant always
> doing a deauth, so we don't want to keep the channel context around
> until the deauth either.
>
> Obviously the same can also happen if the supplicant just asks us to
> deauthenticate without ever having connected at all, but that's a rather
> unlikely case.
>
> Anyone have any idea? :)
>
is it really different from the situation today, when we'll try tx on
idle device/interface (afaict)?
this scenario (deauth after disassoc) also sounds pretty unlikely...

Eliad.

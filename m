Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44408 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HZI2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:28:46 -0400
Received: by obbuo13 with SMTP id uo13so6643762obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 01:28:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345968623.3622.3.camel@jlt4.sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	<1345800585.4503.8.camel@jlt3.sipsolutions.net>
	<CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com>
	<1345968623.3622.3.camel@jlt4.sipsolutions.net>
Date: Sun, 26 Aug 2012 11:28:45 +0300
Message-ID: <CAB3XZEfTEz5U0Tu7H-S0ZzDZvUMBdfMgjx6+oS3yF+LaudznjA@mail.gmail.com> (sfid-20120826_102945_122960_3D2A355C)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 26, 2012 at 11:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2012-08-26 at 10:58 +0300, Eliad Peller wrote:
>
>> > Now if the supplicant wants to deauthenticate as well, we have no
>> > channel context to use for it. We could use remain-on-channel? Or we
>> > could create a new channel context? Or just ignore the deauth? I haven't
>> > found a good solution yet... We also can't rely on the supplicant always
>> > doing a deauth, so we don't want to keep the channel context around
>> > until the deauth either.
>> >
>> > Obviously the same can also happen if the supplicant just asks us to
>> > deauthenticate without ever having connected at all, but that's a rather
>> > unlikely case.
>> >
>> > Anyone have any idea? :)
>> >
>> is it really different from the situation today, when we'll try tx on
>> idle device/interface (afaict)?
>
> Well, it is still a bit different, we have no channel at all :)
>
right, but when the device is idle you are not expected to be tuned to
any channel as well, so it's pretty similar :)

>> this scenario (deauth after disassoc) also sounds pretty unlikely...
>
> It seems that it happens when you ask the supplicant to "disconnect" via
> the CLI.
>
at least in my setup issuing a "disconnect" via the CLI ends only with
a deauth (as the respective code in wpa_supplicant/ctrl_iface.c seems
to call only wpa_supplicant_deauthenticate())

Eliad.

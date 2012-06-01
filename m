Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50909 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab2FAIkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 04:40:04 -0400
Received: by obbtb18 with SMTP id tb18so2589065obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 01:40:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338538911.4884.10.camel@jlt3.sipsolutions.net>
References: <1338538443-23172-1-git-send-email-eliad@wizery.com>
	<1338538911.4884.10.camel@jlt3.sipsolutions.net>
Date: Fri, 1 Jun 2012 11:40:03 +0300
Message-ID: <CAB3XZEfTLN65kVDbfL58t7PaAhMGbnN++DgjwbSELg3NmiGqFg@mail.gmail.com> (sfid-20120601_104010_888841_9AD447A7)
Subject: Re: [PATCH] mac80211: clear ifmgd->bssid only after building DELBA
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 1, 2012 at 11:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-01 at 11:14 +0300, Eliad Peller wrote:
>> ieee80211_set_disassoc() clears ifmgd->bssid before
>> building DELBA frames, resulting in frames with invalid
>> bssid ("00:00:00:00:00:00").
>>
>> Fix it by clearing ifmgd->bssid only after building
>> all the needed frames.
>>
>> After this change, we no longer need to save the
>> bssid (before clearing it), so remove the local array.
>
> I'm not convinced clearing the BSSID this late is correct, there's a lot
> of code using it, for example comparing it on RX, that we may not want
> to have it at this point any more.
>
> It may well be that this is no longer a concern, but I wouldn't dismiss
> it right away.
>
i can't really spot any significant difference between these 2 locations.
i only deferred it latter in the same function (after stopping the
queues, setting carrier off, and sending DELBA + deauth). do you see
anything that might go wrong?

Eliad.

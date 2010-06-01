Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47540 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0FAVxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 17:53:34 -0400
Received: by fxm8 with SMTP id 8so1413115fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 14:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275423555.3634.23.camel@jlt3.sipsolutions.net>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	<1274775071.3635.4.camel@jlt3.sipsolutions.net> <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
	<1274860275.3658.0.camel@jlt3.sipsolutions.net> <4C000B68.9000305@gmail.com>
	<1275416907.3778.11.camel@maxim-laptop> <1275419973.3634.7.camel@jlt3.sipsolutions.net>
	<4C056476.9090905@gmail.com> <1275423555.3634.23.camel@jlt3.sipsolutions.net>
From: "Thomas d'Otreppe" <tdotreppe@gmail.com>
Date: Tue, 1 Jun 2010 22:53:12 +0100
Message-ID: <AANLkTikhzl_WSnTxlKmCPY1oP7rXNQCz0zmMg0Fz8ohI@mail.gmail.com>
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Farina <sidhayn@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 1, 2010 at 9:19 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2010-06-01 at 15:50 -0400, Richard Farina wrote:
>
>> > This won't quite work. monitor interfaces are always slaves in the sense
>> > that their channel setting never takes precedence over anything, so if
>> > you add another interface and do something there, the hardware will
>> > happily channel switch away from the monitor channel, but it will still
>> > report the old channel here that you set.
>> >
>> > I have no idea how to _properly_ fix this though, since eventually we'll
>> > have a situation where you can have multiple interfaces active on
>> > different channels, so that monitors don't have a fixed channel anyway.
>> >
>> > Maybe this patch is sufficient since it works in the case people care
>> > about when they _only_ have a monitor interface, but I think it'd be
>> > nicer if it wouldn't report anything in the other cases.
>> >
>> >
>> Is this a NACK or a "I wish there was a better way to do this but I'll
>> allow it until a better way if found"?
>
> I haven't really made up my mind. I really dislike the reporting of
> wrong information though, see my other email.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Reporting wrong information doesn't make sense to me and thus I also
think returning -EINVAL is a good idea in such case.

Thomas (Mister_X)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52195 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1AZWQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 17:16:29 -0500
Received: by qwa26 with SMTP id 26so1448234qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 14:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296079719.3635.47.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-3-git-send-email-arik@wizery.com> <1296077594.3635.40.camel@jlt3.sipsolutions.net>
 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
 <1296078857.3635.41.camel@jlt3.sipsolutions.net> <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
 <1296079719.3635.47.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 27 Jan 2011 00:16:13 +0200
Message-ID: <AANLkTikYu7E3qriJ9ofw0Xfgbvy6goks=gWwcfaegYFV@mail.gmail.com>
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta connection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 00:08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-01-27 at 00:02 +0200, Arik Nemtsov wrote:
>
>> >> 2. The STA transmits something
>> >> 3. The AP FW deauths the STA
>> >> 4. hostapd adds the station, causing mac80211 to call add_sta(), which
>> >> causes the FW to add the sta
>> >>
>> >> Then we have an endless loop of sta add/remove..
>> >
>> > I'd wondered about that race condition before -- maybe hostapd should
>> > add the station before sending the assoc complete. The race also exists
>> > in practice with just mac80211, except it only leads to a dropped frame.
>>
>> Well it can still get dropped here. This just prevents the FW from
>> de-authenticating the STA.
>
> No I mean the incoming frame would be dropped:

In my previous email what I meant was - even with this patch for the
FW (which allows the incoming packet through without the STA getting
de-authed), the incoming frame can still get dropped by mac80211.
The race always exists in mac80211/hostapd.

>
> If we add the station before the response frame's ACK is received, we
> still have the race, and we need to delete if we don't get the ACK. If
> we add the station before we send the assoc response we get rid of this
> race, but also have to delete if we don't get the ACK. I guess that case
> is actually nicer in some way since we would have allowed the station to
> connect, so if spurious data frames go up because we don't get an ACK
> from the station that's no big deal?
>

Maybe there's no need to delete the station even when no ACK is
received? It will get disconnected after the idle timeout anyway. And
it already passed authentication, so its not a DOS attack.
(If that's what you meant as well then I agree)

Arik

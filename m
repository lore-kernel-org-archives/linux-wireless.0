Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40499 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1AZWCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 17:02:53 -0500
Received: by qwa26 with SMTP id 26so1435872qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 14:02:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296078857.3635.41.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-3-git-send-email-arik@wizery.com> <1296077594.3635.40.camel@jlt3.sipsolutions.net>
 <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com> <1296078857.3635.41.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 27 Jan 2011 00:02:37 +0200
Message-ID: <AANLkTikno8Aa3wKy1js62D3FLOZJUxPyuwYsQd+g8JBM@mail.gmail.com>
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta connection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 23:54, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-01-26 at 23:44 +0200, Arik Nemtsov wrote:
>
>> Well no it doesn't do that. But the FW takes some time to know its
>> authenticated.
>> The flow is this:
>>
>> 1. hostapd sends auth complete (the FW doesn't know anything about this)
>
> you mean assoc, right?

Yea you're right. It's getting late I guess :)

>
>> 2. The STA transmits something
>> 3. The AP FW deauths the STA
>> 4. hostapd adds the station, causing mac80211 to call add_sta(), which
>> causes the FW to add the sta
>>
>> Then we have an endless loop of sta add/remove..
>
> I'd wondered about that race condition before -- maybe hostapd should
> add the station before sending the assoc complete. The race also exists
> in practice with just mac80211, except it only leads to a dropped frame.
>

Well it can still get dropped here. This just prevents the FW from
de-authenticating the STA.

Arik

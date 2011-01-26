Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43053 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZVqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:46:23 -0500
Received: by qwa26 with SMTP id 26so1420376qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 13:46:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296077594.3635.40.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-3-git-send-email-arik@wizery.com> <1296077594.3635.40.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 23:44:54 +0200
Message-ID: <AANLkTinwt64DRvMT5E5+o9a4co0LzdxJ+c1c9DUOWOZe@mail.gmail.com>
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta connection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 23:33, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-01-16 at 07:42 +0200, Arik Nemtsov wrote:
>> If a sta starts transmitting immediately after authentication, sometimes
>> the FW deauthenticates it. Fix this by marking the sta "in-connection"
>> in FW before sending the autentication response.
>
> Starts transmitting what? If it starts transmitting data frames, it's
> supposed to be deauthenticated ... it mustn't do that before it has
> associated?!
>

Well no it doesn't do that. But the FW takes some time to know its
authenticated.
The flow is this:

1. hostapd sends auth complete (the FW doesn't know anything about this)
2. The STA transmits something
3. The AP FW deauths the STA
4. hostapd adds the station, causing mac80211 to call add_sta(), which
causes the FW to add the sta

Then we have an endless loop of sta add/remove..

Regards,
Arik

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:33574 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbZGIRxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:53:48 -0400
Received: by qyk31 with SMTP id 31so297449qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 10:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247139797.2144.27.camel@johannes.local>
References: <1247139797.2144.27.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Jul 2009 10:53:27 -0700
Message-ID: <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
Subject: Re: nl80211 and wext interoperability
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 4:43 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Hi!
>
> With the recent work I've done in cfg80211 for nl80211 and wext, we've
> mostly removed wext code everywhere. The only thing missing right now is
> the key support, and I think then we can declare cfg80211's wext compat
> layer pretty much done in terms of what mac80211 had -- orinoco will
> need the sensitivity (or AP density) thing but I'm not sure how we
> should do that since it's a value that is hardware dependent -- we'll
> need to have very good discovery code for the allowed values (unlike
> wext where you can set 0..3 and don't know what that means). Anyway,
> that wasn't the point of this email.
>
> Currently, if you use wpa_supplicant -Dwext and -Dnl80211 mixed,
> -Dnl80211 gets confused because -Dwext will set a 32-byte random SSID to
> "disconnect".

When do we disconnect like this? Upon initialization of wpa_supplicant
-Dwext -Dnl80211 ?

  Luis

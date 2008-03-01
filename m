Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:15005 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYCAS5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 13:57:03 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3973278fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 01 Mar 2008 10:57:01 -0800 (PST)
Message-ID: <f6ca9fed0803011057k5e2999e1vbb8d69a7306d6f29@mail.gmail.com> (sfid-20080301_185712_122698_45B9467E)
Date: Sat, 1 Mar 2008 19:57:01 +0100
From: drago01 <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: always insert key into list
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204396338.3917.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204396338.3917.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 1, 2008 at 7:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Today I hit one of my new WARN_ONs in the mac80211 code because
>  a key wasn't being freed correctly. After wondering for a while
>  I finally tracked it to the fact that STA keys aren't added to
>  the per-sdata key list correctly, they are supposed to always be
>  on that list, not just for default keys. This patch fixes that.

can this be somehow related to the "wep decrypt failed" message that I
get when using dynamic wep?
(I didn't have time to create any additional debug info for it yet ...)

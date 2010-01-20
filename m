Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f201.google.com ([209.85.222.201]:43293 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0ATSN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:13:28 -0500
Received: by pzk39 with SMTP id 39so3847753pzk.15
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 10:13:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263985353.2819.0.camel@johannes.local>
References: <1263985353.2819.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 20 Jan 2010 10:05:58 -0800
Message-ID: <43e72e891001201005p5207345es6eb1a4b196b22a47@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: export multiple MAC addresses in sysfs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 3:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> If a device has multiple MAC addresses, userspace will
> need to know about that. Similarly, if it allows the
> MAC addresses to vary by a bitmask.
>
> If a driver exports multiple addresses, it is assumed
> that it will be able to deal with that many different
> addresses, which need not necessarily match the ones
> programmed into the device; if a mask is set then the
> device should deal addresses within that mask based
> on an arbitrary "base address".
>
> To test it all and show how it is used, add support
> to hwsim even though it can't actually deal with
> addresses different from the default.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Any reason to not export this via nl80211?
Can we say, use this on Atheros devices for storage of the bssid mask?

  Luis

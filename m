Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50381 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HJSUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 14:20:46 -0400
Received: by wyg24 with SMTP id 24so907806wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 11:20:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312983424.4325.0.camel@jlt3.sipsolutions.net>
References: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
	<1312919418-32196-2-git-send-email-thomas@cozybit.com>
	<1312983424.4325.0.camel@jlt3.sipsolutions.net>
Date: Wed, 10 Aug 2011 11:20:45 -0700
Message-ID: <CAG6hwVNgk5EOqXxvFdFGzQUrKhmg0k84xmUjhqsUUZjOJ5L5xQ@mail.gmail.com> (sfid-20110810_202049_470183_2DA0AEE0)
Subject: Re: [PATCH 1/6] mac80211: fix mesh beacon format
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 6:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-08-09 at 12:50 -0700, Thomas Pedersen wrote:
>
>> -             mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
>> +             mgmt->u.beacon.capab_info |= sdata->u.mesh.security
>> +                                          ? WLAN_CAPABILITY_PRIVACY : 0;
>
> This should, I believe, warn if you run with sparse (make C=1
> M=net/mac80211 or your favourite invocation) -- there's an endian error
> here.

OK that's useful, Thanks!
>
> johannes
>
>

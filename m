Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:42304 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0ATSYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:24:11 -0500
Received: by pzk2 with SMTP id 2so2461237pzk.21
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 10:24:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264011628.5591.211.camel@localhost.localdomain>
References: <1264009908-27195-1-git-send-email-lrodriguez@atheros.com>
	<1264011628.5591.211.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 20 Jan 2010 10:23:48 -0800
Message-ID: <43e72e891001201023x175e6abekecee0ffb7b33d933@mail.gmail.com>
Subject: Re: [PATCH] iw: add country IE parsing
To: Marcel Holtmann <marcel@holtmann.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 10:20 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Luis,
>
>> I've considered showing only the channel set from the Country IE
>> but since cfg80211 now mangles contigious channel sets together
>> it seems more useful for iw to just display the individual triplets
>> separately so this patch is left intact. The triplet print is
>> kept since technically speaking this should also show the
>> regulatory extension stuff when one is found.
>
> looks like this with my Apple Airport if anyone cares:
>
>        Country: CA     Environment: Indoor/Outdoor
>        Country IE triplets:
>                Channels [1 - 11]

And like this for stupid APs:

        Country: US     Environment: Indoor/Outdoor
        Country IE triplets:
                Channels [36 - 36]
                Channels [40 - 40]
                Channels [44 - 44]
                Channels [48 - 48]
                Channels [52 - 52]
                Channels [56 - 56]
                Channels [60 - 60]
                Channels [64 - 64]
                Channels [100 - 100]
                Channels [104 - 104]
                Channels [108 - 108]
                Channels [112 - 112]
                Channels [116 - 116]
                Channels [120 - 120]
                Channels [124 - 124]
                Channels [128 - 128]
                Channels [132 - 132]
                Channels [136 - 136]
                Channels [140 - 140]
                Channels [149 - 149]
                Channels [153 - 153]
                Channels [157 - 157]
                Channels [161 - 161]
                Channels [165 - 165]

I noted to Johannes maybe we should add a debug flag for scan and let
the parsers have the option to either output some debug format (as the
one above) or short form, for which the above would just show:

                Channels [36 - 36]
                Channels [100 - 165]

Anyway I am posting this again just because I've already have had a
use for this for a couple of users I help out when debugging country
IE stuff. Figured its better merged than to keep referring to external
patches.

  Luis

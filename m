Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38395 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaDIP3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 11:29:19 -0400
Received: by mail-pa0-f50.google.com with SMTP id kq14so2655523pab.37
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 08:29:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcpRZjQ1DV3Bf7O73fhu0XHYPwPFgWG-F2+=Fs7en58iQ@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel> <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
 <1397047312.4418.68.camel@dubbel> <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com>
 <CAGm1_kvwCoUT+EYTQy8bMda5fjnTz2seD25DP7Q1hfHyXtO5fw@mail.gmail.com> <CA+XVXfcpRZjQ1DV3Bf7O73fhu0XHYPwPFgWG-F2+=Fs7en58iQ@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 9 Apr 2014 17:28:59 +0200
Message-ID: <CAGm1_kuVg=Y1kHB=QMwv7gU42=zL=z3MPQ+Xck=zLV_NysVbXw@mail.gmail.com> (sfid-20140409_172923_226487_AC51F368)
Subject: Re: wl1271: tx stuck in firmware
To: Arik Nemtsov <arik@wizery.com>
Cc: Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 3:25 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Apr 9, 2014 at 4:20 PM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
>> On Wed, Apr 9, 2014 at 3:07 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> Both changes helped a lot. At least one can make a lot of tests
>> without a crash, though I had one
>>
>> # calibrator wlan0 plt tune_channel 0 1
>> # calibrator wlan0 plt tx_tone 1 9000
>> [  180.041505] wlcore: ERROR command complete timeout
>
> It's a FW error.
> Not sure which change you tried, but if it was one of Luca's, I guess
> the FW doesn't like it when you ignore its requests for a dummy
> packet. Did you try my change with just disabling the re-arm?

I have tried both changes. At first disabling the re-arm, it comes
with the same crash as when I implement both changes at once.

Yegor

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33718 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877AbaDJHnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:43:39 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl14so3630085pab.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 00:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGm1_kttUTzc0aw54R=fFd5K1tvGiv_NmRTAVV-z+5gV0ojCCw@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel> <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
 <1397047312.4418.68.camel@dubbel> <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com>
 <CAGm1_kvwCoUT+EYTQy8bMda5fjnTz2seD25DP7Q1hfHyXtO5fw@mail.gmail.com>
 <CA+XVXfcpRZjQ1DV3Bf7O73fhu0XHYPwPFgWG-F2+=Fs7en58iQ@mail.gmail.com>
 <CAGm1_kuVg=Y1kHB=QMwv7gU42=zL=z3MPQ+Xck=zLV_NysVbXw@mail.gmail.com> <CAGm1_kttUTzc0aw54R=fFd5K1tvGiv_NmRTAVV-z+5gV0ojCCw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 10 Apr 2014 10:43:22 +0300
Message-ID: <CA+XVXfdmV_eAhHDEO10zwfg25Ljw=waX-WHKG42o8uMSvNfSFA@mail.gmail.com> (sfid-20140410_094344_063671_01E4226C)
Subject: Re: wl1271: tx stuck in firmware
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 10:21 AM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> On Wed, Apr 9, 2014 at 5:28 PM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
>> On Wed, Apr 9, 2014 at 3:25 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> On Wed, Apr 9, 2014 at 4:20 PM, Yegor Yefremov
>>> <yegorslists@googlemail.com> wrote:
>>>> On Wed, Apr 9, 2014 at 3:07 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>>> Both changes helped a lot. At least one can make a lot of tests
>>>> without a crash, though I had one
>>>>
>>>> # calibrator wlan0 plt tune_channel 0 1
>>>> # calibrator wlan0 plt tx_tone 1 9000
>>>> [  180.041505] wlcore: ERROR command complete timeout
>>>
>>> It's a FW error.
>>> Not sure which change you tried, but if it was one of Luca's, I guess
>>> the FW doesn't like it when you ignore its requests for a dummy
>>> packet. Did you try my change with just disabling the re-arm?
>>
>> I have tried both changes. At first disabling the re-arm, it comes
>> with the same crash as when I implement both changes at once.
>
> What to do with usual fw and scanning?
>
> # [  165.608684] YY: wl1271_scan_complete_work
> [  165.614218] wlcore: Scan completed due to error.

Ah you didn't mention you also had problems with a regular FW. It's
probably either an API sync issue between the FW and driver, or a
platform integration issue where you're sometimes not getting
interrupts.

Arik

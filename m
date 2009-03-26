Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:17966 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbZCZPP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 11:15:27 -0400
Received: by fg-out-1718.google.com with SMTP id 16so941165fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 08:15:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1537876674@web.de>
References: <1537876674@web.de>
Date: Thu, 26 Mar 2009 18:15:24 +0300
Message-ID: <73aaf0dd0903260815i65df5bbav5c8633cab7afe691@mail.gmail.com> (sfid-20090326_161531_858500_4F3B24A8)
Subject: Re: p54spi - mesh mode summary
From: Max Filippov <jcmvbkbc@gmail.com>
To: Chunkeey@web.de
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> 3) Beaconing works, but not the way it should: like MPs don't hear e=
ach other. Timestamps never get in sync
>> and both MPs issue beacon during 0.1s beacon interval.
>> I've seen it before, with stlc45xx. It shows when LMAC is set up wit=
h LMAC_SETUP_IBSS | LMAC_SETUP_TRANSPARENT flags.
>> If there's no LMAC_SETUP_TRANSPARENT flag in LMAC setup then timesta=
mps get in sync.
>
> FYI: The TSF will always reset when a new beacon is submitted to the =
firmware.
> The specs talks about that.

I'd like to make it clear: there are timestamp field in the beacon and
timestamp associated with the received packet. These two do not
correlate. First gets reset at beacon submission (and why firmware
wouldn't pick up timestamp from the submitted beacon?). The second
only gets reset on firmware reset. And it seems to me that there's no
way to find out, what the current value of beacon timestamp is. TSF
reported in p54_rx_data is the second.

And if so, how timestamp syncing is expected to work in the following c=
ase:

<7>[  353.579189] RX beacon SA=3D00:1d:6e:9b:ee:6d
BSSID=3D7e:2e:03:09:31:25 TSF=3D0x4aaa81 BCN=3D0x618f1f6 diff=3D-974047=
89
@1513
<7>[  353.579250] wlan0: beacon TSF higher than local TSF - IBSS merge
with BSSID 7e:2e:03:09:31:25

After which stack submit new beacon which we send to LMAC, effectively
resetting timestamp in our beacon and not affecting TSF that we would
report on the next received frame.

I see constant beacon resubmission cycle. How does it work on pci/usb p=
54?


>> - when LMAC was set up with LMAC_SETUP_TRANSPARENT flag firmware see=
m to truncate last 2 bytes of the packet
>> =A0 that it reports.
> Heh, that's also a ISL3887 (USB 2nd gen) bug... But PCI devices are n=
ot affected.
> The reason "why" has probably to do with the firmware's frame alignme=
nt code.
> Unfortunately the firmware for (ISL3887 and SPI) is rounding "down" t=
o 4 bytes instead of up...
> So the FCS will be clipped... But fortunately the firmware set a bit =
in the header that tells
> us whenever the frames was corrupted or not (P54_HDR_FLAG_DATA_IN_FCS=
_GOOD).
Thank you for the explanation, it made me feel much better (:

> what happens if you change p54spi_rx the following way:?
Actually, I did this kind of thing. And it works this way.
But I considered it a major hack, as noone acknowledged that there's a
firmware problem:

https://garage.maemo.org/pipermail/stlc45xx-devel/2009-January/000126.h=
tml

But if there's real problem in firmware, I'd consider it mere
workaround and put it back.

--=20
Max
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

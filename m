Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57351 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2AIKXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 05:23:22 -0500
Received: by pbdu13 with SMTP id u13so2109721pbd.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 02:23:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0562DF.3000200@dualc.maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
Date: Mon, 9 Jan 2012 11:23:21 +0100
Message-ID: <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com> (sfid-20120109_112326_012446_92E57548)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 5, 2012 at 9:44 AM, Andreas Hartmann
<andihartmann@freenet.de> wrote:
> Helmut Schaa schrieb:
>> Hi,
>>
>> Am Mittwoch, 4. Januar 2012, 09:38:02 schrieb Andreas Hartmann:
>>> Helmut Schaa schrieb:
>>>>> Removing this patch
>>>>>
>>>>> mac80211: retry sending failed BAR frames later instead of tearing down
>>>>> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
>>>>> it working again.
>>>>>
>>>>> Device is: RaLink RT2800 802.11n PCI
>>>>
>>>> What's the client device connected to the rt2x00 AP?
>>>
>>> It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
>>> module.
>>>
>>>> Mind to send a
>>>> 802.11 capture wen this stall happens?
>>
>> Andreas provided me with a capture now. The interesting part is that
>> the rt2x00 AP sends bursts of BARs with the same sequence number when
>> the stall happens. I only had a quick look at the code in question but
>> couldn't see anything wrong at a first glance.
>
>
> Some additional information:
>
> - The AP initiates BARs for 6 different, successive sequence numbers.
> - The first 5 sequence numbers are finished after sending of about 8 (!)
> BAR's.
> Important: each BAR is responded *instantly* by the STA.
> - The BAR for the next sequence number is sent "endless" though the STA
> responses to each BAR instantly again.
>
>
> Another thing: it is striking, that the performance from STA -> AP is at
> max 8,5 MBit/s, whereas the performance from AP -> STA can be 15 MBit/s
> (all measured with netperf).
>
>
> Could it be, that somewhere in the stack of the AP the response packet
> from STA -> AP get's lost or ignored or blocked?

The BlockAck is solely handled in hardware. But I need to check, maybe
the BAR tx status is reported as unacknowledged when the BA contains
a BA bitmap of only zeros ...

Don't know when I can find time to do this but if you like to test something
you could try to add some printks in the rt2x00 tx status path to see if any
BAR frames are reported as acknowledged (and if these have a bitmap != 0).

Helmut

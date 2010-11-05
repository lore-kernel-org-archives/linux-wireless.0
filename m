Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0KENO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 09:14:57 -0400
Received: by vws13 with SMTP id 13so1423855vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 06:14:56 -0700 (PDT)
Message-ID: <4CD4036E.9090300@lwfinger.net>
Date: Fri, 05 Nov 2010 08:15:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Josh Lehan <krellan@krellan.com>
CC: Pavel Machek <pma@sysgo.com>, linux-wireless@vger.kernel.org
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com> <4CD3CDB1.2090508@krellan.com>
In-Reply-To: <4CD3CDB1.2090508@krellan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2010 04:26 AM, Josh Lehan wrote:
> On 11/03/2010 02:24 AM, Pavel Machek wrote:
>> Hi!
>>
>> Is there an USB wifi card that can still be bought in reasonable
>> ammount (like 1000 pieces) and is well supported by Linux?
>>
>> So far I tried carl9170 (as seen by previous mails) and
>> rt2x00usb. carl9170 is not really usable; rt2x00usb works a bit
>> better, but also fails after some time:
> 
> I would like to know as well.  This would be for ARM, though, not
> PowerPC.  It's tough finding reliable USB Wi-Fi adapters that work under
> Linux these days.  It seems the development focus has shifted to
> PCI-based chipsets, unfortunately.
> 
> I've had mixed success with the VIA VT6656.  These drivers are only at
> "staging" quality within the mainline kernel, though.  There are
> separate drivers that can be downloaded directly from the vendor, though.
> 
> Anybody else have a good suggestion?

The Realtek RTL8712 (aka RTL8192U) and found in the D-Link DWA 130, has a driver
in 2.6.37 (r8712u). Although not based on mac80211, thus found in staging, the
driver is extremely stable - my connection never drops out. With an 802.11n
router, I get transmission throughput of up to 70 Mb/s. The D-Link site has
these available for about $55, although I bought mine new on E-bay for a lot
less than that.

Realtek has recently supplied me with a mac80211-based driver for the RTL8192CE,
which has the same wireless chip with a PCIe interface. As soon as I receive my
sample cards, that driver will be submitted to wireless testing, and it will be
the template for conversion of r8712u. As a result, the current staging driver
should be converted into mainline within the next few months.

Larry

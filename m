Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2AWSQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 13:16:02 -0500
Received: by bkas6 with SMTP id s6so2710890bka.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 10:16:01 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Brad Bellomo <bvbellomo@gmail.com>
Subject: Re: frustrated by carl9170
Date: Mon, 23 Jan 2012 19:15:48 +0100
Cc: linux-wireless@vger.kernel.org
References: <CALY7HC+gbzBmYJK3qQ0aMip_z6utA9jq2ZU6LtDrWpUOGn03CQ@mail.gmail.com>
In-Reply-To: <CALY7HC+gbzBmYJK3qQ0aMip_z6utA9jq2ZU6LtDrWpUOGn03CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201231915.48430.chunkeey@googlemail.com> (sfid-20120123_191607_467768_7AC4C1D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Monday, January 23, 2012 05:59:18 PM Brad Bellomo wrote:
> I have a NetGear wireless n draft dongle that uses the carl9170 driver
> on an Arch system.  This module works for anywhere from several
> minutes to several hours.  Then I have lose all ability to use TCP/IP
> over my wireless until I modprobe -r carl9170, modprobe carl9170, and
> reconnect my network.  Although ar9170usb worked fine, I would rather
> troubleshoot this than revert to a deprecated driver, or at worst
> case, buy a better supported device.  I do not see anything relevant
> in my dmesg log.  Does this device log errors somewhere else?  Is
> carl9170 actively being developed?  I don't mind digging into code
> myself, but if no one is working on carl9170, I would rather buy new
> hardware (recommendations appreciated) than spend time fixing
> something with no future.
There's not a lot of debug information in your post. e.g.: what's
the exact hardware? From where is the carl9170 driver coming from,
[kernel-version, or compat-wireless?] what's the firmware version?
Furthermore, a bit of background information about your setup wouldn't
hurt either.
[e.g.: What AP (and firmware)? Do you use HT20/HT40? which frequency band
and encryption setting].

When the device "stops". Do you know if it fails to receive
any data or if it has problems with outgoing traffic? Also what
is wpa_supplicant doing at the time when it fails?

The driver itself exports a debugfs interface under
/sys/kernel/debug/ieee80211/phy$X/carl9170

Of course, you are welcome to debug and run experiments on your own.
If you come across something peculiar (which can be reproduced) then
let me know.

Regards,
	Chr

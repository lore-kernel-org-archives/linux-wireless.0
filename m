Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:38668 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZIYT1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 15:27:37 -0400
Received: by iwn8 with SMTP id 8so1786004iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 12:27:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku> <20090924180251.14503.64152.stgit@tikku>
	<43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
	<da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
	<43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
	<da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 12:27:21 -0700
Message-ID: <43e72e890909251227y1b4286f7gb92e75074af2bc3b@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 12:11 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> On Thu, Sep 24, 2009 at 1:11 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Sep 24, 2009 at 12:10 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>>
>>> BTW, is there an easy way to get the module name for the interface?
>>> That's also helpful information for the user.
>>
>> If you can map the interface to PCI ID then I think its possible,
>> lspci -k seems to do it.
>
> Not all drivers use PCI, we have USB, SDIO, SPI and so on.

Sure, it was just an example of a transport where this does exist, I
am hoping this doesn't use PCI specific stuff and based on a simple
strace of "strace -o foo lspci -k -s 03:00.0"  I see it actually ends
up reading a  /lib/modules/ file and am hoping this is what it uses to
do the mapping. But you still first need the bus ID for the netdevice,
not sure how to best to do that. I do see the sysfs ieee80211 class
maps the phy%d to the bus:

mcgrof@tux ~ $ ls -ld /sys/class/ieee80211/phy0/device
lrwxrwxrwx 1 root root 0 2009-09-25 12:25
/sys/class/ieee80211/phy0/device -> ../../../0000:03:00.0

If you can extract the bus from here and then the device:vendor id I
think you can read the /lib/modules/ map file for the driver.

Check these files out:

ls /lib/modules/2.6.31-wl/modules.*map

  Luis

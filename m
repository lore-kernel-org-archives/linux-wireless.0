Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36698 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcFZXjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 19:39:05 -0400
Received: by mail-wm0-f47.google.com with SMTP id f126so80101506wma.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2016 16:39:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1973511.3caevZ3pSB@debian64>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <2421107.Vh3zsAgVDf@debian64> <CAFBinCBtjv4XoUyO6007hs0Aiut-mFxeq9jdEBq9d22dqzTvLw@mail.gmail.com>
 <1973511.3caevZ3pSB@debian64>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 27 Jun 2016 01:38:43 +0200
Message-ID: <CAFBinCAh+mdG3Lh6+aS2oAZXxhuapSf34eDfxgUjmCSvWeg-fw@mail.gmail.com> (sfid-20160627_013910_079685_8AE74E17)
Subject: Re: [PATCH RFC v3 3/3] ath9k: parse the device configuration from an
 OF node
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: lede-dev@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, mark.rutland@arm.com,
	robh+dt@kernel.org, arend.vanspriel@broadcom.com,
	Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 25, 2016 at 9:26 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> The problem with the owl-loader is/was that it sticks around
> when it has initialized all the cards. Unloading a module by
> itself is tough. One way out would be to add it to ath9k's pci.c.
> The question is: will such a feature have support from the ath9k
> folks?
owl-loader seems very small (<7KiB) and it only allocates a few bytes
dynamically. Even if you move this code to ath9k you will still have
the same problem: as long as ath9k is not unloaded this code will hang
around in memory.
But apart from this - moving it to the kernel might have some benefits
though as it could be shared between ath9k and ath5k (as some ath5k
seem to require a similar "fixup" as well).

> I've added lede-dev and Luis since this is relevant for them.
> Maybe between the sysloadfw.sh and owl-loader, there's another
> solution we overlooked so far? I know Luis has been digging
> around in the firmware_class and added the sysdata API. But
> from what I can tell, this would ?break? LEDE/OpenWRT's
> userspace helper, since the sysfs interface in
> /sys/class/firmware which is used by procd to upload the data
> is gone with sysdata or am I wrong?
good idea to keep lede-dev in the loop, as they will be affected (in
my opinion: positively) by this change.


Regards,
Martin

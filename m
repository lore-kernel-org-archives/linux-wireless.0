Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56351 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0IIFyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:54:19 -0400
Received: by qyk36 with SMTP id 36so5623266qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:54:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimrfBjaQH3gQKJjiir24cKFoj_0rrFHdNSvbuv7@mail.gmail.com>
References: <1283988519-44671-1-git-send-email-steve@cozybit.com>
	<AANLkTimrfBjaQH3gQKJjiir24cKFoj_0rrFHdNSvbuv7@mail.gmail.com>
Date: Wed, 8 Sep 2010 22:54:18 -0700
Message-ID: <AANLkTimsdpMU-7mexyZhQ0TXQUABmgatb3TYCTNG6zTu@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf_usb: fix libertas_tf_usb to match structural
 changes in libertas_tf
From: Steve deRosier <steve@cozybit.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 8, 2010 at 7:29 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Thu, Sep 9, 2010 at 09:28, Steve deRosier <steve@cozybit.com> wrote:
>> The development of the libertas_tf_sdio driver introduced structural
>> changes in libertas_tf.  Most notably, firmware loading and starting
>> was needed in the probe stage due to the requirement that mac80211
>> have the MAC address set before the starting of mac80211 in add_card.
>> This patch fixes libertas_tf_usb to match these structural changes
>> as needed.
>>
>> Signed-off-by: Steve deRosier <steve@cozybit.com>
>
> I'm not sure if the usb part of this driver is still functional, but
> even if it isn't, it may be nicer (bisectability, etc.) to re-order
> your patches like so:
> 1. Make the structural changes (and clean ups) in the base code and usb driver
> 2. Introduce the sdio driver in a single patch, taking advantage of
> these changes.
>
> It will also mean that the sdio driver will be introduced to the
> kernel in a working state, rather than introduced in a partially
> working state, then fixed over several commits.
>

Well, it would be nice.  I agree 100%.  If I could have foreseen the
changes to main code and the USB driver, perhaps I could've coded it
this way.  I started out with trying not to make any changes to the
main code at all if possible while adding the sdio driver.
Unfortunately, it didn't work out that way.  My job was to make
libertas_tf work with the 8686 on an sdio bus.  Changes to the usb
driver only happened because I had to break it in order to make my
sdio driver function.  Hence, the USB changes are last.  I could have
left it in a non-functional state, but I don't work that way.

BTW, as far as I know, before I started, libertas_tf_usb was
functional and worked on the XO-1s that I tested on.  After my changes
here, libertas_tf_usb did work on an XO-1.5 with a 8388 usb with
thin-firmware.  So, libertas_tf_usb is still functional and ready to
be used.  Does anything other than the XO-1s use it, I have no idea.

Thanks,
- Steve



> Thanks,
>
> --
>
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
>

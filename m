Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0I0Xju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:39:50 -0400
Received: by mail-fx0-f46.google.com with SMTP id 3so2287943fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 16:39:50 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: A few questions about modifications in carl9170
Date: Tue, 28 Sep 2010 01:39:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <20100927132957.GA2977@qubit.lri.fr> <20100927230137.GA5702@qubit.lri.fr> <20100927232357.GA5869@qubit.lri.fr>
In-Reply-To: <20100927232357.GA5869@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009280139.43745.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 September 2010 01:23:57 Ignacy Gawedzki wrote:
> And while writing that email, I left the card plugged in the USB socket.  In
> the meantime, I got the following:
> 
>   usb 5-1: no command feedback received (-110).
>   carl9170 cmd: 08 01 00 00 04 40 1d 00 00 00 00 00              .....@......
>   usb 5-1: restart device (6)
>   ieee80211 phy1: writing reg 0x1d4004 (val 0x0) failed (-110)
>   usb 5-1: device restarted successfully.
> 
> Then when I unplugged it:
> 
>   usb 5-1: USB disconnect, address 11
> 
> And finally upon modprobe -r carl9170:
> 
>   usbcore: deregistering interface driver carl9170
> 
> And now modprobe is stuck in D+. :/

yup, this should be fixed by "[PATCH] carl9170: fix hung workqueue".
 
> I now wonder how that could possibly be due to my modifications in the driver
> and mac80211 (in a nutshell: retrieve the measurement per frame from the FW
> and collect it into a stats structure in the sta descriptor, which is later
> retrieved from userspace through netlink).  I'll try without these and report
> back if that still happens.
hm, you could also add a "custom" RADIO_TAP field. This way you could use
wireshark to monitor the round trip times for each individual frame
(this way you could also export the frames' duration + tx vectors too)

Regards,
	Christian

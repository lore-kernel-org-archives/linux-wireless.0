Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49373 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0IFIAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 04:00:07 -0400
Received: by qyk33 with SMTP id 33so4046320qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 01:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100906T041329-313@post.gmane.org>
References: <loom.20100906T041329-313@post.gmane.org>
Date: Mon, 6 Sep 2010 10:00:06 +0200
Message-ID: <AANLkTi=5P8N6QDDZkVuFwCMDzBTLsCkiOem0_WwL-hvS@mail.gmail.com>
Subject: Re: rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed
 out, invoke forced tx handler
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Michael <msbroadf@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 6, 2010 at 4:17 AM, Michael <msbroadf@gmail.com> wrote:
> Im trying the latest compat-wireless 2010-09-05 and i am using a RALINK3027
> 802.11N wireless USB dongle.
>
> I setup the wifi using hostapd in monitor and managed mode for this adapter, and
> it sets up an AP ok, but i notice the following message quite frequently.
>
> phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out,
> invoke forced tx handler
>
> appears very often and greatly interferes with the TX packets and makes the link
> unusable.
>
> Could someone tell me if this is being worked on, or if I can help somehow fix
> it.  Im am a software engineer but don't have much kernel level experience.

It is being worked on, but it cannot be fully resolved. It is
currently simply a fact
that the DMA can lockup in the device even the official Ralink driver
has a watchdog
function which resets the TX queue whenever it detects the lockup.

I am currently working on improving the detection, since there can be
a DMA timeout
and a TX status report timeout. (Where the latter occurs much more
often then the DMA
timeout). This should decrease the packet loss somewhat, but will not
prevent the
problems to occur.

Ivo

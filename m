Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42765 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0I0TrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:47:22 -0400
Received: by fxm3 with SMTP id 3so2153573fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:47:21 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Mon, 27 Sep 2010 21:46:30 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009271956.41041.helmut.schaa@googlemail.com> <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com>
In-Reply-To: <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009272146.30378.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 27 September 2010 schrieb Joshua Smith:
> Sometimes my Linksys/Cisco WMP600N adapter will not initialize in AP mode. 
> Prior to going into AP mode, I do 'iw wlan0 scan' and get a bunch of info,
> so the hardware is working up to that point.  When I try to start hostapd,
> I get this error in dmesg:
> 
> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
> phy0 -> rt2800pci_set_device_state: Error - Device failed to enter state 4 (-5).

Since you've scanned already before, I guess some DMA registers aren't reset
correctly when taking the interface down.

> (note that I also get this message:
> phy0 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
> but I get that when everything works, as well.)

Yeah, that shouldn't be related.

Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52533 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0DVTwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 15:52:33 -0400
Received: by gwj19 with SMTP id 19so2253721gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 12:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BCDEC94.2080202@lwfinger.net>
References: <4BCDEC94.2080202@lwfinger.net>
Date: Thu, 22 Apr 2010 15:52:32 -0400
Message-ID: <w2xb6c5339f1004221252v7633ea6fgba9e801774f9f4b1@mail.gmail.com>
Subject: Re: Problem with AR5001 on eeepc900A after disable with RFKILL switch
From: Bob Copeland <me@bobcopeland.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Bernhard M. Wiedemann" <bernhardout@lsmod.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 20, 2010 at 2:04 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> This problem is reported at
> https://bugzilla.novell.com/show_bug.cgi?id=595586.
>
> Although not mentioned in the bug report, the kernel is 2.6.33.
>
> The initial part of the report is as follows:
>
> ======================================================================
>
> After disabling WLAN on Asus eeepc 900A using rfkill button (Fn+F2) it
> does not get back into a working state without a reboot.
>
> Reproducible: Always
>
> Steps to Reproduce:
> 1. boot up eeepc900A with WLAN enabled
> 2. press Fn+F2 (rfkill button) to disable WLAN
> 3. press Fn+F2 again to enable WLAN
> Actual Results:
>
> -----
> 1. lspci before rfkill
> 01:00.0 Ethernet controller: Atheros Communications AR8121/AR8113/AR8114
> Gigabit or Fast Ethernet (rev b0)
> 02:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
> Network Adapter (rev 01)
> -----
> 2. lspci after rfkill
> 01:00.0 Ethernet controller: Attansic Technology Corp. Atheros
> AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)
> 02:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
> Network Adapter (rev ff)

Weird..

So it says 'Attansic' on the ethernet only after rfkill is
re-enabled?  The 0xff revision on wifi makes slightly
more sense, if it's some issue like broken PCI config space
reads.

IIRC rfkill switch on those platforms cuts the bus power; I don't
think ath5k participates specifically.  I assume the
eepc-laptop driver is loaded?

-- 
Bob Copeland %% www.bobcopeland.com

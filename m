Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39982 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2FUAsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 20:48:33 -0400
Received: by lbbgm6 with SMTP id gm6so1378461lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 17:48:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D172F55@POCITMSEXMB02.LntUniverse.com>
References: <45566970CF58C74CB52107862E0541CD1D172F55@POCITMSEXMB02.LntUniverse.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Jun 2012 10:48:11 +1000
Message-ID: <CAGRGNgUmKCJkk-LqRgehnF7TxmTBsOVQzrsusM+8BW3MAHVt2w@mail.gmail.com> (sfid-20120621_024837_245368_D83F4172)
Subject: Re: Compat Wireless Version - WL1271
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jun 21, 2012 at 12:47 AM, Girish Bn <Girish.BN@lnties.com> wrote:
> Hi,
> We are using TI WL1271 to support Wi-FI/Wi-Fi Direct for Printer products
> The system configuration is as follows
> Processor: NXP LPC313X
> Kernel: Linux 2.6.28.2

Are you able use a newer kernel?

> RAM:32MB
> FLASH:16MB
> We have ported the Compat Wireless 3.4 RC3(http://wireless.kernel.org/en/users/Download/stable#Patches) package successfully for prototyping.
> However we have disabled Power Management related references in drivers/net/wl12xx/sdio.c as ours is a older kernel which doesn't support run-time PM.
> We will be using the following Wi-Fi related features
> 1.  Wi-Fi Direct( As a Group Owner Negotiation or Autonomous GO), Legacy STA Client (Infrastructure Mode)
> 2. Wireless Personal and Enterprise Security (EAP-FAST, EAP_PEAPv1)
> Let us know which version of Compat wireless package, Wl1271 Firmware version, WPA Supplicant and IW tools can be used in our system?

I'm not sure when support for Wi-Fi Direct landed, but you will need
to use a kernel that's newer than that. I'm also not sure whether
wl1271 supports those features at the moment.

In terms of versions, you'll have to figure that out yourself.

You will need to find which version of WPA Supplicant, IW and
compat-wireless supports the features you want. You will then need to
determine which version of the firmware that the wl1271 driver in that
compat-wireless release needs and use that.

> Let us know how to enable Power Management in the WL1271 driver and also kernel patches to enable the Power Management as this very critical

If your kernel doesn't have the necessary support for runtime power
management, then you're on your own and will have to back-port it
yourself. Compat-wireless tries to produce the best functionality for
older kernels, but sometimes it's simply not practical to back-port
large chunks of infrastructure to older kernels. That said, if you do
manage to back-port it, patches for compat or compat-wireless would be
most welcome.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

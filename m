Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:3881 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbdHVHM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 03:12:29 -0400
Subject: Re: ath9k driver - is it possible to disable tx/rx radio chains?
To: =?UTF-8?Q?H=c3=a5vard_Rabbe?= <hrabbe@me.com>,
        linux-wireless@vger.kernel.org
References: <0DB9FDCC-490C-438E-AA50-1C751565A9AE@me.com>
 <8cf52994-eda4-d88f-a236-2b74c085bf3f@neratec.com>
 <73CCFF27-AA9B-4F1C-BAAF-EA38C5CC31C2@me.com>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <f21749c9-21bc-e9cf-b3d8-c2632b577e09@neratec.com> (sfid-20170822_091232_794585_42CFBC45)
Date: Tue, 22 Aug 2017 09:12:25 +0200
MIME-Version: 1.0
In-Reply-To: <73CCFF27-AA9B-4F1C-BAAF-EA38C5CC31C2@me.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/08/17 23:04, Håvard Rabbe wrote:
> Hi
> Thank you so much. You made my day!
> The command works. Im looking forward to test it out :-)
> 
> 
> I also have two of these card. they don’t have the same bitmap, but I assume they work the same way?
> 
> qca9882 chipset with 2 chains available using ath10k driver:
> 	Available Antennas: TX 0x3 RX 0x3
> 	Configured Antennas: TX 0x3 RX 0x3
> 
> qca9880 chipset with 3 chains available using ath10k driver:
> 	Available Antennas: TX 0x3 RX 0x3
> 	Configured Antennas: TX 0x3 RX 0x3
> 
> 

The bitmap is always the same.
0x1 for chain 0
0x3 for chain 0 and 1
0x7 for chain 0, 1 and 2
0xf for chain 0, 1, 2 and 3

Are you sure that your qca9880 card has 3 chains?
Because the "Available Antennas: TX 0x3 RX 0x3" says there are only 2 chains available.
It could be that the card physically has 3 chains, but the 3rd is disabled in eeprom.

BR
Matthias

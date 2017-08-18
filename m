Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:38421 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbdHRHId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 03:08:33 -0400
Subject: Re: ath9k driver - is it possible to disable tx/rx radio chains?
To: =?UTF-8?Q?H=c3=a5vard_Rabbe?= <hrabbe@me.com>,
        linux-wireless@vger.kernel.org
References: <0DB9FDCC-490C-438E-AA50-1C751565A9AE@me.com>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <8cf52994-eda4-d88f-a236-2b74c085bf3f@neratec.com> (sfid-20170818_090836_524735_BF37653B)
Date: Fri, 18 Aug 2017 09:00:27 +0200
MIME-Version: 1.0
In-Reply-To: <0DB9FDCC-490C-438E-AA50-1C751565A9AE@me.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/08/17 01:32, Håvard Rabbe wrote:
> Hi
> I’m using wifi card with AR9280 chipset that uses the ath9k driver.
> 
> The card has 2 available radio chains and I’m only going to connect 1 antenna.
> 
> Is it possible to disable the radio chain im not using?
> 
> 
> Best Regards,
> 
> Håvard Rabbe
> 

Help text from iw:
phy <phyname> set antenna <bitmap> | all | <tx bitmap> <rx bitmap>

You can set the rx/tx mask with
iw phy phy0 set antenna 1
to not use the second chain

or
iw phy phy0 set antenna 1 3
to not use the second chain for tx, but still use it for rx.

You can see the currently active mask with:
iw list | grep Antenna

Be aware that the value set here is a bitmask only allows the values 1/3/7 (for 1, 2 and 3 chains).
Chain 0 is always active.
--> You can not disable chain 0 and only use chain 1.

BR
Matthias

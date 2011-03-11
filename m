Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58663 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1CKO1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 09:27:38 -0500
Received: by mail-yx0-f174.google.com with SMTP id 7so1184558yxs.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 06:27:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
Date: Fri, 11 Mar 2011 15:18:18 +0100
Message-ID: <AANLkTikYgMaW8TCxN+fW+aeQqU7HJgRL=VHtTMgGq7JG@mail.gmail.com>
Subject: Re: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 marca 2011 11:59 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> It seems all reads are 1 (0xffffffff). Can this be some bug in driver?
> Can this be because I use adapter mini PCIe to PCIe x1? I remember
> such a situation when I connected adapter to PCIe x16 and used N-PHY
> card SSB based.

Now, this is interesting. As my last step before ordering motherboard
with mini PCIe slot, I decided to test my adapter on another machine.

Motherboard in my main PC is P5V02-MX with some magic switch that let
me select between:
1) Ex-SATA
2) PCI-E*1

So I put my adapter with BCM943224 card into ASRock K8NF4G-SATA2
and... it worked with Ubuntu 11.04 LiveCD and brcm80211!

My conclusion:
It seems my P5V02-MX motherboard with that magic Ex-SATA/PCIe x1
switch is in conflict with AI boards. Maybe that switch generated some
timing delays that lead to all register reads being 1?

I'll try to exchange my PC with the one working with ASRock.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43501 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1FRXoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 19:44:08 -0400
Received: by pvg12 with SMTP id 12so2703921pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 16:44:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308442692-4205-2-git-send-email-zajec5@gmail.com>
References: <1308442692-4205-1-git-send-email-zajec5@gmail.com>
	<1308442692-4205-2-git-send-email-zajec5@gmail.com>
Date: Sun, 19 Jun 2011 01:44:08 +0200
Message-ID: <BANLkTi=17HKU7bF6yfvjYVW8F+es1V86qw@mail.gmail.com> (sfid-20110619_014411_572763_0D3F211F)
Subject: Re: [PATCH 2/2] b43: HT-PHY: enable radio
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 czerwca 2011 02:18 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
>  phy_read(0x0810) -> 0x0000
> phy_write(0x0810) <- 0x0000
>  phy_read(0x0810) -> 0x0000
> phy_write(0x0810) <- 0x0001
>  phy_read(0x0810) -> 0x0001
> phy_write(0x0810) <- 0x0000
>  phy_read(0x0810) -> 0x0000
> phy_write(0x0810) <- 0x0002

After hacking MMIO to fool driver's reads:
 phy_read(0x0810) -> 0xffff
phy_write(0x0810) <- 0x0000
 phy_read(0x0810) -> 0xffff
phy_write(0x0810) <- 0x0001
 phy_read(0x0810) -> 0xffff
phy_write(0x0810) <- 0x0000
 phy_read(0x0810) -> 0xffff
phy_write(0x0810) <- 0x0002

So it clearly seems, driver is masking all the bits.

-- 
Rafał

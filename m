Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34140 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0HWWxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 18:53:53 -0400
Received: by qyk9 with SMTP id 9so3164148qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 15:53:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
	<AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
	<AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com>
Date: Tue, 24 Aug 2010 00:53:52 +0200
Message-ID: <AANLkTim6d0C_Lx=zExfHy-hfeVdY=aXZCfi6c825TGt7@mail.gmail.com>
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock
 control call
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 sierpnia 2010 01:30 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
>>> +       if (!fast)
>>> +               b43_clock_control(dev, 0);
>>> +       dev->phy.b_width = b_width;
>>> +       b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
>>> +       /* TODO: Call PHY BMAC Reset */
>>> +       dev->phy.ops->init(dev);
>
> I believe you need to do the whole PHY init, including the common
> part; not just the PHY type-specific init. Larry, is this true?

Do you mean b43_phy_init? Larry: I guess indeed some tip would be nice :)

-- 
Rafał

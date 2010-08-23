Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45330 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0HWXQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 19:16:06 -0400
Received: by vws3 with SMTP id 3so5748008vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 16:16:05 -0700 (PDT)
Message-ID: <4C730173.7080703@lwfinger.net>
Date: Mon, 23 Aug 2010 18:17:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock control
 call
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>	<AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>	<AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com> <AANLkTim6d0C_Lx=zExfHy-hfeVdY=aXZCfi6c825TGt7@mail.gmail.com>
In-Reply-To: <AANLkTim6d0C_Lx=zExfHy-hfeVdY=aXZCfi6c825TGt7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2010 05:53 PM, Rafał Miłecki wrote:
>> I believe you need to do the whole PHY init, including the common
>> part; not just the PHY type-specific init. Larry, is this true?
> 
> Do you mean b43_phy_init? Larry: I guess indeed some tip would be nice :)

As it shows in http://bcm-v4.sipsolutions.net/802.11/PHY/Init, you need to do
the Common steps. #15 in that list is the specific routines for the PHY type in
the device.

The code in b43_phy_init() seems not to have all of these steps in it, but I'm
not sure where they are implemented.

Larry

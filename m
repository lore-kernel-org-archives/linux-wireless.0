Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40747 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbZJLNqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 09:46:46 -0400
Date: Mon, 12 Oct 2009 09:43:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Br=E1ulio?= B O Bhavamitra <brauliobo@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RaLink 148f:3070 not working since upgrade from 2.6.30 to
	2.6.31
Message-ID: <20091012134325.GC27575@tuxdriver.com>
References: <1df1788c0910110455q570ca89fy6edbda3235a7a35e@mail.gmail.com> <1df1788c0910110513j6847bf97q71059fec4ae9722b@mail.gmail.com> <1df1788c0910110518l1d120983id2bf997d2446b4a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1df1788c0910110518l1d120983id2bf997d2446b4a7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 09:18:24AM -0300, Bráulio B O Bhavamitra wrote:
> Also in Ubuntu Karmic Beta (where the firmware is present) it doesn't
> work (radio not working, can't find any access point)
> 
> 2009/10/11 Bráulio B O Bhavamitra <brauliobo@gmail.com>:
> > Since the upgrade from kernel 2.6.30 to 2.6.31 on archlinux the usb
> > wireless from Ralink doesn't work anymore.
> > Please ask for more info if necessary.

This commit is post-2.6.30 (and pre-2.6.31):

commit d53d9e67b55f6a9fc3f836c5c392eb41ce5676f4
Author: Ivo van Doorn <IvDoorn@gmail.com>
Date:   Sun Apr 26 15:47:48 2009 +0200

    rt2x00: Implement support for rt2800usb
    
    Add support for the rt2800usb chipset.
    
    Current problems:
     * Cannot scan 11n AP's
     * No TX during first minute after association
     * Broken Hardware encryption
    
    Includes various patches from Mattias, Felix, Xose and Axel.
    
    Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Signed-off-by: Axel Kollhofer <rain_maker@root-forum.org>
    Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

That is the first time 148f:3070 is supported by the rt2x00 drivers.
I have no idea what you were using up to 2.6.30...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

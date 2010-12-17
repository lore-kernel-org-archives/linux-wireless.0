Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:34109 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab0LQPCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 10:02:14 -0500
Date: Fri, 17 Dec 2010 16:02:06 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in
 use
Message-ID: <20101217150206.GA6805@sig21.net>
References: <AANLkTi=img36VOkKapcgZz54ZmtXRneai-W0bU_W5z=E@mail.gmail.com>
 <740412.10599.qm@web56806.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <740412.10599.qm@web56806.mail.re3.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 03:56:05AM -0800, Walter Goldens wrote:
>  
> > Odd I have been testing this while stresstesting the card,
> > and either
> > unplugging, rmmod or ifdown, and I couldn't
> > reproduce any crashes. Has the stacktrace changed after
> > these patches?
> 
> I can confirm when the rt2800usb is loaded and an rt3070 chip is connected to
> a network, running 'rmmod rt2800usb rt2x00lib rt2x00usb rt2800lib' causes
> immediate system hang (and hard-reset).

FWIW, I did not test this case.  I only tested hot-unplug of the
USB device.  However, I think usually when the network interface
is up the module use count should be incremented so that you
cannot unload the module.

Johannes

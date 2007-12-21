Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:40694 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXLUGRi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 01:17:38 -0500
Date: Fri, 21 Dec 2007 15:17:28 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20071215014244.GI5698@jm.kir.nu>
References: <1197637127.16724.1.camel@localhost.localdomain> <20071215014244.GI5698@jm.kir.nu>
Message-Id: <20071221150228.BA41.40F06B3A@sm.sony.co.jp> (sfid-20071221_061744_130389_45F0EA29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi Jouni,

On Fri, 14 Dec 2007 17:42:44 -0800
Jouni Malinen <j@w1.fi> wrote:

> However, there is a part that you are not going to like.. This is likely
> using a private ioctl for some parts of the association requests, i.e.,
> no -Dwext.. I would assume that this could be cleaned up, though, if
> WEXT would be extended a bit to allow one more enc_capa to notify
> whether the driver wants to take care of 4-way handshake and to allow
> the PSK to be configured with a new key type.

Yes, as the current WEXT did not have this feature, I could not but
design the new PS3 driver in that way.

> It would be interesting to see whether the driver/firmware/hypervisor
> could be convinced to allow EAPOL frames to go through between
> association and 4-way handshake (which would be completed by
> driver/firmware). This is the way I can support WPA/WPA2-Enterprise with
> OSX..

I had asked the hypervisor guy. Unfortunately all EAPOL frames would be
dropped by the wireless chip firmware.

-- 
Masakazu MOKUNO


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58451 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYLPERU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 23:17:20 -0500
Message-ID: <49472BC9.7060406@lwfinger.net> (sfid-20081216_051726_431736_A0DC386E)
Date: Mon, 15 Dec 2008 22:17:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory errors from p54usb
References: <49466F56.6060805@lwfinger.net> <200812152051.48349.chunkeey@web.de>
In-Reply-To: <200812152051.48349.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> look at the high 4KB count?! it looks like your memory is highly fragmented...
> 
> rx_mtu is usually around 3240 bytes on new firmwares...
> but for a quick test it can limited to something much less like the
>  RTS/Fragmentation threshold (somewhere around 2356?)...
> just add:
> priv->rx_mtu = 2356; at line 198 in p54common.c
> 
> In the mean time, I've to get rid of my RAM ;-)

No matter how hard I try, I cannot duplicate these results. They may have been a
fluke, but I do have another problem fr you to ponder.

If I run the 'ping -f -i 0.2' to my file server in one window, and start a
kernel compilation with the source on an NFS volume on that same server, p54usb
will hang. I managed to capture the whole process with kismet running on a third
computer and have analyzed it with wireshark. I can find the last transmission
from the server, but no ACK. The next transmission from the p54 is more than 26
sec later when it sends an 802.11 Probe request. The dmesg log just shows that
there was a disconnection, and a reconnection attempt.

Any idea as to why the receiver would go off-line, but the transmitter is still
working?

Larry

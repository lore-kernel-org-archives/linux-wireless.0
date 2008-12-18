Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48865 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbYLRC24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 21:28:56 -0500
Message-ID: <4949B566.20008@lwfinger.net> (sfid-20081218_032900_521508_C0CCB9E1)
Date: Wed, 17 Dec 2008 20:28:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: p54usb problems
References: <4949753B.9000505@lwfinger.net> <200812172333.56596.chunkeey@web.de>
In-Reply-To: <200812172333.56596.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> hmm, I wonder why it's a "order:1" allocation, even on x86-64 the skb_shared_struct is less than 300 bytes
> and the maximum rx_mtu size about 3240 so there should be room left.... of course, it's not really a big
> deal for p54, since we don't have to support frames larger RTS or Fragmentation threshold anyway...
> but what about 11n devices? aren't they suffer from the same problems under load?

The actual size requested is 520 bytes bigger than what is asked for plus the L1
cache alignment, which is getting close to 4000 bytes. If I missed something, it
could be over 4096.

Larry



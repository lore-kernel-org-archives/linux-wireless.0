Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60288 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730AbZDGVHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 17:07:36 -0400
Date: Wed, 8 Apr 2009 00:07:30 +0300
From: Jouni Malinen <j@w1.fi>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Making promisc mode work with WPA encryption?
Message-ID: <20090407210730.GA29619@jm.kir.nu> (sfid-20090407_230739_953376_CA3FD5F1)
References: <1239063352.4705.40.camel@maxim-laptop> <20090407161718.GA19733@jm.kir.nu> <1239135592.17958.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239135592.17958.6.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 07, 2009 at 11:19:52PM +0300, Maxim Levitsky wrote:

> I mostly agree.
> But then maybe its better not to show unencryped frames at all on
> promisc interface?

I was assuming you were talking about some kind of monitor mode, but if
this is FIF_PROMISC_IN_BSS on a station interface, I would agree that it
would be better not to show some corrupted data frames in the data
interface (I'm assuming here that you mean un-decrypted encrypted frames
to other STAs in BSS). What kind of frames are you seeing in this case?
Which driver are you using?

> Exactly. this why I thought it would be nice if kernel could do that and
> present a virtual promisc mode.
> Userspace helper could do all the job figuring the keys, and kernel
> would just use keys to decrypt the traffic.
> I could even hack the wpa_supplicant on all systems that belong to my
> network to exchange the keys.

I think that I continue to say that this should not be in the kernel or
well, at least not in the upstream kernel. If the current implementation
shows some bogus frames when wlan0 (i.e., non-monitor mode interface) is
set to promisc mode when WPA (or even dynamic WEP) is used, the proper
fix would be to filter those frames out. If someone wants to see all the
frames decrypted, that would be a task for a userspace program (e.g.,
wireshark) and an interface in monitor mode. I've done that in the past
by modifying the AP to send all keys to the sniffer host, but sure, this
could also be done by the supplicant side.

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49977 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZIWW7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 18:59:23 -0400
Date: Wed, 23 Sep 2009 15:58:53 -0700
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Flush TX - wireless summit topic
Message-ID: <20090923225853.GA14625@jm.kir.nu>
References: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 22, 2009 at 03:41:50PM -0700, Luis R. Rodriguez wrote:
> Another thing we spoke about at the wireless summit was flushing TX
> prior to changing channel / scan. Bob, remember the issue with ath5k
> on the band not coinciding on received skbs since we don't do a DMA RX
> flush prior to channel change? Well one theory discussed was that we
> would see that issue disappear if we actually did a proper TX flush
> prior to channel change since we expect we would not see further
> incoming frames from our AP if we told it we were going to PS (sending
> a null func frame). If we implement a proper TX flush then the theory
> goes that we wouldn't need to do any sort of DMA flush as we would not
> have any frames pending.

I don't know where this theory is coming from, but I do not subscribe to
it ;-). The AP may very well send broadcast frames even after we
indicate the change to PS mode. In addition, other frames could
potentially be received based on RX filter settings. If we want to make
sure we do not get new pending RX frames, we need to stop the receiver
first or be prepared to handle the received frames somehow.

The number of pending RX frames would hopefully be relatively small,
though, in this kind of case. In order to process these frames
correctly, they would need to be taken care of prior to the channel
change or alternatively, with the channel parameters cached in the
driver so that they could be sent up with all the correct information
even after the channel change.

-- 
Jouni Malinen                                            PGP id EFC895FA

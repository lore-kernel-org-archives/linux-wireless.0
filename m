Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab0DDKUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 06:20:48 -0400
Received: by gyg13 with SMTP id 13so1605835gyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 03:20:47 -0700 (PDT)
Message-ID: <4BB867F6.3050208@gmail.com>
Date: Sun, 04 Apr 2010 05:20:38 -0500
From: Quintin Pitts <geek4linux@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	sean@mess.org
Subject: Re: [RFT/RFC] p54pci: prevent stuck rx-ring on slow system
References: <201004032309.13029.chunkeey@googlemail.com>
In-Reply-To: <201004032309.13029.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat Apr 03 2010 16:09:12 GMT-0500 (CDT), Christian Lamparter wrote:
> From: Quintin Pitts <geek4linux@gmail.com>
> 
> This patch fixes an old problem, which - under certain
> circumstances - could cause the device to become
> unresponsive. 
> 
> most of p54pci's rx-ring management is implemented in just
> two distinct standalone functions. p54p_check_rx_ring takes
> care of processing incoming data, while p54p_refill_rx_ring
> tries to replenish all depleted communication buffers.
> 
> This has always worked fine on my fast machine, but
> now I know there is a hidden race...
> 
> The most likely candidate here is ring_control->device_idx.
> Quintin Pitts had already analyzed the culprit and posted
> a patch back in Oct 2009. But sadly, no one's picked up on this.
> ( https://patchwork.kernel.org/patch/53079/ [2 & 3] ).
> This patch goes in the same way, except that we now prioritize
> rx data processing, simply because tx routine can wait.
> 
> Reported-by: Sean Young <sean@mess.org>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=11386
> Reported-by: Quintin Pitts <geek4linux@gmail.com>
> Signed-off-by: Quintin Pitts <geek4linux@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Quintin, I've added the "From: ...", because this is from your post.
> So, you've the last word, if you don't agree with what just I wrote.
> 

I agree with what you wrote.

Thanks.

Quintin.

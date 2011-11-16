Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1KPXMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:12:17 -0500
Received: by bke11 with SMTP id 11so1227179bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 15:12:16 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: [PATCH] p54spi: Remove FIXME in op_stop
Date: Thu, 17 Nov 2011 00:12:03 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20111116235120.4c60c066@milhouse>
In-Reply-To: <20111116235120.4c60c066@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111170012.03948.chunkeey@googlemail.com> (sfid-20111117_001229_462284_0E70053F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, November 16, 2011 11:51:20 PM Michael Büsch wrote:
> Don't use the interruptible variant of mutex_lock(). It doesn't really
> need to be interruptible. This avoids nasty error handling.
> 
> Signed-off-by: Michael Buesch <m@bues.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

BTW: I always wondered if it would make sense to have a
cached rx skb ready in p54spi_rx(). This way we don't
have to do DMA onto the stack [which is really ugly and
possibly illegal] and might even get a better rx
performance. I could write the code but as you know I don't
have the hardware to test it.

Regards,
	Christian

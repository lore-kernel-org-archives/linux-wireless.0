Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35900 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab1DMH4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 03:56:05 -0400
Received: by fxm17 with SMTP id 17so269994fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 00:56:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rt2800usb: page allocation failure
Date: Wed, 13 Apr 2011 09:54:06 +0200
Cc: Johannes Stezenbach <js@sig21.net>,
	Igor Plyatov <plyatov@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4DA471DC.7080308@gmail.com> <20110412212236.GA8877@sig21.net> <4DA4FE7C.8070807@lwfinger.net>
In-Reply-To: <4DA4FE7C.8070807@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104130954.07178.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 13. April 2011 schrieb Larry Finger:
> @Igor: The buffer size is set in the define for AGGREGATION_SIZE located in 
> drivers/net/wireless/rt2x00/rt2x00queue.h. Reducing that will cut the buffer 
> size request, but might not help the problem.

... and will break reception of AMSDUs.

However, there are some references that the hardware might be able to support
something like scatter gather DMA (WPDMA_GLO_CFG.HDR_SEG_LEN) but I haven't
investigated in that direction yet.

Helmut

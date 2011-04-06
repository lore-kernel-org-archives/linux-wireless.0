Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42948 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DFMjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 08:39:02 -0400
Received: by fxm17 with SMTP id 17so950396fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 05:39:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kimmo Huoso <kimmo.huoso@saunalahti.fi>
Subject: Re: 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB Adapter(rev.A) [Atheros AR9001U-(2)NG] Invalid misc and Tx excessive retries
Date: Wed, 6 Apr 2011 14:38:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <4D9B077E.3090106@saunalahti.fi>
In-Reply-To: <4D9B077E.3090106@saunalahti.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104061438.43678.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 April 2011 14:13:50 Kimmo Huoso wrote:
> Im having vast amount of  Invalid misc, Tx excessive retries. my 
> hardware is 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB 
> Adapter(rev.A) [Atheros AR9001U-(2)NG].
There are two "rev A", hope you got the second revision.

But back to the topic: these softmac numbers/statistics are bogus...
It might sound a bit weird, but in fact they are not high enough.

To make a fair comparison you would have to check the hardware
counters [RX_PHY_MISC_ERROR & friends] instead. carl9170 already
has a debugfs interface for this reason [hw_[r|t]x_tally], but
ar9170usb lacks this feature.

Regards,
	Chr

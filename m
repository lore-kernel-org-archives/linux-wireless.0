Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52486 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0CAHeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 02:34:11 -0500
Received: by ewy20 with SMTP id 20so1061584ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 23:34:09 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: prahal@yahoo.com
Subject: Re: [PATCH] rt2x00: Fix TX status reporting for rt2800pci.
Date: Mon, 1 Mar 2010 08:34:06 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Josef Bacik <josef@redhat.com>, Pavel Roskin <proski@gnu.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <4B87D9FF.5080105@yahoo.com>
In-Reply-To: <4B87D9FF.5080105@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003010834.06607.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010, Alban Browaeys wrote:
> After testing, we found that TX_STA_FIFO_MCS is the last MCS value
> tried. If the transmission failed, 8 frames have been transmitted. If the
> transmission succeed, we can easily compute the number of retry.  This patch fix
> the way status is reported to mac80211 rate control. It has 2 bugs :
> 
> 1. mcs can contain the short preamble flag and it will lead to wrong
> computations.
> 
> 2. minstrel nearly always say that 54 Mbits is the best rate, even if we are
> very far from the AP
> 
> TX_DONE_FALLBACK flag meaning has been changed : it means that a
> fallback rate table is used by the hardware.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

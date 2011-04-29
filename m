Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:54203 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab1D2UFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:05:47 -0400
Received: by mail-ey0-f176.google.com with SMTP id 28so1850605eya.35
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:05:46 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Restart TX when TX descriptors are available
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303134251-31514-1-git-send-email-ido@wizery.com>
References: <1303134251-31514-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:05:43 +0300
Message-ID: <1304107543.12586.160.camel@cumari> (sfid-20110429_220549_927657_AD663E36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 16:44 +0300, Ido Yariv wrote:
> The driver stops sending TX packets when either there aren't enough
> memory blocks, or it runs out of TX descriptors. The driver continues to
> send packets to the FW only when more memory blocks are available.
> 
> The FW might free TX descriptors without freeing the corresponding
> memory blocks, especially when dynamic memory is enabled. In cases where
> memory blocks are not freed at all, the driver will keep waiting for
> more memory blocks indefinitely.
> 
> Fix this by clearing the WL1271_FLAG_FW_TX_BUSY flag when there are
> available TX descriptors.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Thanks, Ido.  Applied.

-- 
Cheers,
Luca.


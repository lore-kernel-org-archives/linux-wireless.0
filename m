Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49959 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZC3VwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:52:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [PATCH] b43: Refresh RX poison on buffer recycling
Date: Mon, 30 Mar 2009 23:50:58 +0200
Cc: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <200903280041.25265.mb@bu3sch.de> <C0D59D9C-FC8A-4C79-B777-AF2F166D9711@ing.unibs.it>
In-Reply-To: <C0D59D9C-FC8A-4C79-B777-AF2F166D9711@ing.unibs.it>
MIME-Version: 1.0
Message-Id: <200903302350.58971.mb@bu3sch.de> (sfid-20090330_235229_254590_34DEA1F1)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009 23:35:34 Francesco Gringoli wrote:
> I have one more question: the hardware seems to allow frames that are  
> longer than 2352 bytes. If we monitor the firmware during receiving we  
> get up to 0x1005 bytes long frames. When such frames arrives, the  
> kernel drops them as the "The data did not fit into one descriptor  
> buffer and is split over multiple buffers." I tried to increase  
> B43_DMA0_RX_BUFFERSIZE up to 0x1006 but I get problems with dma and  
> the driver keeps restarting the hardware forever. What is wrong with  
> increasing this value above IEEE80211_MAX_FRAME_LEN?

Well... First thing is that I think the hardware wasn't ever
tested with frames >IEEE80211_MAX_FRAME_LEN. So there might be silicon bugs.

The maximum number of bytes one descriptor can carry is 8191 bytes (not including
RX headers and padding. That's 30 bytes).

Third thing is that the buffer must not cross a page boundary. So that is
4096 bytes on most machines. So in practice the 4096 bytes boundary (minus 30 bytes
for headers/padding) is upper bound for B43_DMA0_RX_BUFFERSIZE.

-- 
Greetings, Michael.

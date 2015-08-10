Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbbHJTUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:20:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [-next,1/4] mt7601u: fix dma from stack address
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
To: Jakub Kici?ski <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Message-Id: <20150810192019.3F3B2141194@smtp.codeaurora.org> (sfid-20150810_212024_066430_1E0FBD59)
Date: Mon, 10 Aug 2015 19:20:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jakub Kicinski <kubakici@wp.pl>
> 
> DMA to variables located on the stack is a bad idea.
> For simplicity and to avoid frequent allocations create
> a buffer inside the device structure.  Protect this
> buffer with vendor_req_mutex.  Don't protect vendor
> requests which don't use this buffer.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Thanks, 4 patches applied to wireless-drivers-next.git:

bed429e1ae8b mt7601u: fix dma from stack address
d9517c0a5d74 mt7601u: use correct ieee80211_rx variant
4513493d188d mt7601u: fix tx status reporting contexts
78623bfb6f4c mt7601u: lock out rx path and tx status reporting

Kalle Valo

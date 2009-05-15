Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:54053 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZEOUj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 16:39:28 -0400
Message-ID: <4A0DD2E4.3090802@lwfinger.net>
Date: Fri, 15 May 2009 15:39:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 1/2] b43legacy: Remove unnecessary MMIO in interrupt hotpath
References: <4A0CA755.8000802@lwfinger.net> <200905150154.40819.mb@bu3sch.de>
In-Reply-To: <200905150154.40819.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> This is not correct. Ring1 is used for transmission.
> With this patch applied, you won't receive error notification interrupts
> for the TX ring anymore.
> And ring3 is used for transmission status reporting on old devices.
> This patch breaks it for these devices.

Thanks for the comments. I had thought that you had signed off on Stefano's
original posting of this patch, which was sent to me for testing. I obviously
misunderstood.

V2 will not touch any of this part of the code. If there are DMA reason codes
that do not need to be used, they can be eliminated in a future patch.

Larry




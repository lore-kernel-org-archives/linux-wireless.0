Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41345
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbXIDTSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 15:18:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] bcm43xx: Fix cancellation of work queue crashes
Date: Tue, 4 Sep 2007 21:17:49 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46ddae8c.UPc5+Azm3rCZdJxZ%Larry.Finger@lwfinger.net>
In-Reply-To: <46ddae8c.UPc5+Azm3rCZdJxZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709042117.50006.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2007, Larry Finger wrote:
> A crash upon booting that is caused by bcm43xx has been reported [1] and
> found to be due to a work queue being reinitialized while work on that
> queue is still pending. This fix modifies the shutdown of work queues and
> prevents periodic work from being requeued during shutdown. With this patch,
> no more crashes on reboot were observed by the original reporter. I do not
> get that particular failure on my system; however, when running a large
> number of ifdown/ifup sequences, my system would kernel panic with the
> 'caps lock' light blinking at roughly a 1 Hz rate. In addition, there were
> infrequent failures in the firmware that resulted in 'IRQ READY TIMEOUT'
> errors. With this patch, no more of the first type of failure occur, and
> incidence of the second type is greatly reduced.
> 
> [1] http://bugzilla.kernel.org/show_bug.cgi?id=8937
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This version of the patch is
Acked-by: Michael Buesch <mb@bu3sch.de>

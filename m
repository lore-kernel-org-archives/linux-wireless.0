Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21794 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaKEGxV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 01:53:21 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 4 Nov 2014 22:53:12 -0800
Subject: RE: [Patch v2 3/5] mwifiex: fix out of memory issue observed for
 USB chipsets
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821C071CE@SC-VEXCH1.marvell.com> (sfid-20141105_075327_761097_261FF2AF)
References: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
 <1415187271-17914-3-git-send-email-akarwar@marvell.com>
 <20141105062516.GS1015@us.netrek.org>
In-Reply-To: <20141105062516.GS1015@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

>> We will stop submitting URBs for Rx data when pending packet count
>> reaches high threshold and restart them when enough packets are
>> consumed to solve the problem.
>
>Other drivers and user activity can deplete memory.  How does this patch
>solve the problem when dev_alloc_skb fails?  I'm worried the underlying
>issue remains; handling out of memory.
>

This patch basically avoids out of memory issue caused by our driver. It also solves the problem when dev_alloc_skb fails by other reasons.

When dev_alloc_skb is failed in mwifiex_usb_submit_rx_urb(), we skip submitting that particular URB and "ctx->skb" remains NULL. Later when pending packets are being consumed in Rx work queue, "if_ops.submit_rem_rx_urb()" call takes care of submitting the URB skipped previously.

Please let me know you have any doubts. 

Regards,
Amitkumar

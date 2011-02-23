Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1BWIX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 03:23:58 -0500
Subject: RE: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Greg KH <greg@kroah.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F50C44E4@SC-VEXCH1.marvell.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
	 <1291380780.3499.119.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307F50C44E4@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 09:23:53 +0100
Message-ID: <1298449433.3747.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-22 at 19:37 -0800, Bing Zhao wrote:

> Is it OK if I change PRINTM (debugging printk) to something like IWL_DEBUG_?
> 
> <drivers/net/wireless/iwlwifi/iwl-debug.h>
> ......
> #define IWL_DEBUG_INFO(p, f, a...)      IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
> #define IWL_DEBUG_MAC80211(p, f, a...)  IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
> #define IWL_DEBUG_MACDUMP(p, f, a...)   IWL_DEBUG(p, IWL_DL_MACDUMP, f, ## a)
> #define IWL_DEBUG_TEMP(p, f, a...)      IWL_DEBUG(p, IWL_DL_TEMP, f, ## a)
> #define IWL_DEBUG_SCAN(p, f, a...)      IWL_DEBUG(p, IWL_DL_SCAN, f, ## a)
> #define IWL_DEBUG_RX(p, f, a...)        IWL_DEBUG(p, IWL_DL_RX, f, ## a)
> #define IWL_DEBUG_TX(p, f, a...)        IWL_DEBUG(p, IWL_DL_TX, f, ## a)
> #define IWL_DEBUG_ISR(p, f, a...)       IWL_DEBUG(p, IWL_DL_ISR, f, ## a)
> ......
> 
> Or, you want me to remove PRINTM stuff completely?

Yeah, I know that's there in iwlwifi too ... I don't like it, but I
couldn't yet get it removed or replaced by newer infrastructure (which
didn't exist when this was written). Can I convince you to at least look
at pr_debug based things?

johannes


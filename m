Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0AEDsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 22:48:14 -0500
Subject: re: iwmc3200wifi: fix array out-of-boundary access
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <20100102140957.GB5076@bicker>
References: <20100102140957.GB5076@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 11:48:13 +0800
Message-ID: <1262663293.551.117.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-01-02 at 22:09 +0800, Dan Carpenter wrote:
> It don't think 6c853da3f30c93 is right.  That's the patch 
> titled "iwmc3200wifi: fix array out-of-boundary access"
> 
> 	Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
> 	index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().
> 
> In 2.6.33-rc2 IWM_RX_ID_GET_HASH() doesn't go as high as IWM_RX_ID_HASH 
> and I don't see any array out-of-bounds.
> 
> #define IWM_RX_ID_GET_HASH(id) ((id) % IWM_RX_ID_HASH)

Ah, you are right. I took '%' for '&'. John, would you revert it? Sorry
for the false alarm.

Thanks,
-yi


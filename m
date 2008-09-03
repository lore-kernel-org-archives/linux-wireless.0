Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55617
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbYICDiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:38:25 -0400
Date: Tue, 02 Sep 2008 20:38:18 -0700 (PDT)
Message-Id: <20080902.203818.42437021.davem@davemloft.net> (sfid-20080903_053827_720792_B8E34449)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, ischram@telenet.be
Subject: Re: [PATCH 7/9] iwlwifi: fix Tx cmd memory allocation failure
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-8-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-6-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-7-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-8-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:48 +0800

> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch "iwlwifi: do not use GFP_DMA in iwl_tx_queue_init" removes
> GFP_DMA from allocation tx command buffers. GFP_DMA allows allocation
> only for memory under 16M which causes allocation problems
> suspend/resume flows.
> 
> Using kmalloc is temporal solution and some consistent/coherent
> allocation schema will be more correct. Since iwlwifi hardware
> supports 64bit address this solution should work on x86 (32 and
> 64bit) for now.
> 
> This patch fixes memory freeing problem in the previous patch.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Ian Schram <ischram@telenet.be>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>

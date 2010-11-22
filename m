Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0KVPiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 10:38:01 -0500
Subject: Re: [PATCH 56/62] iwlwifi: Use static const
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2773a20a26f4e326f0849e8ae8fb4f347d6a6ecb.1290305776.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
	 <2773a20a26f4e326f0849e8ae8fb4f347d6a6ecb.1290305776.git.joe@perches.com>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 07:37:03 -0800
Message-Id: <1290440223.7946.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Sat, 2010-11-20 at 18:38 -0800, Joe Perches wrote:
> Using static const generally increases object text and decreases data size.
> It also generally decreases overall object size.
> 
>    text	   data	    bss	    dec	    hex	filename
>   48644	     57	  12120	  60821	   ed95	drivers/net/wireless/b43/phy_n.o.new
>   48661	     57	  12120	  60838	   eda6	drivers/net/wireless/b43/phy_n.o.old
>   37906	     86	   7904	  45896	   b348	drivers/net/wireless/iwlwifi/iwl-agn-lib.o.new
>   37937	     86	   7904	  45927	   b367	drivers/net/wireless/iwlwifi/iwl-agn-lib.o.old
>   37781	    523	   6752	  45056	   b000	drivers/net/wireless/iwlwifi/iwl-3945.o.new
>   37781	    523	   6752	  45056	   b000	drivers/net/wireless/iwlwifi/iwl-3945.o.old
> 
> Changed b43_nphy_write_clip_detection to take a const u16 *
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

I don't see size difference on 3945, otherwise the patch looks ok to me

Wey




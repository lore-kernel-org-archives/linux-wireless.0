Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38646
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755256AbYADWbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:31:20 -0500
Date: Fri, 04 Jan 2008 14:31:12 -0800 (PST)
Message-Id: <20080104.143112.93580751.davem@davemloft.net> (sfid-20080104_223135_437374_55370A0C)
To: rdreier@cisco.com
Cc: mboton.lkml@gmail.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaabnlme87.fsf@cisco.com>
References: <200801042305.55188.mboton@gmail.com>
	<adaabnlme87.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 04 Jan 2008 14:13:12 -0800

>  > -			       "radiotap head [%d]\n",
>  > +			       "radiotap head [%ld]\n",
>  >  			       skb_headroom(skb), sizeof(*iwl4965_rt));
> 
> Actually I think the correct printf format for printing a size_t
> (coming here from sizeof foo) is "%zd".  Otherwise you'll fix the
> warning on 64-bit targets but add a new warning on 32-bit targets.

Right.

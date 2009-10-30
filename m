Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64605 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZJ3CqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 22:46:05 -0400
Subject: Re: [PATCH] mac80211: make align adjustment code support paged SKB
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1256842728.3865.128.camel@johannes.local>
References: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
	 <43e72e890910290918v1ca66bbdk4270eabcae6f5798@mail.gmail.com>
	 <43e72e890910291152g5325718ah1c55912e928896e3@mail.gmail.com>
	 <1256842728.3865.128.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 30 Oct 2009 10:45:54 +0800
Message-Id: <1256870754.5538.300.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-30 at 02:58 +0800, Johannes Berg wrote:
> Step 1)
>   fix a few corner cases other drivers might have, and stick the bit
> of
>   code iwlwifi has right before passing the frame to mac80211 into
>   mac80211 as the first thing it does with the frame
> 
> Step 2)
>   Look through rx.c and check how much stuff it really needs
> linearised,
>   and where. I suspect that most of the time it _only_ needs the first
>   two bytes, until it comes to actually passing the frame up.
> 
> Step 3)
>   After the audit, push down the linearizing to where needed, i.e.
>   management frames completely, other frames up to and including the
>   ethernet header, software decryption all of the frame
> 
> Step 4)
>   make software decryption aware of paged SKBs, and remove the
>   linearising in that case

Yes, this sounds like a very good plan.

Thanks,
-yi


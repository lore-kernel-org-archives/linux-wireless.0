Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51534 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ADScE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 13:32:04 -0500
Date: Wed, 04 Jan 2012 13:28:55 -0500 (EST)
Message-Id: <20120104.132855.1261837733994182914.davem@davemloft.net> (sfid-20120104_193208_629515_3D35080E)
To: kvalo@qca.qualcomm.com
Cc: linville@tuxdriver.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
	linux-next@vger.kernel.org
Subject: Re: [PATCH] ath6kl: force building as a module
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F042078.5040902@qca.qualcomm.com>
References: <20120104094134.28754.39652.stgit@x201>
	<4F042078.5040902@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 4 Jan 2012 11:48:40 +0200

> On 01/04/2012 11:41 AM, Kalle Valo wrote:
>> Stephen reported that ath6kl fails if both sdio and usb are built
>> into the kernel:
>> 
>> ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
>> ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
>> ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant
>> 
>> As a temporary fix make ath6kl build only as a module. This will be reverted
>> once a separate ath6kl core module is implemented which will fix this
>> properly.
>> 
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Sorry, forgot to CC people. The original patch is here:
> 
> http://marc.info/?l=linux-wireless&m=132567025132302&w=2
> 
> John, can you please take this directly so that the build problem gets
> fixed quickly? I will also apply it to ath6kl.git but that should not
> create any merge problems.

John can you very much NOT include this change, and if the ath6kl maintainers
can't fix this properly then revert the changes that caused this regression
in the first place?

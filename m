Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1ECPHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 11:07:14 -0400
Subject: Re: iwlagn: crash when unloading the module
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1304433727.5744.107.camel@wwguy-ubuntu> (sfid-20110503_164512_782430_D6ED552C)
References: <87iptsgk5y.fsf@purkki.adurom.net>
	 <1304433727.5744.107.camel@wwguy-ubuntu>
	 (sfid-20110503_164512_782430_D6ED552C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 17:07:12 +0200
Message-ID: <1304435232.3720.6.camel@jlt3.sipsolutions.net> (sfid-20110503_170717_917904_FD5145B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 07:42 -0700, wwguy wrote:

> > http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/1.png
> > http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/2.png
> > 
> > This is a new laptop and most likely I haven't removed iwlagn module
> > before. So this shouldn't be a regression.
> > 
> 
> it is new to me as well, I never see that happen on my system. Could you
> share some more information with me? such as laptop model, kernel
> version, 32 or 64 bits.
> 
> Also is there any activity while you unload the iwlagn, is it in connect
> state or not? 

Dave looked at this and it turned out to most likely be a bug in the
intel-iommu code. A tentative patch to fix it from him is here:
http://david.woodhou.se/double-unmap-check.patch

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27568 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2HTUdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 16:33:36 -0400
Date: Mon, 20 Aug 2012 13:33:32 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: protect firmware from excessive WoW pattern
 length
Message-ID: <20120820203331.GA31777@pista> (sfid-20120820_223341_556688_24E968B1)
References: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1345446793.4504.0.camel@jlt3.sipsolutions.net>
 <5031E74F.4010104@qca.qualcomm.com>
 <20120820181837.GA4695@pista>
 <50328B3F.3070206@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50328B3F.3070206@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2012 at 10:08:47PM +0300, Kalle Valo wrote:
> > Can you revert this patch? Otherwise the followup will just do the same.
> 
> I can revert the patch. But IMHO the check isn't that bad, and even
> cfg80211 can be buggy sometimes ;)
> 

Well it's probably better not to cover any cfg80211 bugs up in the
driver anyway.

> >> And ath6kl even uses different define pattern_max_len:
> >>
> >> 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
> >>
> >> But the value is still same:
> >>
> >> #define WOW_PATTERN_SIZE	 64
> >> #define WOW_MASK_SIZE		 64
> >>
> >> Thomas, can you please check this? Do we really need two different
> >> defines? And which one is the correct one here?
> > 
> > No AFAICT there is no reason to have two different defines. I can submit
> > a small patch consolidating these, but it would remove the above hunk
> > anyway so I need to know whether you'll revert or not.
> 
> Thanks. I'll revert the patch so please prepare your patch without the
> check.

OK.

Thomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41339 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbKPU5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 15:57:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Li, Yanbo" <yanbol@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Adjust the RX packet pad offset at QCA99X0 4addr mode
References: <1445575816-4500-1-git-send-email-yanbol@qca.qualcomm.com>
	<877fme40ny.fsf@kamboji.qca.qualcomm.com>
	<2cd04da006cb4f2a8eea859b6aad3e10@nasanexm02e.na.qualcomm.com>
Date: Mon, 16 Nov 2015 22:57:44 +0200
In-Reply-To: <2cd04da006cb4f2a8eea859b6aad3e10@nasanexm02e.na.qualcomm.com>
	(Yanbo Li's message of "Fri, 23 Oct 2015 06:10:17 +0000")
Message-ID: <87si45zmpj.fsf@kamboji.qca.qualcomm.com> (sfid-20151116_215757_858570_2D223DED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Li, Yanbo" <yanbol@qca.qualcomm.com> writes:

>> > +		/* The padding bytes's location is different on various chips */
>> > +		enum ath10k_loc_4addr_pad loc_4addr_pad;
>> 
>> I think that loc prefix is a bit misleading, it reminds me of
>> locationing/positioning etc. What about ath10k_hw_4addr_pad?
>> 
>
>
> There is already a FW feature defined as
> "ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDIND" and the relative
> string is "no-4addr-pad", if we just remove the "loc" prefix, it may
> be confuse with this FW feature.
>
> How about we change the loc to offset in this case or any better suggestion?

I did some naming changes in the pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=42cd3832cd7c78bfeabb639a4086c7838fda5b57

Please review and let me know what you think.

-- 
Kalle Valo

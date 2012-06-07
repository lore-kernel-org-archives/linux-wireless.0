Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242Ab2FGSx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 14:53:27 -0400
Message-ID: <4FD0F8A0.3000704@qca.qualcomm.com> (sfid-20120607_205345_315518_D8636841)
Date: Thu, 7 Jun 2012 21:53:20 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com> <4FD0570D.50303@qca.qualcomm.com> <20120607183820.GA2950@pista>
In-Reply-To: <20120607183820.GA2950@pista>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 09:38 PM, Pedersen, Thomas wrote:
>>> +	WIPHY_FLAG_SUPPORTS_RSSI_SCAN		= BIT(22),
>>> > >  };
>> > 
>> > Is this flag really needed? For me this looks like an optimisation more
>> > than a functional change. If the driver supports this, that's great and
>> > we can save some power. But if the driver does not support it does it
>> > really make any difference for the user space? Would user space act
>> > differently if this feature is not supported by the driver?
>
> Well, this allows cfg80211 to return an error if this feature is
> requested but not supported by the driver / fw.

But do we want to return an error when the driver doesn't support this?
I was thinking that driver should just ignore the attribute in that case
and let user space filter the results.

Kalle

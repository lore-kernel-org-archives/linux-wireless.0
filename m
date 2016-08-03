Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34940 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbcHCCvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 22:51:14 -0400
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
To: Johannes Berg <johannes@sipsolutions.net>
References: <20160713200755.26839-1-yanivma@ti.com>
 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
 <1470045822.3389.24.camel@sipsolutions.net>
 <75fef3ce-41a6-5845-e9be-d7ff052a07da@gmail.com>
 <1c2d3cfc-b7fd-c8fd-4f74-14dd3aa3076e@gmail.com>
 <1470122837.2665.5.camel@sipsolutions.net>
Cc: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org,
	Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <bb69b031-53ad-4649-bd1d-e95ca7a0cc70@gmail.com> (sfid-20160803_045231_216586_2A72CC1F)
Date: Wed, 3 Aug 2016 11:51:09 +0900
MIME-Version: 1.0
In-Reply-To: <1470122837.2665.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年08月02日 16:27, Johannes Berg wrote:
> This explicitly configures *HT capability* though - that's even the
> name of the parameter. If you enable HT40 in the capability, the
> resulting BSS might still not actually *use* 40 MHz bandwidth, as
> required by overlapping BSS detection.

OK, I see.

HT Capabilities element = Defined by hardware and software spec of the 
node. So it does not be modified after boot.

HT Operation element = Defined by surrounding environment and 
configuration of the node. So it could be modified after boot.

So, if the node supports HT40, HT Capabilities shows HT40 is capable.
Now, I understand why you rejected this patch.

But now, when disable_ht=1, no HT Capabilities element in beacon even 
though the node supports HT.

My trailing patch could solve the issue.

Masashi Honma.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46370 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab0JAOvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 10:51:24 -0400
Message-ID: <4CA5F569.3000509@openwrt.org>
Date: Fri, 01 Oct 2010 16:51:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix channel flag / regd issues with multiple cards
References: <4CA5180D.3010702@openwrt.org> <4CA51F2F.70701@openwrt.org>
In-Reply-To: <4CA51F2F.70701@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-01 1:37 AM, Felix Fietkau wrote:
> On 2010-10-01 1:06 AM, Felix Fietkau wrote:
>> Since the regulatory code touches the channel array, it needs to be
>> copied for each device instance. That way the original channel array
>> can also be made const.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@kernel.org [all]
> Hmm, don't merge this one just yet. Seems that this may not be the cause
> for the weird multi-card regd issues after all, since the code looks
> like that part should be properly locked, even for multiple wiphys
> sharing the same channel list.
I got user confirmation that this patch does indeed help with this
issue. I think we should merge this patch until we figure out why
sharing the channel list over multiple devices causes these issues.
Without this patch, the channel flags can get messed up in a way that
breaks regulatory compliance.

- Felix

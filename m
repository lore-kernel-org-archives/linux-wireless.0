Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42618 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877Ab2B2SYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:24:49 -0500
Message-ID: <4F4E6D6C.5010605@openwrt.org> (sfid-20120229_192453_279334_52C039E2)
Date: Wed, 29 Feb 2012 19:24:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: Re: [PATCH 3.3 1/4] Revert "ath9k_hw: Fix false tx hung detection
 in AR9003 chips"
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org> <20120229180825.GB13733@tuxdriver.com>
In-Reply-To: <20120229180825.GB13733@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-29 7:08 PM, John W. Linville wrote:
> On Mon, Feb 27, 2012 at 07:58:39PM +0100, Felix Fietkau wrote:
>> The approach of this change is flawed, as it triggers tx status processing
>> from more callsites, yet the chips only have one global tx status queue.
>> Subsequent patches will properly fix the issue that this one tried to address.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> How flawed is the current approach?  That commit looks like it has been
> around for months already.  Does it really _need_ to be fixed in 3.3?
It only slightly reduces the severity of the issue it tried to address,
while adding some ugly race conditions. It is not possible to properly
fix the issue without a revert of that commit, so I really would like to
see this patch series in 3.3.

- Felix

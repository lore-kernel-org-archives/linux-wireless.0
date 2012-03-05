Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50526 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab2CEUYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:24:42 -0500
Message-ID: <4F552104.9000707@openwrt.org> (sfid-20120305_212448_920909_5A6704C5)
Date: Mon, 05 Mar 2012 21:24:36 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: Re: [PATCH 3.3 1/4] Revert "ath9k_hw: Fix false tx hung detection
 in AR9003 chips"
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org> <20120229180825.GB13733@tuxdriver.com> <4F4E6D6C.5010605@openwrt.org> <20120305193348.GE18128@tuxdriver.com>
In-Reply-To: <20120305193348.GE18128@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-05 8:33 PM, John W. Linville wrote:
> On Wed, Feb 29, 2012 at 07:24:44PM +0100, Felix Fietkau wrote:
>> On 2012-02-29 7:08 PM, John W. Linville wrote:
>> > On Mon, Feb 27, 2012 at 07:58:39PM +0100, Felix Fietkau wrote:
>> >> The approach of this change is flawed, as it triggers tx status processing
>> >> from more callsites, yet the chips only have one global tx status queue.
>> >> Subsequent patches will properly fix the issue that this one tried to address.
>> >> 
>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> > 
>> > How flawed is the current approach?  That commit looks like it has been
>> > around for months already.  Does it really _need_ to be fixed in 3.3?
>> It only slightly reduces the severity of the issue it tried to address,
>> while adding some ugly race conditions. It is not possible to properly
>> fix the issue without a revert of that commit, so I really would like to
>> see this patch series in 3.3.
> 
> I am happy to take this series for 3.4, but it seems quite late
> for 3.3.  We have been living with it for a while already.
OK, no problem. I'm using bleeding edge anyway ;)

- Felix

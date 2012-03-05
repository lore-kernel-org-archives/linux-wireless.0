Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52549 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab2CEUWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:22:25 -0500
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH 3.3 1/4] Revert "ath9k_hw: Fix false tx hung detection
 in AR9003 chips"
Date: Mon, 5 Mar 2012 20:22:05 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E21533@aphydexd01b> (sfid-20120305_212230_177391_40DAB05F)
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
 <20120229180825.GB13733@tuxdriver.com>
 <4F4E6D6C.5010605@openwrt.org>,<20120305193348.GE18128@tuxdriver.com>
In-Reply-To: <20120305193348.GE18128@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On Wed, Feb 29, 2012 at 07:24:44PM +0100, Felix Fietkau wrote:
>> On 2012-02-29 7:08 PM, John W. Linville wrote:
> >> On Mon, Feb 27, 2012 at 07:58:39PM +0100, Felix Fietkau wrote:
> >>> The approach of this change is flawed, as it triggers tx status processing
> >>> from more callsites, yet the chips only have one global tx status queue.
> >>> Subsequent patches will properly fix the issue that this one tried to address.
>> >>
>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >>
> >> How flawed is the current approach?  That commit looks like it has been
> > >around for months already.  Does it really _need_ to be fixed in 3.3?
>> It only slightly reduces the severity of the issue it tried to address,
>> while adding some ugly race conditions. It is not possible to properly
>> fix the issue without a revert of that commit, so I really would like to
>> see this patch series in 3.3.
>
>I am happy to take this series for 3.4, but it seems quite late
>for 3.3.  We have been living with it for a while already.

As said, it is not a regression. The latest patch fix it in proper manner. So it fine to have it from 3.4 onwards.

-Rajkumar
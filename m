Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54172 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbC3O2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:28:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 5/5] wil6210: update FW file name
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427704134-30699-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<87wq1y6d1b.fsf@kamboji.qca.qualcomm.com>
	<16442708.jC9XbHNgDJ@lx-wigig-72>
Date: Mon, 30 Mar 2015 17:28:31 +0300
In-Reply-To: <16442708.jC9XbHNgDJ@lx-wigig-72> (Vladimir Kondratiev's message
	of "Mon, 30 Mar 2015 17:00:00 +0300")
Message-ID: <87zj6u36gg.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_162843_973450_19D840EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> On Monday, March 30, 2015 12:38:08 PM Kalle Valo wrote:
>> Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:
>> 
>> > Firmware "board" file name has changed from wil6210.board
>> > to wil6210.brd by the FW generation tools.
>> >
>> > Reflect this in the driver.
>> >
>
>> > -#define WIL_FW2_NAME "wil6210.board" /* board & radio parameters */
>> > +#define WIL_FW2_NAME "wil6210.brd" /* board & radio parameters */
>> 
>> I consider the firmware file names as part of stable user space
>> interface (older user space need to work with newer kernel etc) and this
>> change breaks that.
>
> Hardware was not released to the public yet; no one besides developers
> in the lab should be affected by this.

Actually that doesn't matter as it's common to run few years old
kernels, especially in the embedded world. So no matter what, this
breaks compatibility with user space and without any real benefit
whatsoever. Now will anyone hit this in practise I don't know.

I guess this change is ok for now as wil6210 hw is not that common, but
in the future please be careful with this.

-- 
Kalle Valo

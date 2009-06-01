Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57416 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZFAOrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:47:21 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243858256.5299.14.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local>  <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:47:00 +0200
Message-Id: <1243867620.3015.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Would everybody be happy with this rolled in?
> 
> johannes
> 
> Subject: rfkill: userspace API improvements
> 
> This adds the two following things to /dev/rfkill:
>  1) notification to userspace with a new operation
>     RFKILL_OP_NVS_REPORT about default states restored
>     from platform non-volatile storage

I really don't understand why this is needed. What benefit does it give
us compared to just sent OP_CHANGE and OP_CHANGE as an update. My X200
for example does this anyway on suspend/resume.

So what is rfkilld suppose to be doing when receiving this report? What
is the expected behavior? Why do we bother with multi-OS crap here? I am
really unclear what are we trying to solve here.

>  2) the ability to ignore input events in the kernel
>     while a handler daemon is connected, if the input
>     part is compiled in.

For the rfkill-input ioctl:

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel



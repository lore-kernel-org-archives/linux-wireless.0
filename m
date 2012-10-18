Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42614 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab2JRIsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 04:48:39 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so5634341lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 01:48:38 -0700 (PDT)
Message-ID: <507FC25F.9030702@gmail.com> (sfid-20121018_104843_642448_F9D52ADB)
Date: Thu, 18 Oct 2012 10:48:31 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org, hch@lst.de,
	s.L-H@gmx.de
Subject: Re: [PATCH v2 0/4] Driver for the ar5523 chipset
References: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com> <201210162322.20703.chunkeey@googlemail.com>
In-Reply-To: <201210162322.20703.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-16 23:22, Christian Lamparter wrote:
>> Changes v1 to v2:
>>
>> * Bugfix: Avoid % 512 transfer sizes on TX as the FW will hang.
> Have you tried setting "urb->transfer_flags |= URB_ZERO_PACKET;"
> to your outgoing urbs? This might fix the hang as well and you
> don't need any ugly skb_put.

Thanks! Didn't know about this flag. Solved the problem!

Cheers,

Pontus

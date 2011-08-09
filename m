Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49505 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1HISci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:32:38 -0400
Received: by qyk38 with SMTP id 38so2420775qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 11:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Uzp4M9SNgti9hpob=Q49cJTwhuG5qnY3vgg9Mqjb-OCA@mail.gmail.com>
References: <1312914178-9601-1-git-send-email-senthilb@qca.qualcomm.com> <CAB=NE6Uzp4M9SNgti9hpob=Q49cJTwhuG5qnY3vgg9Mqjb-OCA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Aug 2011 11:32:17 -0700
Message-ID: <CAB=NE6W7LsHzTg_=MSEozKfXOiQt_Z7mB1pQ772m_FqsanTjVw@mail.gmail.com> (sfid-20110809_203247_125323_E5EBED87)
Subject: Re: [PATCH] ath9k_hw: Fix STA (AR9485) bringup issue due to incorrect
 MAC address
To: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 11:31 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Aug 9, 2011 at 11:22 AM, Senthil Balasubramanian
> <senthilb@qca.qualcomm.com> wrote:
>> Due to some recent optimization done in the way the mac address
>> bytes are written into the OTP memory, some AR9485 chipsets were
>> forced to use the first byte from the eeprom template and as AR9485
>> happens to use generic eeprom template which has 0x1 as the first
>> byte causes issues in bringing up the card.
>>
>> So fixed the eeprom template accordingly to address the issue.
>>
>> Cc: Paul Stewart <pstew@google.com>
>> Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
>
> I don't follow the description too well, all I can tell from it is
> that there is an issue if the template has 0x01 set instead of 0x0 but
> it doesn't tell me why.

Is this not a stable fix?

  Luis

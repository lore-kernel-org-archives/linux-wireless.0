Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37852 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaIXK0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 06:26:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: don't enable interrupts for the diagnostic window
References: <20140923143219.23585.34114.stgit@potku.adurom.net>
	<CA+BoTQ=P2mKLbdPTQYM_c-ohMtsucTHbc_aukzqcdpQUwhwtvQ@mail.gmail.com>
Date: Wed, 24 Sep 2014 13:26:18 +0300
In-Reply-To: <CA+BoTQ=P2mKLbdPTQYM_c-ohMtsucTHbc_aukzqcdpQUwhwtvQ@mail.gmail.com>
	(Michal Kazior's message of "Wed, 24 Sep 2014 08:58:56 +0200")
Message-ID: <87d2al9uwl.fsf@kamboji.qca.qualcomm.com> (sfid-20140924_122648_003631_758A4396)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 23 September 2014 16:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>> -       for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
>> +       /* Skip the last copy engine, CE7 the diagnostic window, as that
>> +        * uses polling and isn't initialized for interrupts. */
>
> Comment style :-)

Argh, I never learn. This new comment style is so unnatural for me that
I guess I need to completely convert ath10k to use the new style so that
I can use checkpatch to catch these :)

-- 
Kalle Valo

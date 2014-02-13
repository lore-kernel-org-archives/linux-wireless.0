Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44622 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaBMOxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:53:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Marek Puzyniak <marek.puzyniak@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: change simulate_fw_crash to work with 10.1 firmware
References: <1392052405-15337-1-git-send-email-marek.puzyniak@tieto.com>
	<CA+BoTQ=q-940AsMfneU5SP8Ke1RxEZE12rrm4Z+KBaTBjrW64w@mail.gmail.com>
Date: Thu, 13 Feb 2014 16:52:55 +0200
In-Reply-To: <CA+BoTQ=q-940AsMfneU5SP8Ke1RxEZE12rrm4Z+KBaTBjrW64w@mail.gmail.com>
	(Michal Kazior's message of "Tue, 11 Feb 2014 07:17:45 +0100")
Message-ID: <87ppmr83p4.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_155306_355451_B7A183B5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 February 2014 18:13, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>> Wmi command WMI_FORCE_FW_HANG_CMDID is not supported
>> in firmware 10.1. In order to have firmware crash simulation
>> functionality also in firmware 10.1 driver can force firmware
>> crash by performing not allowed operation. Driver can deliberately
>> crash firmware when setting vdev param for vdev id out of range.
>>
>> Command to trigger firmware crash:
>> echo "crash" > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> ---
>
> The 'fw hang assert' crash can be recovered with a warm reset but a
> real crash can't.

Oh, I didn't know that.

> Thus, I think the two crash methods should be distinguishable 

Yeah, I agree.

> by having either two separate debugfs files or two separate trigger
> keywords.

I think having a keyword would be a better to way differentiate these.
And if the firmware doesn't support WMI_FORCE_FW_HANG_ASSERT, then just
return -EOPNOTSUPP.

-- 
Kalle Valo

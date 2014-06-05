Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFELGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:06:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>
	<538CC949.5020901@candelatech.com>
	<CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>
	<538CD507.1050803@candelatech.com>
Date: Thu, 5 Jun 2014 14:06:13 +0300
In-Reply-To: <538CD507.1050803@candelatech.com> (Ben Greear's message of "Mon,
	2 Jun 2014 12:48:23 -0700")
Message-ID: <87bnu7pqe2.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_130623_077857_C2E405AB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/02/2014 12:29 PM, Emmanuel Grumbach wrote:
>
>> Different TLV based binary blobs concatenated. The actual encoding of
>> each of them is another story.
>
> Should we try to make the 'Type' in TLV be consistent as convenient
> across different drivers?  That might someday help auto-reporting
> tools?

I don't see the need for that as all firmwares are so different anyway.
As long as there's some magic string to recognize/verify for which
firmware it is we should be ok.

> It does not resolve my interest in firmware logs interleaved with
> kernel logs and possibly supplicant, however.
>
> Looks like trace-cmds could do that, but it will not be
> running for normal users when they experience crashes.
>
> Any suggestions other than printk for this feature?

Why do you want to put the crash dump in kernel log, can you describe
your "use case" here? For me it would be enough to have a UUID for each
crash dump and then have the driver print that to kernel log:

ath10k: firmware crashed (uuid 1234567890-4321)

And then you just need to find the correct dump from the file system and
start debugging. Would that be enough for you?

-- 
Kalle Valo

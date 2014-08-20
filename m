Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26594 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTHgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 03:36:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082253.16842.32433.stgit@potku.adurom.net>
	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
	<53F36C63.8040809@candelatech.com> <53F375E4.90409@candelatech.com>
Date: Wed, 20 Aug 2014 10:36:00 +0300
In-Reply-To: <53F375E4.90409@candelatech.com> (Ben Greear's message of "Tue,
	19 Aug 2014 09:05:56 -0700")
Message-ID: <87ppfv62an.fsf@kamboji.qca.qualcomm.com> (sfid-20140820_093617_384665_472A90EB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> This series has taken a long time already, so it would be fine with me
> to deal with the dbglog cleanup in subsequent patches, and just assume
> for now that the dbglog messages start at index 0 in the dbglog-entry-data.

I also would like to get this support finally in. As the basic
infrastructure seems to be mostly ok, I'm planning to split the patchset
into two and the first containing just the basic infrastructure and
register dump:

	ATH10K_FW_CRASH_DUMP_REGDUMP = 1,

Which I'll actually rename to ATH10K_FW_CRASH_DUMP_REGISTERS. And I'll
also fix the endian problem Michal pointed out.

And then we can later add the rest, once they are properly tested and
the endian issues are solved:

	ATH10K_FW_CRASH_DUMP_DBGLOG = 0,
	ATH10K_FW_CRASH_DUMP_STACK = 2,
	ATH10K_FW_CRASH_DUMP_EXC_STACK = 3,
	ATH10K_FW_CRASH_DUMP_RAM_BSS = 4,
	ATH10K_FW_CRASH_DUMP_ROM_BSS = 5,

And as we use TLV format this split doesn't break anything in user
space. How does that sound?

-- 
Kalle Valo

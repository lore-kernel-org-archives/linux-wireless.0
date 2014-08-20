Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48648 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHTOTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 10:19:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082253.16842.32433.stgit@potku.adurom.net>
	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
	<53F36C63.8040809@candelatech.com>
	<87tx5762lk.fsf@kamboji.qca.qualcomm.com>
	<53F49DDC.1030300@candelatech.com>
Date: Wed, 20 Aug 2014 17:19:40 +0300
In-Reply-To: <53F49DDC.1030300@candelatech.com> (Ben Greear's message of "Wed,
	20 Aug 2014 06:08:44 -0700")
Message-ID: <87ha175jlv.fsf@kamboji.qca.qualcomm.com> (sfid-20140820_161953_927236_4DC530F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 08/20/2014 12:29 AM, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>>>> + /* Gather dbg-log */ + dump_tlv = (struct ath10k_tlv_dump_data
>>>>> *)(buf + sofar); + dump_tlv->type =
>>>>> cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG); + dump_tlv->tlv_len =
>>>>> cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
>>>> Hmm should this really be sizeof()? Not next_idx (which
>>>> effectively defines number of bytes of the dbglog)?
>>> I haven't tried decoding this yet, but we may need to know the
>>> next_idx to decode this properly.
>> I really don't like the idea of having untested code in ath10k.
>> Buggy code is okay (preferably document the known bugs when
>> submitting code), but untested code is not.
>
> It would be quite a waste of time to keep re-writing a user-space dump
> tool while the patch set is in this much churn, I think.

> It's not like ath10k is going to blow up, but maybe the decode is less
> useful in that we cannot actually get a useful debuglog decode until
> the problem is resolved. We get zero firmware dbglog messages
> currently, so nothing is lost.

Of course ath10k won't blow up, but every patch and every line of code
increases the maintenance cost. For example, if I had known that the
dbglog dump in your patchset doesn't work at all, I would have dropped
it immediately and saved a lot of time of everyone's time, especially
mine.

So next time you send me untested code PLEASE clearly mention that. I
assume that the developer has tested the submitted code well enough that
it really works. Hoping it to work is not enough! Unless you are
Johannes, Linus or Davem :)

-- 
Kalle Valo

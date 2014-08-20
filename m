Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46013 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHTNIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 09:08:55 -0400
Message-ID: <53F49DDC.1030300@candelatech.com> (sfid-20140820_150859_020138_B0A8E14A)
Date: Wed, 20 Aug 2014 06:08:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>	<20140819082253.16842.32433.stgit@potku.adurom.net>	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>	<53F36C63.8040809@candelatech.com> <87tx5762lk.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tx5762lk.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/20/2014 12:29 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>>>> +       /* Gather dbg-log */
>>>> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
>>>> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
>>>> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
>>>
>>> Hmm should this really be sizeof()? Not next_idx (which effectively
>>> defines number of bytes of the dbglog)?
>>
>> I haven't tried decoding this yet, but we may need to know the next_idx
>> to decode this properly.
>
> I really don't like the idea of having untested code in ath10k. Buggy
> code is okay (preferably document the known bugs when submitting code),
> but untested code is not.

It would be quite a waste of time to keep re-writing a user-space dump tool
while the patch set is in this much churn, I think.

It's not like ath10k is going to blow up, but maybe the decode is less useful
in that we cannot actually get a useful debuglog decode until the problem is
resolved.  We get zero firmware dbglog messages currently, so nothing is lost.

When at least the first patch or two is in, and endian issue is resolved,
I'll write a decode tool (or modify the one I have that parses /var/log/messages
to deal with the new binary dump file).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

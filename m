Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11099 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaHTH3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 03:29:47 -0400
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
Date: Wed, 20 Aug 2014 10:29:27 +0300
In-Reply-To: <53F36C63.8040809@candelatech.com> (Ben Greear's message of "Tue,
	19 Aug 2014 08:25:23 -0700")
Message-ID: <87tx5762lk.fsf@kamboji.qca.qualcomm.com> (sfid-20140820_093008_688977_E8AFF510)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>> +       /* Gather dbg-log */
>>> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
>>> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
>>> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->dbglog_entry_data));
>>
>> Hmm should this really be sizeof()? Not next_idx (which effectively
>> defines number of bytes of the dbglog)?
>
> I haven't tried decoding this yet, but we may need to know the next_idx
> to decode this properly.

I really don't like the idea of having untested code in ath10k. Buggy
code is okay (preferably document the known bugs when submitting code),
but untested code is not.

-- 
Kalle Valo

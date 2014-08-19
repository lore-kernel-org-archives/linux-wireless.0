Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36144 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaHSQF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 12:05:58 -0400
Message-ID: <53F375E4.90409@candelatech.com> (sfid-20140819_180605_246421_F2A402EF)
Date: Tue, 19 Aug 2014 09:05:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>	<20140819082253.16842.32433.stgit@potku.adurom.net> <CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com> <53F36C63.8040809@candelatech.com>
In-Reply-To: <53F36C63.8040809@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2014 08:25 AM, Ben Greear wrote:

>>> +       dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
>>> +       strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
>>> +               sizeof(dump_data->kernel_ver));
>>> +
>>> +       dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
>>> +       dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
>>> +
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

I thought some more on this on the way to work..and I think it will not
be easy to decode this if we do not know the starting point for the
messages.  Each report from firmware will start at the beginning of
a message, so we either need to do a lot of memory copying, or play
tricks with a circular buffer storage.

A long time ago, Kalle mentioned he didn't want any ability to decode
the messages in the kernel, so the 'start' boundary will need to be
the start of the message(s) received from firmware.

This means that the ath10k_debug_dbglog_add will need to be improved
to handle wraps more intelligently, somehow.

This series has taken a long time already, so it would be fine with me
to deal with the dbglog cleanup in subsequent patches, and just assume
for now that the dbglog messages start at index 0 in the dbglog-entry-data.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


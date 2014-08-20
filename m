Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58091 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaHTGsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 02:48:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082253.16842.32433.stgit@potku.adurom.net>
	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>
	<53F36C63.8040809@candelatech.com>
	<CA+BoTQ=ocpY2BDCGhMB7E9s4ykp18uXHMTc7rOn0qb7mDyZ5qw@mail.gmail.com>
Date: Wed, 20 Aug 2014 09:48:31 +0300
In-Reply-To: <CA+BoTQ=ocpY2BDCGhMB7E9s4ykp18uXHMTc7rOn0qb7mDyZ5qw@mail.gmail.com>
	(Michal Kazior's message of "Wed, 20 Aug 2014 08:28:14 +0200")
Message-ID: <87bnrf7j28.fsf@kamboji.qca.qualcomm.com> (sfid-20140820_084847_066495_2397FF95)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 August 2014 17:25, Ben Greear <greearb@candelatech.com> wrote:
>> On 08/19/2014 02:33 AM, Michal Kazior wrote:
>>> On 19 August 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>>>> +       __le32 target_version;
>>>> +       __le32 fw_version_major;
>>>> +       __le32 fw_version_minor;
>>>> +       __le32 fw_version_release;
>>>> +       __le32 fw_version_build;
>>>> +       __le32 phy_capability;
>>>> +       __le32 hw_min_tx_power;
>>>> +       __le32 hw_max_tx_power;
>>>> +       __le32 ht_cap_info;
>>>> +       __le32 vht_cap_info;
>>>> +       __le32 num_rf_chains;
>>>
>>>
>>> Hmm.. some of these values don't really change once driver is loaded
>>> so we could probably just export them as separate debugfs entries but
>>> perhaps that's an overkill just for dumping.
>>
>>
>> I think it will be easier for all involved if there is a single dump image
>> that
>> has all needed info.  Likely the end user of the dump file will have little
>> or no
>> interaction with the host that dumped the file to begin with.
>
> I think there's been this idea about moving dumping to udev somewhat,
> no? 

Yeah. But I'm thinking that should just signal user space that there's a
new crash dump available, nothing else.

> Since this is just debugfs then I imagine you could have a userspace
> program that would create the single blob/crash report from things it
> thinks is important, e.g.. `uname -a`, debugfs entries (fw stack
> traces, dbglog, etc), recent kernel log buffer, etc. It could even all
> be stored in plaintext (with binary data encoded as a hexdump). But
> that, I guess, could be cumbersome, at least initially, until all
> major distros adapt.

Sure, we can push lots of this to user space. But what's the point?

With the current approach we get a self-contained crash dump which the
user (be it a real person or automated) can store with a simple file
copy operatation and can be easily post-processed afterwards. What you
propose is a lot of work for everyone, most likely even more bugs and
without any clear benefits. At least the memory consumption should be
the same (if not even increase due to increased complexity).

-- 
Kalle Valo

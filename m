Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:65197 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaHTG5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 02:57:06 -0400
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
	<87bnrf7j28.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 20 Aug 2014 09:56:36 +0300
In-Reply-To: <87bnrf7j28.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 20 Aug 2014 09:48:31 +0300")
Message-ID: <877g237ior.fsf@kamboji.qca.qualcomm.com> (sfid-20140820_085718_073497_F014F596)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> Since this is just debugfs then I imagine you could have a userspace
>> program that would create the single blob/crash report from things it
>> thinks is important, e.g.. `uname -a`, debugfs entries (fw stack
>> traces, dbglog, etc), recent kernel log buffer, etc. It could even all
>> be stored in plaintext (with binary data encoded as a hexdump). But
>> that, I guess, could be cumbersome, at least initially, until all
>> major distros adapt.
>
> Sure, we can push lots of this to user space. But what's the point?
>
> With the current approach we get a self-contained crash dump which the
> user (be it a real person or automated) can store with a simple file
> copy operatation and can be easily post-processed afterwards. What you
> propose is a lot of work for everyone, most likely even more bugs and
> without any clear benefits. At least the memory consumption should be
> the same (if not even increase due to increased complexity).

I forgot to mention that also I would not want to rely on debugfs except
at the moment to deliver the dump to user space. I'm hoping that we
would get a generic firmware crash dump support to cfg80211 (hopefully
we can talk about that in Dusseldorf) and we might switch to ethtool or
some another user space interface. Then it might be possible to enable
this even without debugfs, if we are happy to take the hit on memory
use.

-- 
Kalle Valo

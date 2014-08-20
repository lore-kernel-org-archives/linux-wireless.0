Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46107 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaHTNNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 09:13:33 -0400
Message-ID: <53F49EFC.5000008@candelatech.com> (sfid-20140820_151336_554903_64A50E75)
Date: Wed, 20 Aug 2014 06:13:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
References: <20140819082038.16842.46876.stgit@potku.adurom.net>	<20140819082253.16842.32433.stgit@potku.adurom.net>	<CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com>	<53F36C63.8040809@candelatech.com> <CA+BoTQ=ocpY2BDCGhMB7E9s4ykp18uXHMTc7rOn0qb7mDyZ5qw@mail.gmail.com>
In-Reply-To: <CA+BoTQ=ocpY2BDCGhMB7E9s4ykp18uXHMTc7rOn0qb7mDyZ5qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> Hmm should this really be sizeof()? Not next_idx (which effectively
>>> defines number of bytes of the dbglog)?
>>
>>
>> I haven't tried decoding this yet, but we may need to know the next_idx
>> to decode this properly.
>
> So basically a (length, payload) encoding would be necessary here
> instead of a single stream, right?

As long as you know the starting point for a message, you can decode the
rest of the message(s) as a stream of 32 bit ints.  The current code that
I wrote is a circular buffer, so after first wrap, we lose an idea of where
to start reading.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

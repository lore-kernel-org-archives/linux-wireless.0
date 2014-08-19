Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35638 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaHSPQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 11:16:36 -0400
Message-ID: <53F36A4F.5050505@candelatech.com> (sfid-20140819_171701_742153_CD6D2DCC)
Date: Tue, 19 Aug 2014 08:16:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v7 3/8] ath10k: save firmware debug log messages
References: <20140819082038.16842.46876.stgit@potku.adurom.net>	<20140819082300.16842.40769.stgit@potku.adurom.net>	<CA+BoTQmubLrvB1LHquFDNf8W06vePvEk6K3aNV9ngCAAXemY6w@mail.gmail.com> <CA+BoTQ=UduqFY6G=sXJR43hQWk-4v09uYvYJYKO7EGuea7L-Xg@mail.gmail.com>
In-Reply-To: <CA+BoTQ=UduqFY6G=sXJR43hQWk-4v09uYvYJYKO7EGuea7L-Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> +       spin_lock_bh(&ar->data_lock);
>>> +
>>> +       /* First 4 bytes are a messages-dropped-due-to-overflow counter,
>>> +        * and should not be recorded in the dbglog buffer, so we skip
>>> +        * them.
>>> +        */
>>> +       ath10k_debug_dbglog_add(ar, skb->data + 4, skb->len - 4);
>
> Can't we just:
>
> struct wmi_dbg_msg {
>    __le32 num_dropped_due_to_overflow;
>    u8 payload[0]; // is this an array of u8 or __le32 actually?
> };

When I wrote this, I was more paranoid about exposing
any possible details of firmware.  It is an array of 32-bit ints in firmware,
and it decodes as ints instead of bytes, so probably u32 payload instead of u8.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

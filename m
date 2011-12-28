Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4663 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab1L1Unb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:43:31 -0500
Message-ID: <4EFB7F6B.8050104@gmail.com> (sfid-20111228_214334_658989_13970DA5)
Date: Wed, 28 Dec 2011 21:43:23 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	=?ISO-8859-2?Q?Jakub_Kici=F1ski?= <kubakici@wp.pl>
Subject: Re: [PATCH 4/7] rt2800usb: Let rt2x00usb handle USB padding
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com> <1325033604-26469-2-git-send-email-gwingerde@gmail.com> <1325033604-26469-3-git-send-email-gwingerde@gmail.com> <1325033604-26469-4-git-send-email-gwingerde@gmail.com> <1325033604-26469-5-git-send-email-gwingerde@gmail.com> <CAOZOX0XauBTyaBR9j75de=BeTZ1v_rRfgdJc7BPYDsA9HYi-2w@mail.gmail.com>
In-Reply-To: <CAOZOX0XauBTyaBR9j75de=BeTZ1v_rRfgdJc7BPYDsA9HYi-2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/11 21:12, Ivo Van Doorn wrote:
> On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> From: Jakub Kiciñski <kubakici@wp.pl>
>>
>> Older USB drivers does not append end padding to skb but instead report
>> it in size of data to be transmitted to HW. rt2800usb should follow that
>> behaviour. Custom write_tx_data callback which was adding pad to skb
>> is not be needed any more.
>>
>> Thanks to this patch frames handed back from rt2800usb to mac80211 will
>> no longer contain end padding.
> 
> What happened to the reports that after this (and the next) patch, the
> non-2800 USB
> drivers are failing?

I have seen only 1 failure report (from Andreas Hartmann), which seemed
to have been caused by not applying both patches. ISTR that Andreas did
not see any regression when both patches were applied.
I have not seen any other reports of failures.
Also, my own testing did not reveal any issues, therefore I included
them in this batch.

<snip>

---
Gertjan.


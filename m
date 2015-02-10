Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49399 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbbBJNta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 08:49:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-02-07
References: <87a90qosos.fsf@kamboji.qca.qualcomm.com>
	<20150209.121342.1535841700027616341.davem@davemloft.net>
Date: Tue, 10 Feb 2015 15:49:24 +0200
In-Reply-To: <20150209.121342.1535841700027616341.davem@davemloft.net> (David
	Miller's message of "Mon, 09 Feb 2015 12:13:42 -0800 (PST)")
Message-ID: <8761b9op0b.fsf@kamboji.qca.qualcomm.com> (sfid-20150210_144937_224957_4970C9D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Sat, 07 Feb 2015 13:40:51 +0200
>
>> There's a small conflict in drivers/net/wireless/rtlwifi/pci.c, the fix
>> is to leave the two labels like this:
>> 
>> 			schedule_work(&rtlpriv->works.lps_change_work);
>> 		}
>> end:
>> 		skb = new_skb;
>> no_new:
>> 		if (rtlpriv->use_new_trx_flow) {
>> 
>> 
>
> That can't be the correct resolution:
>
> drivers/net/wireless/rtlwifi/pci.c: In function ‘_rtl_pci_rx_interrupt’:
> drivers/net/wireless/rtlwifi/pci.c:934:1: warning: label ‘end’ defined but not used [-Wunused-label]
>
> So I've removed that label in the merge commit.

Sorry about that, but great that you catched my mistake.

-- 
Kalle Valo

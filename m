Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61685 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbbBIUto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 15:49:44 -0500
Message-ID: <54D91D66.2060108@lwfinger.net> (sfid-20150209_214949_076799_3FA7BA42)
Date: Mon, 09 Feb 2015 14:49:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "John W. Linville" <linville@tuxdriver.com>, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-02-07
References: <87a90qosos.fsf@kamboji.qca.qualcomm.com> <20150209.121342.1535841700027616341.davem@davemloft.net> <20150209203741.GG3566@tuxdriver.com>
In-Reply-To: <20150209203741.GG3566@tuxdriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2015 02:37 PM, John W. Linville wrote:
> On Mon, Feb 09, 2015 at 12:13:42PM -0800, David Miller wrote:
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Sat, 07 Feb 2015 13:40:51 +0200
>>
>>> There's a small conflict in drivers/net/wireless/rtlwifi/pci.c, the fix
>>> is to leave the two labels like this:
>>>
>>> 			schedule_work(&rtlpriv->works.lps_change_work);
>>> 		}
>>> end:
>>> 		skb = new_skb;
>>> no_new:
>>> 		if (rtlpriv->use_new_trx_flow) {
>>>
>>>
>>
>> That can't be the correct resolution:
>>
>> drivers/net/wireless/rtlwifi/pci.c: In function ‘_rtl_pci_rx_interrupt’:
>> drivers/net/wireless/rtlwifi/pci.c:934:1: warning: label ‘end’ defined but not used [-Wunused-label]
>>
>> So I've removed that label in the merge commit.
>
> FWIW, that's the way I have it in wireless-testing as well..

I must have missed the pull request. Removal of the label "end" is correct.

Larry



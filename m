Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65023 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbbAZINv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:13:51 -0500
Received: by mail-wi0-f174.google.com with SMTP id n3so8104178wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 00:13:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87y4osgn8n.fsf@kamboji.qca.qualcomm.com>
References: <1421412811-6387-1-git-send-email-michal.kazior@tieto.com>
	<1421412811-6387-2-git-send-email-michal.kazior@tieto.com>
	<87y4osgn8n.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 26 Jan 2015 09:13:50 +0100
Message-ID: <CA+BoTQ=L6m2nJzCRMW3QZn4CyYHZ94bK=1gk_iMk7iOGt8nEbw@mail.gmail.com> (sfid-20150126_091356_496984_EE5FD974)
Subject: Re: [PATCH 2/2] ath10k: fix beacon deadlock
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 January 2015 at 17:24, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This should fix a very rare occurrence of the following deadlock:
>>
>>   [<ffffffffa018265e>] ath10k_wmi_tx_beacons_nowait+0x1e/0x50 [ath10k_core]
>>   [<ffffffffa01829b6>] ath10k_wmi_op_ep_tx_credits+0x16/0x40 [ath10k_core]
>>   [<ffffffffa017d685>] ath10k_htc_send+0x285/0x3d0 [ath10k_core]
>>   [<ffffffffa0184b81>] ath10k_wmi_cmd_send_nowait+0x81/0x110 [ath10k_core]
>>   [<ffffffffa0184c61>] ath10k_wmi_tx_beacon_nowait.part.33+0x51/0x90 [ath10k_core]
>>   [<ffffffffa0184cd0>] ath10k_wmi_tx_beacons_iter+0x30/0x40 [ath10k_core]
>>   [<ffffffff81882246>] __iterate_active_interfaces+0xa6/0x100
>>   [<ffffffffa0184ca0>] ? ath10k_wmi_tx_beacon_nowait.part.33+0x90/0x90 [ath10k_core]
>>   [<ffffffff818822ae>] ieee80211_iterate_active_interfaces_atomic+0xe/0x10
>>   [<ffffffffa0182676>] ath10k_wmi_tx_beacons_nowait+0x36/0x50 [ath10k_core]
>>   [<ffffffffa01829b6>] ath10k_wmi_op_ep_tx_credits+0x16/0x40 [ath10k_core]
>>   [<ffffffffa017d140>] ath10k_htc_rx+0x280/0x410 [ath10k_core]
>>   [<ffffffffa01bcbf0>] ? ath10k_ce_completed_recv_next+0x60/0x80 [ath10k_pci]
>>   [<ffffffffa01bc6ab>] ath10k_pci_ce_recv_data+0x11b/0x1d0 [ath10k_pci]
>>   [<ffffffffa01bcf44>] ath10k_ce_per_engine_service+0x64/0xc0 [ath10k_pci]
>>   [<ffffffffa01bcfc2>] ath10k_ce_per_engine_service_any+0x22/0x50 [ath10k_pci]
>>   [<ffffffffa01bc4d0>] ath10k_pci_tasklet+0x30/0x90 [ath10k_pci]
>>   [<ffffffff81055a55>] tasklet_action+0xc5/0x100
>>
>> To prevent this make sure to release ar->data_lock
>> while calling to ath10k_wmi_beacon_send_ref_nowait().
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This introduces a new warning from kbuild:
>
> tree:   git://github.com/kvalo/ath ath-next-test
> head:   59030a70b61c41268383d1406bb49fc559e0da4e
> commit: 60845cf1bc104bbec7509eb4b6c9f09a1559bfdc [104/113] ath10k: fix beacon deadlock
>
> New smatch warnings:
> drivers/net/wireless/ath/ath10k/wmi.c:969 ath10k_wmi_tx_beacon_nowait() warn: variable dereferenced before check 'bcn' (see line 967)

>From a practical standpoint there is no dereference because control
buffer is inlined in sk_buff and it ends up just as an offset to the
sk_buff. I guess smatch couldn't figure this out due to macros.

When I run smatch (tip) locally it doesn't complain about this. Maybe
I'm missing some parameters?

I'll post a v2 later.


Michał

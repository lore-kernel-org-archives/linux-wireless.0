Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3084 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbcF2IYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 04:24:30 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] mac80211: fix fq lockdep warnings
Date: Wed, 29 Jun 2016 08:24:25 +0000
Message-ID: <874m8c9zd5.fsf@kamboji.qca.qualcomm.com> (sfid-20160629_102439_168186_DE7AC4A5)
References: <878txzo7c6.fsf@kamboji.qca.qualcomm.com>
	<1467026569-19329-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1467026569-19329-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 27 Jun 2016 13:22:49 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some lockdep assertions were not fulfilled and
> resulted in a kernel warning/call trace.
>
> Existing code sequences should've guranteed safety
> but it's always good to be extra careful.
>
> The call trace could look like this:
>
>  [ 237.335805] ------------[ cut here ]------------
>  [ 237.335852] WARNING: CPU: 3 PID: 1921 at include/net/fq_impl.h:22 fq_flow_dequeue+0xed/0x140 [mac80211]
>  [ 237.335855] Modules linked in: ath10k_pci(E-) ath10k_core(E) ath(E) mac80211(E) cfg80211(E)
>  [ 237.335913] CPU: 3 PID: 1921 Comm: rmmod Tainted: G        W   E   4.7.0-rc4-wt-ath+ #1377
>  [ 237.335916] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
>  [ 237.335918]  00200286 00200286 eff85dac c14151e2 f901574e 00000000 eff85de0 c1081075
>  [ 237.335928]  c1ab91f0 00000003 00000781 f901574e 00000016 f8fbabad f8fbabad 00000016
>  [ 237.335938]  eb24ff60 00000000 ef3886c0 eff85df4 c10810ba 00000009 00000000 00000000
>  [ 237.335948] Call Trace:
>  [ 237.335953]  [<c14151e2>] dump_stack+0x76/0xb4
>  [ 237.335957]  [<c1081075>] __warn+0xe5/0x100
>  [ 237.336002]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
>  [ 237.336046]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
>  [ 237.336053]  [<c10810ba>] warn_slowpath_null+0x2a/0x30
>  [ 237.336095]  [<f8fbabad>] fq_flow_dequeue+0xed/0x140 [mac80211]
>  [ 237.336137]  [<f8fbc67a>] fq_flow_reset.constprop.56+0x2a/0x90 [mac80211]
>  [ 237.336180]  [<f8fbc79a>] fq_reset.constprop.59+0x2a/0x50 [mac80211]
>  [ 237.336222]  [<f8fc04e8>] ieee80211_txq_teardown_flows+0x38/0x40 [mac80211]
>  [ 237.336258]  [<f8f7c1a4>] ieee80211_unregister_hw+0xe4/0x120 [mac80211]
>  [ 237.336275]  [<f933f536>] ath10k_mac_unregister+0x16/0x50 [ath10k_core]
>  [ 237.336292]  [<f934592d>] ath10k_core_unregister+0x3d/0x90 [ath10k_core]
>  [ 237.336301]  [<f85f8836>] ath10k_pci_remove+0x36/0xa0 [ath10k_pci]
>  [ 237.336307]  [<c1470388>] pci_device_remove+0x38/0xb0
>  ...
>
> Fixes: 5caa328e3811 ("mac80211: implement codel on fair queuing flows")
> Fixes: fa962b92120b ("mac80211: implement fair queueing per txq")
> Reported-by: Valo, Kalle <kvalo@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>

> Can you verify this fixes call traces you're
> seeing, please?

Yup, I don't see the warnings anymore. I tried multiple times, rebooting
etc. Thanks for fixing this.

-- 
Kalle Valo
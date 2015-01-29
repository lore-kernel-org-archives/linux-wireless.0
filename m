Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42003 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbA2Quo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 11:50:44 -0500
Message-ID: <54CA64E2.2050502@candelatech.com> (sfid-20150129_175048_004808_A7F9341C)
Date: Thu, 29 Jan 2015 08:50:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: YanBo <dreamfly281@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 2/5] ath10k: fix wmi-htc tx credit starvation
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <1397040531-6224-1-git-send-email-michal.kazior@tieto.com> <1397040531-6224-3-git-send-email-michal.kazior@tieto.com> <CAFuUQkiVB7DVXpBCrSy_LFMCm3CX9wPi_awq3x16FHDB2OmasA@mail.gmail.com> <CA+BoTQnXPMT3xQ=kmV5hdXgffZUB=tBvVnsawvzLATajPzoYsg@mail.gmail.com>
In-Reply-To: <CA+BoTQnXPMT3xQ=kmV5hdXgffZUB=tBvVnsawvzLATajPzoYsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2015 11:57 PM, Michal Kazior wrote:
> On 29 January 2015 at 02:32, YanBo <dreamfly281@gmail.com> wrote:
>> Hi Michal,
>>
>> What the conclusion about this patch, it  looks like this patch not be
>> merged into ath10K due to introduce some unstable issue, I'v got
>> another issue that when move the station enter hibernate mode. the AP
>> will continue report message like before
>> [ 3958.681293] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3959.681449] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3960.681696] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3961.681877] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3962.682080] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3963.682361] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3964.682550] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
>> [ 3965.682743] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
>> 00:03:7f:40:04:5b
> 
> The spurious STA kickout alone is most likely an aftermath of HTX Tx
> credit starvation when client was detected as inactive by hostapd and
> was subsequently disassociated. However due to starvation
> wmi-peer-delete was never sent to firmware so fw thinks the peer is
> still there.
> 
> I suppose fw should be restarted when ath10k is unable to submit a
> configuration command like wmi-peer-delete. It doesn't make sense to
> continue since fw-host state loses coherency and weird things can
> start to happen (spurious sta kickout is the best known example).

At least some of the tx-credits problem is in firmware, but
regardless of that:

Instead of restarting firmware in this case, maybe change the
'wait-for-3-seconds' timeout to 3 1-second timeouts, and
on second timeout force a flush, ignoring tx-credits if
required?  That may not be pretty, but seems better than resetting
firmware if it works.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64179 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbbA2H5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 02:57:15 -0500
Received: by mail-wi0-f174.google.com with SMTP id n3so22175055wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2015 23:57:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFuUQkiVB7DVXpBCrSy_LFMCm3CX9wPi_awq3x16FHDB2OmasA@mail.gmail.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-3-git-send-email-michal.kazior@tieto.com>
	<CAFuUQkiVB7DVXpBCrSy_LFMCm3CX9wPi_awq3x16FHDB2OmasA@mail.gmail.com>
Date: Thu, 29 Jan 2015 08:57:13 +0100
Message-ID: <CA+BoTQnXPMT3xQ=kmV5hdXgffZUB=tBvVnsawvzLATajPzoYsg@mail.gmail.com> (sfid-20150129_085720_024670_7A2644FB)
Subject: Re: [RFTv2 2/5] ath10k: fix wmi-htc tx credit starvation
From: Michal Kazior <michal.kazior@tieto.com>
To: YanBo <dreamfly281@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 January 2015 at 02:32, YanBo <dreamfly281@gmail.com> wrote:
> Hi Michal,
>
> What the conclusion about this patch, it  looks like this patch not be
> merged into ath10K due to introduce some unstable issue, I'v got
> another issue that when move the station enter hibernate mode. the AP
> will continue report message like before
> [ 3958.681293] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3959.681449] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3960.681696] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3961.681877] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3962.682080] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3963.682361] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3964.682550] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b
> [ 3965.682743] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
> 00:03:7f:40:04:5b

The spurious STA kickout alone is most likely an aftermath of HTX Tx
credit starvation when client was detected as inactive by hostapd and
was subsequently disassociated. However due to starvation
wmi-peer-delete was never sent to firmware so fw thinks the peer is
still there.

I suppose fw should be restarted when ath10k is unable to submit a
configuration command like wmi-peer-delete. It doesn't make sense to
continue since fw-host state loses coherency and weird things can
start to happen (spurious sta kickout is the best known example).


> and there are also error message like this be happened at early time:
>
>
> [ 1316.883053] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
>
> [ 1316.912357] ath10k_pci 0000:01:00.0: failed to transmit management
> frame via WMI: -11
>
> [ 1316.985476] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
>
> I suspect it is triggered as you mentioned because the HTC Tx credits
> are drained
> to 0 and no other commands can be submitted,  if the answer is yes,
> I'd hear your suggestion about whether this patch still  worth to be
> continue improve to solve such kinds of issue.

Yep, looks like the starvation issue.

The problem with the patch is it creates ugly latencies. This has been
reported by Avery[1] (he used/uses this patch internally for his
purposes).

Ideally mgmt frames should be sent via HTT. 10.2 is capable of sending
raw frames via HTT so it might be possible to utilize that and forgo
WMI mgmt tx for 10.2+. I did a proof-of-concept for raw tx on 10.2
some time ago [2] but I'm haven't tested how it interacts with
powersave buffering.


[1]: http://thread.gmane.org/gmane.linux.drivers.ath10k.devel/638
[2]: http://thread.gmane.org/gmane.linux.drivers.ath10k.devel/246


Michał

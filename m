Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45782 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaEWHJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:09:30 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so4311994wgh.4
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 00:09:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87tx8hwyul.fsf@kamboji.qca.qualcomm.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<87tx8hwyul.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 May 2014 09:09:28 +0200
Message-ID: <CA+BoTQ=WsP2HNBCGOb-Vem80sN7FvnPA_2B2=sShdgW_+fpvTg@mail.gmail.com> (sfid-20140523_090933_713952_C482110B)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 18:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If ath10k was built into the kernel it could stall
>> booting for 120 seconds by default (60 seconds for
>> each firmware API variant) waiting for firmware
>> files before userspace was ready or filesystems
>> mounted.
>>
>> Fix this by making the core registering
>> asynchronous.
>>
>> This also shoves off about 1 second from boot time
>> on most systems since the driver is now mostly
>> initialized in a worker and modprobe takes very
>> little time to complete.
>>
>> As a side effect there's no way to propagate
>> registering errors to the pci subsystem but this
>> probably isn't really necessary.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I see a new sparse warning with this patch:
>
> drivers/net/wireless/ath/ath10k/core.c:956:6: warning: symbol 'ath10k_core_register_work' was not declared. Should it be static?

Yeah. I forgot to add static keyword since I've played a little around
the code ealier. I'll fix it, thanks!


Michał

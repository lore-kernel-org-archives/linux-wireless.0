Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36152 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcFJJKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 05:10:45 -0400
Received: by mail-wm0-f43.google.com with SMTP id n184so257987754wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 02:10:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru> <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com>
 <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 10 Jun 2016 11:10:43 +0200
Message-ID: <CA+BoTQ=xWetiO9GK_staz=M=rAT4_tA5khedqn206mjyRHsmQg@mail.gmail.com> (sfid-20160610_111051_322091_FF8AB05C)
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
To: Felix Fietkau <nbd@nbd.name>
Cc: "A. Benz" <ash.benz@bk.ru>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2016 at 10:55, Felix Fietkau <nbd@nbd.name> wrote:
> On 2016-06-10 10:50, Michal Kazior wrote:
>> On 9 June 2016 at 09:46, A. Benz <ash.benz@bk.ru> wrote:
>>> Dear All,
>>>
>>> I am using LEDE on my IPQ806x (QCA9980) system (Archer C2600).
>>> With compat-wireless-2016-05-12, I observed traces attached below.
>>> The router is unstable and eventually reboots by itself (randomly).
>>>
>>> Upon reverting to compat-wireless-2016-01, the issue disappears. Nothing
>>> else is changed (software-wise or hardware).
>>> This was confirmed with other users.
>>>
>>> A new compile with the fixes below:
>>> https://git.lede-project.org/?p=lede/nbd/staging.git;a=commit;h=858e26f3c0fc11231f25497cbb2ddca1e5f101e0
>>>
>>> Did not solve the problem.
>>>
>>> Please let me know if I need to provide any further information.
>>>
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 558 at
>>> compat-wireless-2016-05-12/net/mac80211/rx.c:4068
>>> ieee80211_rx_napi+0x8c/0x8a4 [mac80211]()
>>
>> Can you post what is at rx.c line 4068 (and +/- 3 lines), please?
> It's early in ieee80211_rx_napi:
>
>     sband = local->hw.wiphy->bands[status->band];
>     if (WARN_ON(!sband))
>         goto drop;

Thanks.


> I could not easily find a scenario under which status->band would not be
> set properly by the driver, so my guess is there is some nasty memory
> corruption going on.

Hmm.. could it be related to ath10k not fulfilling (some) NAPI's
locking requirements and thus ending up with, e.g. linked-list mayhem?


Michał

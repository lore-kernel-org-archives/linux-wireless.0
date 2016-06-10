Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbcFJMWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:22:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"A. Benz" <ash.benz@bk.ru>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru>
	<CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com>
	<d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
Date: Fri, 10 Jun 2016 15:22:42 +0300
In-Reply-To: <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name> (Felix Fietkau's
	message of "Fri, 10 Jun 2016 10:55:36 +0200")
Message-ID: <877fdxfd2l.fsf@kamboji.qca.qualcomm.com> (sfid-20160610_142330_525694_5EE6EC6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

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
>
> I could not easily find a scenario under which status->band would not be
> set properly by the driver, so my guess is there is some nasty memory
> corruption going on.
>
> FWIW, I've received several reports like this from different people on
> different devices. They're also confirming that reverting to the
> snapshot from January makes things stable again.

Adding ath10k list to the loop.

-- 
Kalle Valo

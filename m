Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33741 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbcHCHJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 03:09:34 -0400
Received: by mail-wm0-f54.google.com with SMTP id p129so63116160wmp.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 00:09:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <579B71B4.7080206@candelatech.com>
References: <1469608424-11370-1-git-send-email-benjamin@sipsolutions.net>
 <5798EEC3.5040008@candelatech.com> <1469803947.7306.139.camel@sipsolutions.net>
 <579B71B4.7080206@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 3 Aug 2016 09:09:31 +0200
Message-ID: <CA+BoTQkbM8uQoOWhXnKp+qJXxnnvHXeW4rV_fSuy3ftzLgMsww@mail.gmail.com> (sfid-20160803_090937_414395_129AE43D)
Subject: Re: [PATCH] ath10k: Allow setting coverage class
To: Ben Greear <greearb@candelatech.com>
Cc: Benjamin Berg <benjamin@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
	Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 July 2016 at 17:09, Ben Greear <greearb@candelatech.com> wrote:
> On 07/29/2016 07:52 AM, Benjamin Berg wrote:
[...]
>> Yeah, I am aware of the fact that the firmware may do internal resets
>> from time to time. The interesting question (and one for which I do not
>> know the answer) is whether we get a wmi or other event under all
>> conditions where the register may be rewritten due to a reset.
>>
>> The current code will re-set the register value after any wmi event
>> including debug messages. If this is not enough, then the only solution
>> might be to periodically poll the register values instead of relying on
>> a received event.
>
> You will get a dbglog event at least most of the time, so maybe that
> will be good enough.

But you need to remember you need to enable dbglog first to get these
events. I guess when coverage class is set the driver could,
internally, override dbglog mask so that these events are guaranteed
to be reported for the purpose of properly refreshing registers on
channel programming.

At that point I guess the update hook could be just placed in dbglog
handler alone instead of all over wmi_rx variants.


Michał

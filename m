Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44800 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HSRiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 13:38:09 -0400
Received: by iye16 with SMTP id 16so5917564iye.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 10:38:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131E1CA9A@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
 <CAEsZsEjRwJs-YTfWgunzPmh56t4KaQ2sPG_n0W5KitfWL-AcKQ@mail.gmail.com> <AC090B9732AB2B4DB7FF476E907FE6600131E1CA9A@dnce02.ent.ti.com>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Fri, 19 Aug 2011 14:37:49 -0300
Message-ID: <CAEsZsEg=-EWO566OFFmp=EY-FtD39+c2k1vxyUFbQX198hcykg@mail.gmail.com> (sfid-20110819_193814_899698_6475027F)
Subject: Re: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
To: "Elias, Ilan" <ilane@ti.com>
Cc: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Ilan,

On Thu, Aug 18, 2011 at 3:43 AM, Elias, Ilan <ilane@ti.com> wrote:
>> What happens if the driver is polling for targets or even with a
>> remote target activated? The nfc_dev structure has some control to
>> track the driver state (e.g. dev->polling) that must have their values
>> updated. Otherwise, the next start_poll() call would fail with EBUSY.
> You're correct, of course.
> When dev_down is called and we have some active operation (e.g. polling,
> active target), there are 2 approaches:
> 1) stop internally any active operations and update internal states
> (e.g. dev->polling). Please note that if we have an active data exchange,
> the callback might not be called at all.
> 2) simply return EBUSY and let the upper layers handle it.

We don't use to interrupt a running command when a new one arrives.
However, if dev_down/dev_up commands are intending to be used also as
a reset procedure, the first approach is more suitable.

Until now we didn't face any situation that required a reset
procedure. So i would go with the second approach.

> With both approaches, we'll have to keep track of active target state
> (in addition to dev->polling). Which option do you prefer?

Yes, that's true. Something like dev->remote_activated will be needed.

Regards,
Aloisio

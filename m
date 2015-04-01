Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33284 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbbDAN7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 09:59:13 -0400
Received: by iebmp1 with SMTP id mp1so36295601ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2015 06:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPZAZS58=O1SHtnDeVrGLpvpBAg85-WQ_LNbsuqDbAu5GeQXBA@mail.gmail.com>
References: <CAPZAZS58=O1SHtnDeVrGLpvpBAg85-WQ_LNbsuqDbAu5GeQXBA@mail.gmail.com>
Date: Wed, 1 Apr 2015 15:59:12 +0200
Message-ID: <CAAd0S9A=M1L+cE0e9LiQfcmYEaN0WnaX4csnFaORUH3jgN9ayQ@mail.gmail.com> (sfid-20150401_155916_739180_E10903E4)
Subject: Re: Wireless Module: Carl9170 driver and firmware communication
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ashkan Parcham Kashani <ashkan.parchamkashani@mail.utoronto.ca>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tue, Mar 31, 2015 at 2:40 AM, Ashkan Parcham Kashani
<ashkan.parchamkashani@mail.utoronto.ca> wrote:
> I'm working on a project where I need to communicate some additional
> control information between the carl9170 driver and firmware. I am not
> exactly sure where the best place to add this extra information would be.
> I assumed that the DMA might work if I can extend it and reserve some
> space for the controls. I only need a few bytes for the communication.

Should be doable. Add your fields to the "_carl9170_tx_superdesc"
and "carl9170_tx_superdesc" for both the driver and the firmware
and recompile. Watch out: the size of the structs should be a
multiple of 4. (Note: this is only for TX!)

> I also considered using device registers for this, but it's hard to
> find documentation of which registers may be free to use.
This is way easier, as the modified firmware will continue to work
with the standard driver and vice versa. The driver can directly
write into and read from the program/data ram of the firmware.
Add your fields to the firmware_context_struct in carlfw/include/carl9170.h
and add a handle_mywork() into main_loop() in carlfw/src/main.c.

> I'm also wondering how one would go about interrupting the firmware.
> At times, the driver will need to interrupt the firmware, in which
> case the firmware should stop transmitting any packets it is currently
> transmitting.
Depends on how you implement it. There's a watchdog that needs to
be serviced. If you don't want to deal with the dog, you can set (stops
TX) or clear (resumes TX) the AR9170_MAC_VIRTUAL_CCA_QX bits
in the "AR9170_MAC_REG_QOS_PRIORITY_VIRTUAL_CCA" register.

Note: The firmware doesn't have any real interrupt handling.

Regards,
   Christian

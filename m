Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936606AbcJ0N7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 09:59:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        briannorris@google.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in remove_card
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
        <1477318892-22877-5-git-send-email-akarwar@marvell.com>
        <20161025001405.GE15034@dtor-ws>
Date: Thu, 27 Oct 2016 16:20:25 +0300
In-Reply-To: <20161025001405.GE15034@dtor-ws> (Dmitry Torokhov's message of
        "Mon, 24 Oct 2016 17:14:05 -0700")
Message-ID: <87d1imudwm.fsf@purkki.adurom.net> (sfid-20161027_160132_013512_69FEF4F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

>> +/* reset_trigger variable is used to identify if mwifiex_sdio_remove()
>> + * is called by sdio_work during reset or the call is from sdio subsystem.
>> + * We will cancel sdio_work only if the call is from sdio subsystem.
>> + */
>> +static u8 reset_triggered;
>
> It would be really great if the driver supported multiple devices. IOW
> please avoid module-globals.

Good catch, it's a hard requirement to support multiple devices at the
same time.

-- 
Kalle Valo

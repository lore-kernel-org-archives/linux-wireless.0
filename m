Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42729 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1HQWmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 18:42:52 -0400
Received: by iye16 with SMTP id 16so2727521iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 15:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131E1C412@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com> <AC090B9732AB2B4DB7FF476E907FE6600131E1C412@dnce02.ent.ti.com>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Wed, 17 Aug 2011 19:42:32 -0300
Message-ID: <CAEsZsEgvr_GPZvmqx_xrA2ACBKOLvEhvTaZ_FijQb_dh9K7FCw@mail.gmail.com> (sfid-20110818_004255_557580_FB8FBD44)
Subject: Re: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
To: "Elias, Ilan" <ilane@ti.com>
Cc: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Wed, Aug 17, 2011 at 3:33 AM, Elias, Ilan <ilane@ti.com> wrote:
> Hi Aloisio, Lauro, Samuel,
>
>>
>> The following 2 NFC control operations (via generic netlink) were added:
>>       - Dev_up, which turn on the NFC controller (this operation may take
>> a     few seconds, as it can download new FW to the NFC controller)
>>       - Dev_down, which turn off the NFC controller
>>
> Please note that in the file core.c, the new flag 'dev_up' is not checked in the nfc core API (e.g. in the function nfc_start_poll).
> We should discuss whether the dev_up/dev_down operations will be used in all devices (i.e. also PN533) - this is my preference.

I agree. In order to abstract the NFC device type that is being used,
dev_up must be called before start_poll to all devices. The driver
must be in charge of deciding if something must be done at dev_up
time.

Regards,
Aloisio

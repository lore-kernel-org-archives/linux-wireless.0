Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45820 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0KDAUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 20:20:01 -0400
Received: by wyf28 with SMTP id 28so1274674wyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 17:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101102083035.GM1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
 <1288659351-22313-6-git-send-email-brian@cozybit.com> <20101102083035.GM1733@mail.wantstofly.org>
From: Brian Cavagnolo <brian@cozybit.com>
Date: Wed, 3 Nov 2010 17:19:39 -0700
Message-ID: <AANLkTim3x5dNtdKuyQBqB5edtb+REuc90CVEAoyyLgRP@mail.gmail.com>
Subject: Re: [PATCH 6/7] mwl8k: choose proper firmware image as directed by user
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 2, 2010 at 1:30 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Mon, Nov 01, 2010 at 05:55:50PM -0700, Brian Cavagnolo wrote:
>
>> The mwl8k can operate in AP or STA mode, depending on the
>> firmware image that is loaded.  Allow the user to specify
>> the desired firmware image at module load time.
>
> Strong NAK on selecting firmware image type with a module parameter,
> that's so wrong it's not even funny.
>
> Just use the STA image before ->add_interface() has been called if
> it is available.

The intention here is to save users who wish to only operate in AP
mode from sustaining an unnecessary firmware re-load.  Can you
elaborate on why it is unacceptable to achieve this with a module
parameter?  Perhaps just calling it ap_mode instead of want_ap_fw
makes more sense?

> And please switch to async firmware loading while you're at it.

Okay.

>> Also, the firmware image can be swapped to meet the user's
>> add_interface request.  For example, suppose the STA
>> firmware is loaded, no STA interface has been added, and the
>> user adds an AP interface.  In this case, the AP firmware
>> will be loaded to meet the request.
>>
>> Based on a patch from Pradeep Nemavat <pnemavat@marvell.com>
>
> Which was suggested by Lennert Buytenhek -- please give credit where
> it is due.
>

My apologies.  Understood.

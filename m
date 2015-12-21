Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38773 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbLUSZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 13:25:08 -0500
Received: by mail-wm0-f51.google.com with SMTP id l126so81467997wml.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 10:25:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56783C98.1080700@lwfinger.net>
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
 <1450664916-25205-2-git-send-email-dlenski@gmail.com> <56783C98.1080700@lwfinger.net>
From: Daniel Lenski <dlenski@gmail.com>
Date: Mon, 21 Dec 2015 10:24:27 -0800
Message-ID: <CAOw_LSF6cPVCxqOS1eQ+iqESZGRdG46048M15r5s0huVJVHwjg@mail.gmail.com> (sfid-20151221_192513_625881_8150B79C)
Subject: Re: [PATCH] enable setting MAC address for r8723au
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 9:53 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/20/2015 08:28 PM, Dan Lenski wrote:
>>
>> Signed-off-by: Dan Lenski <dlenski@gmail.com>
>
>
> The commit message should be in this patch rather than in the non-patch
> previous mail. If this patch were to be accepted, all that explanation would
> be lost!
>
> Rather than issuing a warning when the MAC is changed after the interface
> has been brought up, have you considered changing the value of
> rtw_adapter->bup to zero whenever the connection goes down? Would that help
> with the confusion in the user-space tools?

No. rtw_adapter isn't visible to userspace at all. NetworkManager, for
instance, seems to get confused when *any* up interface changes its
MAC address.

bup should *not* be reset to zero when the device is closed.
netdev_open23a() checks or bup==0 and calls rtl8723au_hal_init() to do
hw initialization and firmware download if so. This is unnecessary
after subsequent re-opening, which is why netdev_close() doesn't set
bup=0.

> NACK.

I'll resubmit with the commit message fixed and the warning removed.

Dan

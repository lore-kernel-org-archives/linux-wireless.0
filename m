Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbbLWLSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 06:18:35 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] enable setting MAC address for r8723au
References: <1450664916-25205-1-git-send-email-dlenski@gmail.com>
	<1450664916-25205-2-git-send-email-dlenski@gmail.com>
	<56783C98.1080700@lwfinger.net>
	<CAOw_LSF6cPVCxqOS1eQ+iqESZGRdG46048M15r5s0huVJVHwjg@mail.gmail.com>
Date: Wed, 23 Dec 2015 06:18:33 -0500
In-Reply-To: <CAOw_LSF6cPVCxqOS1eQ+iqESZGRdG46048M15r5s0huVJVHwjg@mail.gmail.com>
	(Daniel Lenski's message of "Mon, 21 Dec 2015 10:24:27 -0800")
Message-ID: <wrfjpoxxxvjq.fsf@redhat.com> (sfid-20151223_121839_199564_7F21C635)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> On Mon, Dec 21, 2015 at 9:53 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 12/20/2015 08:28 PM, Dan Lenski wrote:
>>>
>>> Signed-off-by: Dan Lenski <dlenski@gmail.com>
>>
>>
>> The commit message should be in this patch rather than in the non-patch
>> previous mail. If this patch were to be accepted, all that explanation would
>> be lost!
>>
>> Rather than issuing a warning when the MAC is changed after the interface
>> has been brought up, have you considered changing the value of
>> rtw_adapter->bup to zero whenever the connection goes down? Would that help
>> with the confusion in the user-space tools?
>
> No. rtw_adapter isn't visible to userspace at all. NetworkManager, for
> instance, seems to get confused when *any* up interface changes its
> MAC address.
>
> bup should *not* be reset to zero when the device is closed.
> netdev_open23a() checks or bup==0 and calls rtl8723au_hal_init() to do
> hw initialization and firmware download if so. This is unnecessary
> after subsequent re-opening, which is why netdev_close() doesn't set
> bup=0.
>
>> NACK.
>
> I'll resubmit with the commit message fixed and the warning removed.
>

In addition, do *not* overwrite the eeprompriv.mac_addr - that struct is
a clean copy of the eeprom's data and should not be modified.

Please changed the dev entry and make sure they driver updates from
there instead.

Second, please CC me directly as the driver maintainer.

For longer term, please try out rtl8xxxu, hopefully we can
rm -rf drivers/staging/rtl8723au soon.

Jes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56319 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2CTO3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:29:34 -0400
Received: by vbbff1 with SMTP id ff1so35910vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 07:29:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V4NuNc8Xr3qKAaXgs2og-2e6qusek=ZFdvQCq4JtKavQ@mail.gmail.com>
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	<1332214021-9716-3-git-send-email-mcgrof@frijolero.org>
	<1332245223.3329.5.camel@jlt3.sipsolutions.net>
	<CAB=NE6V4NuNc8Xr3qKAaXgs2og-2e6qusek=ZFdvQCq4JtKavQ@mail.gmail.com>
Date: Tue, 20 Mar 2012 10:29:33 -0400
Message-ID: <CAJdJm_MD1QQG3hyQmo-RffeObGBSViLAOBZeyRJqoEbh0x2PMA@mail.gmail.com> (sfid-20120320_152952_379172_B7859CD5)
Subject: Re: [Lf_driver_backport] [PATCH 2/4] compat: backport work_busy()
From: Anderson Lizardo <anderson.lizardo@openbossa.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andre Guedes <andre.guedes@openbossa.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luiz,

[I'm subscribed only to lf_driver_backport]

On Tue, Mar 20, 2012 at 9:50 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Tue, Mar 20, 2012 at 5:07 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2012-03-19 at 20:26 -0700, Luis R. Rodriguez wrote:
>>> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
>>>
>>> Best we can do is just tell the users of we are WORK_BUSY_PENDING
>>> for older kernels. The ckmake log:
>>
>> [...]
>>
>>> + * Test whether @work is currently pending or running.  There is no
>>> + * synchronization around this function and the test result is
>>> + * unreliable and only useful as advisory hints or for debugging.
>>> + * Especially for reentrant wqs, the pending state might hide the
>>> + * running state.
>>
>> What's this needed for? It seems if it's used only for hints/debugging
>> we should not need the function, or possibly simply return some
>> pointless combination like -1?
>
> net/bluetooth/hci_core.c:1701:  if (work_busy(&hdev->le_scan))

Did you consider making this change bluetooth specific (e.g. under
patches/16-bluetooth.patch with LINUX_VERSION_CODE check) so that
work_pending() is used on this location for older kernels? Or are
there other users for work_busy() besides bluetooth?

I talked with the author of this code (CC'd) and he said it should be
safe to make this replacement.

Another change I made sometime ago (specifically to bluetooth code)
for it to build with older kenels (2.6.32 in my case), was to change
this line in net/bluetooth/hci_core.c:

queue_work(system_long_wq, &hdev->le_scan);

to:

schedule_work(&hdev->le_scan);

Again, I checked with the original author and we believe it is okay to
do this (I also lightly tested these changes).

Hope that helps. Best Regards,
-- 
Anderson Lizardo
Instituto Nokia de Tecnologia - INdT
Manaus - Brazil

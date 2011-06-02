Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42638 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1FBRXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 13:23:16 -0400
Received: by qwk3 with SMTP id 3so471514qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 10:23:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110531093201.GA15266@redhat.com>
References: <20110529104529.GA2769@localhost.localdomain>
	<BANLkTinABm=J0eZnwAjkYPwA1e3AgoFW6Q@mail.gmail.com>
	<20110531093201.GA15266@redhat.com>
Date: Thu, 2 Jun 2011 19:23:15 +0200
Message-ID: <BANLkTin8xTf2AJGfXwo1RiA72gE=GtAakg@mail.gmail.com> (sfid-20110602_192320_856750_69ACE3F3)
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Well isn't the bug then that autowakeup_work isn't cancelled using
>> cancel_work_sync
>> like the other workqueue tasks?
>>
>> I rather add the call to cancel_work_sync then moving the killing of
>> the workqueue.
>> The position where the workqueue is destroyed should be the place
>> where we cancel
>> all scheduled work, that way we can assume no rt2x00-related threads ater this
>> position.
>
> rt2x00lib_config() could be running simultaneously to rt2x00lib_remove_dev()
> and queue just canceled autowake_work again into (just destroyed) workqueue.
> Other solution to fix, would be use ieee80211_queue_work() instead of custom
> workqueue, is that better?

Well 3 things are needed then,
1) Don't schedule autowake_work when DEVICE_PRESENT flag is not set
2) The handler for autowake_work should exit immediately when
DEVICE_PRESENT flag is not set
3) add a cancel_work_sync for the autowake_work inside remove_dev

That should effictively prevent the entire work structure from running
while the driver
is being rmmodded, or the device is being unplugged.

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f198.google.com ([209.85.210.198]:63554 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZGZIGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 04:06:42 -0400
Received: by yxe36 with SMTP id 36so1577205yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2009 01:06:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248510909.32151.48.camel@johannes.local>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
	<1248482853-17032-2-git-send-email-lrodriguez@atheros.com>
	<1248510909.32151.48.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 26 Jul 2009 01:06:22 -0700
Message-ID: <43e72e890907260106h1ad9cdd6i9dc22e3bfece86d8@mail.gmail.com>
Subject: Re: [PATCH] mac80211: redefine usage of the mac80211 workqueue
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Daniel Drake <ddrake@brontes3d.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 25, 2009 at 1:35 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-24 at 20:47 -0400, Luis R. Rodriguez wrote:
>> The mac80211 workqueue exists to enable mac80211 and drivers
>> to queue their own work on a single threaded workqueue. mac80211
>> takes care to flush the workqueue during suspend but we never
>> really had requirements on drivers for how they should use
>> the workqueue in consideration for suspend.
>>
>> We extend mac80211 to document how the mac80211 workqueue should
>> be used, how it should not be used and finally move raw access to
>> the workqueue to mac80211 only. Drivers and mac80211 use helpers
>> to queue work and flush the mac80211 workqueue:
>>
>>   * ieee80211_queue_work()
>>   * ieee80211_queue_delayed_work()
>>   * ieee80211_flush_workqueue()
>
> I would prefer to have wait_on_work()

That's currently static.

> and/or cancel_work_sync() instead
> of flushing?

That's fine but currently drivers are issuing flush_workqueue() directly.

> It's often preferable due to locking constraints to
> cancel_work_sync() instead of flush_workqueue(). Do people really need
> flush_workqueue()?

Yeah good point, so I see 2 users of flush_workqueue, one in at76 and
another on ar9170.

at76: at76_delete_device()

This is used at usb disconnect and probe failure. cancel_work_sync()
definitely seems more appropriate.

ar9170: ar9170_op_stop()

same here, but seems we could add the flush on mac80211 prior to
calling the drv_stop() currently we call it after.

  Luis

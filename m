Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:38777 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZG2UpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:45:24 -0400
Received: by an-out-0708.google.com with SMTP id d40so1234064and.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090729200036.GA10056@tuxdriver.com>
References: <1248733291-10848-1-git-send-email-lrodriguez@atheros.com>
	<20090729200036.GA10056@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 29 Jul 2009 13:45:03 -0700
Message-ID: <43e72e890907291345u5de674fem7b0769f52a7251c5@mail.gmail.com>
Subject: Re: [PATCH v3] mac80211: redefine usage of the mac80211 workqueue
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 1:00 PM, John W. Linville<linville@tuxdriver.com> wrote:
> On Mon, Jul 27, 2009 at 03:21:31PM -0700, Luis R. Rodriguez wrote:
>> The mac80211 workqueue exists to enable mac80211 and drivers
>> to queue their own work on a single threaded workqueue. mac80211
>> takes care to flush the workqueue during suspend but we never
>> really had requirements on drivers for how they should use
>> the workqueue in consideration for suspend.
>>
>> We extend mac80211 to document how the mac80211 workqueue should
>> be used, how it should not be used and finally move raw access to
>> the workqueue to mac80211 only. Drivers and mac80211 use helpers
>> to queue work onto the mac80211 workqueue:
>>
>>   * ieee80211_queue_work()
>>   * ieee80211_queue_delayed_work()
>>
>> These helpers will now warn if mac80211 already completed its
>> suspend cycle and someone is trying to queue work. mac80211
>> flushes the mac80211 workqueue prior to suspend a few times,
>> but we haven't taken the care to ensure drivers won't add more
>> work after suspend. To help with this we add a warning when
>> someone tries to add work and mac80211 already completed the
>> suspend cycle.
>>
>> Drivers should ensure they cancel any work or delayed work
>> in the mac80211 stop() callback.
>
> How are they supposed to do that after you've removed workqueue
> from the ieee80211_hw structure?

They do not refer to the mac80211 workqueue for that, they can cancel
work using cancel_work_sync(their_foo_work_struct).

> This breaks the compilation of
> at76c50x-usb.c...

Strange, I thought I tested that, will retest,

  Luis

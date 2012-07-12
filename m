Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:54361 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2GLQ0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:26:14 -0400
Received: by ghrr11 with SMTP id r11so2594830ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 09:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342108999.4531.34.camel@jlt3.sipsolutions.net>
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com>
	<1342108999.4531.34.camel@jlt3.sipsolutions.net>
Date: Thu, 12 Jul 2012 19:26:13 +0300
Message-ID: <CAB3XZEc0nk5xj10WadANvHaUxMYaZ9k26aCUnDbMDLGbTGEzPw@mail.gmail.com> (sfid-20120712_182617_777259_87192F64)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 7:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-07-12 at 19:00 +0300, Eliad Peller wrote:
>> On Thu, Jul 12, 2012 at 6:15 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > When bringing monitor mode up with a driver using the
>> > mac80211 virtual monitor interface this resulted in a
>> > warning because cfg80211_update_iface_num() is called
>> > from PRE_UP, which causes it to call mac80211 and the
>> > low-level driver before the device is started.
>> >
>> > For the case that another interface is added and the
>> > monitor interface should be removed, this is correct.
>> > However, in the case where a monitor interface is
>> > added, it's not correct as the above.
>> >
>> > To fix this, we need to split up the cases and track
>> > whether or not "only monitor" is active so that the
>> > code can correctly call into the driver when things
>> > change.
>
>> why not always do it only on IFACE_UP?
>
> Yeah .. thought so too at first, but it doesn't work, say you have this
> situation:
>
>  * up moni0 (monitor)
>  * up wlan0 (managed)
>
> Then the set_monitor_enabled(false) should happen before wlan0 is
> brought up, otherwise mac80211/the driver will correctly reject wlan0
> being brought up.
>
but you don't call set_monitor_enabled(false) on pre_up in your
patch... so i guess the driver will still get its add_interface
callback while the monitor is enabled?

afaict, the only effect of pre_up is updating
rdev->num_running_ifaces/rdev->num_running_monitor_ifaces, which don't
seem to matter much...

Eliad.

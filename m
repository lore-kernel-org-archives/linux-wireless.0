Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42858 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab2GLQht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:37:49 -0400
Received: by qcro28 with SMTP id o28so1634276qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 09:37:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342110662.4531.42.camel@jlt3.sipsolutions.net>
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com>
	<1342108999.4531.34.camel@jlt3.sipsolutions.net>
	<CAB3XZEc0nk5xj10WadANvHaUxMYaZ9k26aCUnDbMDLGbTGEzPw@mail.gmail.com>
	<1342110662.4531.42.camel@jlt3.sipsolutions.net>
Date: Thu, 12 Jul 2012 19:37:48 +0300
Message-ID: <CAB3XZEfP6qUfrnxeCHoJ_XrD4H_HjkVw685C04XCrVm=1wD8Mw@mail.gmail.com> (sfid-20120712_183757_920970_4209BD7D)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 7:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-07-12 at 19:26 +0300, Eliad Peller wrote:
>
>> >> why not always do it only on IFACE_UP?
>> >
>> > Yeah .. thought so too at first, but it doesn't work, say you have this
>> > situation:
>> >
>> >  * up moni0 (monitor)
>> >  * up wlan0 (managed)
>> >
>> > Then the set_monitor_enabled(false) should happen before wlan0 is
>> > brought up, otherwise mac80211/the driver will correctly reject wlan0
>> > being brought up.
>> >
>> but you don't call set_monitor_enabled(false) on pre_up in your
>> patch...
>
> It does, this is what happens when wlan0 is brought up:
>

>>       if (monitors_only) {
>
> no, we'll go into else
>
i completely overlooked this if :)

>> afaict, the only effect of pre_up is updating
>> rdev->num_running_ifaces/rdev->num_running_monitor_ifaces, which don't
>> seem to matter much...
>
> No :-)
>
thanks for the detailed walkthrough :D

Eliad.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43809 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZKQWDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:03:54 -0500
Received: by fxm21 with SMTP id 21so512692fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 14:03:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cb0375e10911061145ja572542hde731eee7279ea1@mail.gmail.com>
References: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
	 <1257327017.28469.76.camel@johannes.local>
	 <cb0375e10911061145ja572542hde731eee7279ea1@mail.gmail.com>
Date: Tue, 17 Nov 2009 17:03:59 -0500
Message-ID: <cb0375e10911171403g7863a37bscafab483836573a@mail.gmail.com>
Subject: Re: iwlwifi connection troubles, maybe aggregation related
From: Andrew Lutomirski <luto@mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>, oliver.greg@gmail.com
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg: I'm not sure your bug is the same as mine.  I don't get oopses.

This bug has been here for a long time and it's getting old, so it's
now #2120 :)

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2120

--Andy

On Fri, Nov 6, 2009 at 2:45 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Wed, Nov 4, 2009 at 4:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2009-11-03 at 18:38 -0500, Andrew Lutomirski wrote:
>>
>>> iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:21:d8:49:4a:52 tid = 0
>>
>>> Turning on or off power management and fiddling with
>>> no_sleep_autoadjust makes no difference.  Setting tx_agg_tid_enable to
>>> zero in debugfs while the connection was working seemed to make it a
>>> little more reliable (it lasted long enough to do "git pull" but not
>>> much longer).
>>>
>>> After running "iw dev wlan0 disconnect" a few times, I start to get
>>> errors like this:
>>>
>>> [18078.209635] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
>>> [18078.313461] iwlagn 0000:03:00.0: No space for Tx
>>> [18078.313467] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
>>> enqueue_hcmd failed: -28
>>> [18078.313470] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
>>> [18078.522409] iwlagn 0000:03:00.0: No space for Tx
>>> [18078.522414] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
>>> enqueue_hcmd failed: -28
>>
>> Sounds like the firmware messes up ...
>>
>> Maybe as a first workaround you could modprobe iwlagn with
>> 11n_disable=1. But I don't know at this point what the problem could be.
>
> 11n_disable50=1 seems to work.  I'll reply again if it stops working.
>
> Do the Intel folks have any ideas?
>
> Thanks,
> Andy
>

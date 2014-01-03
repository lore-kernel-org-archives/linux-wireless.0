Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59679 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaACLso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 06:48:44 -0500
Received: by mail-ie0-f172.google.com with SMTP id qd12so15944583ieb.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 03:48:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V6dmhE4GZhEthU08H+5CvKa0Z98mam4_dG-NEuwK4b5mkhaw@mail.gmail.com>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	<CA+V6dmhE4GZhEthU08H+5CvKa0Z98mam4_dG-NEuwK4b5mkhaw@mail.gmail.com>
Date: Fri, 3 Jan 2014 12:48:44 +0100
Message-ID: <CANq1E4RD=_y_TmTPsMsmZ4Jg628VmPWmz=EiByfAV5TxK3zV_w@mail.gmail.com> (sfid-20140103_124906_937543_1839BB71)
Subject: Re: Exporting the TSF to userland
From: David Herrmann <dh.herrmann@gmail.com>
To: Pierre Bourdon <delroth@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pierre

On Fri, Jan 3, 2014 at 2:07 AM, Pierre Bourdon <delroth@gmail.com> wrote:
> On Tue, Dec 31, 2013 at 5:24 AM, Pierre Bourdon <delroth@gmail.com> wrote:
>> Hello linux-wireless,
>>
>> I'm a developer of libdrc, a project that allows Linux computers to
>> control a Wii U GamePad. Because of how the device operates, our
>> library needs to be able to read the TSF value of the access point
>> device from userland.
>>
>> We currently have a hacky patch that works for our use cases, but it
>> would be a lot more convenient if that feature could be upstreamed.
>> What would be the best way to proceed?
>>
>> Our current patch:
>> https://bitbucket.org/memahaxx/drc-mac80211/commits/4a9823cf2a6733bc15a05cffaebd8850d07451a7
>
> To clarify: I have 0 experience developing "clean" stuff for the Linux
> driver (only hacky patches). A few simple questions that I have in
> order to make this patch more useful:

Usual procedure is to send the patch via git-send-email and people
will comment on it. Even if it's a hack, please send the patch. And
you might wanna CC the maintainers of the affected trees.

> * Is there some kind of "threshold" for features like this to be
> accepted upstream? How likely is it that this feature will get merged
> in the end?

If there's a use-case, it is very likely get merged (unless another
more appropriate API comes up). So just keep pushing on it, nobody
minds if you resend the patch if it was unanswered for a week.

> * Is there any framework for exporting data from mac80211 drivers to a
> /sys or /proc file? There is code that exports data to debugfs, but
> that is usually not mounted by default or enabled by distributions.
> Our patch currently uses a /sys file, but I think nothing else in
> mac80211 does anything like that so far.

>From inside of mac80211 we don't control any sysfs attributes, yet.
Furthermore, device_create_file() is usually racy with device_add(),
so you really should create global attributes via the .attr field of
devices (or classes/types). See net/wireless/sysfs.c.
But you probably don't want to introduce a reverse dependency on
mac80211 from net/wireless/, I am not sure what to do here.. others
should know better.

> * Should integer values be exported as human-readable ASCII base 10
> numbers in proc/sys files or is exporting the raw bytes as our patch
> currently does acceptable?

sysfs must be human-readable and 1-value-per-file. See
Documentation/filesystems/sysfs.txt.
So if there's no strong reason to change that, I'd say convert it to
ASCII and you're fine. You can choose a suitable base yourself, but
base-10 is a good default.

Regarding your patch:
 - please adjust your coding-style to Documentation/CodingStyle
 - The drv_add_interface() hack looks really weird.. are you sure you
don't wanna bail out instead?

Thanks
David

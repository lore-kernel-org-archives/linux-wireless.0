Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45235 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZHaSn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 14:43:26 -0400
Received: by mail-bw0-f219.google.com with SMTP id 19so2968529bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 11:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890908270243i7c1d8ddav322a35c566d2c010@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
	 <3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
	 <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
	 <1251357267.20531.4.camel@johannes.local>
	 <3ace41890908270243i7c1d8ddav322a35c566d2c010@mail.gmail.com>
Date: Mon, 31 Aug 2009 19:43:27 +0100
Message-ID: <3ace41890908311143q697898a3mcbc681d3941b45c9@mail.gmail.com>
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, hal@lists.freedesktop.org,
	htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 10:43 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Thu, Aug 27, 2009 at 8:14 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Wed, 2009-08-26 at 16:45 -0700, Luis R. Rodriguez wrote:
>>
>>> Johannes, did kernels < 2.6.31 have /sys/class/rfkill ?
>>
>> Yes, but I never understood why that matters. If you've got
>> compat-wireless "rfkill" loaded then the original rfkill can't be loaded
>> anyway. And their symbols would probably clash anyway if the original is
>> built in, in which case you can't use compat.
>>
>> You haven't renamed cfg80211's sysfs either, so why rfkill?
>>
>> johannes
>>
>
> There are a couple of wimax drivers which depends on rfkill... or
> bluetooth drivers? I think one likely reason is that there are valid
> situations or hardware combinations which requires having both of them
> loaded. (but that's a whole can of worms )

Argh, I just have a stacktrace after reboot - toshiba_acpi.ko (on a
toshiba laptop) requires the stock-kernel rfkill-* symbols, and rfkill
won't load because of my modified compat-wireless rfkill_backport.ko
which takes up /sys/class/rfkill rather than
/sys/class/rfkill_backport . There's your reason from sysfs renaming.
I wonder why/how I could unload rfkill.ko earlier, since the *_acpi.ko
needs it - maybe I had acpi unloaded as a side-effect also.

I guess we'll need hal to treat /sys/class/rfkill_backport like
/sys/class/rfkill  then - will file a bug somewhere on freedesktop,
although I hear hal is on its way out....

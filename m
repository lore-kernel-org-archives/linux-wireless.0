Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38882 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZLRXQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 18:16:23 -0500
Received: by iwn1 with SMTP id 1so2512897iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 15:16:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261177735.4041.107.camel@localhost.localdomain>
References: <1261176470.14206.23.camel@johannes.local> <43e72e890912181502u3610ac23qe2dfc09f1d337bf5@mail.gmail.com>
	<1261177735.4041.107.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 15:16:03 -0800
Message-ID: <43e72e890912181516t2a779ec3l5778225a61ba455c@mail.gmail.com>
Subject: Re: [PATCH] ar9170: load firmware asynchronously
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 3:08 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Luis,
>
>> > This converts ar9170 to load firmware asynchronously
>> > out of ->probe() and only register with mac80211 when
>> > all firmware has been loaded successfully. If, on the
>> > other hand, any firmware fails to load, it will now
>> > unbind from the device.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> > ---
>> > This can go in now, the prereq patch went in via gregkh.
>> >
>> > This ought to make it possible to build the driver
>> > into the kernel and as long as your system boots
>> > within 60 seconds it'll all just work.
>> >
>> > This is how we need to load firmware for drivers that
>> > require the firmware image to detect which features
>> > to register to mac80211/cfg80211, but it's also useful
>> > when no features depend on the firmware.
>> >
>> > I've done ar9170 because I'm somewhat familiar with its
>> > implementation. b43 should probably be converted to this
>> > scheme since it actually has features that depend on the
>> > firmware, and libertas_tf has the MAC addresss depending
>> > on the firmware (well it needs the firmware to read it).
>> >
>> > The only complication with this is that now the user is
>> > mostly unaware they have a wireless device, they can only
>> > find it via lsusb/lspci etc. if firmware loading fails,
>> > or from kernel messages. And also manual binding in sysfs,
>> > device re-plugging or module re-loading is required to
>> > get the module to find the device after putting firmware
>> > in place...
>> >
>> > Still I think this is better than what we have now with
>> > many drivers -- if firmware is missing you get network
>> > interfaces etc. but cannot ever use them, and it's not
>> > always entirely clear that is due to missing firmware.
>>
>> Sweet -- we could also expose firmware load events if not done so
>> already and let userspace propagate such nasty warnings, I think we'd
>> need to pass the firmware expected and the driver the requested it so
>> that once the firmware is in place (I guess through inotify maybe) the
>> driver modprobe can be retried.
>
> actually PackageKit should be doing something like this already. It
> might need to be adapted a bit, but the basics should be there.

Wow, I'm impressed. Thanks for the heads up.

  Luis

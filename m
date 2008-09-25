Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:29312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYIYLEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 07:04:12 -0400
Received: by fg-out-1718.google.com with SMTP id 19so264855fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 04:04:09 -0700 (PDT)
Message-ID: <1ba2fa240809250404i7e2404e7o3531ea1a889afb35@mail.gmail.com> (sfid-20080925_130416_779280_580B5D7F)
Date: Thu, 25 Sep 2008 14:04:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1222334592.10563.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 12:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-09-25 at 15:34 +0800, Zhu Yi wrote:
>> On Wed, 2008-09-24 at 02:44 -0600, Johannes Berg wrote:
>> > On Wed, 2008-09-24 at 13:57 +0800, Zhu Yi wrote:
>> > > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>> > >
>> > > The patch adds channels sysfs entry for iwl3945. Make it consistent
>> > > with iwlagn.
>> >
>> > I advocate just make it consistent by removing it entirely.
>>
>> We need a way to show the channel info the card EEPROM advocated, not
>> the final one intersected with the regdomain. Are you suggesting a
>> debugfs entry?
>
> Not that I understand why you need that since iw shows all channels you
> are registering (albeit with possibly a few more flags like "disabled"),
> but yeah, if anything all this stuff should be in debugfs. There's also
> this little fact that this channel list shouldn't ever get used, you
> should be (and afaik are since I fixed it) using what the regdomain is
> enforcing, and you're already printing the channel list when enough
> debugging flags are set on driver load.



> Therefore, I don't understand why you need to clutter the driver with
> this code.

You are too development oriented not everybody is looking into kernel
logs. It's easier to ask user
to cat sysfs/debubgfs. This is not tracing this is just check static
information.

Malicious gossip has it you're trying to obfuscate the code
> to a point where everybody else refuses to work on it.

We have probably most documented HW registers from all drivers so I
doubt that has any ground :)

> Anyhow, I see none of the sysfs files you're exporting as being
> userspace API that is actually needed in that form.
>
> Also, looking into more details, your sysfs files seem to fall into
> three categories:

Most of the sysfs files are rather historic remainders, it was just
not highest priority so far to clean it up.

>  1) things that mac80211 provides but you haven't hooked up
>  2) things that are generally useful, but you've added to your driver
>    instead of helping build the generic framework
>  3) things that are truly only useful for your internal debugging
>
> 1) notably TX power;

We are definitely hooked to TX power, maybe you didn't notice

> 2) it looks like retry_rate should be settable through a generic rate
>   control API if it is truly useful (otherwise category 3)
This one can be removed.

power_level
>   also belongs here, sometimes one can't avoid the impression that
>   you're adding things like that to avoid having to help define and
>   implement the generic functionality;

The patches are no the way, actually  I've sent one yesterday and more
are on the way.

> 3) Neither flags nor filter flags seem useful (and filter flags you can
>   actually influence via nl80211) to set outside test environments,
>   statistics falls here too, same probably with antenna, status, error
>   and events logs and "measurement".

These are purely for debugging and should be removed or moved to
debugfs, except log level
which I want always visible and has proven to be most useful.

> Similar issues surround the module parameters, I won't go into them
> other than saying that they constitute API as well and at least having
> different versions for 4965 and 5000 hw seems entirely pointless.
It's not pointless if you have both system on the board. This issue is
not new and
there were few attempts to add per device module parameters somehow
the patches were never accepted
into kernel.

 Many
> of them seem rather pointless in general, and something not only you
> have been doing and that I've asked for before is that I'd like to see a

> generic option to disable hardware crypto in _mac80211_ rather than each
> driver because this is actually genuinely useful if you want to monitor
> frames at the same time.
This is good point also disabling and enabling hw scan I would like to
remove from module params.
This is on TODO list.

Thanks
Tomas

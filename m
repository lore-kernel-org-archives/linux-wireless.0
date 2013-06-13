Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35753 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3FMRfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:35:03 -0400
Received: by mail-wg0-f53.google.com with SMTP id y10so5802329wgg.8
        for <linux-wireless@vger.kernel.org>; Thu, 13 Jun 2013 10:35:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMcMvsgVHMzVY4fnW7n+vgdWKKVgvF+fJ93xvRkkfZUjxt-bBQ@mail.gmail.com>
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
	<877ghz3il6.fsf@purkki.adurom.net>
	<477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com>
	<8738sn2mcf.fsf@purkki.adurom.net>
	<51B8C41E.7050907@candelatech.com>
	<477F20668A386D41ADCC57781B1F70430EA268B4A3@SC-VEXCH1.marvell.com>
	<20130613173002.GC3246@tuxdriver.com>
	<CAMcMvsgVHMzVY4fnW7n+vgdWKKVgvF+fJ93xvRkkfZUjxt-bBQ@mail.gmail.com>
Date: Thu, 13 Jun 2013 10:35:00 -0700
Message-ID: <CAMcMvsjT_MB4k_yDnuOozAXLY++OJ-EYx0REtEa2PphVOJbcJQ@mail.gmail.com> (sfid-20130613_193508_824233_2F78BE79)
Subject: Re: [PATCH] mwifiex: Add module parameter for regdomain
From: Paul Stewart <pstew@chromium.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 13, 2013 at 10:33 AM, Paul Stewart <pstew@chromium.org> wrote:
> On Thu, Jun 13, 2013 at 10:30 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>>
>> On Wed, Jun 12, 2013 at 12:01:23PM -0700, Bing Zhao wrote:
>> >
>> > > >> "iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
>> > > >>
>> > > >> What we need here is a *driver* hint. Furthermore, with a driver
>> > > >> regulatory hint, the passive-scan and no-ibss flags are cleared so we
>> > > >> can start AP with hostapd on 5G band.
>> > > >
>> > > > So it's a driver hint which is coming from user space via a module
>> > > > parameter. IMHO you are abusing interfaces here. Is there any better way
>> > > > to solve your problem?
>> > >
>> > > It would be nice to have some way to do this for ath9k and other NICs
>> > > as well.  Best I could come up with is a similar hack for ath9k.
>> > >
>> > > I think part of the problem is that this config info needs to be
>> > > available very early in the module loading/init logic, so it's
>> > > too late to be configured using 'iw' or similar.
>> >
>> > Exactly. regulatory_hint () needs to be called right after wiphy registration.
>>
>> It does seem a bit ugly.  But if Marvell wants it, I don't see any
>> "regulatory" argument to disallow something like this.
>>
>> Does anyone have a better suggestion for a user interface for such
>> a feature?
>
>
> The only (slightly) cleaner thing I could think of is a module
> parameter to cfg80211 so all drivers in the system would be made aware
> of the boot-time regulatory domain.

Oh, wait.  That exists in the 'ieee80211_regdom' parameter to
cfg80211.  You should use that. :-)

>>
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.

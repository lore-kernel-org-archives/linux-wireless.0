Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51724 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1GYUWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:22:08 -0400
Received: by qyk29 with SMTP id 29so1075824qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 13:22:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311367076.27468.4.camel@bender>
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
 <1310457159-16698-2-git-send-email-s.neumann@raumfeld.com>
 <20110715173240.GD2566@tuxdriver.com> <1311367076.27468.4.camel@bender>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jul 2011 13:21:46 -0700
Message-ID: <CAB=NE6U+3VgAz19-r-oY=WCbvw=LtX5OZc-c3Nop3Zdm9m3fvQ@mail.gmail.com> (sfid-20110725_222213_658790_BC89598A)
Subject: Re: [PATCH] cfg80211: hold reg_mutex when updating regulatory
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, daniel@zonque.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 1:37 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> Hi,
>
> On Fri, 2011-07-15 at 13:32 -0400, John W. Linville wrote:
>> Luis, any comment on this?
>>
>> On Tue, Jul 12, 2011 at 09:52:39AM +0200, Sven Neumann wrote:
>> > The function wiphy_update_regulatory() uses the static variable
>> > last_request and thus needs to be called with reg_mutex held.
>> > This is the case for all users in reg.c, but the function was
>> > exported for use by wiphy_register(), from where it is called
>> > without the lock being held.
>> >
>> > Fix this by making wiphy_update_regulatory() private and introducing
>> > regulatory_update() as a wrapper that acquires and holds the lock.
>> >
>> > Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
>
> I'd appreciate if someone would review this patch. But probably this is
> not really an issue except that it's somewhat ugly to export a function
> that should be called with a lock held and that lock is actually
> private. But in this particular case it is not a problem, as far as I
> can see, since the only user of wiphy_update_regulatory() outside
> net/wireless/reg.c is initialization code. So there is not likely going
> to be a race condition here.

Apologies for the delay and thanks for the patch. The patch seems good
except for the fact that there are so many changes reflected on the
patch itself and this can be avoided by splitting the work into a few
more patches so that the actual code changes required are reflected
cleanly in one patch. Can you perhaps split up your changes so that
moves of code are just that and actual code changes are reflected
elsewhere?

  Luis

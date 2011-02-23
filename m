Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1BWHaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 02:30:18 -0500
Received: by wwb39 with SMTP id 39so1207069wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 23:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298379745.3773.1.camel@jlt3.sipsolutions.net>
References: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
	<1298027245.3772.3.camel@jlt3.sipsolutions.net>
	<20110219061241.GA5881@vmraj-lnx.users.atheros.com>
	<1298106890.3725.7.camel@jlt3.sipsolutions.net>
	<AANLkTinP96mRkqCz-HgE3ePR-g2pFveR6HL2QoNw=E_r@mail.gmail.com>
	<1298379745.3773.1.camel@jlt3.sipsolutions.net>
Date: Wed, 23 Feb 2011 13:00:15 +0530
Message-ID: <AANLkTi=0hUr8xKfwmkkp84DHvs1Sr1gWk1oVkLCZB+pZ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 6:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> If the device queues are stopped, we have to find some other fix for
>> this power save issue since null func frame will be queued to pending
>> frames as I mentioned earlier. Can we have this patch merged and fix
>> the monitor vif issue for this case and the scanning case later? I
>> have also sent a RFC patch earlier with stopping device queues and a
>> new PS_PENDING flag for this
>> (http://marc.info/?l=linux-wireless&m=129775059910372&w=3) That patch
>> also addresses this race.
>
> I think for a first solution we can probably get away not worrying about
> monitor injection frames, since typically they'd be used by P2P things
> that disable powersave anyway. Right? And we already have the monitor
> vs. flush problem anyway.

Thanks. I will resend the patch rebased to current wireless-testing.

Vivek.

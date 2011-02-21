Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1BUHVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 02:21:21 -0500
Received: by wyb38 with SMTP id 38so806793wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 23:21:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298106890.3725.7.camel@jlt3.sipsolutions.net>
References: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
	<1298027245.3772.3.camel@jlt3.sipsolutions.net>
	<20110219061241.GA5881@vmraj-lnx.users.atheros.com>
	<1298106890.3725.7.camel@jlt3.sipsolutions.net>
Date: Mon, 21 Feb 2011 12:51:19 +0530
Message-ID: <AANLkTinP96mRkqCz-HgE3ePR-g2pFveR6HL2QoNw=E_r@mail.gmail.com>
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

On Sat, Feb 19, 2011 at 2:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2011-02-19 at 11:42 +0530, Rajkumar Manoharan wrote:
>
>> > I know we currently don't allow powersave when there's more than one
>> > interface, but we still allow it while there are monitor interfaces and
>> > a monitor interface could be sending packets, which would violate the
>> > flush() contract with the driver -- the driver may expect not to get any
>> > packets during flush.
>
>> AFIK we also are not stopping tx queue of monitor iface on offchannel.
>> Doing so could help flush().
>
> Hrm, indeed. And we can't even stop the queues there. We can pause them
> for the flush though. In fact, why don't we just stop device queues for
> flush and bypass this problem.

If the device queues are stopped, we have to find some other fix for
this power save issue since null func frame will be queued to pending
frames as I mentioned earlier. Can we have this patch merged and fix
the monitor vif issue for this case and the scanning case later? I
have also sent a RFC patch earlier with stopping device queues and a
new PS_PENDING flag for this
(http://marc.info/?l=linux-wireless&m=129775059910372&w=3) That patch
also addresses this race.

Vivek.

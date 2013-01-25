Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59261 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3AYWLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 17:11:37 -0500
Received: by mail-wi0-f178.google.com with SMTP id hn3so1636wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 14:11:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359149801.4655.24.camel@jlt4.sipsolutions.net>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	<20130109134059.GC18778@thinkpad-t410>
	<1358379163.15012.69.camel@jlt4.sipsolutions.net>
	<20130117053413.GB31449@thinkpad-t410>
	<1359149801.4655.24.camel@jlt4.sipsolutions.net>
Date: Fri, 25 Jan 2013 14:11:36 -0800
Message-ID: <CAJ-Vmonm7_sY8aDhU5sm0gyYQWkovENDFKy7KOag4bnjeWXcXg@mail.gmail.com> (sfid-20130125_231148_758032_E348A549)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, strangely enough (!) FreeBSD's net80211 code has similar problems
with TX and flushing.

Luckily (again, !) FreeBSD has a "raw" transmit path for things like
this, which is used for things such as probe requests and such. But
it's all a bit hairy and unclear.

There's a double problem - if you have frames in the raw transmit path
that have a sequence number or a CCMP IV number, those need to stay in
order, or things also go boom. Linux works around this by holding a
lock across the whole TX path, so things are "naturally" serialised
this way. I'm fixing this particular issue differently in FreeBSD.

Anyway, the main problem is making sure frames go out "right". Right
now, there's strange issues where probe requests that are queued get
flushed when the scan code goes to set a new channel.

So (after a few things like IBSS QoS, IBSS 11n and the last bits of
power save / ps-poll handling that i'm fixing up) go into FreeBSD's
wireless code, I'm likely going to revamp the scan and off-channel
code. At the very least I'm going to make it so a VAP doesn't change a
channel immediately - it marks the VAP as not accepting further
frames, then it waits for the TX queue to flush before it changes code
(with a _hard_  timeout..) and then a notice will go back to the scan
code tos ay that the channel change has completed.

Anyway, fun times..


adrian

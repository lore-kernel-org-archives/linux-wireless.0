Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44384 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3CYAEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 20:04:01 -0400
Received: by mail-wg0-f45.google.com with SMTP id dq12so709056wgb.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 17:03:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303242358.17133.chunkeey@googlemail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com>
	<CAMgrJ3buZxZermRmpUW2r3gYtUmF=3UoEo7NW9VYTkAwS7gdtQ@mail.gmail.com>
	<201303242358.17133.chunkeey@googlemail.com>
Date: Sun, 24 Mar 2013 17:03:59 -0700
Message-ID: <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com> (sfid-20130325_010406_435883_A9ADC702)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let me just be really clear.

Fast channel change is notoriously unreliable and really only fully
debugged on some very later chips.

The correct thing to do is something like this:

* if you meet the fast cc requirements (same channel width, same
frequency band, etc) then change channel;
* if you fail the initial cal, or you hit some traffic stop condition,
or you start failing NF cals - do a cold reset.

Now, unless you're doing some kind of very latency sensitive
applications (eg doing channel scans whilst in hostap mode) and you
debug this very very thoroughly, fast-cc is not guaranteed to work. So
I'd just ignore fast channel change in its entirety.

Now, warm versus cold reset. Cold reset resets everything. Warm reset
apparently doesn't fully reset everything in the MAC/PHY. Although I
-thought- the initval arrays would initialise things, apparently there
are some things that don't get fully cleared. Hence why I suggest
doing a cold reset if things are going a bit awry.

Felix's catch was good - if the queues weren't fully stopped, just do
a cold reset. But I'd just give up on fast-cc for now.



Adrian

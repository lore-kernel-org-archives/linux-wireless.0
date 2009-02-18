Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f167.google.com ([209.85.218.167]:49263 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZBRUwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:52:23 -0500
Received: by bwz11 with SMTP id 11so112361bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 12:52:21 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76_usb: fix Oops on disconnect
References: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
	<da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com>
	<c4d76b3b0902081947x92eb0bo73fa63afb23b5e2c@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 22:52:19 +0200
In-Reply-To: <c4d76b3b0902081947x92eb0bo73fa63afb23b5e2c@mail.gmail.com> (Jason Andryuk's message of "Sun\, 8 Feb 2009 22\:47\:32 -0500")
Message-ID: <87wsbnpiws.fsf@litku.valot.fi> (sfid-20090218_215230_517746_DCCFB701)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> I'll take a look at at76c50x-usb in general and bringing over this
> patch specifically.  Unfortunately, I still had one disconnect oops
> with the patch installed.  Netconsole was not configured, so I did not
> catch it.  There were several other successful disconnects without
> Oops though.

Progress is always good :)

> It may need locking as none is currently present, but does a one way
> transition device_unplugged 0 -> 1 need a lock?

Using int might be enough but I think it's not guarenteed anywhere.
Better to use atomic operations directly or use a proper lock. But I
think the issues are more than that. For example, the disconnect
handler is not taking the mutex.

-- 
Kalle Valo

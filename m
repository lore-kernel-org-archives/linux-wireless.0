Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:1105 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbZBIDre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 22:47:34 -0500
Received: by yx-out-2324.google.com with SMTP id 8so654040yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2009 19:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com>
References: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
	 <da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com>
Date: Sun, 8 Feb 2009 22:47:32 -0500
Message-ID: <c4d76b3b0902081947x92eb0bo73fa63afb23b5e2c@mail.gmail.com> (sfid-20090209_044738_890790_4D35CBD3)
Subject: Re: [PATCH] at76_usb: fix Oops on disconnect
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll take a look at at76c50x-usb in general and bringing over this
patch specifically.  Unfortunately, I still had one disconnect oops
with the patch installed.  Netconsole was not configured, so I did not
catch it.  There were several other successful disconnects without
Oops though.

It may need locking as none is currently present, but does a one way
transition device_unplugged 0 -> 1 need a lock?

Jason

On Sat, Feb 7, 2009 at 6:29 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> On Thu, Feb 5, 2009 at 6:03 AM, Jason Andryuk <jandryuk@gmail.com> wrote:
>> flush_workqueue needs to be called instead of the generic one and the
>> associated functions need to be modified to prevent re-adding
>> themselves to the workqueue.
>
> Good fix. Can you please port this to the at76c50x-usb driver I posted
> this morning?
>
> Kalle
>

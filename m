Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:16528 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYAUHYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 02:24:01 -0500
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 1/2] ath5k: debug level improvements
References: <20080121020924.3818.46553.stgit@one> <87prvvfzj5.fsf@nokia.com>
	<200801211607.25360.bruno@thinktube.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 21 Jan 2008 09:20:36 +0200
In-Reply-To: <200801211607.25360.bruno@thinktube.com> (ext bruno randolf's message of "Mon\, 21 Jan 2008 16\:07\:25 +0900")
Message-ID: <87fxwrfxvf.fsf@nokia.com> (sfid-20080121_072407_095633_E0953DEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bruno randolf <bruno@thinktube.com> writes:

> On Monday 21 January 2008 15:44:46 Kalle Valo wrote:
>> > +	char buf[20];
>> > +
>> > +	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
>> > +		return -EFAULT;
>>
>> How about let the compiler count the size of buf? Like this:
>>
>> if (copy_from_user(buf, userbuf, min_t(size_t, count, sizeof(buf))))
>>
>> That way the size of buf is only in one place, and we might avoid a
>> bug whenever someone changes the size of buf.
>
> good idea. that way i can also get rid of min_t(size_t,...) and use min().

Even better.

>> > +static ssize_t read_file_debug(struct file *file, char __user *user_buf,
>> > +				   size_t count, loff_t *ppos)
>> > +{
>> > +	struct ath5k_softc *sc = file->private_data;
>> > +	char buf[1000];
>>
>> To my eyes allocating 1000 bytes from stack is too large.
>
> what about 700? ;) 
> the output currently is 626 byte.

Hehe :) I have no idea what's the preferred limit here, so I cannot
you give a definitive answer. But I would guess that 700 byte
allocation is still sensible with 4k stacks.

But this is for a debug interface so most likely this doesn't matter
that much.

-- 
Kalle Valo

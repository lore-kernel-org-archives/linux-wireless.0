Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:11213 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753934AbYAUHHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 02:07:38 -0500
From: bruno randolf <bruno@thinktube.com>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [PATCH 1/2] ath5k: debug level improvements
Date: Mon, 21 Jan 2008 16:07:25 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20080121020924.3818.46553.stgit@one> <87prvvfzj5.fsf@nokia.com>
In-Reply-To: <87prvvfzj5.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801211607.25360.bruno@thinktube.com> (sfid-20080121_070743_418342_5966D623)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 January 2008 15:44:46 Kalle Valo wrote:
> > +	char buf[20];
> > +
> > +	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
> > +		return -EFAULT;
>
> How about let the compiler count the size of buf? Like this:
>
> if (copy_from_user(buf, userbuf, min_t(size_t, count, sizeof(buf))))
>
> That way the size of buf is only in one place, and we might avoid a
> bug whenever someone changes the size of buf.

good idea. that way i can also get rid of min_t(size_t,...) and use min().

> > +static ssize_t read_file_debug(struct file *file, char __user *user_buf,
> > +				   size_t count, loff_t *ppos)
> > +{
> > +	struct ath5k_softc *sc = file->private_data;
> > +	char buf[1000];
>
> To my eyes allocating 1000 bytes from stack is too large.

what about 700? ;)
the output currently is 626 byte.

thanks,
bruno

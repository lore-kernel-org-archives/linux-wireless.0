Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:58987 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYAUGqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 01:46:15 -0500
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 1/2] ath5k: debug level improvements
References: <20080121020924.3818.46553.stgit@one>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 21 Jan 2008 08:44:46 +0200
In-Reply-To: <20080121020924.3818.46553.stgit@one> (ext Bruno Randolf's message of "Mon\, 21 Jan 2008 11\:09\:24 +0900")
Message-ID: <87prvvfzj5.fsf@nokia.com> (sfid-20080121_064632_683566_1FCB0192)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf <bruno@thinktube.com> writes:

> @@ -209,7 +209,12 @@ static ssize_t write_file_tsf(struct file *file,
>  				 size_t count, loff_t *ppos)
>  {
>  	struct ath5k_softc *sc = file->private_data;
> -	if (strncmp(userbuf, "reset", 5) == 0) {
> +	char buf[20];
> +
> +	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
> +		return -EFAULT;

How about let the compiler count the size of buf? Like this:

if (copy_from_user(buf, userbuf, min_t(size_t, count, sizeof(buf))))

That way the size of buf is only in one place, and we might avoid a
bug whenever someone changes the size of buf.

> +static ssize_t read_file_debug(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	char buf[1000];

To my eyes allocating 1000 bytes from stack is too large.

-- 
Kalle Valo

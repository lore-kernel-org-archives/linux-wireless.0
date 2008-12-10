Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40878 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYLJKeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 05:34:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Fix sparse warnings
Date: Wed, 10 Dec 2008 11:33:53 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <493f552d.zivnzjivWDMPej+O%Larry.Finger@lwfinger.net>
In-Reply-To: <493f552d.zivnzjivWDMPej+O%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101133.54173.mb@bu3sch.de> (sfid-20081210_113428_009637_4E8CE094)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 06:35:41 Larry Finger wrote:
>   CHECK   drivers/net/wireless/b43legacy/debugfs.c
> drivers/net/wireless/b43legacy/debugfs.c:243:9: warning: memset with byte count of 131072

I know about this error and I think it's a damn stupid error.
There is a reason why the value was so high in b43. I don't know about b43legacy.
Did you check if all callbacks still work properly?

> Index: wireless-testing/drivers/net/wireless/b43legacy/debugfs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/debugfs.c
> +++ wireless-testing/drivers/net/wireless/b43legacy/debugfs.c
> @@ -211,7 +211,7 @@ static ssize_t b43legacy_debugfs_read(st
>  	struct b43legacy_dfs_file *dfile;
>  	ssize_t uninitialized_var(ret);
>  	char *buf;
> -	const size_t bufsize = 1024 * 128;
> +	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
>  	const size_t buforder = get_order(bufsize);
>  	int err = 0;

-- 
Greetings, Michael.

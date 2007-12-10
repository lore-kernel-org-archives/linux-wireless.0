Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22351 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751800AbXLJJWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 04:22:38 -0500
From: bruno randolf <bruno@thinktube.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] ath5k: add debugfs entries for registers, tsf, beacon, reset
Date: Mon, 10 Dec 2007 18:22:42 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
References: <1197274926-14334-1-git-send-email-bruno@thinktube.com> <475D00D7.10309@gmail.com>
In-Reply-To: <475D00D7.10309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200712101822.43487.bruno@thinktube.com> (sfid-20071210_092240_699150_CE4C9CF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007 18:03:19 Jiri Slaby wrote:
> > +static int open_file_registers(struct inode *inode, struct file *file)
> > +{
> > +	struct seq_file *s;
> > +	int res;
> > +	res = seq_open(file, &register_seq_ops);
> > +	s = file->private_data;
> > +	s->private = inode->i_private;
>
> Sorry for not noticing this earlier, if res is nonzero, you are
> dereferencing NULL (s) here.

oh, sorry for not realizing that myself. so i add:

+       if (res == 0) {
+               s = file->private_data;
+               s->private = inode->i_private;
+       }

and resend.

thanks,
bruno


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:13858 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751396Ab0CZASg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 20:18:36 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0912972714
	for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 09:18:34 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH 10/10] ath5k: Adaptive Noise Immunity (ANI) Implementation
Date: Fri, 26 Mar 2010 09:18:28 +0900
Cc: linux-wireless@vger.kernel.org
References: <20100325054603.10697.48915.stgit@tt-desk> <20100325054952.10697.41515.stgit@tt-desk> <loom.20100325T115111-300@post.gmane.org>
In-Reply-To: <loom.20100325T115111-300@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003260918.28079.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 25 March 2010 19:59:11 Joerg Pommnitz wrote:
> Bruno Randolf <br1@...> writes:
> > +/* debugfs: ani */
> > +
> > +static ssize_t read_file_ani(struct file *file, char __user *user_buf,
> > +				   size_t count, loff_t *ppos)
> > +{
> > +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> 
> ...
> 
> > +}
> 
> I would prefer a machine readable solution, e.g. individual files
> in an ANI directory with one value each.
> 
> > +static ssize_t write_file_ani(struct file *file,
> > +				 const char __user *userbuf,
> > +				 size_t count, loff_t *ppos)
> > +{
> 
> ...
> 
> > +	return count;
> > +}
> 
> Same as above: instead of a catch all with magic configuration words, use
> individual files with at least guessable values (e.g. 0/1 for
> enable/disable of individual features).

yes i agree with you and i mentioned this in my introdution message [PATCH 
0/0]. these are just debug files...

my question is which interface to use?

 iw? - probably not generic enough, allthough something like "sensitivity" 
could be useful to other drivers too?

 sysfs? configfs? - what is the interface of choice nowadays? ;)

bruno

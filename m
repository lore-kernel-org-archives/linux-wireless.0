Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35485 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab0CYLFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 07:05:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Nuks3-0006fE-Nz
	for linux-wireless@vger.kernel.org; Thu, 25 Mar 2010 12:05:03 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 12:05:03 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 12:05:03 +0100
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH 10/10] ath5k: Adaptive Noise Immunity (ANI) Implementation
Date: Thu, 25 Mar 2010 10:59:11 +0000 (UTC)
Message-ID: <loom.20100325T115111-300@post.gmane.org>
References: <20100325054603.10697.48915.stgit@tt-desk> <20100325054952.10697.41515.stgit@tt-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf <br1@...> writes:
>  
> +/* debugfs: ani */
> +
> +static ssize_t read_file_ani(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
...
> +}

I would prefer a machine readable solution, e.g. individual files
in an ANI directory with one value each.

> +static ssize_t write_file_ani(struct file *file,
> +				 const char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
...
> +	return count;
> +}

Same as above: instead of a catch all with magic configuration words, use
individual files with at least guessable values (e.g. 0/1 for enable/disable
of individual features).

Otherwise I'm excited to see ath5k become feature complete compared with 
Madwifi.

Regards
  Joerg


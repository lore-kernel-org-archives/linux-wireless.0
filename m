Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46810 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0GWKFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 06:05:17 -0400
Date: Fri, 23 Jul 2010 12:04:42 +0200
From: Dan Carpenter <error27@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
Message-ID: <20100723095252.GA26313@bicker>
References: <20100722085202.GV17585@bicker> <201007231744.14922.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201007231744.14922.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 23, 2010 at 05:44:14PM +0900, Bruno Randolf wrote:
> 
> i think it would be better to make sure the buffer is always big enough to 
> hold all the output (it's not very variable in length), but as a safety net 
> this can't hurt.
> 

This is a smatch thing.  I suppose someday I will fix smatch to
evaulate the strings themselves and verify that the buffer is large
enough.  But for now it's nice to be able to automatically check that
the buffers don't overflow.  

regards,
dan carpenter


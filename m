Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab0GVKpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 06:45:20 -0400
Date: Thu, 22 Jul 2010 12:44:19 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
Message-ID: <20100722104419.GZ17585@bicker>
References: <20100722085202.GV17585@bicker> <4C4807AD.5090302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C4807AD.5090302@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 10:56:13AM +0200, Jiri Slaby wrote:
> On 07/22/2010 10:52 AM, Dan Carpenter wrote:
> > snprintf() returns the number of characters that would have been written
> > (not counting the NUL character).  So we can't use it as the limiter to 
> > simple_read_from_buffer() without capping it first at sizeof(buf).
> 
> Doesn't scnprintf make more sense here?
> 

Not really...  It's nice to pass a negative number as the buffer size to
snprintf() instead of having to make that a special case.

regards,
dan carpenter

> thanks,
> -- 
> js

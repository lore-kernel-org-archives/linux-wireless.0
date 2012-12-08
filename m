Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posteo.de ([89.146.220.134]:44010 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab2LHOrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 09:47:55 -0500
Date: Sat, 8 Dec 2012 15:30:32 +0100
From: Felix Janda <felix.janda@posteo.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
Message-ID: <20121208143032.GA1903@gauss> (sfid-20121208_154759_708085_09D20710)
References: <50C01558.8050102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C01558.8050102@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/12 at 09:47pm, Larry Finger wrote:
> Felix,
> 
> Please test this with b43 built into the kernel.
> 
> Thanks,
> 
> Larry

Thanks, for coming back to this.

It now gives me a kernel panic after 30 seconds.

I did some debugging using ssleep and printk. b43_fw_cb seems
to be called several times and on the last time the "firmware"
argument seems to be zero. The execution then returns to
b43_do_request_fw, which tries to deference a zero pointer in
the line

> +	if (ctx->blob->size < sizeof(struct b43_fw_header))


It is another machine then last time, has B4306 (rev 3) and a
kernel without modules. The firmware is in /lib/firmware/b43,
which is on the root partition. There is no udev installed.

Felix

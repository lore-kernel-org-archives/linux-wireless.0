Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49270 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0BAV7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 16:59:11 -0500
Subject: Re: [PATCH] ath9k: fix access to freed data on unload
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e891002011332g5ee05addp3f140ea23a45e09d@mail.gmail.com>
References: <1264905444.10146.9.camel@mj>
	 <43e72e891002011011h4714ecddrb9421a877832bffd@mail.gmail.com>
	 <20100201203637.GE4952@tuxdriver.com>
	 <43e72e891002011332g5ee05addp3f140ea23a45e09d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 16:59:01 -0500
Message-Id: <1265061541.17261.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-01 at 13:32 -0800, Luis R. Rodriguez wrote:

> >> Thanks, can you please resend with a Cc: stable@kernel.org on the commit log?
> >
> > Doesn't look to me like the patch even applies to 2.6.33...?
> 
> Sorry thought it would have by then.

The current mainline 2.6.33 uses the cleanup field, but in a different
way.  ath_bus_cleanup() is called before ieee80211_free_hw(), so it's
should not be affected by the bug.  I was wrong to assume that 2.6.33 is
affected.

As for wireless-testing, once ath_bus_cleanup() moved from main.c to
ahb.c and pci.c, it became redundant (apart from the buggy part).

If we ever want to factorize some cleanup code in the future, it will be
different code anyway, so the current "cleanup" should go away.

-- 
Regards,
Pavel Roskin

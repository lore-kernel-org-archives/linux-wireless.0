Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:47414 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZJPHP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 03:15:27 -0400
From: Kalle Valo <kalle.valo@iki.fi>
To: Greg KH <greg@kroah.com>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
References: <1255575825.10636.17.camel@laptop>
	<20091015031138.GB16633@kroah.com>
Date: Fri, 16 Oct 2009 10:13:45 +0300
In-Reply-To: <20091015031138.GB16633@kroah.com> (ext Greg's message of "Thu,
	15 Oct 2009 05:11:38 +0200")
Message-ID: <87zl7rbyl2.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> On Wed, Oct 14, 2009 at 11:03:45PM -0400, Javier Martinez Canillas wrote:
>> I got the following compile error with today linux-next tree.
>> 
>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_reset’:
>> drivers/staging/stlc45xx/stlc45xx.c:1061: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_interrupt’:
>> drivers/staging/stlc45xx/stlc45xx.c:1492: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_wq_tx’:
>> drivers/staging/stlc45xx/stlc45xx.c:1571: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>> drivers/staging/stlc45xx/stlc45xx.c: In function ‘stlc45xx_op_tx’:
>> drivers/staging/stlc45xx/stlc45xx.c:2135: error: ‘struct ieee80211_hw’ has no member named ‘workqueue’
>> drivers/staging/stlc45xx/stlc45xx.c: At top level:
>> drivers/staging/stlc45xx/stlc45xx.c:2351: warning: initialization from incompatible pointer type
>> 
>> The driver was trying to access directly to mac80211 workqueue. Use the helper functions instead. 
>> 
>> I think this patch solves the issue. Also fix a compile warning due a change in configure_filter() handler params.
>
> ah, good catch, I had that driver disabled in my builds for some stupid
> reason.  I'll queue this up in my tree.

I think it's better to drop stlc45xx. As I haven't sent any patches for
few months is obvious that I don't have time to work on it anymore. And
p54spi should work now, at least I have seen positive reports on mailing
lists.

Greg, if you want I can send a patch removing stlc45xx.

-- 
Kalle Valo

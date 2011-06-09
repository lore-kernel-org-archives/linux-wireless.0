Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33853 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab1FINTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 09:19:25 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan is ongoing
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115501.32208.82264.stgit@localhost6.localdomain6>
	<20110608200332.GC4069@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 09 Jun 2011 16:19:24 +0300
In-Reply-To: <20110608200332.GC4069@shale.localdomain> (Dan Carpenter's message of "Wed\, 8 Jun 2011 23\:03\:32 +0300")
Message-ID: <87wrgv6t2b.fsf@purkki.adurom.net> (sfid-20110609_151929_342346_AAB812BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

> On Wed, Jun 08, 2011 at 02:55:01PM +0300, Kalle Valo wrote:
>> -        /* Translate data to cfg80211 mgmt format */
>> -	if (ar->arWmi)
>             ^^^^^^^^^
> 	You removed this check on purpose?  Is this only NULL when
> 	the scan is canceled?

It's null only when the module is being destroyed. And I changed it so
that when ar6000_destroy() aborts the scan we do not use ar->arWmi at
all and avoid the crash.

-- 
Kalle Valo

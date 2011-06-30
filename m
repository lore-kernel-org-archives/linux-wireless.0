Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45531 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab1F3H77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 03:59:59 -0400
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: implement testmode rx command
References: <20110627153610.16774.65919.stgit@localhost6.localdomain6>
	<20110628201836.GA18749@kroah.com> <20110628201915.GA19616@kroah.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 30 Jun 2011 10:59:55 +0300
In-Reply-To: <20110628201915.GA19616@kroah.com> (Greg KH's message of "Tue\, 28 Jun 2011 13\:19\:15 -0700")
Message-ID: <871uyb21hg.fsf@purkki.adurom.net> (sfid-20110630_100001_952315_7A316A19)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> On Tue, Jun 28, 2011 at 01:18:36PM -0700, Greg KH wrote:
>> On Mon, Jun 27, 2011 at 06:36:10PM +0300, Kalle Valo wrote:
>> > Add new testmode command for retrieving rx reports from firmware.
>> > 
>> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> 
>> This patch breaks the build.
>> 
>> Please test your patches before sending them out, it causes lots of
>> problems and annoys me when you don't.
>
> Oh, and the error is:
>
> ERROR: "ar6000_testmode_rx_report_event" [drivers/staging/ath6kl/ath6kl.ko] undefined!

I did test the patch but only with CONFIG_NL80211_TESTMODE enabled but
forgot to test the case when testmode is disabled. The linking fails
in that case.

I'll send v2 which will fix this. I'm sorry for all the trouble.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:38408 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2LCUAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 15:00:05 -0500
Message-ID: <50BD03EF.3010504@01019freenet.de> (sfid-20121203_210010_722746_4359AA64)
Date: Mon, 03 Dec 2012 20:56:31 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
References: <20121203115632.GA2490@redhat.com> <50BCB3A3.4090708@01019freenet.de> <201212031629.16806.chunkeey@googlemail.com>
In-Reply-To: <201212031629.16806.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

thanks for your explanation!

Christian Lamparter wrote:
> On Monday, December 03, 2012 03:13:55 PM Andreas Hartmann wrote:
>> Stanislaw Gruszka wrote:
>>> Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
>>> failed BAR frames later instead of tearing down aggr" caused regression
>>> on rt2x00 hardware (connection hangs).
>>
>> This patch caused a problem, too, with carl9170
>> (http://thread.gmane.org/gmane.linux.kernel.wireless.general/92203/focus=92376).
>> How did they fix it (the thread unfortunately ends without any solution
>> / patch).
> 
> This was fixed by: carl9170: fix HT peer BA session corruption
> (c9122c0d63a50 in wireless-testing). The issue here is that the
> hardware does not set the tx success bit when it receives a
> BA for a sent BAR [looks like it is expecting a legacy ACK?!
> but who knows - the original vendor driver [otus] didn't really
> deal with BARs anyway].

If I got Helmut correctly here
(http://news.gmane.org/find-root.php?group=gmane.linux.kernel.wireless.general&article=83762),
rt2x00pci could have a related problem (probably missing tx status).

Wouldn't it be an idea to try a similar approach?

https://kernel.googlesource.com/pub/scm/linux/kernel/git/linville/wireless-testing/+/c9122c0d63a50bab0a97dc936a38c0f921b6930e^!/

> So the driver has to do that job and currently it's done in
> the following way:
> When mac80211 sends a BAR, the driver will keep a reference of
> the frame around in ar->bar_list, before it is sent on its way.
> If the device receives a BA within the retry window then the
> driver's rx-path will enter carl9170_ba_check. This function
> sets the TX_STAT_ACK flag [for the BAR] if the incoming BA
> matches.
> 
> While there are a few problems with this approach [added tx and rx
> overhead due to flexible ba filtering and bar queuing, unwanted BAR
> retries, ...], it was one of the better solution which was within
> the capabilities of the hardware, firmware and driver.
> Obviously, if the ar9170 hardware would just set that tx success
> bit [ath9k mac does this properly], this wouldn't be necessary.
> 
> Regards,
> 	Chr


Thanks,
kind regards,
Andreas

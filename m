Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:34414 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0DQHCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 03:02:24 -0400
Message-ID: <4BC95A5C.5020205@acm.org>
Date: Sat, 17 Apr 2010 08:51:08 +0200
From: U Kuehn <ukuehn@acm.org>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Resolved, was Re: Problem: Regression with iwl 4965 since 2.6.32.10
References: <4BC04027.1090802@acm.org> <1271195092.14052.8010.camel@rchatre-DESK>
In-Reply-To: <1271195092.14052.8010.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Reinette,

reinette chatre wrote:
>> In my usual setup, I connect to an WPA2-configured access point using
>> wpa_supplicant. Starting with 2.6.32.10 networking stops to work shortly
>> after the 4-way handshake. After the next re-keying it works again for a
>> short time.
>>
>> I tracked the problem down to commit
>> 44af042e42f2231579ea8ef7586d3789d198f609.
>>
> 
> Two more patches following up on the one you mention are on their way to
> stable. If you want to pick them up earlier they are:
> iwlwifi: counting number of tfds can be free for 4965
> iwlwifi: need check for valid qos packet before free
> 
> In fact ... I just checked and they are both already queued for 2.6.32
> so you can just pick them up from the 2.6.32 stable queue
> ( http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=tree;f=queue-2.6.32;hb=HEAD )
> 
> ... in fact ... I suggest you take all the iwlwifi patches there.
> 
Thanks, that did indeed help. With the four patches
	iwlwifi-counting-number-of-tfds-can-be-free-for-4965.patch
	iwlwifi-fix-nfreed.patch
	iwlwifi-need-check-for-valid-qos-packet-before-free.patch
	iwlwifi-range-checking-issue.patch
applied, 2.6.32.11 works again reliably, as far as I could test so far.

Best regards,
Ulrich



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1559 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2IEQ1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 12:27:18 -0400
Message-ID: <50477D5E.2040003@broadcom.com> (sfid-20120905_182721_970474_08F68239)
Date: Wed, 5 Sep 2012 18:27:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 flush callback
References: <503DFDE4.5030102@broadcom.com>
 <1346853217.4364.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346853217.4364.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 03:53 PM, Johannes Berg wrote:
> Hi Arend,
>
>> I ma currently looking into a long standing issue with flush callback in
>> brcmsmac. After some debugging I found out that mac80211 keeps pushing
>> packets to brcmsmac during the flush. Is that correct? Should brcmsmac
>> (or any other driver) stop the mac80211 queues during the flush? My
>> assumption was that mac80211 would not do transmits during the flush,
>> but it probably comes from another worker thread.
>
> Hmm, good question, this area isn't quite fully worked out yet I
> think ... probably better to stop queues yourself for now, although I
> guess mac80211 should really take care to do it ...
>

Thanks, Johannes

I did look at some other driver and it seems they grab a mutex in the 
flush that is (probably?) also grabbed in the tx path thus blocking it. 
For brcmsmac I submitted a patch to explicitly stop the queues in the flush.

Gr. AvS


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:62189 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ2XpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:45:20 -0400
Received: by wf-out-1314.google.com with SMTP id 27so254634wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 16:45:19 -0700 (PDT)
Message-ID: <1ba2fa240810291645n3c90161brb70c76b12d514f52@mail.gmail.com> (sfid-20081030_004526_417943_9299E40F)
Date: Thu, 30 Oct 2008 01:45:19 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "reinette chatre" <reinette.chatre@intel.com>
Subject: Re: Still 4965 issues with wireless-testing
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225321298.1115.309.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
	 <1225321298.1115.309.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 1:01 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Wed, 2008-10-29 at 14:33 -0700, Marcel Holtmann wrote:
>> Hi guys,
>>
>> so besides the point that the Ubuntu 8.10 kernel has a broken driver
>> for the Intel 4965 cards which will crash my X61 after less than one
>> minute uptime when it connects to my access point, I have my dmesg
>> full with warnings from the latest wireless-testing kernel.
>>
>> I know that we have discussed this before and Johannes' patch at least
>> turns it into warnings instead of killing my system completely, but I
>> am still surprised why this hasn't been fixed.
>>
>> Attached is one of the dmesg snippets. They occur multiple times per
>> minute.
>
> Could you please compare your testing with that done in
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703 ?

Strange I haven't seen this one for while
txq_id = 31 (0x1f)
Which is due to
 SEQ_TO_QUEUE(s)     (((s) >> 8) & 0x1f)
We should dump the whole RXB there to see what is there and open full RX log
which is bit 24 in the log level
Thanks
Tomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50057 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaHUOkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 10:40:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	<20140821124907.27159.64620.stgit@potku.adurom.net>
	<1408626616.4388.0.camel@jlt4.sipsolutions.net>
Date: Thu, 21 Aug 2014 17:40:46 +0300
In-Reply-To: <1408626616.4388.0.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 21 Aug 2014 15:10:16 +0200")
Message-ID: <877g21c3dd.fsf@kamboji.qca.qualcomm.com> (sfid-20140821_164058_978758_F2E787FE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2014-08-21 at 15:49 +0300, Kalle Valo wrote:
>> From: Ben Greear <greearb@candelatech.com>
>> 
>> Store the firmware registers and other relevant data to a firmware crash dump
>> file and provide it to user-space via debugfs. Should help with figuring out
>> why the firmware crashed.
>
> So we just discussed Tuesday/yesterday that I'll be writing a generic
> framework to provide this data to userspace, maybe you want to wait for
> that.

Heh, this has been a pretty long review period. To be honest I really
would like to get this just out of my hands :) And we do have a need for
this. When are you planning to implement that generic framework?

What I understood is that this is already pretty close what you are
planning. Instead of creating a debugfs file of our own and allocating a
vmalloc buffer (which we do now), we would just use the buffer provided
by cfg80211 (or whatever component that would be) and use the sysfs file
the framework provides. So hopefully it would be pretty easy to convert
this to use your framework.

-- 
Kalle Valo

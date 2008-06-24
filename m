Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:32627 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbYFXLMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:12:06 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7605083rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 04:12:05 -0700 (PDT)
Message-ID: <1ba2fa240806240412w3b0847c1r7ac51ac70f8603ec@mail.gmail.com> (sfid-20080624_131225_072292_BCB96FDE)
Date: Tue, 24 Jun 2008 14:12:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/4] mac80211: add last beacon time in scan list
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1214304433.8967.277.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214304433.8967.277.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 1:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-06-24 at 13:38 +0300, Tomas Winkler wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch adds the interval between the scan results and the last time a
>> beacon was received in the result of the scan.
>
> Why do we need this?

Not sure myself I already forgotten who asked me to do it. Maybe some
roaming algorithm needs it in the user space.
>
>> +                     memset(&iwe, 0, sizeof(iwe));
>> +                     iwe.cmd = IWEVCUSTOM;
>> +                     sprintf(buf, " Last beacon: %dms ago",
>> +                             jiffies_to_msecs(jiffies - bss->last_update));
>
> Is there no time_between() or something that accounts for wraparound?

Will fix it.
Thanks
Tomas

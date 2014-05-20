Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42392 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETPS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 11:18:59 -0400
Received: by mail-ig0-f178.google.com with SMTP id hl10so859420igb.11
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 08:18:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140520143226.GC13981@tuxdriver.com>
References: <537B2FF7.5070908@gmail.com>
	<1400582238-18601-1-git-send-email-egrumbach@gmail.com>
	<20140520143226.GC13981@tuxdriver.com>
Date: Tue, 20 May 2014 18:18:58 +0300
Message-ID: <CAB3XZEe_xVq_Rq1OT7fvx4wZn1-uxL8c=5AavH4Buq5wUEdVbA@mail.gmail.com> (sfid-20140520_171902_632011_98C6A493)
Subject: Re: [PATCH] iwlwifi: mvm: don't filter out the first beacon
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 5:32 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, May 20, 2014 at 01:37:18PM +0300, Emmanuel Grumbach wrote:
>> From: Avri Altman <avri.altman@intel.com>
>>
>> Enabling beacon filtering should be done only after a beacon
>> has been received. Doing that too early will cause
>> disconnections.
>> This has already been fixed, but the fix didn't take care
>> about the case where the beacon is received after the
>> association, it waited only for association which is not
>> enough.
>>
>> Signed-off-by: Avri Altman <avri.altman@intel.com>
>> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++---
>>  drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 ---
>>  drivers/net/wireless/iwlwifi/mvm/power.c    | 63 +++++++++--------------------
>>  3 files changed, 27 insertions(+), 54 deletions(-)
>
> It is very late in the release cycle for a fix of this size.
> How serious is the issue?  A random disconnect doesn't seem like a
> huge problem so long as it isn't common...?
>
fwiw, it looks like you can simply workaround the issue by setting the
IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC flag.

Eliad.

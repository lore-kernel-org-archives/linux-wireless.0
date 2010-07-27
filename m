Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33605 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0G0I1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 04:27:45 -0400
Received: by pvc7 with SMTP id 7so349747pvc.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 01:27:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
References: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
	<AANLkTinHXxhwrOmhRxveekG7_C7WeydUdSBL2R7DwOvJ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 01:27:25 -0700
Message-ID: <AANLkTinch-sygnRmB6LKi6xLNYVKY6Ap3YL4_PMNdmKQ@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix sw scan bracketing
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 1:04 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Jun 18, 2010 at 3:32 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> Currently, detection in hwsim and ath9k can
>> detect that two sw scans are in flight at the
>> same time, which isn't really true. It is
>> caused by a race condition, because the scan
>> complete callback is called too late, after
>> the lock has been dropped, so that a new scan
>> can be started before it is called.
>>
>> It is also called too early semantically, as
>> it is currently called _after_ the return to
>> the operating channel -- it should be before
>> so that drivers know this is the operating
>> channel again.
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/mac80211/scan.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- wireless-testing.orig/net/mac80211/scan.c   2010-06-18 12:22:56.000000000 +0200
>> +++ wireless-testing/net/mac80211/scan.c        2010-06-18 12:23:25.000000000 +0200
>> @@ -287,6 +287,8 @@ void ieee80211_scan_completed(struct iee
>>        local->scanning = 0;
>>        local->scan_channel = NULL;
>>
>> +       drv_sw_scan_complete(local);
>> +
>>        /* we only have to protect scan_req and hw/sw scan */
>>        mutex_unlock(&local->scan_mtx);
>>
>> @@ -296,8 +298,6 @@ void ieee80211_scan_completed(struct iee
>>
>>        ieee80211_configure_filter(local);
>>
>> -       drv_sw_scan_complete(local);
>> -
>>        ieee80211_offchannel_return(local, true);
>>
>>  done:
>
> Leaving the entire patch in the e-mail reply as the patch is small to
> help with context.
>
> Turns out this patch broke ath9k in the sense that right after a scan
> we get disconnected from the AP. I just bisected wireless-testing by
> master-tag dates and found 2010-06-18 to be where we hit poo in. I
> reverted this patch and its cured. I'm going to test a recent
> wireless-testing now and then just try reverting this to see if its OK
> even on a recent wireless-testing, and then see if we can fix this
> properly on ath9k or whatever.

Yeap, reverting this patch alone today on wireless-testing makes me
ath9k happy once again.

 Luis

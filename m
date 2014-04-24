Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44684 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXTYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 15:24:39 -0400
Received: by mail-lb0-f172.google.com with SMTP id p9so1133920lbv.17
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 12:24:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VNHBrk+HWGLZxNOBFXsGv6XLQus8zTx-AP2Ye6jbgnPA@mail.gmail.com>
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6VNHBrk+HWGLZxNOBFXsGv6XLQus8zTx-AP2Ye6jbgnPA@mail.gmail.com>
Date: Thu, 24 Apr 2014 21:24:37 +0200
Message-ID: <CALhHN=oYVjMqQG8XyHuWik14R6hGUSbt986YLXqH361gio6CjQ@mail.gmail.com> (sfid-20140424_212950_716943_9772F1A1)
Subject: Re: [PATCH] cfg80211: reg: track crda request
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 April 2014 19:33, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Wed, Apr 16, 2014 at 3:53 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>>
>>  static void reg_timeout_work(struct work_struct *work)
>>  {
>> -       REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
>> +       struct regulatory_request *lr;
>> +
>>         rtnl_lock();
>> -       restore_regulatory_settings(true);
>> +
>> +       lr = get_last_request();
>> +       REG_DBG_PRINT("Timeout while waiting for CRDA to reply %s request, restoring regulatory settings\n",
>> +                     reg_initiator_name(lr->initiator));
>> +
>> +       switch (lr->initiator) {
>> +       case NL80211_REGDOM_SET_BY_CORE:
>> +       case NL80211_REGDOM_SET_BY_DRIVER:
>> +               /* Call CRDA again for last request */
>> +               reg_process_hint(lr);
>> +               break;
>> +       case NL80211_REGDOM_SET_BY_USER:
>> +               restore_regulatory_settings(true);
>> +               break;
>> +       case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>> +               restore_regulatory_settings(false);
>> +               break;
>> +       default:
>> +               WARN_ON(1);
>> +               break;
>> +       }
>>         rtnl_unlock();
>>  }
>
> Janusz,
>
> As is, we don't ever bail out and could end up triggering CRDA to be
> called every ~3 seconds with this patch. This is why I had added the
> opportunistic triggers, which are technically still in place today but
> there are only a few entries for those to kick off: beacon hints on 5
> GHz for cards that enable beacon hints. I don't think its a good idea
> we have a a recurring timer trigger for this. I think we need to
> consider a time at which we should give up on CRDA being present and
> instead rely on userspace to let us know its ready (ideally userspace
> would do something with inotify on the path) so we can kick the queue
> again.
>

I think about such counter/limitation before.
But next I remove such counter.
In case we don't have CRDA nor using INTERNAL_REGD - this mean we
don't have correct regulatory configuration.
Why then should we stop warning about this?

In case we will have counter eg. 10 x 3 seconds, we can't be sure if that is:
- not mounted fs (fsck other ...) case
- there isn't any CRDA in the system (quite possible when using openwrt) case
- when have a lot of messages in dmesg you will not know there is not
CRDA in the system

In case of recurring timer when you will check dmes you will be sure
there isn't any CRDA binary - and there will be clear message about
this.
Because of that I didn't add this counter.

BR
Janusz

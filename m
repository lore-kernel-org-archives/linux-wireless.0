Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54818 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976Ab2E3Ra4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 13:30:56 -0400
Received: by laai10 with SMTP id i10so55092laa.41
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 10:30:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338395594.4511.31.camel@jlt3.sipsolutions.net>
References: <1338393559-1792-1-git-send-email-victorg@ti.com>
	<1338395594.4511.31.camel@jlt3.sipsolutions.net>
Date: Wed, 30 May 2012 20:30:53 +0300
Message-ID: <CAK80WHZRU_ML6jxn0g39N72LFkeTAs1JPRW8r46Ma5Sb36UgTQ@mail.gmail.com> (sfid-20120530_193100_858462_40A8CB4B)
Subject: Re: [PATCH v2 1/2] nl80211/cfg80211: add scan channel times to scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 7:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-05-30 at 18:59 +0300, Victor Goldenshtein wrote:
>
>>  #define IEEE80211_SCAN_RESULT_EXPIRE (30 * HZ)
>> +#define      IEEE80211_CHANNEL_TIME          (HZ / 33)
>> +#define      IEEE80211_PASSIVE_CHANNEL_TIME  (HZ / 8)
>
> And as you just heard on IRC, this is bogus since the units are supposed
> to be TU, not jiffies (which isn't a valid unit to use in a userspace
> API anyway since it's not even a "constant" unit)
>

will define the default scan times in TU as:

+#define      IEEE80211_CHANNEL_TIME_TU                      (1024 / 33)
+#define      IEEE80211_PASSIVE_CHANNEL_TIME_TU  (1024 / 8)

and will convert them back to jiffies in the software scan.

-- 
Thanks,
Victor.

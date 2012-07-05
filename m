Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2GEQsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 12:48:38 -0400
Received: by pbbrp8 with SMTP id rp8so13036620pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 09:48:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341474303.4455.5.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 5 Jul 2012 09:48:16 -0700
Message-ID: <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com> (sfid-20120705_184842_322981_B105DA7B)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 12:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-07-04 at 09:26 -0700, Luis R. Rodriguez wrote:
>> I've skipped the other comments as I can address those in a new series.
>>
>> On Wed, Jul 4, 2012 at 2:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > So I'm not really convinced about this. It seems this Kconfig should
>> > better be a Kconfig that enables other Kconfig only, not enabling other
>> > features. How else would anyone be able to do due diligence and check
>> > what exactly this enables that they need to test?
>>
>> Makes sense, so would we then have CONFIG_REG_HINT_CELL_BASE_STATION ?
>
> I don't know how fine-grained it should be? Maybe it should be more
> generic and be a config for all (future) kinds of user hints?

Well so in this case the cell base station hint support gets used and
trusted on the wireless core if CONFIG_REG_HINT_CELL_BASE_STATION is
set. Whether or not a *driver* trusts and uses it as well will depend
on whether or not they set the NL80211_FEATURE_CELL_BASE_REG_HINTS
feature on their wiphy->features. The way I was thinking about drivers
going about enabling / disabling was to let the driver have its own
kconfig option for this. The reason is that firmware may require some
implementation / changes / testing to ensure that a device won't poop
out if this is used.

  Luis

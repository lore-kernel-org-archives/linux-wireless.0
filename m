Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:22910 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYGIWpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 18:45:16 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1906076waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 15:45:14 -0700 (PDT)
Message-ID: <1ba2fa240807091545r37c6cff2l109bc24fa416b0a0@mail.gmail.com> (sfid-20080710_004521_062552_8E1E1674)
Date: Thu, 10 Jul 2008 01:45:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi workaround for mac80211 sequence number bug
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunksi" <ron.rindjunski@intel.com>
In-Reply-To: <1215642292.3246.79.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215641485.3246.72.camel@johannes.berg>
	 <1ba2fa240807091517y40f6ab8cscc352bfdaa0d715@mail.gmail.com>
	 <1215642292.3246.79.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 1:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-10 at 01:17 +0300, Tomas Winkler wrote:
>
>> This is not a bug in mac.
>> The sequence number can be committed only if the packet is not dropped
>> somewhere in the driver. See lower in the function.. There are plenty
>> of  places on the TX path when packet can be dropped this it's last
>> station.  There is no reason to pushing this into mac
>
> I don't see it that way. In fact, in the code I'm looking at, there is
> nothing that drops the frame before committing the sequence number
> change after assigning it.
>
> And all the cases where it drops the frame _before_ the piece of code I
> quoted don't actually matter, the first bunch of those are bugs and the
> not associated one is strange but most likely doesn't matter either (if
> we're not associated sequence numbers don't matter), and the
> "destination STA entry not found" one doesn't matter either since that
> means there's some disconnect/bug between iwlwifi and mac80211 since
> they should synchronise via sta_notify().

Unfortunately sta_notify still does nothing in iwlwifi, need some more
work on this.
I've eliminated most dropping places over the time if you look in the
history it wasn't like that before and not all of the parts of the
code develops in the same speed.
Anyhow it doesn't matter for the packet that was dropped but it matter
for the packet that will come.  I think that advancing sequence number
should be low as possible. I'm not sure about other drivers' drop
points.

> Which particular item do you see as problematic?
Most problem at the time was found a good place for it in the mac80211.

Tomas

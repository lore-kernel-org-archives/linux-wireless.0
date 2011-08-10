Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54302 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1HJUkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:40:55 -0400
Received: by wyg24 with SMTP id 24so987074wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313007274.4016.2.camel@jlt3.sipsolutions.net>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	<1312933511-9486-2-git-send-email-thomas@cozybit.com>
	<1312983507.4325.1.camel@jlt3.sipsolutions.net>
	<CAG6hwVN27E=bt_-Ocv2JagUPmtZAWux17Lm3cV24be9TfM1BDQ@mail.gmail.com>
	<1313007274.4016.2.camel@jlt3.sipsolutions.net>
Date: Wed, 10 Aug 2011 13:40:54 -0700
Message-ID: <CAG6hwVOw8RZDZfEKoxTSK50taq2o7hLE_wUVNWW_k7kH3gfkVA@mail.gmail.com> (sfid-20110810_224102_899609_BD2CC0E2)
Subject: Re: [PATCH 1/8] mac80211: improve mpath debugging
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 1:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-08-10 at 13:11 -0700, Thomas Pedersen wrote:
>> On Wed, Aug 10, 2011 at 6:38 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
>> >
>> >> +#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
>> >> +#define mpath_dbg(fmt, args...)      printk(KERN_DEBUG fmt, ##args)
>> >> +#else
>> >> +#define mpath_dbg(fmt, args...)      do { (void)(0); } while (0)
>> >> +#endif
>> >
>> > Maybe this should be a static inline for checking the fmt args even when
>> > it's compiled out?
>> >
>> I don't really see the point, since all this would give us is the
>> compiler checking whether a const char * was passed as an argument to
>> fmt, right?
>
> No, if you annotate it correctly gcc will also check that the arguments
> match, and warn if you do
>
> mpath_dbg("foo: %s", 7)
>
> for example :-)

Ah, well OK. The next version will include this change.

Thomas

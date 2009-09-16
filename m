Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34552 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZIPP3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 11:29:37 -0400
Received: by bwz19 with SMTP id 19so3576949bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 08:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382256815.20090916121443@mail.ru>
References: <174470396.20090916030952@mail.ru>
	 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
	 <792649359.20090916034611@mail.ru>
	 <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
	 <90263558.20090916050213@mail.ru>
	 <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
	 <1382256815.20090916121443@mail.ru>
Date: Wed, 16 Sep 2009 16:24:11 +0100
Message-ID: <3ace41890909160824w146d63e6haddabe645d3e27d2@mail.gmail.com>
Subject: Re: Re[6]: cfg80211 and rfkill_backport question.
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2009 at 10:14 AM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello Luis!
>
> Wednesday, September 16, 2009, 4:17:40 AM, Luis R. Rodriguez wrote:
>> They don't have to be exported and inlined, its one or the other. So
> Yes, that's what I supposed.
>> just ensure you your symbols you have conflicts with as
>> EXPORT_SYMBOL() or defined in a header file as inline. You will
>> obviously also need the header declaration if defined as an
>> EXPORT_SYMBOL.
> From what I checked it all looks fine to me, except that there is
> a circular dependency between cfg80211 and rfkill_backport (which
> is confirmed by nm output I suppose). Is this circular dependency
> intentional? Or, could it be avoided? (My understanding was that
> as module loader loads one file at a time, it just have no way
> to resolve such symbols, maybe I'm wrong on this)

Hmm, yes and no... insmod loads modules one at a time; but as long as
you run depmod, modprobe loads dependent modules automatically. I
don't know if modprobe works for circular dependency, but it probably
works correctly (since AFAIK, it reference-counts)?

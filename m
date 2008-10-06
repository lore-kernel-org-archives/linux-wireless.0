Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:57174 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYJFQwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:52:34 -0400
Received: by wx-out-0506.google.com with SMTP id h27so614289wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 09:52:32 -0700 (PDT)
Message-ID: <43e72e890810060952p6a9a7ae5i30bdda28f1a9fab8@mail.gmail.com> (sfid-20081006_185259_116669_13C1321C)
Date: Mon, 6 Oct 2008 09:52:32 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
In-Reply-To: <1223296783.15196.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 <1223296221.15196.6.camel@johannes.berg>
	 <1223296592.11272.163.camel@violet.holtmann.net>
	 <1223296783.15196.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 5:39 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-06 at 14:36 +0200, Marcel Holtmann wrote:
>> Hi Johannes,
>>
>> > > I take this back. It took a couple of hours, but it crashed again.
>> >
>> > Do you have 64k pages enabled? My issue goes away entirely when I
>> > disable 64k pages.
>>
>> so the initial issue was a BUG_ON when the ucode reports back an
>> unsupported event. That should have been fixed by now since we just
>> can't crash the whole kernel, because some piece of firmware acts bogus
>> now and then.
>
> I have a different interpretation of the original issue, since afaik the
> value it was doing a BUG_ON on is a value that is only passed in by the
> driver and copied by the ucode to the response, hence it shouldn't
> actually crash unless the driver is passing bogus stuff in or, as it
> seems to be the case here, the DMA programming is completely fucked and
> the ucode just goes to write to random memory locations.

Seems like a good enough argument to call for it to be opened up.

  Luis

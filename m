Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:39228 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0LWCIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 21:08:21 -0500
Received: by iyf40 with SMTP id 40so2539622iyf.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 18:08:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101223020439.GC4215@senthil-lnx.users.atheros.com>
References: <1293032660-3627-1-git-send-email-senthilkumar@atheros.com>
 <AANLkTikGgSbAY1FRHNOoVmgVk3BKdvBtY+ir9y5BywW0@mail.gmail.com>
 <20101223015542.GA4215@senthil-lnx.users.atheros.com> <20101223020439.GC4215@senthil-lnx.users.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 21:07:59 -0500
Message-ID: <AANLkTimjS6kPkvaso11oWoJSLPXkS_m9Jq7JbO1SWuQG@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 9:04 PM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> On Thu, Dec 23, 2010 at 07:25:42AM +0530, Senthilkumar Balasubramanian wrote:
>> On Wed, Dec 22, 2010 at 09:22:06PM +0530, Luis R. Rodriguez wrote:
>> > On Wed, Dec 22, 2010 at 10:44 AM, Senthil Balasubramanian
>> > <senthilkumar@atheros.com> wrote:
>> > > There are few places where we are checking for macversion and revsions
>> > > before RTC is powered ON. However we are reading the macversion and
>> > > revisions only after RTC is powered ON and so both macversion and
>> > > revisions are actully zero and this leads to incorrect srev checks
>> > >
>> > > Incorrect srev checks can cause registers to be configured wrongly and can
>> > > cause unexpected behavior. Fixing this seems to address the ASPM issue that
>> > > we have observed. The laptop becomes very slow and hangs mostly with ASPM L1
>> > > enabled without this fix.
>> >
>> > On what chipset? Or did we see this on one chipset and suspect it can
>> > affect others?
>> We have noticed on Merlin and it is obviously incorrect for other chipsets
> This should be read as "we have noticed this issue with ar9380/ar9382"

The reason I asked about the chipset is ar9380 stuff won't be relevant
for longterm 2.6.35.

  Luis

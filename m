Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40328 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0AYSTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:19:18 -0500
Received: by pzk28 with SMTP id 28so597350pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:19:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264250814.2593.25.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<1264186981.2593.10.camel@johannes.local> <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	<1264189560.2593.14.camel@johannes.local> <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	<1264205494.7208.7.camel@wwguy-ubuntu> <43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	<1264206170.7208.8.camel@wwguy-ubuntu> <1264250814.2593.25.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jan 2010 10:18:57 -0800
Message-ID: <43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 4:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-01-22 at 16:22 -0800, Guy, Wey-Yi wrote:
>
>> > > We are doing Power consumption test with different DTIM value, the test
>> > > is based on test scripts, so we disable the NetworkManager to make sure
>> > > we can control which AP we need to associated with. During the test, we
>> > > notice when AP change it DTIM value, a lot time STA will used the old
>> > > DTIM value in Power Save mode which cause problem.
>> >
>> > Ah I see. What if there was no old dtim value before?
>>
>> I am not sure, I believe the default is "1", but I might be wrong
>
> Yes, since 0 is nonsensical, we would use 1 instead.

OK -- it seems we have a consensus waiting for a beacon would be good,
but it would be good to have something in for stable. Is the patch Guy
posted acceptable for that purpose? That is, merge this for now until
we get beacon wait implemented prior to association.

  Luis

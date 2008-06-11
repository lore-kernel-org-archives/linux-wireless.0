Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:59326 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYFKK5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 06:57:41 -0400
Received: by an-out-0708.google.com with SMTP id d40so722137and.103
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 03:57:40 -0700 (PDT)
Message-ID: <43e72e890806110357v64beb0c6h92db67aae0b4e99b@mail.gmail.com> (sfid-20080611_125748_917879_DA17EF50)
Date: Wed, 11 Jun 2008 03:57:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] First CRDA integration work
In-Reply-To: <43e72e890806110329o28ad24e5g8331917fcfbebc78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080611040402.GE17936@ruslug.rutgers.edu>
	 <43e72e890806110329o28ad24e5g8331917fcfbebc78@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 3:29 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Jun 10, 2008 at 9:04 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>>
>> Release, review early. First work patch for integration of
>> CRDA work. Nukes old regulatory work, adds CRDA-like data structures
>> to cfg80211, adds a world regdom and uses it by default,
>> and start nl80211 definitions. The fun part, nl80211_get_reg()
>> and nl80211_set_reg() are pending. Hoping the second
>> shift <cough Johannes> can take over as I'm going to bed now.
>>
>> At least it compiles, and should give an idea of where this is
>> going. This wasn't tested either :)
>>
>> CRDA stuff can be checked out from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git
>>
>> For those who like diagrams:
>>
>> http://wireless.kernel.org/crda.png
>
> OK well it doesn't crash, lucky me. I'm on it now.
>
> Also credit where its due: Thanks to Johannes for whipping up the
> userspace API really quickly and so well :) Not to mention already
> having set up mac80211 to make this patch easy :)

OK some issues: we don't handle yet the case where
power_rule->max_antenna_gain is 0 which is designed to mean "Not
available" in those cases the original antenna gain of the channel
(set by the EEPROM mapping for example) should be left alone.

Now for the netlink hooks and CRDA to query back.

  Luis

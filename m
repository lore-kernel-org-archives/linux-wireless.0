Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33219 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbbLQRlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 12:41:32 -0500
Received: by mail-lf0-f52.google.com with SMTP id p203so57464399lfa.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 09:41:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151217155633.GC6910@tuxdriver.com>
References: <20151216173223.GF4073@localhost>
	<20151217155633.GC6910@tuxdriver.com>
Date: Thu, 17 Dec 2015 19:41:30 +0200
Message-ID: <CANUX_P2Q7QrmKD5HXdxHB3NrPr9zdh+G9Ac8QiaxoyCP0DQapg@mail.gmail.com> (sfid-20151217_184136_347894_39152BA4)
Subject: Re: [ANNOUNCE] New location for wireless-testing tree
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 17, 2015 at 5:56 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Dec 16, 2015 at 12:32:23PM -0500, Bob Copeland wrote:
>> As reported previously[1], John Linville will be moving on from maintenance
>> of the wireless-testing[2] tree at the end of the year.  A huge thank you to
>> John for doing all this work for so many years!
>>
>> We now have a shared wireless directory on kernel.org where we (currently
>> myself and Kalle as backup) will continue to maintain this tree going
>> forward.  The new tree can be found at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
>>
>> Note: unlike John's tree, we are going to try rebasing this tree on every
>> build (like linux-next) instead of merging the downstream trees, in order
>> to avoid certain merge problems when those trees are rebased.
>>
>> This means that if you are working directly off of wireless-testing, use
>> 'git pull --rebase' to sync, instead of just 'git pull'.
>>
>> We'll see how this goes and reassess after a couple of cycles.
>>
>> Please let me know of any issues.
>>
>> [1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/145291
>>
>> [2] wireless-testing is an integration testing tree, consisting of:
>>
>>  * Linus's latest -rc
>>  * patches in mac80211 and wireless-drivers (for the upcoming release)
>>  * patches in mac80211-next and wireless-drivers-next (for the next release)
>>
>> It is not pulled into any upstream tree, but it should be a pretty good
>> indication of what is baking in Linux wireless for the next release, without
>> having unrelated changes from all the other subsystems as in linux-next.
>
> Given this most welcome announcement, I will hereby cease maintenance
> of the predecessor wireless-testing tree in favor of this new
> canonical source.
>

Somewhat related. I started a while ago to mirror our internal
development tree to korg. You'll find there the bleeding edge of
iwlwifi's development: both fixes and new features. It is a backport
based tree. Pretty much all the patches for mac80211{-next}.git that
we (Intel) send come from there as well. Note that this is the "raw
data" (including Change-IDs and server that are inside Intel's
intranet) which I later edit to send patches upstream. I merge
mac80211.git and mac80211-next.git to that tree to get mac80211
patches that come from upstream. In a sense, this tree looks like a
backport of wireless-testing with content that is not there yet.
You'll also find there "stable branches" that go through more thorough
test cycles against their matching firmware version.

I am not sure anyone is interested, but if someone wants, the tree is here:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/

A bit more info on the "stable branches":
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release

Drop me an email if you start to use this tree just to know if people
are really using it :)

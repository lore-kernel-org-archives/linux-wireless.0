Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59978 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFYRed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 13:34:33 -0400
Message-ID: <53AB0828.8060207@candelatech.com> (sfid-20140625_193441_634400_29730DFB)
Date: Wed, 25 Jun 2014 10:34:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: Re: [RFC] wireless: improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com> <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com> <20140623205451.GG1390@garbanzo.do-not-panic.com> <53A89A0F.9090509@candelatech.com> <20140624004442.GH1390@garbanzo.do-not-panic.com> <53A8E3F9.7000001@candelatech.com> <CAB=NE6XJaHNAL17mN7Ghw9GnatOwaOacikv5XupK7xKjUe=m_Q@mail.gmail.com> <53AAFD75.7090603@candelatech.com> <CAB=NE6WY978KkB6KL3MLDJOekgwBk4r--vjQ-+Qke6SLJn9EGg@mail.gmail.com>
In-Reply-To: <CAB=NE6WY978KkB6KL3MLDJOekgwBk4r--vjQ-+Qke6SLJn9EGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2014 10:20 AM, Luis R. Rodriguez wrote:
> On Wed, Jun 25, 2014 at 9:48 AM, Ben Greear <greearb@candelatech.com> wrote:
>> I started trying to do some more DFS testing on a 3.14.8+ kernel,
>> and from what I can tell, the US region is configured for
>> DFS-Unset.  I was assuming this should be set to DFS_FCC.
>>
>> I tried installing the latest regulatory.bin.  crda is whatever
>> is standard on Fedora 19.
>>
>> Do you know if DFS is supposed to work at all in the 3.14 kernel?
> 
> DFS region support was added upstream via 8b60b07805
> 
> mcgrof@ergon ~/linux (git::master)$ git describe --contains 8b60b07805
> v3.3-rc1~182^2~44^2~384
> 
> Now, that doesn't mean a driver will have DFS support of course. I'm
> not going to treasure hunt that for you.

The driver (ath10k) works, and if I manually force the 'US' regulatory domain
to use DFS-FCC in set_regdom in reg.c, then it shows up as DFS-FCC in 'iw reg get'
and hostapd & driver properly detects radar since airport is nearby, hostapd
chooses a different channel, and things go on working.

>> I'm certain I had this working earlier on this machine,
>> but I was on a somewhat patched linux.ath tree at the
>> time it seems....
> 
> There's an issue Krishna reported about internal db now parsing the
> new db.txt format properly after the antenna gain removal but a patch
> is supposed to be on the way.  You don't seem to be using that though
> so you may want to debug things a bit further.

Is the 'regulatory.bin' from today's wireless-regdb repository
correct?  I did not try regenerating it..I just did a git pull...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


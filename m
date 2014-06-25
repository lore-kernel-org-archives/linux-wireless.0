Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:38246 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaFYRU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 13:20:26 -0400
Received: by mail-la0-f42.google.com with SMTP id pn19so1001135lab.15
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 10:20:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53AAFD75.7090603@candelatech.com>
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
 <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com>
 <20140623205451.GG1390@garbanzo.do-not-panic.com> <53A89A0F.9090509@candelatech.com>
 <20140624004442.GH1390@garbanzo.do-not-panic.com> <53A8E3F9.7000001@candelatech.com>
 <CAB=NE6XJaHNAL17mN7Ghw9GnatOwaOacikv5XupK7xKjUe=m_Q@mail.gmail.com> <53AAFD75.7090603@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 25 Jun 2014 10:20:05 -0700
Message-ID: <CAB=NE6WY978KkB6KL3MLDJOekgwBk4r--vjQ-+Qke6SLJn9EGg@mail.gmail.com> (sfid-20140625_192031_717269_8703BF62)
Subject: Re: [RFC] wireless: improve dfs-region intersection.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2014 at 9:48 AM, Ben Greear <greearb@candelatech.com> wrote:
> I started trying to do some more DFS testing on a 3.14.8+ kernel,
> and from what I can tell, the US region is configured for
> DFS-Unset.  I was assuming this should be set to DFS_FCC.
>
> I tried installing the latest regulatory.bin.  crda is whatever
> is standard on Fedora 19.
>
> Do you know if DFS is supposed to work at all in the 3.14 kernel?

DFS region support was added upstream via 8b60b07805

mcgrof@ergon ~/linux (git::master)$ git describe --contains 8b60b07805
v3.3-rc1~182^2~44^2~384

Now, that doesn't mean a driver will have DFS support of course. I'm
not going to treasure hunt that for you.

> I'm certain I had this working earlier on this machine,
> but I was on a somewhat patched linux.ath tree at the
> time it seems....

There's an issue Krishna reported about internal db now parsing the
new db.txt format properly after the antenna gain removal but a patch
is supposed to be on the way.  You don't seem to be using that though
so you may want to debug things a bit further.

 Luis

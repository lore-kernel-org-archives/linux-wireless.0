Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53208 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2FHP4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 11:56:35 -0400
Received: by qabj40 with SMTP id j40so1272044qab.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 08:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339170742.5748.10.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<1339094215.4630.7.camel@jlt3.sipsolutions.net>
	<1339102567.4630.8.camel@jlt3.sipsolutions.net>
	<4FD11B47.10002@lwfinger.net>
	<CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com>
	<1339136879.5832.1.camel@jlt3.sipsolutions.net>
	<1339137689.5832.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
Date: Fri, 8 Jun 2012 17:56:34 +0200
Message-ID: <CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com> (sfid-20120608_175639_943037_93321BC2)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 5:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 17:48 +0200, Johannes Berg wrote:
>
>> > Ahrg! I keep numbering them wrong, this should be fixed:
>> > http://p.sipsolutions.net/3bbdb9c6294dad70.txt
>>
>> Nope, still wrong, I shouldn't be using skb_get_queue_mapping but rather
>> info->index since now mac80211 is giving us the right *queue number*
>> rather than just *AC*
>
> Hopefully this is better: http://p.sipsolutions.net/017d73ac0688f863.txt

The previous patched all had the mac suspend failure. This one:

drivers/net/wireless/b43/main.c: In function 'b43_qos_upload_all':
drivers/net/wireless/b43/main.c:3483: error: size of array 'type name'
is negative
drivers/net/wireless/b43/main.c: In function 'b43_qos_clear':
drivers/net/wireless/b43/main.c:3502: error: size of array 'type name'
is negative
drivers/net/wireless/b43/main.c: In function 'b43_op_conf_tx':
drivers/net/wireless/b43/main.c:3578: error: size of array 'type name'
is negative

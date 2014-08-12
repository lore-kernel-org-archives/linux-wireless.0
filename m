Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62708 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbaHLNzo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 09:55:44 -0400
From: Avinash Patil <patila@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 12 Aug 2014 06:51:15 -0700
Subject: RE: mwifiex: switching from adhoc to 5GHz managed fails
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147BFF@SC-VEXCH2.marvell.com> (sfid-20140812_155549_448422_1E8F8AC1)
References: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com>,<CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com>
In-Reply-To: <CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

Not many fixes have gone in after 701a9e6; also none of the fixes affect adhoc creation/join as such.

What is your FW revision? Also if possible, can you please collect dynamic debug logs.

Thanks,
Avinash.
________________________________________
From: Andreas Fenkart [afenkart@gmail.com]
Sent: Tuesday, August 12, 2014 4:28 AM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org
Subject: Re: mwifiex: switching from adhoc to 5GHz managed fails

Hi Avinash,

2014-08-08 14:51 GMT+02:00 Avinash Patil <patila@marvell.com>:
> Are you setting type back to managed after leaving ibss?
yes

> I quickly tried this in my setup and after setting type to managed before connection to 5GHz AP, association is successful.

15ba2236f3556fc01b9ca91394465152b5ea74b6 Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
9a3c4145af32125c5ee39c0272662b47307a8323 Linux 3.16-rc6

and latest commit in driver/net/wireless/mwifiex:
701a9e619347ac06d59481db14bbc4df99763270 mwifiex: initialize Tx/Rx
info of a packet correctly

Am I missing some patches?

> If I dont set type, I see error from iw itself "operation not supported".
I receive "ASSOC_RESP: failed:"

iw version : 3.13

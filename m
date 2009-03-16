Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:54875 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZCPNWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 09:22:34 -0400
Received: by ewy25 with SMTP id 25so3461985ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 06:22:31 -0700 (PDT)
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Message-Id: <F3209A42-65EA-4F71-8443-67E2F8CAFA3F@icix.org> (sfid-20090316_142238_046397_F85254B8)
From: =?ISO-8859-1?Q?Ant=F3nio_Marques?= <froz@icix.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200903151445.01344.IvDoorn@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Mon, 16 Mar 2009 13:22:27 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <467E98EC-F5B1-4D79-914E-35E021125E37@icix.org> <594B4EB2-FE87-4756-B016-C83083EF415B@icix.org> <200903151445.01344.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 15, 2009, at 13:45 , Ivo van Doorn wrote:
> On Sunday 15 March 2009, Antonio Marques wrote:
>> Upon further investigation, beaconing does not work after configuring
>> an interface in mesh point mode but running 'iwlist mesh scan'
>> triggers something in the driver that enables beaconing.
>> After executing this command beacons are generated and correctly
>> received at other nodes.
>
> Thats odd, but very interesting :)
> Could you enable debugfs and CONFIG_RT2X00_LIB_DEBUGFS and
> use the script from http://kernel.org/pub/linux/kernel/people/ivd/tools/rt2x00_regdump.sh
> to create a register dump before running 'iwlist mesh scan' and  
> afterwards.
> (So basically when beaconing is broken and when it is working).
>
> Thanks,
>
> Ivo


As requested, I have attached the output of the script run before and  
after
running 'iwlist mesh scan'. Unfortunately there seems to be no change in
the output. I have also included the queue statistics as these do  
change from
one state to the next. Any further pointers to help debug this? I'll  
gladly test
any patches that try to address this issue.

Antonio Marques


Before running 'iwlist mesh scan':

kernel: 2.6.29-rc7-wl
driver:	rt73usb
version:	2.3.0
compiled:	Mar 16 2009 11:53:37
dev_flags: 0x0000625f
rt chip:	1300
rf chip:	0002
revision:	0002573a

register	base	words	wordsize
csr	12288	300	4
eeprom	0	128	2
bbp	0	128	1
rf	4	4	4


Queues:

qid	count	limit	length	index	done	crypto
14	0	24	1	1	0	0
0	0	24	0	0	0	0
1	0	24	0	0	0	0
2	6	24	0	6	6	0
3	0	24	0	0	0	0
16	0	4	0	0	0	0


After running 'iwlist mesh scan':

kernel: 2.6.29-rc7-wl
driver:	rt73usb
version:	2.3.0
compiled:	Mar 16 2009 11:53:37
dev_flags: 0x0000625f
rt chip:	1300
rf chip:	0002
revision:	0002573a

register	base	words	wordsize
csr	12288	300	4
eeprom	0	128	2
bbp	0	128	1
rf	4	4	4

Queues:

qid	count	limit	length	index	done	crypto
14	0	24	8	8	0	0
0	11	24	0	11	11	0
1	0	24	0	0	0	0
2	6	24	0	6	6	0
3	0	24	0	0	0	0
16	0	4	0	0	0	0



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54712 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0ANUZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 15:25:56 -0500
Received: by pzk1 with SMTP id 1so47557pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 12:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <995709e41001141215k76582249sc4761bdc13d94bb4@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	<995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	<4B4C8320.8060801@free.fr> <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	<43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
	<995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
	<43e72e891001120918v70c3be7nd3d3819f0e8b0cd0@mail.gmail.com>
	<995709e41001122307g2d0e9546g2b3680a6cb0a345d@mail.gmail.com>
	<20100113160942.GB15698@tux> <995709e41001141215k76582249sc4761bdc13d94bb4@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 14 Jan 2010 12:25:34 -0800
Message-ID: <43e72e891001141225h31aba82en213d529e1cc5f8cc@mail.gmail.com>
Subject: Re: [ath9k-devel] [Moblin Dev] Wireless is keep on disconnecting
To: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"arjan@linux.intel.com" <arjan@linux.intel.com>,
	"Li, Yan" <yan.i.li@intel.com>, "dev@moblin.org" <dev@moblin.org>,
	alainswb <alainswb@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 14, 2010 at 12:15 PM, Jaswinder Singh Rajput
<jaswindermobile@gmail.com> wrote:
> Hello,
>
> On Wed, Jan 13, 2010 at 9:39 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Tue, Jan 12, 2010 at 11:07:45PM -0800, Jaswinder Singh Rajput wrote:
>>> Hello Luis,
>>>
>>> On Tue, Jan 12, 2010 at 10:48 PM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com> wrote:
>>> > On Tue, Jan 12, 2010 at 9:14 AM, Jaswinder Singh Rajput
>>> > <jaswindermobile@gmail.com> wrote:
>>> >> Hello Luis,
>>> >>
>>> >> On Tue, Jan 12, 2010 at 10:16 PM, Luis R. Rodriguez
>>> >> <lrodriguez@atheros.com> wrote:
>>> >>> On Tue, Jan 12, 2010 at 7:24 AM, Jaswinder Singh Rajput
>>> >>> <jaswindermobile@gmail.com> wrote:
>>> >>>
>>> >>>>> I keep on getting "Network Lost" message on moblin 2.1 when I transfer
>>> >>>>> some big file. I am trying to understand Is it a feature or a Bug.
>>> >>>>>
>>> >>>>> My other machines are working great with Wireless even Windows XP
>>> >>>>> running on Netbook never did this to me.
>>> >>>
>>> >>> Your report lacks a lot of information, its unclear what Moblin 2.1 is
>>> >>> using for its kernel for those who are not following moblin
>>> >>> development on a regular basis, and if its anything older than 2.6.32
>>> >>> its old and I recommend upgrading. May want to try to upgrade your
>>> >>> kernel or upgrade to a stable release of compat-wireless snapshot for
>>> >>> example:
>>> >>>
>>> >>> http://wireless.kernel.org/en/users/Download/stable
>>> >>>
>>> >>
>>> >> I am attaching dmesg on Acer Aspire One D250 Netbook.
>>> >>
>>> >> I am going to build latest git kernel and with latest wireless kernel
>>> >> on it and let you know the status.
>>> >
>>> > latest wireless kernel is not a good idea if you are considering using
>>> > wireless-testing unless your are up to deal with a bleeding edge
>>> > kernel which may not yet be completely stable. Stick to stable if you
>>> > want stable.
>>> >
>>>
>>> I have old kernel git tree (2.6.32-rc7 ac50e9507 , Tue Nov 17 09:42:35
>>> 2009) sitting on my box I tested with it.
>>> I have tested it for long time and I am attaching the dmesg, I never
>>> got Network Lost message with :
>>> commit ac50e950784cae1c26ad9e09ebd8f8c706131eb3
>>> Merge: 5743695... 6c06f07...
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Tue Nov 17 09:42:35 2009 -0800
>>>
>>> Here is my test with iperf, even though iperf client does not work so
>>> I used iperf server and get speed of approx 19 Mbits/sec. Now my issue
>>> is why speed is soo slow ?
>>>
>>> [jaswinder@jaswinder-desktop iperf-2.0.4]$ ./configure CXX=g++-4.3
>>> CC=gcc-4.3 --prefix=/home/jaswinder
>>>
>>> [jaswinder@jaswinder-desktop iperf-2.0.4]$ iperf -c 192.168.1.220
>>> connect failed: No route to host
>>> write1 failed: Broken pipe
>>> write2 failed: Broken pipe
>>> ------------------------------------------------------------
>>> Client connecting to 192.168.1.220, TCP port 5001
>>> TCP window size: 16.0 KByte (default)
>>> ------------------------------------------------------------
>>> [  3] local 0.0.0.0 port 38243 connected with 192.168.1.220 port 5001
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  3]  0.0- 0.0 sec  0.00 Bytes  0.00 bits/sec
>>> [jaswinder@jaswinder-desktop iperf-2.0.4]$ iperf -s
>>> ------------------------------------------------------------
>>> Server listening on TCP port 5001
>>> TCP window size: 85.3 KByte (default)
>>> ------------------------------------------------------------
>>> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.220 port 48659
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  4]  0.0-10.3 sec  23.1 MBytes  18.9 Mbits/sec
>>> [  5] local 192.168.1.2 port 5001 connected with 192.168.1.220 port 48660
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  5]  0.0-10.2 sec  24.0 MBytes  19.7 Mbits/sec
>>> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.220 port 39090
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  4]  0.0-120.2 sec    286 MBytes  19.9 Mbits/sec
>>>
>>> I will also test with wireless-testing tree and let you know the results.
>>
>> I recommend to use latest stable, use wireless-testing if you feel comfortable
>> with dealing with issues. your 2.6.32-rc7 is old, I recommend a stable release,
>> there have been quite a large number of fixes that have gone into the 2.6.32
>> stable series already.
>>
>
> With wireless-testing I am getting oops. I am attaching it picture.

What did I tell you about wireless-testing? Its unstable and you
should use if only if you are up for it. Anyway, try the patch Sujith
posted that seems would address that, titled:

[PATCH] ath9k: Fix panic on driver load

> I also noticed one more thing now speed is further reduced from 19 to 15 Mbps :

So for each single issue you are going to keep at it on the same
thread? That' doesn't work well.

You are likely going to be able to help developers parse better your
issues if you separate them. And when you do separate your issues,
keep the list trimmed, you have the entire world on your CC list. You
just need linux-wireless for wireless-testing issues.

Also, provide more information like your AP setup, 'iw event -t' log, etc.

Please, go read:

http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

  Luis

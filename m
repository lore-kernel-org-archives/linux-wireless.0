Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44712 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759723Ab1CDPuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 10:50:04 -0500
Received: by wyg36 with SMTP id 36so2210214wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 07:50:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110303191656.73bba824@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
	<AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
	<20110302163051.425d1419@toddler>
	<AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
	<20110303143151.03dbe76b@toddler>
	<AANLkTiksdt5fciyFZ_nphEYgLH6Ey_HSHHpY5Eg9pNqD@mail.gmail.com>
	<20110303191656.73bba824@realh.co.uk>
Date: Fri, 4 Mar 2011 21:20:02 +0530
Message-ID: <AANLkTikjQPVjkHZy29B9e=jgOyH__HB0ED0aSQALEc2t@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/4 Tony Houghton <h@realh.co.uk>:
> On Thu, 3 Mar 2011 21:27:32 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> sudo modprobe ath9k debug=0xffffffff
>
> That debug option was what I needed. I'm attaching what I captured with
> netconsole leading up to a crash.

Could not find something suspicious, but need to look more into it.
The patch you mentioned adds support for new version of a  chip and I
am not quite clear how it can directly cause a kernel lock. All those
things added are mainly hardware code and need to see whether some
thing basic is missed in the patch.

>
> I also found that I couldn't reproduce the problem while running on
> battery, but as soon as I connected the PSU it crashed the very next
> time I disabled wireless. I hadn't noticed that PSU/battery made a
> difference before, but it does seem to be an issue.
>

Please see whether this is consistently reproducible.
As a try can you please disable the network manager and use iw command
to connect?

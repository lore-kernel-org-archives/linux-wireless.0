Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45211 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaF0AT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 20:19:58 -0400
Received: by mail-oa0-f53.google.com with SMTP id l6so4805259oag.40
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2014 17:19:58 -0700 (PDT)
Message-ID: <53ACB8B0.7030007@lwfinger.net> (sfid-20140627_022014_978061_B18432C1)
Date: Thu, 26 Jun 2014 19:20:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wuk@josip-volf.info, davgordon@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Re: Driver for Mediatek MT7630E
References: <2508403.0JHOuVQMG0@x750lb01>
In-Reply-To: <2508403.0JHOuVQMG0@x750lb01>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2014 04:41 AM, Josip Volf - Wuk wrote:
> Larry Finger wrote:
>> For interested readers, I have modified the GitHub code to compile using
>> the current wireless-testing kernel source. If there is sufficient
>> interest, I could set up a new GH repo for it as an interim measure with
>> conditional code allowing it to build on recent kernels (3.5+).
>
> I have a notebook with MT7630 wireless device:
> 02:00.0 Network controller [0280]: MEDIATEK Corp. Device [14c3:7630]
>          Subsystem: Foxconn International, Inc. Device [105b:e074]
>
> Is it possible to create a GH repo, I'm not a developer but I'm willing to
> help any way I can, and I'm also a quick learner :)

I forked the older git repo to http://github.com/lwfinger/mt7630. The code there 
will build on any kernel 3.5 or newer (including 3.16).

Although it will build, it still needs a lot of work. The driver is very 
"chatty" and spams the logs. Even more disturbing is that it fails to 
authenticate to any of my APs. That includes WPA1 and WPA2 variants. As usual, 
the necessary commands are as follows:

git clone http://github.com/lwfinger/mt7630
cd mt7630
make
sudo make install

If the make step fails, you have not set up your system to build an 
out-of-kernel driver. The driver produced here will replace rt2800pci and some 
other related drivers.

Larry



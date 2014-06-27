Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35663 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0GxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 02:53:04 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so2259858wiv.10
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2014 23:53:03 -0700 (PDT)
References: <2508403.0JHOuVQMG0@x750lb01> <53ACB8B0.7030007@lwfinger.net>
Mime-Version: 1.0 (1.0)
In-Reply-To: <53ACB8B0.7030007@lwfinger.net>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <386D9605-ACF0-426B-8E30-5301F6881A46@gmail.com> (sfid-20140627_085312_788806_7CBC9BE3)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Driver for Mediatek MT7630E
Date: Fri, 27 Jun 2014 08:53:03 +0200
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Although I stepped down as rt2x00 maintainer I'm still following developments.
I noticed that Mediatek have published a Linux MT7630E driver on their website as well.
This one seems to be a bit newer than the one in the github repo (at least it is based on a newer rt2x00 version).
Maybe you should check that one out.

---
Gertjan

Sent from my iPad

> On 27 jun. 2014, at 02:20, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> On 06/25/2014 04:41 AM, Josip Volf - Wuk wrote:
>> Larry Finger wrote:
>>> For interested readers, I have modified the GitHub code to compile using
>>> the current wireless-testing kernel source. If there is sufficient
>>> interest, I could set up a new GH repo for it as an interim measure with
>>> conditional code allowing it to build on recent kernels (3.5+).
>> 
>> I have a notebook with MT7630 wireless device:
>> 02:00.0 Network controller [0280]: MEDIATEK Corp. Device [14c3:7630]
>>         Subsystem: Foxconn International, Inc. Device [105b:e074]
>> 
>> Is it possible to create a GH repo, I'm not a developer but I'm willing to
>> help any way I can, and I'm also a quick learner :)
> 
> I forked the older git repo to http://github.com/lwfinger/mt7630. The code there will build on any kernel 3.5 or newer (including 3.16).
> 
> Although it will build, it still needs a lot of work. The driver is very "chatty" and spams the logs. Even more disturbing is that it fails to authenticate to any of my APs. That includes WPA1 and WPA2 variants. As usual, the necessary commands are as follows:
> 
> git clone http://github.com/lwfinger/mt7630
> cd mt7630
> make
> sudo make install
> 
> If the make step fails, you have not set up your system to build an out-of-kernel driver. The driver produced here will replace rt2800pci and some other related drivers.
> 
> Larry
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:10951 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1BJFbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 00:31:55 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020256.msg
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 07:31:14 +0200
Subject: Re: SSB AI support code ([RFC] v2)
From: George Kashperko <george@znau.edu.ua>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D5320AA.5020405@lwfinger.net>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net>
Content-Type: text/plain
Date: Thu, 10 Feb 2011 07:24:16 +0200
Message-Id: <1297315457.12795.40.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again.

Here is updated patchset for AI support code.
 ~ found one more mistake (one more thing I've missed out from patches
not published yet. serious one - guaranteed kernel oops right after sb
scan. hopefully will get time to share whole patchwork I've got these
weekends - mostly mips stuff, but also pmu code, dma/gmac driver, etc);
 ~ modified ssb_core_state_flags - now its easy and clean;
 ~ modified ssb_core_ctl_flags - now it accepts mask in way it works in
other ssb_/b43_ maskset helpers (btw still looking for better name for
it, maybe ssb_core_ctl_maskset if you like ?);
 ~ fixed compile time bugs caused by mips deps (again sorry for that,
Larry) - tested by compiling for x86_64 and cross compiling for mips;
 ~ cleaned things out to make checkpatch.pl happy;

mask and val for ssb_core_ctl_flags are still u32. Its retval same as
ssb_core_state_flags is u32 too. Not sure why but I like it in this way
even considering other 2 bytes of flags/core regs aint used currently by
any code known to me. Maybe it could be of some use later ? Anyway if
you insist I will make it u16.

Havent tested it on actual hw yet, just done with patchset and have no
time left cause of work. Will do this evening right after done with
working tasks.

In order to avoid wall'o'posts here is the link to .tar.bz2'ed patchset:
http://www.znau.edu.ua/temp/ssb-ai-linux-wireless-testing/2011-02-10T06-35/2011-02-10T06-35.tar.bz2

Individual patches are available here:
http://www.znau.edu.ua/temp/ssb-ai-linux-wireless-testing/2011-02-10T06-35/

Have nice day,
George

P. S.
Unfortunately will be away from web till evening, got a trip :/



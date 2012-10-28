Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33100 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2J1PtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 11:49:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1677222bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2012 08:49:08 -0700 (PDT)
Message-ID: <508D53EE.7050405@gmail.com> (sfid-20121028_164916_299124_3D8FCE4A)
Date: Sun, 28 Oct 2012 16:49:02 +0100
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"Porter, Matt" <mporter@ti.com>
Subject: Re: mwifiex_sdio problem: firmware fails to be active in time
References: <507F4448.2040707@gmail.com> <477F20668A386D41ADCC57781B1F7043083B80E44A@SC-VEXCH1.marvell.com> <50802984.6070203@gmail.com> <CAMXE1-qWOKphtOjUYWUz1CLDUtAynODvHmLm60rJMC=jBtRsNw@mail.gmail.com> <508AF992.8070606@gmail.com>
In-Reply-To: <508AF992.8070606@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26.10.2012 22:58, Daniel Mack wrote:
> [have to re-open this issue again]
> 
> On 21.10.2012 16:16, Andrei Emeltchenko wrote:
>> I have the same board and see this problem sometimes. Reloading modules
>> might help, if not reboot always works :).
> 
> I thought I solved this issue, but I can't reproduce the running version
> anymore unfortunately. It constantly fails with the error I described,
> even though the clock and all voltages etc are definitely stable.

Ok, following up on my own writings: I solved this issue. It took me
awhile to figure out that the 88WSD8787 is really picky about the
clock/power sequencing. It really needs >= 1ms delay in the startup
phase, otherwise the firmware won't start up.

So if anyone has this problem, make sure to care for that very detail.



Daniel

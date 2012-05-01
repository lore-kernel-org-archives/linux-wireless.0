Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61141 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2EAObu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 10:31:50 -0400
Received: by obbtb18 with SMTP id tb18so886229obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 07:31:50 -0700 (PDT)
Message-ID: <4F9FF3D3.1020006@lwfinger.net> (sfid-20120501_163154_532370_9DD0068A)
Date: Tue, 01 May 2012 09:31:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: simple w8 <simplew8@gmail.com>
CC: Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com> <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com> <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com> <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com> <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com> <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com> <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net> <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com> <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com> <4F9F6B67.5000400@lwfinger.net> <CAKVccoVA=Rk8AkD+h0n9aeV95h0iMcnQgM_WMJq3rjzoFvkU-w@mail.gmail.com> <CAKVccoX=u=qX_OJ8RMSxpNEMGYdGVzimZURJ+ZeNZjhW1jPt6Q@mail.gmail.com>
In-Reply-To: <CAKVccoX=u=qX_OJ8RMSxpNEMGYdGVzimZURJ+ZeNZjhW1jPt6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2012 08:36 AM, simple w8 wrote:
>
> SEams that was your last fix for rtl8192
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=eb641120479de7ee703fabb5e6ee0ec7947474ba
>    that reduced the wifi force, thus detecting less wifi networks.
>
> Running without that "fix" the notebook detects more wifi networks,
> seams like the antenna have more force.

You keep talking about "antenna force". What does that mean?

That patch keeps your device from running forever at a maximum of 1 Mbps by 
adjusting the initial gain of the RX amplifier. You may reverse it if you want 
so that you can detect more APs when you scan; however, most people prefer to 
get better performance from the device. That patch will not be reversed.

As to the problems with power saving, I cannot fix a problem if I cannot 
duplicate it. The locking in that section has been reviewed by several people, 
and there are no glaring errors. If disabling power saving makes your box work, 
then that is what you need to do. That is why those parameters can be set at 
load time.

Larry



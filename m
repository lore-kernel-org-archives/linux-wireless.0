Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56158 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1FZUs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 16:48:59 -0400
Received: by pvg12 with SMTP id 12so2521570pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2011 13:48:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E03A25F.7080103@lwfinger.net>
References: <4E03A25F.7080103@lwfinger.net>
Date: Sun, 26 Jun 2011 22:48:59 +0200
Message-ID: <BANLkTi=6yY6i=EoivVkNUq6RGD6W6hWftg@mail.gmail.com> (sfid-20110626_225502_048301_62BDD4D8)
Subject: Re: Improvement in b43 on BCM4312 (14e4:4315)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 czerwca 2011 22:30 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> Rafał and John,
>
> I was doing routine testing today on 3.0-rc4 kernels built from
> wireless-testing and Linus's mainline git tree. To my surprise, I noticed an
> important difference on the netbook with a 14e4:4315 BCM4312 802.11b/g LP
> PHY device. Although b43 would work OK with light loads, it would always
> fail at heavy loads. Sometimes, it would get the "Out of order TX status"
> failure, and sometimes it would just lose the connection. As that machine is
> quite slow, I maintain its kernel source on an NFS volume exported by an
> x86_64 machine with fast CPUs and relatively fast disks.
>
> Until today, the BCM4312 had never been able to complete the "make
> modules_install" step needed to get a new kernel on the netbook, and would
> fail in the middle of copying the modules from the NFS volume to the local
> /lib/modules tree. After installing the wireless-testing 3.0-rc4 kernel
> using rtl8187 as the network driver, I was quite surprised to find that the
> new kernel could use b43 to install the new kernel from Linus's tree. After
> booting that kernel, the failure returned.
>
> I then made other load tests on the w-t kernel without failures.
>
> There are no real differences between the b43 sources in the two kernels.
> There are lots of changes associated with the bus reorganization; however
> these do not seem to cause the problem.
>
> Only one of the patches to ssb seems to be the "fix", namely commit eb40e3e8
> entitled "drivers/ssb/driver_chipcommon_pmu.c: uninitilized warning" by
> Connor Hansen. I need to do more tests on this patch, but the kernel from
> Linus's tree could reinstall itself when I added this patch. I see no
> indication in the commit message regarding pushing this one to stable, but I
> think it should go upstream to mainline and the stable trees.

It does not look like possible fix to me. Plus it sounds like false
warning from compiler.

Take a look at relation between:
1) updown_tab and updown_tab_size
2) depend_tab and depend_tab_size

Second value (*_size) is never used when first one is NULL. In switch
we don't change updown_tab or depend_tab. They are both NULL, so
updown_tab_size and depend_tab_size should never be checked at all.

Could you do more tests about this, please?

-- 
Rafał

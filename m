Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:30764 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab1CRWvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 18:51:23 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028944.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 00:50:19 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTi=5nwO-xsCok3_R494qFGH-W5CwteP3j5Np9ZK0@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <1300460342.13499.60.camel@dev.znau.edu.ua>
	 <AANLkTimboGmJNdHHbzWdSGf14jenn+yag944A8GBEXtc@mail.gmail.com>
	 <1300483139.15919.42.camel@dev.znau.edu.ua>
	 <AANLkTi=5nwO-xsCok3_R494qFGH-W5CwteP3j5Np9ZK0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 19 Mar 2011 00:50:28 +0200
Message-Id: <1300488628.16395.42.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


В Птн, 18/03/2011 в 23:42 +0100, Rafał Miłecki пишет:
> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> > Well, I see this as following. In generic host life time there are
> > several states. These states are following:
> > 1. Host just started up, underlying backplane is powered up, we issued
> > backplane detect/scan. At this point at least some minimal windowed
> > access is up (if such required), not yet cores/devices are known.
> > 2. Backplane got identified, scanned, individual cores/devices
> > recognised, buscommon and buscore are registered with kernel to get them
> > matched with drivers, and then probed and set up.
> > 3. Buscommon and buscore are driven, host can finish with host specific
> > workarounds, both buscommon and buscore can get their _init entry points
> > called, we can setup host device irq routine, finally we can expose the
> > rest cores/devices to kernel.
> >
> > With that in mind here is my general host ops design pseudo code:
> > struct host_ops {
> >        /* Init call we should get once both buscommon and buscore drivers are bound (state #3) */
> >        int (*init)(struct bcmb_bus *bus);
> >
> >        /* Regular backplane access ops */
> >        u8 (*read(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr);
> >        void (*write(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr, u(8|16|32) val);
> >
> >        /* For some theoretically hard-to-set-up before scan hosts we could keep scan_read32 */
> >        u32 scan_read32(struct bcmb_bus *bus, bcmb_addr_t addr);
> > };
> 
> I don't think it makes much sense. If init is going to be called in
> state #3, what about some pre-init? set_master, request_region, xtal,
> iomap?
> 
These are already done by host-device driver in its _probe.
After you done with that you alloc your host-specific bcmb_pci_host
struct and call something like bcmb_add_bus(host, &my_host_ops);

Have nice day,
George



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:24949 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab1CRVUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 17:20:23 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028929.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 23:19:19 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTimboGmJNdHHbzWdSGf14jenn+yag944A8GBEXtc@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <1300460342.13499.60.camel@dev.znau.edu.ua>
	 <AANLkTimboGmJNdHHbzWdSGf14jenn+yag944A8GBEXtc@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Mar 2011 23:18:59 +0200
Message-Id: <1300483139.15919.42.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> > The clean solution I see here is to have host code apart from
> > backplane-specific processing. The way to accomplish this is obvious as
> > actual host device responsibility is not to switch cores but rather
> > provide mappings into physical address space of the backplane regardless
> > of the target request being made to core, sprom/otp, agent or whatever.
> > This makes much cleaner model than that provided by ssb.
> 
> How do you think, what interface would fit for that?
> 
> Something like:
> struct host_ops {
>         bool (*init)(struct device *dev);
>         bool (*exit)(struct device *dev);
>         bool (*set_agent_addr)(struct device *dev, u16 addr);
>         bool (*set_core_addr)(struct device *dev, u16 addr);
> };
> ?

Well, I see this as following. In generic host life time there are
several states. These states are following:
1. Host just started up, underlying backplane is powered up, we issued
backplane detect/scan. At this point at least some minimal windowed
access is up (if such required), not yet cores/devices are known.
2. Backplane got identified, scanned, individual cores/devices
recognised, buscommon and buscore are registered with kernel to get them
matched with drivers, and then probed and set up.
3. Buscommon and buscore are driven, host can finish with host specific
workarounds, both buscommon and buscore can get their _init entry points
called, we can setup host device irq routine, finally we can expose the
rest cores/devices to kernel.

With that in mind here is my general host ops design pseudo code: 
struct host_ops {
	/* Init call we should get once both buscommon and buscore drivers are bound (state #3) */
	int (*init)(struct bcmb_bus *bus);

	/* Regular backplane access ops */
	u8 (*read(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr);
	void (*write(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr, u(8|16|32) val);

	/* For some theoretically hard-to-set-up before scan hosts we could keep scan_read32 */
	u32 scan_read32(struct bcmb_bus *bus, bcmb_addr_t addr);
};

Finally (I'm not yet decided on that - still planning on sertaing
things) I see here a place for one more op - something like 
int (*device_fixup)(struct bcmb_bus *bus, u16 ven, u16 id, u8 rev, struct bcmb_device **dev);

This one is supposed to allocate and setup struct bcmb_device at scan
time with optionally extending device list with more devices the host is
confident with (in my code model each core exposes at least 2 devices -
the core agent and the core itself, first one considered as
backplane-private and thus never registered with kernel). Such a fixup
could help to get a clean decision on how to handle host-specific
resourses such as sprom/otp/flash/uarts/etc.

Have nice day,
George



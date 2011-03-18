Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37077 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab1CRWmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 18:42:21 -0400
Received: by qyk7 with SMTP id 7so1194605qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 15:42:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300483139.15919.42.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<1300460342.13499.60.camel@dev.znau.edu.ua>
	<AANLkTimboGmJNdHHbzWdSGf14jenn+yag944A8GBEXtc@mail.gmail.com>
	<1300483139.15919.42.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 23:42:20 +0100
Message-ID: <AANLkTi=5nwO-xsCok3_R494qFGH-W5CwteP3j5Np9ZK0@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/18 George Kashperko <george@znau.edu.ua>:
> Well, I see this as following. In generic host life time there are
> several states. These states are following:
> 1. Host just started up, underlying backplane is powered up, we issued
> backplane detect/scan. At this point at least some minimal windowed
> access is up (if such required), not yet cores/devices are known.
> 2. Backplane got identified, scanned, individual cores/devices
> recognised, buscommon and buscore are registered with kernel to get them
> matched with drivers, and then probed and set up.
> 3. Buscommon and buscore are driven, host can finish with host specific
> workarounds, both buscommon and buscore can get their _init entry points
> called, we can setup host device irq routine, finally we can expose the
> rest cores/devices to kernel.
>
> With that in mind here is my general host ops design pseudo code:
> struct host_ops {
>        /* Init call we should get once both buscommon and buscore drivers are bound (state #3) */
>        int (*init)(struct bcmb_bus *bus);
>
>        /* Regular backplane access ops */
>        u8 (*read(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr);
>        void (*write(8|16|32))(struct bcmb_bus *bus, bcmb_addr_t addr, u(8|16|32) val);
>
>        /* For some theoretically hard-to-set-up before scan hosts we could keep scan_read32 */
>        u32 scan_read32(struct bcmb_bus *bus, bcmb_addr_t addr);
> };

I don't think it makes much sense. If init is going to be called in
state #3, what about some pre-init? set_master, request_region, xtal,
iomap?

-- 
Rafał

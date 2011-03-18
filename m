Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40546 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1CRU0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:26:06 -0400
Received: by qyk7 with SMTP id 7so1123807qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 13:26:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300460342.13499.60.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<1300460342.13499.60.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 21:26:05 +0100
Message-ID: <AANLkTimboGmJNdHHbzWdSGf14jenn+yag944A8GBEXtc@mail.gmail.com>
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
> The clean solution I see here is to have host code apart from
> backplane-specific processing. The way to accomplish this is obvious as
> actual host device responsibility is not to switch cores but rather
> provide mappings into physical address space of the backplane regardless
> of the target request being made to core, sprom/otp, agent or whatever.
> This makes much cleaner model than that provided by ssb.

How do you think, what interface would fit for that?

Something like:
struct host_ops {
        bool (*init)(struct device *dev);
        bool (*exit)(struct device *dev);
        bool (*set_agent_addr)(struct device *dev, u16 addr);
        bool (*set_core_addr)(struct device *dev, u16 addr);
};
?

-- 
Rafał

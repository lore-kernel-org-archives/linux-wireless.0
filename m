Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38400 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3GUQzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 12:55:37 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: <thomas@fjellstrom.ca>, Larry Finger <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH] ath: wil6210: Fix build error
References: <1374374808-12768-1-git-send-email-Larry.Finger@lwfinger.net>
	<51EBFABB.8080701@lwfinger.net> <1559869.yu0fjJXVeX@balsa>
	<5330916.8NnOO4SNAp@lx-vladimir>
Date: Sun, 21 Jul 2013 19:55:34 +0300
In-Reply-To: <5330916.8NnOO4SNAp@lx-vladimir> (Vladimir Kondratiev's message
	of "Sun, 21 Jul 2013 18:52:38 +0300")
Message-ID: <87bo5vyhrt.fsf@purkki.adurom.net> (sfid-20130721_185541_112359_5CFBC720)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Dropping stable)

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

>> It also looked like that that driver or section of the kernel was compiling 
>> with -Werror. I haven't verrified that but I remember seeing "treating all 
>> warnings as errors" at one point.
>> 
> You are right, I have this in Makefile:
> (if one turn on extra warnings with -W, there will be lots of false alarms,
> that's why this ifeq())
>
> ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
> 	subdir-ccflags-y += -Werror
> endif

This is exactly why it's recommended not to use -Werror on releases.
It's ok when developers use it, but for end users -Werror should not be
enabled by default.

-- 
Kalle Valo

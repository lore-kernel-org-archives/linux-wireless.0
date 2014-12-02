Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaLBKzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 05:55:13 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/9] wil6210: add handling of RX HTRSH interrupt
Date: Tue, 2 Dec 2014 12:54:50 +0200
Message-ID: <2146658.TBtZmHcG4l@lx-wigig-72> (sfid-20141202_115519_066884_31384718)
In-Reply-To: <1417491850.4894.10.camel@perches.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1417440803-26883-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1417491850.4894.10.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 01, 2014 07:44:10 PM Joe Perches wrote:
> > In addition there's a rate limitted warning message.
> 
> limited.
Yes, thanks.

> I think this _ratelimited bit should be a separate patch.
> (and a suggestion / comment below too)
Agree, sending v2

> #define wil_err_ratelimited(wil, fmt, ...)		\
> do {							\
> 	if (net_ratelimit())				\
> 		wil_err(wil, fmt, ##__VA_ARGS__);	\
> } while (0)
Oh no, this way arguments won't be evaluated for suppressed messages.
The way it is done is less compact but do predictable job with arguments.

Thanks, Vladimir

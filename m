Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab2CWRkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 13:40:09 -0400
Message-ID: <1332524894.5884.15.camel@sortiz-mobl> (sfid-20120323_184014_297105_F53BE299)
Subject: Re: [PATCH] NFC: Add Core support to generate tag lost event
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Date: Fri, 23 Mar 2012 18:48:14 +0100
In-Reply-To: <CAK3JMAZhJP=RC09gA7jHf7Z5ZhuscHbsLW2dPq9Wk52uGQt7YA@mail.gmail.com>
References: <4F6C5C59.2060708@linux.intel.com>
	 <CAK3JMAZhJP=RC09gA7jHf7Z5ZhuscHbsLW2dPq9Wk52uGQt7YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 14:11 -0300, Lauro Ramos Venancio wrote:
> 2012/3/23 Eric Lapuyade <eric.lapuyade@linux.intel.com>:
> > Some HW/drivers get notifications when a tag moves out of the radio field.
> > This notification is now forwarded to user space through netlink.
> 
> I think to put a timer in the NFC core is not the best solution for
> this problem.
> This solution is not suitable for devices that receive an event when
> the tag moves out of the field.
One more thing: If the device provides such capability, the driver can
then call nfc_target_lost() directly, and not register a
presence_check() ops. Without such an ops, the timer won't get started,
obviously.
presence_check() is for drivers that are limited to asking the firmware
about the target being on the field or not.

Cheers,
Samuel.



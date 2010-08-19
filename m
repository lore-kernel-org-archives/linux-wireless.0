Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0HSIPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 04:15:48 -0400
Message-ID: <4C6CE715.4010203@kernel.org>
Date: Thu, 19 Aug 2010 10:11:01 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Luis Rodriguez <lrodriguez@atheros.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari
 One
References: <201008190001.11342.rjw@sisk.pl>
In-Reply-To: <201008190001.11342.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Rafael.

On 08/19/2010 12:01 AM, Rafael J. Wysocki wrote:
> While testing 2.6.36-rc1 (with a couple of fixes on top) I noticed
> that the ath9k driver didn't work after resume from suspend to RAM.
> An attempt to unload the driver using rmmod caused the BUG_ON() in
> kernel/workqueue.c:2844 to trigger.

That BUG_ON() triggers if destroy_workqueue() is called while work
items are still pending on the workqueue.  Can you please trigger
stack traces after resume and post it?

Thanks.

-- 
tejun

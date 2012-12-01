Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52609 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2LACqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 21:46:37 -0500
Date: Fri, 30 Nov 2012 21:38:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFC] How to manage dependency between patches
Message-ID: <20121201023800.GD2355@tuxdriver.com> (sfid-20121201_034648_844544_63DBA12F)
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20121128141319.GA9118@tuxdriver.com>
 <1480359.ZVbZvOVayc@lx-vladimir>
 <1585902.GCBvcuyASu@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1585902.GCBvcuyASu@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:29:55AM +0200, Vladimir Kondratiev wrote:
> Hi,
> 
> I have the following situation:
> 
> - there is the driver for 60g WiFi card, "wil6210", that I want to merge. It 
> consists of 2 patches:
> 
> wireless: Driver for 60GHz card wil6210
> wireless: integrate wil6210 driver into build
> 
> - then, there is one more patch for Atheros drivers family config that I rely 
> on:
> 
> wireless: allow Atheros card to not depend on ath.ko
> 
> - and, there is one more patch that I depend on:
> 
> dynamic_debug: dynamic hex dump
> 
> Discussion about last patch was taken from linux-wireless to the LKML, and it 
> get pushed to Greg K-H by Jason Baron.
> 
> So, question is: what is the right strategy for wil6210 driver?
> 
> Shall I wait till 2 patches I depend on get merged? Some other idea?
> 
> Please advise.
> 
> Thanks, Vladimir

Since Greg is merging one patch and I'm merging the other, under
normal circumstances they will only reach the same tree sometime
during the 3.8 merge window.  FWIW, I was under the impression that
you were targeting 3.9 anyway.  If so, you can simply wait to have
your driver merged sometime after 3.8-rc1.

Does that help?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

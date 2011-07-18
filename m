Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:39100 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab1GRTb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 15:31:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"dcbw@redhat.com" <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 18 Jul 2011 12:25:37 -0700
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-ID: <477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com> (sfid-20110718_213129_644654_64435CD5)
References: <20110717170310.CAD139D401C@zog.reactivated.net>
In-Reply-To: <20110717170310.CAD139D401C@zog.reactivated.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Subject: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
> 
> This is unused and I'm not really sure in what context it was designed to
> be used.

The auto deep sleep feature was added with commit 4912545:
libertas: Add auto deep sleep support for SD8385/SD8686/SD8688

When auto deep sleep is enabled a timer will be started to monitor the activities. At timer expiry (no activity for configured time period) an enter_deep_sleep command will be sent to the card automatically to save power. Once an activity is detected station will exit from deep sleep mode for processing and restart the timer. After the event is processed and there is no new activity the timer will expire and then the deep sleep mode is entered automatically again.

As the auto deep sleep feature for SD8385/SD8686/SD8688 cards is very useful for many embedded platforms to handle enter/exit deep sleep mode automatically, please do not remove it from libertas driver. If you have any particular issue with this feature enabled, we can work on it and solve the problem.

Thanks,
Bing


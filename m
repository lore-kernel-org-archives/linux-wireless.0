Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55921 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab1GSSYx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 14:24:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"dcbw@redhat.com" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 19 Jul 2011 11:23:49 -0700
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-ID: <477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com> (sfid-20110719_202459_694100_43CB074B)
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	<477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
 <CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
In-Reply-To: <CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> > As the auto deep sleep feature for SD8385/SD8686/SD8688 cards is very useful for many embedded
> platforms to handle enter/exit deep sleep mode automatically, please do not remove it from libertas
> driver. If you have any particular issue with this feature enabled, we can work on it and solve the
> problem.
> 
> The problem is that it can't actually be enabled. This is dead code.
> Or if it can, please point out what I'm missing.

To enable deep sleep mode:
iwconfig wlan0 power period 0

To enable auto deep sleep mode with idle time period set to 5 seconds:
iwconfig wlan0 power period 5

To disable deep sleep/auto deep sleep mode:
iwconfig wlan0 power period -1

The iwconfig (from Wireless Tools version 30pre8 beta or newer) supports "power period" command.

Thanks,
Bing


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38335 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2LGLrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 06:47:23 -0500
Message-ID: <50C1D747.2020005@openwrt.org> (sfid-20121207_124727_076337_151D0729)
Date: Fri, 07 Dec 2012 12:47:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] Revert "ath9k_hw: Update AR9003 high_power tx gain table"
References: <1354815611-7220-1-git-send-email-nbd@openwrt.org> <CAJ-Vmonvo9tq4ZF8WosnXNQq=ArqoDuKtz5y8UnFoWfYAikMxQ@mail.gmail.com> <20121207055322.GA27229@hemis.qca.qualcomm.com>
In-Reply-To: <20121207055322.GA27229@hemis.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-07 6:53 AM, Rajkumar Manoharan wrote:
> On Thu, Dec 06, 2012 at 11:35:33AM -0800, Adrian Chadd wrote:
>> On 6 December 2012 09:40, Felix Fietkau <nbd@openwrt.org> wrote:
>> > This reverts commit f74b9d365ddd33a375802b064f96a5d0e99af7c0.
>> >
>> > Turns out reverting commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd
>> > "ath9k_hw: Updated AR9003 tx gain table for 5GHz" was not enough to
>> > bring the tx power back to normal levels on devices like the
>> > Buffalo WZR-HP-G450H, this one needs to be reverted as well.
>> >
>> > This revert improves tx power by ~10 db on that device
>> 
>> Did anyone figure out why this was happening?
>> 
>> Maybe we should look at the HAL commits around the same time to see if
>> someone changed the programming - eg, assuming TPC is always on, or
>> the 2 stream / 3 stream reduction PHY register, or such.
>> 
> Generally we update initval taken from Systems team. We might have missed to
> program the some registers while updating initvals. I prefer to fix the missing
> portion rather than reverting ini tables. Otherwise we end up with using
> older initvals and hard to debug hw related issues.
For a few months I was trying to get an answer from the Systems team as
to why that change was made. Contacted several people about it, got no
proper response.
When I first found the bug (a long time ago), I did extensive review of
internal changes to driver/initvals around that time, and I'm pretty
confident that this tx power issue is not caused by missing changes that
we forgot to port over.

- Felix

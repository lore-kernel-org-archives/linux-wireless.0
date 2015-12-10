Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46649 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLJO6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 09:58:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<1448018530.3141.25.camel@sipsolutions.net>
	<097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
	<1448530804.2167.4.camel@sipsolutions.net>
	<9d111cc7d61047b5890b7c5d53d71bbd@SC-EXCH02.marvell.com>
Date: Thu, 10 Dec 2015 16:57:59 +0200
In-Reply-To: <9d111cc7d61047b5890b7c5d53d71bbd@SC-EXCH02.marvell.com> (David
	Lin's message of "Fri, 27 Nov 2015 02:00:00 +0000")
Message-ID: <87d1ue73m0.fsf@kamboji.qca.qualcomm.com> (sfid-20151210_155811_507972_5AF4A3D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

> On November 26, 2015 5:40 PM, Johannes Berg wrote:
>> On Thu, 2015-11-26 at 08:27 +0000, David Lin wrote:
>> 
>> > > > +#ifdef CONFIG_SUPPORT_MFG
>> > >
>> > > This Kconfig variable doesn't exist.
>> > >
>> >
>> > The compile variable is used privately by Marvell and our customers in
>> > production line.
>> 
>> Yeah, still. Make it a proper Kconfig variable, defaulting to off and hidden
>> under something, or remove it. It's extremely misleading to have something
>> called CONFIG_* when it's not a Kconfig variable.
>> 
>
> I will change this compile variable from "CONFIG_SUPPORT_MFG" to
> "SUPPORT_MFG".

Then it's still dead code which won't ever get compiled in upstream.
Please follow what Johannes suggested.

-- 
Kalle Valo

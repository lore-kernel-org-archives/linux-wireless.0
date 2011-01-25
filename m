Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1AYADf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 19:03:35 -0500
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id p0P03Xd8028988
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 16:03:33 -0800
Received: from iwn39 (iwn39.prod.google.com [10.241.68.103])
	by kpbe20.cbf.corp.google.com with ESMTP id p0P02K4P020282
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 16:03:31 -0800
Received: by iwn39 with SMTP id 39so4994430iwn.41
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 16:03:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110123072116.GA7170@vmraj-lnx.users.atheros.com>
References: <1295452063-13828-1-git-send-email-rmanoharan@atheros.com>
	<1295452063-13828-2-git-send-email-rmanoharan@atheros.com>
	<AANLkTimSBJxY0f6G6BLcLbsDySvn6KZQu=Vdj134yZLD@mail.gmail.com>
	<20110120075130.GA3431@vmraj-lnx.users.atheros.com>
	<AANLkTim4d5xBBRnzWDoyZhJKriX3MByA-XbHsnTOW5+B@mail.gmail.com>
	<20110123072116.GA7170@vmraj-lnx.users.atheros.com>
Date: Mon, 24 Jan 2011 16:03:31 -0800
Message-ID: <AANLkTimJB1QJ63f_=RPRuMXGnt95+y9LQzpAMmcEcLx2@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: Fix power save usage count imbalance on deinit
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change doesn't regress the issue with scan-during-suspend.  The
other regression you should test for is that the system really does
continue to honor powersave after a suspend-resume cycle (verify
null-functions and drop in power consumption).  You should be able to
do that yourself, and I'd suggest testing for this case as well before
committing any changes to powersave.

--
Paul

On Sat, Jan 22, 2011 at 11:21 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> On Fri, Jan 21, 2011 at 04:32:20AM +0530, Luis R. Rodriguez wrote:
>> On Wed, Jan 19, 2011 at 11:51 PM, Rajkumar Manoharan
>> <rmanoharan@atheros.com> wrote:
>> > On Thu, Jan 20, 2011 at 12:54:56AM +0530, Luis R. Rodriguez wrote:
>> >> On Wed, Jan 19, 2011 at 7:47 AM, Rajkumar Manoharan
>> >> <rmanoharan@atheros.com> wrote:
>> >> > Upon unloading the driver, the ps_usecount is incremented
>> >> > before configuring gpio registers in deinit_device.
>> >> > But it is failed to restore the ps_usecount after that.
>> >> > The problem is that the chip is moved to FULL SLEEP
>> >> > by radio_disable when mac80211 is reporting as idle
>> >> > though ps_usecount is not zero.
>> >> >
>> >> > This patch retores ps_usecount properly and ensures that
>> >> > the chip is always moved to full sleep only if ps usage
>> >> > counte is zero which helps in debugging. And also fixes
>> >> > the following warning.
>> >> >
>> >> > ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
>> >> > ath: Could not stop RX, we could be confusing the DMA engine when we
>> >> > start RX up
>> >> > ------------[ cut here ]------------
>> >> > WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
>> >> > ath_stoprecv+0xf4/0x100 [ath9k]()
>> >> >
>> >>
>> >> Are you sure this hunk does not regress the suspend/resume case when
>> >> using the new dbus API?
>> >>
>> > I verfied the suspend/resume case with AR9280 card. But I don't
>> > understand how the new dbus API is related with this patch?
>>
>> Paul, if you get a chance to give this a spin before it gets merged
>> it'd be appreciated.
> Paul,
> Did you get a chance to evaluate this patch? Shall we proceed further?
>
> --
> Rajkumar
>

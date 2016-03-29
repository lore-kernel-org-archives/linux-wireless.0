Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:32856 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcC2HPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 03:15:42 -0400
Received: by mail-yw0-f172.google.com with SMTP id h65so8140686ywe.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 00:15:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALQ-SOAZ+T-kPK0_6s9v80QP+U5sBYtPzUDF2qnXgXuQ593-sg@mail.gmail.com>
References: <CALQ-SOAZ+T-kPK0_6s9v80QP+U5sBYtPzUDF2qnXgXuQ593-sg@mail.gmail.com>
Date: Tue, 29 Mar 2016 00:15:41 -0700
Message-ID: <CALQ-SODDats7p8Wjor0L4SRj5Rf5npQ8g5kZ9fUbBo8KZe4stg@mail.gmail.com> (sfid-20160329_091545_739622_B09F998C)
Subject: Re: WMM vs QoS
From: Steven Pease <spease@suitabletech.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a test, I attempted to hardcode mac80211 to hardcode a priority of
6 or 7. I tried several places, but the most correct seemed to be
cfg80211_classify8021d. Despite this I noticed no change in behavior.
I also looked for a place in the ath9k driver, but it looked like it
pretty much just handed the data frames off from mac80211 to the
device firmware.

Any pointers on where I should be looking to affect the QoS attached
to 802.11 frames?

Thanks.

- Steven

On Wed, Mar 23, 2016 at 2:57 AM, Steven Pease <spease@suitabletech.com> wrote:
> Hi,
> I've been tracking down some obscure wireless issues and noticed that
> there doesn't seem to be a clean mapping between RFC4594 DSCP classes
> and WMM queues.
>
> Specifically, it appears that the highest priority defined for VOIP
> traffic (EF), and which seems to be commonly used for voice, maps as
> AC_VI (next-highest) rather than AC_VO (highest). Whereas I would've
> naively expected AF41 to map as AC_VI and EF to map as AC_VO.
>
> I might be misunderstanding something. However, if this is truly the
> case, I'm wondering if there would be any adverse effects to modifying
> mac80211 to cause EF packets to get translated into the AC_VO queue?
> It seems like this way I might be able to have my cake and eat it too
> rather than choosing between correct QoS on only one of L2 or L3.
>
> Thanks.
>
> --
> - Steven



-- 
- Steven

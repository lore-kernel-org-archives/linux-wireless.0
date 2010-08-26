Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45749 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab0HZXLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 19:11:24 -0400
Received: by iwn5 with SMTP id 5so1971633iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2010 16:11:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100826204722.GA1745@tux>
References: <20100826204722.GA1745@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 26 Aug 2010 16:11:03 -0700
Message-ID: <AANLkTimbKnZ4WBgkXa9fm2Tj1=hfCOC8Zm=Skg+CfUgJ@mail.gmail.com>
Subject: Re: issues with scanning in mac80211
To: Amod Bodas <Amod.Bodas@atheros.com>
Cc: Jouni Malinen <Jouni.Malinen@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Helmut Schaa <Helmut.Schaa@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	ext Kalle Valo <kvalo@adurom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 26, 2010 at 1:47 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Massaging this message a bit and putting it on the public
> mailing list.
>
> On Thu, Aug 26, 2010 at 01:14:36PM -0700, Amod Bodas wrote:
>> Thanks Jouni. Even my observations are same i.e I see 1 sec or
>> so scan before returning to home channel. Given background scan
>> issue looks to be mac80211 related.
>>
>> Who is lead scan module expert in the community?
>
> Well Helmut worked on it:
>
> Author: Helmut Schaa <Helmut.Schaa@gmx.de>
> Date:   Wed Feb 24 14:19:21 2010 +0100
>
>    mac80211: Improve software scan timing
>
>    The current software scan implemenation in mac80211 returns to the operating
>    channel after each scanned channel. However, in some situations (e.g. no
>    traffic) it would be nicer to scan a few channels in a row to speed up
>    the scan itself.
>
>    Hence, after scanning a channel, check if we have queued up any tx frames and
>    return to the operating channel in that case.
>
>    Unfortunately we don't know if the AP has buffered any frames for us. Hence,
>    scan only as many channels in a row as the pm_qos latency and the negotiated
>    listen interval allows us to.
>
>    Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> but AFAICT the issues documented below were likely not considered into the
> architecture and its the first time I see them pointed out, unless I missed
> something. The above commit log shows only the pm_qos latency was taken
> into consideration, which I suppose can be modified for now as a hack
> to deal with these issues.

As suggested by Jouni, I'll test using min(listen_interval,
DTIM_PERIOD), this should only help with broadcast / multicast data
upon a scan. If there are any other thresholds required by userspace
this should likely be configured on the bg scan module I think.

  Luis

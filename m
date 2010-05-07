Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47677 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0EGVoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 17:44:04 -0400
Received: by pwi5 with SMTP id 5so745589pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 14:44:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100507023519.GA7240@tuxdriver.com>
References: <1273171517-6264-1-git-send-email-linville@tuxdriver.com>
	<k2t43e72e891005061501h91e475f6q6cb8bc7c3bbec990@mail.gmail.com>
	<20100507001319.GA6990@tuxdriver.com> <20100507023519.GA7240@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 May 2010 14:43:44 -0700
Message-ID: <p2s43e72e891005071443k348a2802u51dcdc8a549ed84c@mail.gmail.com>
Subject: Re: [PATCH] mac80211: set IEEE80211_TX_CTL_FIRST_FRAGMENT for beacons
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 7:35 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, May 06, 2010 at 08:13:20PM -0400, John W. Linville wrote:
>> On Thu, May 06, 2010 at 03:01:25PM -0700, Luis R. Rodriguez wrote:
>> > On Thu, May 6, 2010 at 11:45 AM, John W. Linville
>> > <linville@tuxdriver.com> wrote:
>> >
>> > Why though?
>>
>> Because it is correct, appropriate, and zero additional cost.  And
>> because if you use the same tx path for beacons as you use for normal
>> frames and if in that path you manage the sequence number in software
>> you should be checking that flag before bumping the sequence number.
>
> That isn't worded too clearly...  If you manage the sequence number
> in software then you should be checking that flag before bumping
> the sequence number.  If you use the same tx path for beacons as is
> used for normal frames and you don't set that flag for beacons,
> then beacons will reuse the sequence number from the previous frame.
>
> Does that make sense?

Yeah, thanks, perhaps the documentation should be expanded for this on
the mac80211.h. This verbiage might also come in handy on the commit
log. What do you think?

  Luis

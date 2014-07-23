Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:60479 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaGWIex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 04:34:53 -0400
Received: by mail-la0-f54.google.com with SMTP id el20so649971lab.27
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 01:34:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnngYO_AzqQnxFpWQrez-q7Z=hBUNOt+H8FybE9+fq5fA@mail.gmail.com>
References: <1406070154-6614-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQnngYO_AzqQnxFpWQrez-q7Z=hBUNOt+H8FybE9+fq5fA@mail.gmail.com>
Date: Wed, 23 Jul 2014 11:34:52 +0300
Message-ID: <CANUX_P3BaQU6Xx+U2Ujwin6JSvsnf-jdB3Hi7vA1sXJDrvmm-Q@mail.gmail.com> (sfid-20140723_103501_379773_308F4D64)
Subject: Re: [PATCH v3 1/5] ath10k: provide firmware crash info via debugfs.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 11:25 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 23 July 2014 01:02,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>

Do we plan to have a common place for all the drivers?
I'd suggest to have mac80211 / cfg80211 link to a file created by the
driver. This would allow us to have this file even if we haven't
registered to mac80211 yet - although it'd be under a different place.
What do you think?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:65134 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaF2RIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 13:08:06 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so7735179oag.14
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 10:08:04 -0700 (PDT)
Message-ID: <53B047F7.2000204@lwfinger.net> (sfid-20140629_190813_347958_5DE218A4)
Date: Sun, 29 Jun 2014 12:08:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lolilolicon <lolilolicon@gmail.com>, ath9k-devel@qca.qualcomm.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Bug: USB wifi card TL-WN722N (AR9271, ath9k_htc) fails to get
 DHCP lease
References: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>	<53AF5FB8.3060505@lwfinger.net> <CAMtVo_PAkxCkxO7ETV6r=Xg75LLRt0GHi8GdqhT4tXKZSpmOvQ@mail.gmail.com>
In-Reply-To: <CAMtVo_PAkxCkxO7ETV6r=Xg75LLRt0GHi8GdqhT4tXKZSpmOvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2014 04:32 AM, lolilolicon wrote:
> On Sun, Jun 29, 2014 at 8:37 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> Something went wrong in your bisection. Commit 88daf80 is a merge commit and
>> is unlikely to be the bad one. You might try a checkout of b080e04 and try
>> it to see if it is bad or good. That is the first non-merge commit before
>> 88daf80.
>>
>> Larry
>>
>
> I have no clue how you identified b080e04, but I tested it and it is good.
> I'm not good at git so please bear with me. What I know is 88daf80 is
> bad, and both its two parents 010d3c3 and 35582ad are good: does that
> not mean 88daf80 is the first bad commit?
>
> % git bisect start 88daf80 010d3c3 35582ad
> 88daf80dcca19ff995cc263592426f734a9702f3 is the first bad commit
>
> What am I getting wrong?

I am not an expert in git, but I think you are being too restrictive with that 
command. If you do "git bisect start 88daf80 010d3c3", there are ath9k patches 
in the code left to test. With the other option "git bisect start 88daf80 
35582ad", git visualize does not show any ath9k changes.

Larry


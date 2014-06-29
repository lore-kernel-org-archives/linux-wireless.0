Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60889 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaF2Jcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 05:32:45 -0400
Received: by mail-oa0-f52.google.com with SMTP id j17so7524858oag.11
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 02:32:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53AF5FB8.3060505@lwfinger.net>
References: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>
	<53AF5FB8.3060505@lwfinger.net>
Date: Sun, 29 Jun 2014 17:32:44 +0800
Message-ID: <CAMtVo_PAkxCkxO7ETV6r=Xg75LLRt0GHi8GdqhT4tXKZSpmOvQ@mail.gmail.com> (sfid-20140629_113249_140005_4930E212)
Subject: Re: Bug: USB wifi card TL-WN722N (AR9271, ath9k_htc) fails to get
 DHCP lease
From: lolilolicon <lolilolicon@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 29, 2014 at 8:37 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> Something went wrong in your bisection. Commit 88daf80 is a merge commit and
> is unlikely to be the bad one. You might try a checkout of b080e04 and try
> it to see if it is bad or good. That is the first non-merge commit before
> 88daf80.
>
> Larry
>

I have no clue how you identified b080e04, but I tested it and it is good.
I'm not good at git so please bear with me. What I know is 88daf80 is
bad, and both its two parents 010d3c3 and 35582ad are good: does that
not mean 88daf80 is the first bad commit?

% git bisect start 88daf80 010d3c3 35582ad
88daf80dcca19ff995cc263592426f734a9702f3 is the first bad commit

What am I getting wrong?

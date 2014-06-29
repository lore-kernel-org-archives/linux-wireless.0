Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46259 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaF2AhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 20:37:09 -0400
Received: by mail-oa0-f49.google.com with SMTP id i7so7217004oag.36
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 17:37:09 -0700 (PDT)
Message-ID: <53AF5FB8.3060505@lwfinger.net> (sfid-20140629_023722_678647_37C450F1)
Date: Sat, 28 Jun 2014 19:37:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lolilolicon <lolilolicon@gmail.com>, ath9k-devel@qca.qualcomm.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Subject: Re: Bug: USB wifi card TL-WN722N (AR9271, ath9k_htc) fails to get
 DHCP lease
References: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>
In-Reply-To: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2014 04:17 PM, lolilolicon wrote:
> This bug was introduced in merge commit 88daf80 (if I did the bisect correctly).
>
> A workaround around the bug is to set the ath9k_htc param nohwcrypt=1.
>
> The difference in the journal/log between good and bad is that in the
> presence of the bug, dhcpcd would time out soliciting a DHCP lease.
> Some other users report that they're getting an IP, but the connection
> is very slow.
>
> Also reported elsewhere:
> https://bugs.archlinux.org/task/40905
> https://bugzilla.kernel.org/show_bug.cgi?id=78581
>
> Apologies if I messed up anything (sending to the wrong ML/people,
> inadequate info, etc.)
> If you need anything else, just ask.

Something went wrong in your bisection. Commit 88daf80 is a merge commit and is 
unlikely to be the bad one. You might try a checkout of b080e04 and try it to 
see if it is bad or good. That is the first non-merge commit before 88daf80.

Larry


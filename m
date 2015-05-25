Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36073 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbEYECl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 00:02:41 -0400
Received: by pdfh10 with SMTP id h10so61082933pdf.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2015 21:02:41 -0700 (PDT)
Message-ID: <55629ECA.9050203@gmail.com> (sfid-20150525_060245_341162_005555B2)
Date: Mon, 25 May 2015 09:32:18 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Varka Bhadram <varkab@cdac.in>
Subject: Re: [PATCH wireless-next] mac80211: fix double flush workqueue
References: <1431671210-6761-1-git-send-email-varkab@cdac.in>	 (sfid-20150515_082729_656523_7D208EC4) <1432020391.7437.2.camel@sipsolutions.net>
In-Reply-To: <1432020391.7437.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes Berg,

On 05/19/2015 12:56 PM, Johannes Berg wrote:

> On Fri, 2015-05-15 at 11:56 +0530, Varka Bhadram wrote:
>> In suspend functionality flushing of the workqueue is done
>> with ieee80211_stop_device(). This patch avoid flushing
>> the workqueue for two times.
> Why do you think this makes sense?
>
> This is done in entirely different places in the code.

Initially flushing of workqueue is done at [1], and also flushing of the same workqueue
has done with ieee80211_stop_device() at [2].

[1]:https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/pm.c#n50
[2]:https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/pm.c#n154

--
Thanks,
Varka Bhadram.


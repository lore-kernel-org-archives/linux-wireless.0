Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37569 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaIOTi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 15:38:29 -0400
Received: by mail-wi0-f173.google.com with SMTP id em10so4873842wid.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 12:38:22 -0700 (PDT)
Received: from [192.168.1.100] (85-250-104-189.bb.netvision.net.il. [85.250.104.189])
        by mx.google.com with ESMTPSA id i6sm12719488wib.7.2014.09.15.12.38.20
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2014 12:38:20 -0700 (PDT)
Message-ID: <5417402C.2070705@gmail.com> (sfid-20140915_213835_788014_7273FE6A)
Date: Mon, 15 Sep 2014 22:38:20 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: git request-pull gets confused?
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


I have patches that rely on mac80211-next. Until now, I would wait for John to pull them from mac80211-next into wireless-next,
then I'd merge wireless-next into my tree. On top of that I'd apply the new patches.

"git request-pull wireless-next/master iwlwifi-next HEAD" didn't get confused in this case, it would show my patches only and not the
patches in wireless-next obviously.

This time, I did something slightly different. I merged Johannes's tag - the one he sent to John. So that I got content from mac80211-next
before it made it to wireless-next, and on top of that I applied my new patches. I thought I could wait for John to pull from Johannes and
then, I'd just have to fetch wireless-next and let do git request-pull do its magic... But...

"git request-pull wireless-next/master iwlwifi-next HEAD" lists my merge patch:
Emmanuel Grumbach (1):
      Merge tag 'mac80211-next-for-john-2014-09-12' into HEAD

which is perfectly fine. I can see no mac80211 patches in the patch list, but...

[snip]
 include/linux/ieee80211.h                             |  73 ++++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h                                |  69 +++++++++++++++++++++++++++------
 include/net/mac80211.h                                |  34 ++++++++--------
 include/uapi/linux/nl80211.h                          | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/agg-rx.c                                 |   5 ++-
 net/mac80211/cfg.c                                    | 114 ++++++++++++++++++++++++++++++++++++------------------
 net/mac80211/chan.c                                   | 191 +++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------
 net/mac80211/debugfs.c                                |   6 +--
[snip]


It seems that the baseline taken by git request-pull to list the files I change is wrong:
The following changes since commit f991e17ba2584e2be66476cc468f19769efd55cc:

  iwlwifi: mvm: align CSA GO NOA time event naming with the firmware (2014-09-14 22:02:24 +0300)

I'd expect git request-pull to notice that Johannes's tag that I pulled is already in wireless-next and that I am not really changing these files?

$ git --version
git version 1.9.1


Thoughts?

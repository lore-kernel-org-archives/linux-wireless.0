Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f174.google.com ([209.85.215.174]:40029 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbeIGCNv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 22:13:51 -0400
Received: by mail-pg1-f174.google.com with SMTP id l63-v6so5870491pga.7
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 14:36:26 -0700 (PDT)
Date: Thu, 6 Sep 2018 14:36:22 -0700
From: Brian Norris <briannorris@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Zhi Chen <zhichen@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org
Subject: [for -stable] commit "c82919888064 ath10k: fix scan crash due to
 incorrect length calculation"
Message-ID: <20180906213620.GA72542@ban.mtv.corp.google.com> (sfid-20180906_233635_042171_26F54294)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg / stable maintainer(s),

IIUC, this commit is a good candidate for -stable. I just hit the bug on
4.14, because of new vendor firmware that noticed the mismatched length
(an internal "assert"), but it seems like this is equally problematic
from the kernel side for as long as this code existed [1]:

commit c8291988806407e02a01b4b15b4504eafbcc04e0
Author: Zhi Chen <zhichen@codeaurora.org>
Date:   Mon Jun 18 17:00:39 2018 +0300

    ath10k: fix scan crash due to incorrect length calculation

Thanks,
Brian

[1] I guess that would be:

Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")

which was in v4.0.

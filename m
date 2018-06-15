Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50414 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755862AbeFOMZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 08:25:07 -0400
Message-ID: <1529065504.10037.18.camel@sipsolutions.net> (sfid-20180615_142510_345072_E7E2F61E)
Subject: Re: [RFCv2 2/2] mac80211: Add support for per-rate rx statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sriram R <srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2018 14:25:04 +0200
In-Reply-To: <1527514479-6696-3-git-send-email-srirrama@codeaurora.org>
References: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org>
         <1527514479-6696-3-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why did you change to rhashtable?

That seems very strange, since we explicitly want to limit the number of
entries, but rhashtable will grow/shrink as required.

I think I liked my approach better since it allowed us to clearly limit
the memory consumption for this.

johannes

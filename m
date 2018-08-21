Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35480 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbeHUUhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 16:37:01 -0400
Message-ID: <1534871755.25523.32.camel@sipsolutions.net> (sfid-20180821_191723_186239_2E38447B)
Subject: Re: [PATCH 0/2] workqueue lockdep limitations/bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 19:15:55 +0200
In-Reply-To: <20180821160039.GO3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180043_407003_1DE29E4C)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
         <20180821160039.GO3978217@devbig004.ftw2.facebook.com>
         (sfid-20180821_180043_407003_1DE29E4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tejun,

> > Let's say we again have an ordered workqueue, and the following:
> > 
> > work1_function
> > {
> > 	mutex_lock(&mutex);
> > }
> 
> Regular mutexes complain when the locker isn't the unlocker already.
> Do we really care about this case?

Oh, sorry for the confusion. I was just eliding the - not very
interesting for this case - unlock. Really I should've typed up a
lock/unlock pair in all of the examples.

johannes

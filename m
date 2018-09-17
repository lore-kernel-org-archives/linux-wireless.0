Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39160 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbeIQNHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:07:14 -0400
Message-ID: <1537170050.2957.1.camel@sipsolutions.net> (sfid-20180917_094115_729391_1278F60A)
Subject: Re: [PATCH] mac80211: fix issue with possible txq NULL pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Erik Stromdahl <erik.stromdahl@gmail.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2018 09:40:50 +0200
In-Reply-To: <20180914160034.2753-1-erik.stromdahl@gmail.com> (sfid-20180914_180044_364636_63E0B0A6)
References: <20180914160034.2753-1-erik.stromdahl@gmail.com>
         (sfid-20180914_180044_364636_63E0B0A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-09-14 at 18:00 +0200, Erik Stromdahl wrote:
> Drivers that do not have the BUFF_MMPDU_TXQ flag set will not have a
> TXQ for the special TID = 16.
> 
> In this case, the last member in the *struct ieee80211_sta* txq array
> will be NULL.
> 
> We must check this in order not to get a NULL pointer dereference when
> iterating the txq array.

Uh, yes, thanks. This is my fault - I merged the overlapping patches
closely together.

johannes

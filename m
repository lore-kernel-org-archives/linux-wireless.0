Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56308 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753162AbdHBMVN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 08:21:13 -0400
Message-ID: <1501676470.11126.2.camel@sipsolutions.net> (sfid-20170802_142116_389508_E563D50C)
Subject: Re: [PATCH] rt2x00: Fix MMIC countermeasures.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>, mike@hellotwist.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Date: Wed, 02 Aug 2017 14:21:10 +0200
In-Reply-To: <20170802070117.GA2790@redhat.com> (sfid-20170802_090235_721632_7626EB3C)
References: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
         <20170802070117.GA2790@redhat.com> (sfid-20170802_090235_721632_7626EB3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-08-02 at 09:01 +0200, Stanislaw Gruszka wrote:

> The relevant mac80211 code look like this:
> 
> ieee80211_rx_result
> ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)

I believe that ieee80211_rx_h_decrypt() will drop the frames you're
looking at, and I do think the original patch is correct. If MMIC
validation was (and could be) done, then the frame must have been
decrypted properly.

johannes

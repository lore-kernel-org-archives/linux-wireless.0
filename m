Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34285 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVKkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 06:40:04 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3389418wgh.28
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 03:40:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
Date: Wed, 22 Oct 2014 12:40:03 +0200
Message-ID: <CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com> (sfid-20141022_124010_013078_376C8A05)
Subject: Re: Change channel bandwidth without iw command
From: Michal Kazior <michal.kazior@tieto.com>
To: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 October 2014 12:14, Okhwan Lee <ohlee@mwnl.snu.ac.kr> wrote:
> Hi,
>
> We are trying to implement a protocol to evaluate the performance our
> algorithm using QCA9880.
>
> To implement our protocol, a receiver have to change the bandwidth
> when a Action frame (what we define) is successfully received.
> We know that the QCA9880 can change bandwidth by using iw command in
> monitor mode.
> So, we use similar function path used by "iw dev set freq ..."
> When the receiver detects the reception of the Action frame we call
> "ieee80211_set_monitor_channel" at the end of ieee80211_rx as follows:
>
> /*************** net/mac80211/rx.c ******************/
>
> // receive action frame, change bandwidth 80 -> 20
>
>                 rtnl_lock(); //lock rtnetlink used in pre_doit of nl80211
>                 chandef = local->monitor_chandef; // copy current chandef
>                 chandef.width = NL80211_CHAN_WIDTH_20; // set bandwidth
>                 chandef.center_freq1 = 5180; // set center freq...
>                 ieee80211_set_monitor_channel(wiphy, &chandef);
>                 rtnl_unlock();
>
> /********************************************************/

If my understanding is correct you're doing it wrong.

You probably want to modify chanctx of a vif the frame is associated
with and notify the driver via appropriate mac80211 helpers instead of
the hack above. Remember to get your locking right.


> However, the receiver invokes kernel panic when receives the Action frame.
> As fas as we know, the panic is occurred in ath10k_config_chan of
> ath10k device driver.

The panic printout would be most helpful. My best guess is this
crashes in ath10k_dbg() at the very beginning of ath10k_config_chan
because ar->chandef.chan is NULL. This is probably the case since you
use monitor_chandef which is probably "empty" at the point you invoke
your code.


> To the best our knowledge, our implementation exploits same function
> path of iw command in nl80211, cfg80211, mac80211 and ath10k.
> Moreover, we confirm that the input parameters (wiphy, chandef) in our
> implementation are identical to the parameters used by iw command.
>
> Is there any reason why we cannot change bandwidth?
> Of course, iw command work correctly.

The iw set channel is for monitor interfaces only so trying to make it
work with, e.g. a station interface will bring you pain.


Michał

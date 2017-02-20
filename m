Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58024 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbdBTX04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 18:26:56 -0500
Message-ID: <1487633211.484.1.camel@sipsolutions.net> (sfid-20170221_002659_973615_F165814A)
Subject: Re: Monitor mode 'cook' flag meaning
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas d'Otreppe <tdotreppe@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 21 Feb 2017 00:26:51 +0100
In-Reply-To: <CALs6+XLDZLmc6JWMPun4sT+W_M4Cqh47LcK+HjiuZ8gKFLkbTA@mail.gmail.com> (sfid-20170221_002306_313869_E4D6D4DA)
References: <CALs6+XLDZLmc6JWMPun4sT+W_M4Cqh47LcK+HjiuZ8gKFLkbTA@mail.gmail.com>
         (sfid-20170221_002306_313869_E4D6D4DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-20 at 16:22 -0700, Thomas d'Otreppe wrote:
> I've been looking through the different flags for monitor mode in iw.
> Most of them are rather obvious (and well explained) but what is
> exactly 'cooked mode'?
> 
> I looked up in Google and in the linux-wireless wiki (nothing in
> there) and I only found explanations in 2 patches (most likely still
> in the source code) which are still vague:
> - A monitor interface in "cooked" mode will see all frames that
> mac80211 has not used internally
> - report frames after processing. Overrides all other flags.
> 
> Thinking about what the first one says, it doesn't seem any different
> than just fcsfail.

No, that's the wrong idea. "cook" means that e.g. auth frames that
mac80211 didn't actually look at will be sent there.

Anyway, ignore cooked mode. It's only for ancient hostapd versions.

> I don't even see when control or otherbss should be needed since
> 'none' is already providing them.

Those are hw-dependent.

johannes

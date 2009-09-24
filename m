Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40274 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZIXEjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 00:39:12 -0400
Received: by bwz6 with SMTP id 6so1039740bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 21:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909232116n4ddc8bedxf7033a140a0c6fa0@mail.gmail.com>
References: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
	 <20090924035356.GC2726@tuxdriver.com>
	 <da94abde0909232116n4ddc8bedxf7033a140a0c6fa0@mail.gmail.com>
Date: Wed, 23 Sep 2009 21:39:14 -0700
Message-ID: <da94abde0909232139t396b37b3x7cfdeaaafbbbcda1@mail.gmail.com>
Subject: Re: wireless-testing broken
From: Kalle Valo <kalle.valo@iki.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 9:16 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> On Wed, Sep 23, 2009 at 8:54 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> I know you aren't in a great situation for this, but could you try
>> a bisect?  Or, you might just try reverting "iwlwifi: reduce noise
>> when skb allocation" as a start...
>
> Sure, I'll start bisecting right now.

The result is:

55a00b83339f25d2979b85ab6e2151390327db80 is first bad commit
commit 55a00b83339f25d2979b85ab6e2151390327db80
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Sep 17 17:15:31 2009 -0700

    cfg80211: don't overwrite privacy setting

    When cfg80211 is instructed to connect, it always
    uses the default WEP key for the privacy setting,
    which clearly is wrong when using wpa_supplicant.
    Don't overwrite the setting, and rely on it being
    false when wpa_supplicant is not running, instead
    set it to true when we have keys.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

I verified the result by manually reverting the commit and this is
really causing my problem. My current setup is debian unstable,
default debian wpa_supplicant (using wext I think, haven't checked)
and open network at Portland Marriott hotel. I can reproduce the
problem every time.

Kalle

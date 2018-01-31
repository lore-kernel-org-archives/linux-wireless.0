Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50092 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeAaMFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 07:05:19 -0500
Message-ID: <1517400317.2189.54.camel@sipsolutions.net> (sfid-20180131_130524_077215_6C5A88D1)
Subject: Re: [PATCH v4 2/3] mac80211_hwsim: add nl_err_msg in
 hwsim_new_radio in netlink case
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 13:05:17 +0100
In-Reply-To: <cf608fec-78d5-40f4-8601-50537d6f4e73@uni-rostock.de>
References: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
         <20180122170437.14213-3-benjamin.beichler@uni-rostock.de>
         <1517299004.2189.38.camel@sipsolutions.net>
         <cf608fec-78d5-40f4-8601-50537d6f4e73@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-30 at 10:47 +0100, Benjamin Beichler wrote:

> It should not be triggered because of already existing macs, I added it
> for somehow completeness, but you can leave it out.

Sure.

> After having again a look on it, there could be an -ENOMEM on
> rhashtable_insert. Maybe it's better to explicitly catch only -EEXIST
> and print for the rest an generic error. Do you agree ?

Nah, that's unlikely enough ... and you get -ENOMEM back in userspace
too.

That said, good thing I looked at this - you forgot a set of braces :-)

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932596AbeAOMJb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:09:31 -0500
Message-ID: <1516018169.410.14.camel@sipsolutions.net> (sfid-20180115_130935_528241_502A6C81)
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 13:09:29 +0100
In-Reply-To: <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:

> To do not break the operation with legacy software using hwsim, the new
> address is set twice. The problem here is, the netlink call backs use
> wiphy->addresses[1] as identification of a radio and not the proposed
> permanent address (wiphy->addresses[0]). This design decision is not
> documented in the kernel repo, therefore this patch simply reproduces this,
> but with the same address.

It's weird to have the same address twice - perhaps we can XOR 0x40 or
so?

johannes

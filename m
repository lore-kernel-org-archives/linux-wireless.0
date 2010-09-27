Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62896 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab0I0SOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 14:14:51 -0400
Received: by gxk9 with SMTP id 9so1595566gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 11:14:28 -0700
Message-ID: <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 11:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Even if the reorder timeout timer fires while
> scanning, the frames weren't received during
> scanning and therefore shouldn't be dropped.

I don't get what we are doing with these frames today, are you saying
we pegged some of these frames into the reorder buffer when starting a
sw scan, or that we were dropping them?

  Luis

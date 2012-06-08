Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38293 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FHSvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:51:43 -0400
Received: by bkcji2 with SMTP id ji2so2057620bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 11:51:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120608173901.GC13889@tuxdriver.com>
References: <1338971102-4872-1-git-send-email-arik@wizery.com> <20120608173901.GC13889@tuxdriver.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 8 Jun 2012 21:51:26 +0300
Message-ID: <CA+XVXfd70avDeFGLR5S_D_b-TQ+EZtPb+PwTZZApK6OpiL8e0g@mail.gmail.com> (sfid-20120608_205147_025600_A8CCF1BB)
Subject: Re: [PATCH v3] mac80211: stop Rx during HW reconfig
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 8:39 PM, John W. Linville <linville@tuxdriver.com> wrote:
> Should this go to 3.5 and/or stable?

I don't think this is necessary. This only partially solves the race,
and reconfig is a corner case anyway.

And the part of the race it solves is actually only created in 3.6, by
the patch "mac80211: add stations after AP start on reconfig".

Arik

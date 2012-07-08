Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45681 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2GHQ1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 12:27:23 -0400
Received: by yhmm54 with SMTP id m54so10330123yhm.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 09:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net> <1341608733-7503-2-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 8 Jul 2012 19:27:07 +0300
Message-ID: <CA+XVXfdo7agXE9Osxzmda2ZWi-xQ6pvP66zktdiDJq3P6PULgg@mail.gmail.com> (sfid-20120708_182726_415999_78852915)
Subject: Re: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 7, 2012 at 12:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Making the scan_sdata pointer usable with RCU makes
> it possible to dereference it in the RX path to see
> if a received frame actually matches the interface
> that is scanning. This is just preparations, making
> the pointer __rcu.

I noticed no synchronize_rcu() in the start/stop scan calls. Good/bad idea?

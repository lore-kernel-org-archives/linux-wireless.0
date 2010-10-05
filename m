Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43748 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0JERyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:54:35 -0400
Received: by iwn5 with SMTP id 5so8595719iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 10:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286300260.3641.16.camel@jlt3.sipsolutions.net>
References: <1286300260.3641.16.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 10:54:14 -0700
Message-ID: <AANLkTin98eJWiKp77dR+UCSAR0ngctRh0749=ch6y3eo@mail.gmail.com>
Subject: Re: [PATCH] mac80211: avoid transmitting delBA to old AP
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 10:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When roaming while we have active BA session,
> we can end up transmitting delBA frames to
> the old AP while we're already on the new AP's
> channel, which can cause warnings.

when the old AP is on 2.4 GHz and the new AP is 5 GHz.

I'd also add: and in the worst case transmit delBAs on an incorrect channel.

> Simply avoid sending those frames, but still
> tear down the internal session state, since
> they are not really necessary anyway as we
> will implicitly disassociate when sending the
> association to the new AP.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

This

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33752 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaXG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 19:06:59 -0400
Received: by iyb14 with SMTP id 14so2869981iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 16:06:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301610698-3688-1-git-send-email-lrodriguez@atheros.com>
References: <1301610698-3688-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 31 Mar 2011 16:06:38 -0700
Message-ID: <AANLkTikf65sZ3v72w8XJd=ncaUwtX6qA7jmX3N9Sg97Q@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: add a timer for invalid user reg hints
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: gregoryx.alagnou@intel.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 31, 2011 at 3:31 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We have no other option but to inform userspace that we have
> queued up their regulatory hint request when we are given one
> given that nl80211 operates atomically on user requests. The
> best we can do is accept the request, and set a timer for processing
> it. If the timer is hit we restore the regulatory settings and
> ignore the user input.
>
> This fixes this reported bug:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=28112
>
> Reported-by: gregoryx.alagnou@intel.com
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

I'll respin using schedule_delayed_work() instead.

  Luis

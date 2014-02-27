Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41774 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaB0NVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 08:21:51 -0500
Received: by mail-pa0-f44.google.com with SMTP id bj1so2504360pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 05:21:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393376982-28276-4-git-send-email-mcgrof@do-not-panic.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com> <1393376982-28276-4-git-send-email-mcgrof@do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 27 Feb 2014 15:21:35 +0200
Message-ID: <CA+XVXffSTA__zwYDzzyHB2B1mLZaL0sXT8prmUvdb-w_QA4_pg@mail.gmail.com> (sfid-20140227_142154_726704_ADC5A7FE)
Subject: Re: [PATCH 3/3] cfg80211: processing regulatory requests on netdev notifier
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux@eikelenboom.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 26, 2014 at 3:09 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> This adds a trigger to review any pending regulatory
> requests whenever an 802.11 device interface is brought
> down or up. We use this as an opportunistic trigger
> for checking the regulatory work queues as otherwise
> they they're only checked upon an initial regulatory
> request or when beacon hints are found.
>
> This opportunistic mechanism can be used to trigger
> kicking the queues regulatory queues at any time from
> userspace without having to change the regulatory state.
>
> A timer just waiting upon init is not that appropriate
> as when it should be triggered will depend on systems,
> a much better approach is to use and add opportunistic
> triggers. The interface coming up is typically a good
> indicator that filesystems have been mounted since
> firmware is required for some devices.
>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>  net/wireless/reg.h | 1 +
>  1 file changed, 1 insertion(+)

Seems the actual patch is missing?

Arik

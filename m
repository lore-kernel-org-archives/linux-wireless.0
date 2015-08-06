Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:32926 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbbHFLbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 07:31:34 -0400
Received: by labjt7 with SMTP id jt7so29405841lab.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 04:31:33 -0700 (PDT)
Subject: Re: [PATCH 2/5] net: rfkill: add rfkill_find_type function
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55C34593.8010907@cogentembedded.com> (sfid-20150806_133154_628451_E65C3669)
Date: Thu, 6 Aug 2015 14:31:31 +0300
MIME-Version: 1.0
In-Reply-To: <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 8/5/2015 4:39 PM, Heikki Krogerus wrote:

> Helper for finding the type based on name. Useful if the
> type needs to be determined based on device property.

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>   include/linux/rfkill.h | 15 +++++++++++++
>   net/rfkill/core.c      | 57 +++++++++++++++++++++++++-------------------------
>   2 files changed, 44 insertions(+), 28 deletions(-)

> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index d901078..02f563c 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
[...]
> @@ -268,6 +277,12 @@ static inline bool rfkill_blocked(struct rfkill *rfkill)
>   {
>   	return false;
>   }
> +
> +static inline enum rfkill_type rfkill_find_type(const char *name)
> +{
> +	return 0;
 > +}
 > +

    Shouldn't it return some member of 'enum rfkill_type' instead?

[...]

MBR, Sergei


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:21377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbYGNKVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 06:21:51 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2803119waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 03:21:50 -0700 (PDT)
Message-ID: <1ba2fa240807140321m2c111de1x38affda7de4f6f2d@mail.gmail.com> (sfid-20080714_122155_124163_B0CE80CB)
Date: Mon, 14 Jul 2008 13:21:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] Add new regulatory framework for Linux wireless
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <20080711123039.GP17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080711123039.GP17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 11, 2008 at 3:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Johannes' changes have been taken into consideration for this patch.
> Individual changes can be seen here:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/v3-regdomain-patches/
>
> This adds a new regulatory framework for the wireless subsystem (cfg80211).
> This relies on the new Central Regulaotry Domain Agent:
>
> http://wireless.kernel.org/en/developers/Regulatory/CRDA
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git
>
> CRDA and its integration allows us to keep the wireless regulatory
> database completely in userspace. This lets us update it without
> making kernel upgrades.
>
> For drivers wishing to verify the regulatory data a callback
> chain has been provided, regulatory_chain. Driver can use this
> to update further enhance their regulatory compliance if required.
>
> For drivers which can determine what country they were designed for
> and wishing to support that regulatory domain first (before
> considering Country IEs from APs) they can hint it to the wireless
> using regulatory_hint().
>
> Country IE parsing is not yet added by can be added and with this
> framework can be used to enhance trust for regulatory data from APs.
> The industry currently has different techniques for parsing and using
> Country IEs. What I currently propose is to take the common denominator
> between what the AP provides, what CRDA has and what the driver can
> provide privately through its callback. So the wireless core can keep
> as the common denominator between the AP's Country IE and what CRDA
> has for the alpha2 provided by the Country IE. Drivers themselves can
> further enhance regulatory enforcement by relying on private driver
> data if they wish so.
>
I've submitted RFC patch for Country IE parsing in mac80211 as part of
the work on 802.11h.  (TGh)
Q. How do you plan to merge CRDA and Country IE, where you will keep
Country IE info cfg80211 or mac80211?

Thanks
Tomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:13038 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZAMUva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 15:51:30 -0500
Received: by yw-out-2324.google.com with SMTP id 9so101785ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 12:51:29 -0800 (PST)
Message-ID: <43e72e890901131251p66816689j6965dc865d616006@mail.gmail.com> (sfid-20090113_215135_902944_59E8F960)
Date: Tue, 13 Jan 2009 12:51:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: simplify regulatory code
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <1231878042-21799-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1231878042-21799-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 12:20 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Now that cfg80211 has its own regulatory infrastructure we can
> condense ath9k's regulatory code considerably. We only keep data
> we need to provide our own regulatory_hint(), regulatory_set_custom_rd(),
> reg_notifier() and information necessary for calibration.
>
> Atheros hardware supports 12 world regulatory domains, since these
> are custom we apply them through the the new regulatory_set_custom_rd().
> Although we have 12 we consolidate these into 5 structures based on
> frequency and apply a different set of flags that differentiate them
> on a case by case basis through the reg_notifier().
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> This patch seems to be too big (135653 bytes) for linux-wireless so
> here a URL to it if you want to wget it:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-01-13/0001-ath9k-simplify-regulatory-code.patch

Here's a new one rebased on top of the latest wl which addresses a
conflict with:

"ath9k: Fix an operator typo in REG_DOMAIN_2GHZ_MASK"

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-01-13/0001-ath9k-simplify-regulatory-code-v2.patch

  Luis

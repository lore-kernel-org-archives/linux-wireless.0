Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40482 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749Ab2GLTlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 15:41:05 -0400
Received: by ghrr11 with SMTP id r11so2828442ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 12:41:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120712093952.9976.84033.stgit@localhost6.localdomain6>
References: <20120712093944.9976.84585.stgit@localhost6.localdomain6> <20120712093952.9976.84033.stgit@localhost6.localdomain6>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 12 Jul 2012 12:40:44 -0700
Message-ID: <CAB=NE6WjW-f=giqEEycNcZqjjB7SuioiMyEbrLcGaz8oD1CPNA@mail.gmail.com> (sfid-20120712_214111_044783_DCAD539F)
Subject: Re: [PATCH 2/2] ath6kl: add support for changing contry code
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 2:39 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> +config ATH6KL_REGDOMAIN
> +       bool "Atheros ath6kl regdomain support"
> +       depends on ATH6KL
> +       depends on CFG80211_CERTIFICATION_ONUS
> +       ---help---
> +         Enabling this makes it possible to change the regdomain in
> +         the firmware. This can be only enabled if regulatory requirements
> +         are taken into account.

You will need to add wiphy->features |=
NL80211_FEATURE_CELL_BASE_REG_HINTS in order to enable the base
station hints to propagate to the driver and even to the core,
otherwise this is ignored. This was addressed starting at v4 of my
onus patches. Given this, I think it makes sense to rename the option
to enable / disable base station hints and to update the language to
clearly reflect that is the only type of hint that would be used to
update the firmware regulatory domain.

  Luis

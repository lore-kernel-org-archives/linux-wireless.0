Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbeHVPKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:10:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 07/15] iwlwifi: add 80211 hdr offset to trace data
References: <20180821063657.30071-1-luca@coelho.fi>
        <20180821063657.30071-8-luca@coelho.fi>
Date: Wed, 22 Aug 2018 14:45:21 +0300
In-Reply-To: <20180821063657.30071-8-luca@coelho.fi> (Luca Coelho's message of
        "Tue, 21 Aug 2018 09:36:49 +0300")
Message-ID: <877ekir5f2.fsf@kamboji.qca.qualcomm.com> (sfid-20180822_134528_791267_1CDB0978)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Mordechay Goodstein <mordechay.goodstein@intel.com>
>
> Every rx mpdu cmd is built from cmd_hdr | 80211_hdr.  The problem is
> that the size of cmd_hdr changes with API changes and we don't know
> where the 80211_hdr starts.
>
> By adding the size of cmd_hdr dynamically, we can ensure that we always
> know how to parse mpdu frames, without dependending on the API changes.
>
> Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> --- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
> @@ -2,6 +2,7 @@
>   *
>   * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
>   * Copyright(c) 2015        Intel Deutschland GmbH
> + * Copyright(c) 2018        Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
> @@ -12,10 +13,6 @@
>   * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>   * more details.
>   *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
> - *
>   * The full GNU General Public License is included in this distribution in the
>   * file called LICENSE.
>   *

Ok, you have more of these removals in this patch so I guess it's
intentional. But IMHO it would be nicer to remove these all in one go
instead of sprinkle around in different patches.

-- 
Kalle Valo

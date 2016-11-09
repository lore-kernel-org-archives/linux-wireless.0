Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48902 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751520AbcKIHbI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 02:31:08 -0500
Message-ID: <1478676664.3313.16.camel@coelho.fi> (sfid-20161109_083111_768107_812198D9)
From: Luca Coelho <luca@coelho.fi>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Date: Wed, 09 Nov 2016 09:31:04 +0200
In-Reply-To: <20161109055048.GA27520@google.com>
References: <20161109055048.GA27520@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 3/3] iwlwifi: pcie: trans: Remove unused 'shift_param'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-08 at 21:50 -0800, Kirtika Ruchandani wrote:
> shift_param is defined and set in iwl_pcie_load_cpu_sections
> but not used. Fix this to avoid -Wunused-but-set-variable
> warning.
> The code using it turned into dead code with commit dcab8ecd5617
> which added a separate function iwl_pcie_load_given_ucode_8000
> (then 8000b) for IWL_DEVICE_FAMILY_8000. Commit 76f8c0e17edc
> removed the dead code but left shift_param as is.
> 
> iwlwifi/pcie/trans.c: In function ‘iwl_pcie_load_cpu_sections’:
> iwlwifi/pcie/trans.c:871:6: warning: variable ‘shift_param’ set but not used [-Wunused-but-set-variable]
> 
> Fixes: dcab8ecd5617 (iwlwifi: mvm: support ucode load for family_8000 B0 only)
> Fixes: 76f8c0e17edc (iwlwifi: pcie: remove dead code)
> 
> Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
> Cc: Sara Sharon <sara.sharon@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Eran Harary <eran.harary@intel.com>

I'll remove Harary's Cc here too, since this email is not valid anymore
and I don't know his new one (and he probably doesn't care anymore
anyway).

--
Luca.

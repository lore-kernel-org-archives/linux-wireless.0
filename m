Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48868 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751577AbcKIHZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 02:25:22 -0500
Message-ID: <1478676318.3313.12.camel@coelho.fi> (sfid-20161109_082526_632180_18078BA3)
From: Luca Coelho <luca@coelho.fi>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Date: Wed, 09 Nov 2016 09:25:18 +0200
In-Reply-To: <20161109055015.GA27416@google.com>
References: <20161109055015.GA27416@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/3] iwlwifi: mvm: rs: Remove unused
 'mvmvif'/'mvmsta' variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(removed Erarn Harary from the Cc list, since this email is not valid
anymore)

Hi Kirtika,
Just a couple of nitpicks, nothing important, so no need to resend.


On Tue, 2016-11-08 at 21:50 -0800, Kirtika Ruchandani wrote:
> mvmvif is defined and set in rs_mimo_allow but not used. Compiling
> iwlwifi with W=1 gives the following warning, remove it. mvmsta is used only to
> obtain mvmvif so remove it as well.
> 
> iwlwifi/mvm/rs.c: In function 'rs_mimo_allow':
> iwlwifi/mvm/rs.c:165:22: warning: variable 'mvmvif' set but not used.[-Wunused-but-set-variable]
> 
> This fix removes calls to iwl_mvm_sta_from_mac & iwl_mvm_vif_from_mac. They are
> both accessors, and do not have any side-effects.
> Commit e621c2282 removed a workaround that disabled MIMO on P2P, 'mvmvif' was
> used for that workaround, but not removed with it.
> 
> Fixes: e621c2282e31 ("iwlwifi: rs: Remove workaround that disables MIMO on P2P")
> 

Usually the Fixes: tag is together with the other tags (such as Cc,
Signed-off-by), i.e. no empty line here.


> Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
> Cc: Alexander Bondar <alexander.bondar@intel.com>
> Cc: Emmanuel Grumbach <emmmanuel.grumbach@intel.com>

And the Signed-off-by tag is usually the last one here, after all Cc's
and stuff.  But it doesn't matter much.

-- 
Cheers,
Luca.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4158 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKQNil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 08:38:41 -0500
Date: Mon, 17 Nov 2008 08:37:37 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Xu, Martin" <martin.xu@intel.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts per second at idle
Message-ID: <20081117133737.GA16412@hash.localnet> (sfid-20081117_143846_471899_C0B342C0)
References: <bug-11749-13098@http.bugzilla.kernel.org/> <20081013150525.884BC108058@picon.linux-foundation.org> <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com> <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com> <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 03:35:07PM +0800, Xu, Martin wrote:
> Hi bob??
> Please review below patch which has been modified according to your comments.

Thanks, looks a lot better.  I still have a few minor comments:

> +static void
> +set_beacon_filter(struct ieee80211_hw *hw, bool enable)
> +{
[...]
> +	return;
> +}

Please don't use 'return' for void functions.

> +static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> +				    struct ieee80211_vif *vif,
> +				    struct ieee80211_bss_conf *bss_conf,
> +				    u32 changes)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	if (changes & BSS_CHANGED_ASSOC) {
> +		mutex_lock(&sc->lock);
> +		sc->assoc = bss_conf->assoc;
> +		if (sc->opmode == NL80211_IFTYPE_STATION) {
> +			if (sc->assoc)
> +				set_beacon_filter(hw, 1);
> +			else
> +				set_beacon_filter(hw, 0);

No need for test:
                        set_beacon_filter(hw, sc->assoc);

> +		}
> +		mutex_unlock(&sc->lock);
> +	}
> +	return;

ditto above comment

Thanks,
Bob

-- 
Bob Copeland %% www.bobcopeland.com


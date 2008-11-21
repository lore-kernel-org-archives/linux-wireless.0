Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40818 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbYKUUbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:21 -0500
Date: Fri, 21 Nov 2008 15:27:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Xu, Martin" <martin.xu@intel.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts
	per second at idle
Message-ID: <20081121202734.GC3540@tuxdriver.com> (sfid-20081121_213138_877141_D50F7D1E)
References: <bug-11749-13098@http.bugzilla.kernel.org/> <20081013150525.884BC108058@picon.linux-foundation.org> <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com> <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com> <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com> <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com> <20081117133737.GA16412@hash.localnet> <9F0C1DB20AFA954FA1DA05309350433D41183AB4@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9F0C1DB20AFA954FA1DA05309350433D41183AB4@pdsmsx503.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 11:13:18AM +0800, Xu, Martin wrote:
> Hi Bob:
> Please review below patch thanks.
> 
> From: Martin Xu <martin.xu@intel.com>
> Subject: disable beacon filter when station is not associated with any AP.
> 
> Ath5k driver has too many interrupts per second at idle
> http://bugzilla.kernel.org/show_bug.cgi?id=11749
> 
> Signed-off-by: Martin Xu <martin.xu@intel.com>
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 34cd1a4..37da7cc 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -241,6 +241,10 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
>  static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
>  static void ath5k_reset_tsf(struct ieee80211_hw *hw);
>  static int ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb);
> +static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif,
> +				struct ieee80211_bss_conf *bss_conf,
> +				u32 changes);
>  
>  static struct ieee80211_ops ath5k_hw_ops = {
>  	.tx 		= ath5k_tx,

This patch defines ath5k_bss_info_changed, but doesn't use it.
Is that really what you meant to do?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

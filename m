Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39968 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3LIUpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 15:45:22 -0500
Date: Mon, 9 Dec 2013 15:30:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20131203
Message-ID: <20131209203057.GC3359@tuxdriver.com> (sfid-20131209_214530_771813_638464EF)
References: <87txep52hf.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87txep52hf.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 03, 2013 at 06:22:04PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here are ath10k patches which accumulated during the merge window.
> 
> Janusz and Marek implemented DFS support to ath10k, but the code is not
> enabled yet due to missing cfg80211/mac80211 patches (it will be enabled
> in the next pull request). Michal did some device reset fixes and made
> it possible for ath10k to share an interrupt with another device. And
> lots of smaller fixes from different people.
> 
> This time there are two conflicts, one in htc.c and other in mac.c. For
> the htc change just delete the hunk. For the mac.c conflict take the
> hunk from cfb27d29b61 (the bigger one) and rename
> IEEE80211_CHAN_PASSIVE_SCAN to IEEE80211_CHAN_NO_IR. After you have
> fixed the conflicts 'git diff' should show you this:
> 
> diff --cc drivers/net/wireless/ath/ath10k/htc.c
> index edae50b,b068ae0..0000000
> --- a/drivers/net/wireless/ath/ath10k/htc.c
> +++ b/drivers/net/wireless/ath/ath10k/htc.c
> diff --cc drivers/net/wireless/ath/ath10k/mac.c
> index 06fe2b8,7d3d3ac..0000000
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@@ -1356,7 -1482,10 +1482,10 @@@ static int ath10k_update_channel_list(s
>                         ch->ht40plus =
>                                 !(channel->flags & IEEE80211_CHAN_NO_HT40PLUS);
>   
> +                       ch->chan_radar =
> +                               !!(channel->flags & IEEE80211_CHAN_RADAR);
> + 
>  -                      passive = channel->flags & IEEE80211_CHAN_PASSIVE_SCAN;
>  +                      passive = channel->flags & IEEE80211_CHAN_NO_IR;
>                         ch->passive = passive;
>   
>                         ch->freq = channel->center_freq;
> 
> Please let me know if you prefer me to handle the conflict differently
> or if there are any other problems with the pull request.
> 
> The following changes since commit a1b13b9ad3759dca24c6b721ee026c540a4e6564:
> 
>   rt2x00: rt2800pci: use module_pci_driver macro (2013-10-18 14:07:00 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git tags/for-linville-20131203
> 
> for you to fetch changes up to cfb27d29b61cc32c0bb75f741aeabb9c6e6af742:
> 
>   ath10k: fix multi BSSID with WPA on FW 10.1 (2013-12-02 18:51:13 +0200)

Pulling now -- thanks for the advice on the merge fixup!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

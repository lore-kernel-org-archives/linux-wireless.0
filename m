Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:20776 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBHXHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 18:07:49 -0500
Date: Thu, 8 Feb 2018 15:01:01 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt7601u: set device mac address in
 mt7601u_add_interface()
Message-ID: <20180208150101.0e069f65@cakuba.netronome.com> (sfid-20180209_000756_353651_C3D6DE79)
In-Reply-To: <c2fe73b04dac0827adf135e669ed441f9ed1d13c.1518126991.git.lorenzo.bianconi@redhat.com>
References: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
        <c2fe73b04dac0827adf135e669ed441f9ed1d13c.1518126991.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu,  8 Feb 2018 23:08:09 +0100, Lorenzo Bianconi wrote:
> If mac80211 adds a vif with a different mac address respect to
> the eeprom one, the device will not be able to connect to the ap
> since the hw address has not been updated.
> Fix the issue updating hw mac address in mt7601u_add_interface routine
> 
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1516935
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt7601u/main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
> index 43ebd460ba86..3c9ea40d9584 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/main.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/main.c
> @@ -64,6 +64,9 @@ static int mt7601u_add_interface(struct ieee80211_hw *hw,
>  	 */
>  	mvif->idx = idx;
>  
> +	if (!ether_addr_equal(dev->macaddr, vif->addr))
> +		mt7601u_set_macaddr(dev, vif->addr);
> +
>  	if (dev->wcid_mask[wcid / BITS_PER_LONG] & BIT(wcid % BITS_PER_LONG))
>  		return -ENOSPC;
>  	dev->wcid_mask[wcid / BITS_PER_LONG] |= BIT(wcid % BITS_PER_LONG);

Sorry, my recollection of mac80211 code is waning, but can't we have
more than one vif as long as they are on the same channel?

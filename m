Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292Ab2IEKVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 06:21:16 -0400
Date: Wed, 5 Sep 2012 12:20:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?iso-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
Message-ID: <20120905102046.GC2311@redhat.com> (sfid-20120905_122133_436457_2EEFAF3D)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346838562-4818-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
> +	ret = wait_event_timeout(wl->tx_flush_wq,
> +				 brcms_tx_flush_completed(wl),
> +				 msecs_to_jiffies(BRCMS_FLUSH_TIMEOUT));
> +
> +	ieee80211_wake_queues(hw);
> +	WARN_ON(!ret);
Any particular reason why this WARN_ON is after ieee80211_wake_queues() ?

Stanislaw


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46242 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab2DFQTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 12:19:19 -0400
Message-ID: <4F7F1780.1090803@openwrt.org> (sfid-20120406_181922_413007_FB82EC91)
Date: Fri, 06 Apr 2012 18:19:12 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: fix an issue in ieee80211_tx_info count field
 management
References: <CAA2SeN+DRnff_e-fDuFAV-vof0OEsw7VEkmxBhUivq0kSspzvw@mail.gmail.com>
In-Reply-To: <CAA2SeN+DRnff_e-fDuFAV-vof0OEsw7VEkmxBhUivq0kSspzvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-05 11:39 PM, Lorenzo Bianconi wrote:
> Hi all,
> 
> I noticed a possible issue in the status count field management of the
> ieee80211_tx_info data structure. In particular, when the AGGR
> processing is employed,
> ath_tx_complete_aggr() sets status.rates[].count just for the first
> frame and not for others belonging to the same burst, leading to wrong
> statistic data in the mac80211 debug file system.
The driver behavior is OK and mac80211 needs to be changed. The tx
status code that counts retries needs to check if AMPDU CTL and STATUS
flags match and stop counting for packets where they don't match.

- Felix

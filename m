Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42841 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751987AbZHBHgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:36:16 -0400
Message-ID: <4A7541ED.2090309@gmx.de>
Date: Sun, 02 Aug 2009 09:36:13 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath5k: fix missing output in monitor mode after	ifconfig
 up
References: <4A74C2B6.3070407@gmx.de> <20090802032019.GA25339@hash.localnet>
In-Reply-To: <20090802032019.GA25339@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2009 05:20 AM, Bob Copeland wrote:
> On Sun, Aug 02, 2009 at 12:33:26AM +0200, Joerg Albert wrote:
>> Let ath5k_chan_set() call ath5k_reset() if ath5k_config() was told
>> that the channel changed. This fixes the bug that we don't
>> get any packets in monitor mode after:
> 
> Cool, thanks for the patch.  Just a couple of comments:
> 
>> +                              int chan_changed);
> 
> Should use bool for that.
> 
>> -       ret = ath5k_chan_set(sc, conf->channel);
>> +       ret = ath5k_chan_set(sc, conf->channel,
>> +                            changed & IEEE80211_CONF_CHANGE_CHANNEL);
> 
> Since this is the only place ath5k_chan_set is called, how about changing
> ath5k_chan_set to unconditionally do a reset, and put the test outside?
> 
> i.e.:
> 
>         if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
>                 ath5k_chan_set(sc, conf->channel);

Good idea. I'll redo the patch.

BTW, it assumes that IEEE80211_CONF_CHANGE_CHANNEL is set even if only chan->hw_value has changed,
e.g. by switching from A to TurboA on the same channel. AFAIK TurboX isn't currently supported by ath5k.

Regards,
Jörg.

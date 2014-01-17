Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53884 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaAQWSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 17:18:10 -0500
Message-ID: <52D9AC1F.6090002@lwfinger.net> (sfid-20140117_231814_880446_1E9EAFC5)
Date: Fri, 17 Jan 2014 16:18:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ZHAO Gang <gamerh2o@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Jonas Gorski <jogo@openwrt.org>, Luca Coelho <luca@coelho.fi>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] b43: fix the wrong assignment of status.freq in
 b43_rx()
References: <d4d1340a176aee1e58ffe80e83ddc3394f2829e3.1389975095.git.gamerh2o@gmail.com>
In-Reply-To: <d4d1340a176aee1e58ffe80e83ddc3394f2829e3.1389975095.git.gamerh2o@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2014 10:17 AM, ZHAO Gang wrote:
> Use the right function to update frequency value.
>
> If rx skb is probe response or beacon, the wrong frequency value can
> cause problem that bss info can't be updated when it should be.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 8318d78a44d4 ("cfg80211 API for channels/bitrates, mac80211
> and driver conversion")
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---

This patch seems to fix a problem that caused scanning under NetworkManager to 
fail. The symptom was that no available networks were seen in the NM applet 
after a connection was made. Now the available AP list remains populated.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry



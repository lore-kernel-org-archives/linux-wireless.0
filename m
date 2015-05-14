Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27713 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbbENPMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 11:12:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com>
	<873837qo6l.fsf@kamboji.qca.qualcomm.com>
	<554CE438.5000208@candelatech.com>
	<CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com>
	<871tinjosq.fsf@kamboji.qca.qualcomm.com>
	<5550D629.2090501@candelatech.com>
	<CAG5N3qE6nA2oEhR5Zk8sS331-ycM+jZLBy2BeGPX0ueHqvJ6Kg@mail.gmail.com>
Date: Thu, 14 May 2015 18:12:36 +0300
In-Reply-To: <CAG5N3qE6nA2oEhR5Zk8sS331-ycM+jZLBy2BeGPX0ueHqvJ6Kg@mail.gmail.com>
	(Liu CF's message of "Tue, 12 May 2015 15:44:29 -0700")
Message-ID: <87oalnchwb.fsf@kamboji.qca.qualcomm.com> (sfid-20150514_171248_056907_18775A1B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Liu CF/TW" <cfliu.tw@gmail.com> writes:

> I am going to propose just one single module parameter control: enc_mode
>
> - enc_mode = 0: Use HW crypto (default),
>
>   Driver behavior:
>      - ath10k driver uses native WiFi mode for both Tx/Rx.
>      - ath10k driver configures key to HW.
>      Given HW key descriptor is configured, mac80211 would offload Tx
> encryption to HW and only do Rx decryption (by mac80211) if HW failed
> to do it.

But isn't the point here to use 802.11 frames ("raw mode")? Then why
name the module paramater as enc_mode? I think that's confusing.

And to me enc_mode doesn't tell much, my first thought was "encoding
mode". Wouldn't cryptmode tell more to the user?


-- 
Kalle Valo

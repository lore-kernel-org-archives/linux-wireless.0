Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36161 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913AbbELXCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 19:02:03 -0400
Received: by iepk2 with SMTP id k2so14916535iep.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 16:02:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG5N3qE6nA2oEhR5Zk8sS331-ycM+jZLBy2BeGPX0ueHqvJ6Kg@mail.gmail.com>
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com>
 <873837qo6l.fsf@kamboji.qca.qualcomm.com> <554CE438.5000208@candelatech.com>
 <CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com>
 <871tinjosq.fsf@kamboji.qca.qualcomm.com> <5550D629.2090501@candelatech.com> <CAG5N3qE6nA2oEhR5Zk8sS331-ycM+jZLBy2BeGPX0ueHqvJ6Kg@mail.gmail.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Tue, 12 May 2015 16:01:21 -0700
Message-ID: <CAG5N3qHCRL8m1wJ4xVauK+4rBoLVsPra5Rx5c+5bHUuXPZR8Pg@mail.gmail.com> (sfid-20150513_010208_249888_C5A60592)
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param for
 raw tx injection, sw crypto support.
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 3:44 PM, Liu CF/TW <cfliu.tw@gmail.com> wrote:
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
>

Recap. Should be: "Given HW key descriptor is configured, Tx
encryption and Rx decryption would be both done by HW."

Note: Due to HW limitation, SW crypto can't be done in native WiFi mode.
Transmit already encrypted frames requires raw mode.
Bypass encrypted frame for SW for decryption in native Wifi mode is
possible, but requires reinserting QoS header on per frame basis which
is tedious.

>   Use case:
>       - The only mode current driver supports to date.
>       - The CT firmware special use case should fall into this
> category where firmware overrides the ath10k driver setting to force
> Rx fallback to SW decryption (in mac80211).
>          (From Ben's description, I believe CT FW overrides the global
> Rx decap mode=raw mode  + mangle the HW Rx descriptor to skip HW
> decryption)
>
> - enc_mode = 1: Use SW crypto.
>
>   Driver behavior:
>      - ath10k driver uses raw encap mode for both Tx/Rx
>      - ath10k driver doesn't configure actual key to HW but program
> CLEAR key context to bypass HW.
>      This is the classic nohwcrypt=1 mode. Only SW crypto is enabled globally.
>   Use case:
>      - NEW: Full SW crypto on both Tx/Rx.
>      - NEW: raw injected Tx frame. If encryption required, would use
> mac80211 SW crypto.
>
> - enc_mode = 2: Supports both HW and SW crypto simultaneously.
>
>   Driver behavior:
>      - ath10k driver uses raw encap mode for both Tx/Rx
>      - ath10k driver configures key to HW only if the per BSS config
> enables it (either via debugfs or nl80211 attribute, TBD)
>        If HW key is configured, use HW crypto. Otherwise, use SW crypto.
>
>   Use case:
>     - NEW: raw injected Tx frame. If encryption is required, could
> support both SW or HW crypto (by the per BSS config)
>     - NEW: some BSS could use HW crypto with no performance hit while
> some BSS could bypass HW crypto (ex: CAPWAP like split-MAC encrypted
> frames)
>
> Ben, in this case, as long as enc_mode == 0, your FW should continue
> to work. I will add a new FW feature TX_RAW_ENCAP_SUPPORTED, and fail
> at module load time if enc_mode !=0 and FW doesn't support it. Would
> this address your concerns?
>
> David.
>
>

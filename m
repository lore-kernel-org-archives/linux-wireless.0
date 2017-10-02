Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:32836 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdJBJCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 05:02:55 -0400
Received: by mail-lf0-f65.google.com with SMTP id j73so1877457lfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 02:02:54 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: Re: [PATCH 00/11] SDIO support for ath10k
To: silexcommon@gmail.com, ath10k@lists.infradead.org
Cc: Alagu Sankar <alagusankar@silex-india.com>,
        linux-wireless@vger.kernel.org
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Message-ID: <b4bbf022-77d7-f907-f35b-7afacfc227e5@gmail.com> (sfid-20171002_110109_703044_3A8EE1C6)
Date: Mon, 2 Oct 2017 11:02:52 +0200
MIME-Version: 1.0
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

It is great to see that we are finally about have fully working
mainline support for QCA9377 SDIO chipsets!

Great job!

On 2017-09-30 19:37, silexcommon@gmail.com wrote:
> From: Alagu Sankar <alagusankar@silex-india.com>
> 
> This patchset, generated against master-pending branch, enables a fully
> functional SDIO interface driver for ath10k.  Patches have been verified on
> QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access Point
> and P2P modes.
> 
> The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1
> with the board data from respective SDIO card vendors. Receive performance
> matches the QCA reference driver when used with SDIO3.0 enabled platforms.
> iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s
> 
Can you share any scripts etc. (wrapping hostapd and wpa_supplicant stuff)
or provide some more info about you test setup?

I made a quick socat based test on an old laptop (I don't think it has SDIO
3.0 support) and I did unfortunately not get the same figures as you did :(

> This patchset differs from the previous high latency patches, specific to SDIO.
> HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET is enabled for HI_ACS. This instructs the
> firmware to use HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing packets. Without
> this flag, the management frames are not sent out by the firmware. Possibility
> of management frames being sent via WMI and data frames through the reduced Tx
> completion needs to be probed further.
> 
Ah, so that explains why I couldn't see any messages in the air.

> Further improvements can be done on the transmit path by implementing packet
> bundle. Scatter Gather is another area of improvement for both Transmit and
> Receive, but may not work on all platforms
> 
> Known issues: Surprise removal of the card, when the device is in connected
> state, delays sdio function remove due to delayed WMI command failures.
> Existing ath10k framework can not differentiate between a kernel module
> removal and the surprise removal of teh card.
> 
> Alagu Sankar (11):
>    ath10k_sdio: sdio htt data transfer fixes
>    ath10k_sdio: wb396 reference card fix
>    ath10k_sdio: DMA bounce buffers for read write
>    ath10k_sdio: reduce transmit msdu count
>    ath10k_sdio: use clean packet headers
>    ath10k_sdio: high latency fixes for beacon buffer
>    ath10k_sdio: fix rssi indication
>    ath10k_sdio: common read write
>    ath10k_sdio: virtual scatter gather for receive
>    ath10k_sdio: enable firmware crash dump
>    ath10k_sdio: hif start once addition
> 
>   drivers/net/wireless/ath/ath10k/core.c    |  35 ++-
>   drivers/net/wireless/ath/ath10k/debug.c   |   3 +
>   drivers/net/wireless/ath/ath10k/htc.c     |   4 +-
>   drivers/net/wireless/ath/ath10k/htc.h     |   1 +
>   drivers/net/wireless/ath/ath10k/htt_rx.c  |  19 +-
>   drivers/net/wireless/ath/ath10k/htt_tx.c  |  24 +-
>   drivers/net/wireless/ath/ath10k/hw.c      |   2 +
>   drivers/net/wireless/ath/ath10k/hw.h      |   1 +
>   drivers/net/wireless/ath/ath10k/mac.c     |  31 ++-
>   drivers/net/wireless/ath/ath10k/sdio.c    | 398 ++++++++++++++++++++++--------
>   drivers/net/wireless/ath/ath10k/sdio.h    |  10 +-
>   drivers/net/wireless/ath/ath10k/wmi-tlv.c |   2 +-
>   12 files changed, 403 insertions(+), 127 deletions(-)
> 

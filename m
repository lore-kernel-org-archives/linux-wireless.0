Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:38705 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbdLVQZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:25:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "silexcommon@gmail.com" <silexcommon@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/11] SDIO support for ath10k
Date: Fri, 22 Dec 2017 16:25:31 +0000
Message-ID: <87608y91c5.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_172539_865935_7A999023)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
        (silexcommon@gmail.com's message of "Sat, 30 Sep 2017 23:07:37 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

silexcommon@gmail.com writes:

> From: Alagu Sankar <alagusankar@silex-india.com>
>
> This patchset, generated against master-pending branch, enables a fully
> functional SDIO interface driver for ath10k.  Patches have been verified =
on
> QCA9377-3 WB396 and Silex's SX-SDCAC reference cards with Station, Access=
 Point
> and P2P modes.
>
> The driver is verified with the firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1
> with the board data from respective SDIO card vendors. Receive performanc=
e
> matches the QCA reference driver when used with SDIO3.0 enabled platforms=
.
> iperf tests indicate a downlink UDP of 275Mbit/s and TCP of 150Mbit/s
>
> This patchset differs from the previous high latency patches, specific to=
 SDIO.
> HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET is enabled for HI_ACS. This instruc=
ts the
> firmware to use HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing packets. Witho=
ut
> this flag, the management frames are not sent out by the firmware. Possib=
ility
> of management frames being sent via WMI and data frames through the reduc=
ed Tx
> completion needs to be probed further.
>
> Further improvements can be done on the transmit path by implementing pac=
ket
> bundle. Scatter Gather is another area of improvement for both Transmit a=
nd
> Receive, but may not work on all platforms
>
> Known issues: Surprise removal of the card, when the device is in connect=
ed
> state, delays sdio function remove due to delayed WMI command failures.
> Existing ath10k framework can not differentiate between a kernel module
> removal and the surprise removal of teh card.
>
> Alagu Sankar (11):
>   ath10k_sdio: sdio htt data transfer fixes
>   ath10k_sdio: wb396 reference card fix
>   ath10k_sdio: DMA bounce buffers for read write
>   ath10k_sdio: reduce transmit msdu count
>   ath10k_sdio: use clean packet headers
>   ath10k_sdio: high latency fixes for beacon buffer
>   ath10k_sdio: fix rssi indication
>   ath10k_sdio: common read write
>   ath10k_sdio: virtual scatter gather for receive
>   ath10k_sdio: enable firmware crash dump
>   ath10k_sdio: hif start once addition

Sorry, I run out of time to review this in detail. To make the review
easier I recommend to split this patchset into two sets, first set
containing only the bare essential to get basic functionality working
(for example ping working on x86) and the second set containing all the
optimisations (the bounce buffer stuff etc).

And try to make the first set as small as possible so that we can get it
faster applied.

--=20
Kalle Valo=

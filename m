Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51834 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2LGHrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 02:47:25 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so408360ieb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 23:47:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLrre0u0XotTWupgefExM14AgkP-UTfVECGyy7AY0z9SQ@mail.gmail.com>
References: <CABPxzYLrre0u0XotTWupgefExM14AgkP-UTfVECGyy7AY0z9SQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 7 Dec 2012 13:17:04 +0530
Message-ID: <CABPxzYKxtpiWiabyPCQVqNnQDNyGqf4Mp3K_X1CbZoM=jppsBg@mail.gmail.com> (sfid-20121207_084729_498446_DB88E69A)
Subject: Re: [ath9k-devel] AR5008: AMPDU Status Support for Radiotap monitor mode
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Linux Wireless for Information.

On Tue, Dec 4, 2012 at 5:51 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> Hi All,
>
> I am working on AMPDU stats for ath9k PCIe cards for use as sniffer in
> monitor mode.
> As the driver doesnt support the AMPDU stats for radiotap we have
> written the below snippet to add support for the same.
>
> Can someone answer the below queries?
>
> 1) How to populate the below fields?
>                 ampdu_reference
>                 ampdu_delimiter_crc
> 2) Whats the difference between the PRE and POST delimiter CRC Error counters?
> 3) how do we get the first subframe info? the status8 register (0x8)
> is not working.
>
> Once i get all the answers and after testing will submit this patch.
>
> Reference for radiotap ampdu fields:
> http://www.radiotap.org/defined-fields/A-MPDU%20status
>
> Attached the capture with the below code added.
>
> Code Snippet: recv.c:  ath9k_rx_skb_preprocess (similar approach can
> be done for HTC based chips, htc_txrx.c: ath9k_rx_prepare)
>
> #define AR_RxFirstAggr      0x20000000
>
>
>         if (rx_stats->rs_isaggr) {
>                 rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
>                 rx_status->ampdu_reference=0x99999999; // Junk..
>                 rx_status->ampdu_delimiter_crc=0x10; //Junk
>                 rx_status->flag |= RX_FLAG_AMPDU_LAST_KNOWN;
>                 if (rx_stats->rs_isfirstaggr) { // Took from other
> chipset (ar9220) but not working for ar5008 chipset...always it shows
> zero
>                         printk("\n packet is first SF of the AMPDU\n");
>                         rx_status->flag |=RX_FLAG_AMPDU_IS_ZEROLEN; //
> Temp Hack to Verify
>                 }
>                 //printk("\n packet is aggr: Setting the AMPDU\n");
>                 if (!rx_stats->rs_moreaggr) {
>                         rx_status->flag |=RX_FLAG_AMPDU_IS_LAST;
>                 }
>                 if (rx_stats->pre_delim_crc_err ||
> rx_stats->post_delim_crc_err ) {
>                         printk("\n packet is aggr: Delim crc is True\n");
>                         rx_status->flag |= RX_FLAG_AMPDU_DELIM_CRC_ERROR;
>                 } else if(!rx_stats->pre_delim_crc_err &&
> !rx_stats->post_delim_crc_err ) {
>                         //printk("\n packet is aggr: Delim crc is True\n");
>                         rx_status->flag |= RX_FLAG_AMPDU_DELIM_CRC_KNOWN;
>
>                 }
>
>         }
>
> Regards,
> Chaitanya T K.

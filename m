Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41100 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0KPPhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 10:37:32 -0500
Received: by vws13 with SMTP id 13so282967vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 07:37:31 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/9] rt2x00: Fix header_length in rt2x00lib_txdone
Date: Tue, 16 Nov 2010 16:36:27 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131911.47346.IvDoorn@gmail.com> <201011131912.55384.IvDoorn@gmail.com>
In-Reply-To: <201011131912.55384.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161636.27245.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 13 November 2010 schrieb Ivo van Doorn:
> From: RA-Jay Hung <Jay_Hung@ralinktech.com>
> 
> Put the assignment of header_length after pull out extra tx headroom

Thanks, this fixes an occasional panic for me in AP mode:

[  133.980000] skb_under_panic: text:81933574 len:1550 put:16 head:80a86800 data:80a867fc tail:0x80a86e0a end:0x80a86ea0 dev:wlan0
[  134.010000] Kernel bug detected[#1]:
[  134.010000] Cpu 0
[  134.010000] $ 0   : 00000000 80320000 00000089 00000001
[  134.010000] $ 4   : 8020559c 00002a63 00000001 00002a63
[  134.010000] $ 8   : 00000020 00000001 00000001 0000000a
[  134.010000] $12   : 000000cd 00000009 00000000 3a699d00
[  134.010000] $16   : 81909d00 80fac2f8 818f4aa8 80e7fba0
[  134.010000] $20   : 81909d00 819036f8 819036e0 00000002
[  134.010000] $24   : 00000000 80103130                  
[  134.010000] $28   : 80e7e000 80e7fb58 00000001 8012c4f0
[  134.010000] Hi    : 00000000
[  134.010000] Lo    : cbd20000
[  134.010000] epc   : 8012c4f0 skb_push+0x6c/0x88
[  134.010000]     Not tainted
[  134.010000] ra    : 8012c4f0 skb_push+0x6c/0x88
[  134.010000] Status: 1000e403    KERNEL EXL IE 
[  134.010000] Cause : 10800024
[  134.010000] PrId  : 0001964c (MIPS 24Kc)
[  134.010000] Modules linked in: rt2800pci rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 eeprom_93cx6 crc_itu_t crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc
[  134.010000] Process irq/6-rt2800_wm (pid: 794, threadinfo=80e7e000, task=819811e0, tls=00000000)
[  134.010000] Stack : 00005220 81933574 0000060e 00000010 80a86800 80a867fc 80a86e0a 80a86ea0
[  134.010000]         81979000 81909d00 819036f8 81933574 80840000 819036f8 00000000 00000041
[  134.010000]         8020f480 819a9a80 0000be88 00000002 001a05fc 00800030 00040000 0000000d
[  134.010000]         00020007 00020005 00000003 00040000 00000006 00000004 001a0021 00000008
[  134.010000]         819036f8 819036f8 819036e0 818f4aa8 00000000 81931cfc 80e7fc78 80f1831c
[  134.010000]         ...
[  134.010000] Call Trace:
[  134.010000] [<8012c4f0>] skb_push+0x6c/0x88
[  134.010000] [<81933574>] rt2x00queue_write_tx_frame+0x218/0x344 [rt2x00lib]
[  134.010000] [<81931cfc>] rt2x00mac_tx+0x258/0x2d4 [rt2x00lib]
[  134.010000] [<80f19fa8>] __ieee80211_tx+0x14c/0x1e4 [mac80211]
[  134.010000] [<80f1a118>] ieee80211_tx+0xd8/0x25c [mac80211]
[  134.010000] [<80f1ae58>] ieee80211_tx_pending+0x11c/0x26c [mac80211]
[  134.010000] [<8001e444>] tasklet_action+0x88/0xe4
[  134.010000] [<8001ec10>] __do_softirq+0xb0/0x148
[  134.010000] [<8001ecf0>] do_softirq+0x48/0x6c
[  134.010000] [<8001ef78>] local_bh_enable+0x8c/0xa8
[  134.010000] [<81930414>] rt2x00lib_rxdone+0x2d0/0x320 [rt2x00lib]
[  134.010000] [<80eee2ec>] rt2x00pci_initialize+0x24c/0x270 [rt2x00pci]
[  134.010000] 
[  134.010000] 
[  134.010000] Code: afa9001c  0c001571  afa20020 <0200000d> 0804b13d  00000000  8fbf002c  01001021  03e00008 

Helmut

> Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 3afa2a3..c879f9a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -250,10 +250,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
>  	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
> -	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
> +	unsigned int header_length, i;
>  	u8 rate_idx, rate_flags, retry_rates;
>  	u8 skbdesc_flags = skbdesc->flags;
> -	unsigned int i;
>  	bool success;
>  
>  	/*
> @@ -272,6 +271,11 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
>  
>  	/*
> +	 * Determine the length of 802.11 header.
> +	 */
> +	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
> +
> +	/*
>  	 * Remove L2 padding which was added during
>  	 */
>  	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
> 


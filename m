Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:58649 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2L2J2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2012 04:28:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE combo device
Date: Sat, 29 Dec 2012 10:29:22 +0100
Message-ID: <3835139.gKBy1HP29j@linux-lqwf.site> (sfid-20121229_102859_566846_46989D91)
In-Reply-To: <50DA64E7.9050700@lwfinger.net>
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net> <6432515.NlhvICzq3b@linux-lqwf.site> <50DA64E7.9050700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 December 2012 20:45:59 Larry Finger wrote:
> >> +struct patch_info {
> >> +    uint16_t        prod_id;
> >> +    uint16_t        lmp_sub;
> >> +    char            *patch_name;
> >> +    char            *config_name;
> >> +    uint8_t         *fw_cache;
> >> +    int             fw_len;
> >> +};
> >> +
> >> +struct xchange_data {
> >> +    struct dev_data *dev_entry;
> >> +    int pipe_in, pipe_out;
> >> +    uint8_t send_pkt[PKT_LEN];
> >> +    uint8_t rcv_pkt[PKT_LEN];
> >
> > Violations of the DMA coherency rules, fails on non-x86
> 
> I see that the buffers are not 64-bit aligned. What other conditions are necessary?

They need to be aligned on cache lines and nothing else may use
that cache line. The size of a cache line is specific to an architecture.
It is generally easiest for such buffers to be allocated separately with kmalloc().

> Thanks for the review. As suggested by you and Marcel, a complete rewrite is 
> needed. I plan to use the mini-driver approach of Tedd Ho-Jeong An; however, 
> your comments will be used when constructing that code.

Very good.

	Regards
		Oliver


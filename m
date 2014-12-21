Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48139 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaLURZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 12:25:20 -0500
Date: Sun, 21 Dec 2014 11:25:16 -0600
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry.Finger@lwfinger.net,
	linux-kernel@vger.kernel.org
Subject: [BUG] rtl8192se: panic accessing unmapped memory in skb
Message-ID: <20141221172516.GA12784@zzz> (sfid-20141221_182533_842510_4752AA2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a RTL8192SE wireless card, attached via PCI.  Usually it works with no
issues, but I recently had a kernel panic occur in the rtl8192se driver.  The
kernel version is 3.18.  Based on my analysis of the panic dump, the panic was
caused by a memory access violation in this block of code in
rtl92se_rx_query_desc():

        if (stats->decrypted) {
                hdr = (struct ieee80211_hdr *)(skb->data +
                       stats->rx_drvinfo_size + stats->rx_bufshift);

                if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
                        (ieee80211_has_protected(hdr->frame_control)))
                        rx_status->flag &= ~RX_FLAG_DECRYPTED;
                else
                        rx_status->flag |= RX_FLAG_DECRYPTED;
        }

Specifically, the violation occurred the first time hdr->frame_control was
accessed, as part of _ieee80211_is_robust_mgmt_frame().

The panic occurred when the system was under heavy filesystem load but seemingly
is not easily reproducible.

There was recently a NULL check that was removed from this exact place in the
code, but it was certainly useless.  Instead, what's much more suspect to me is
that inside _rtl_pci_rx_interrupt(), there is no error checking of the return
value of _rtl_pci_init_one_rxdesc(), which might fail if the skb couldn't be
allocated.  I am wondering if this could be causing the problem.

Eric

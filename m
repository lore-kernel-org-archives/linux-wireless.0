Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753727AbdDSDeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 23:34:50 -0400
Date: Wed, 19 Apr 2017 13:34:46 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: ks7010 endianness question
Message-ID: <20170419033446.GA17058@eros> (sfid-20170419_053455_188599_BEC87AA1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wolfram,

May I please ask you with an ks7010 driver endianness question?

Comments on the hostif_hdr data structure (ks_hostif.h) state that the
target uses little endian byte order.

/*
 * HOST-MAC I/F data structure
 * Byte alignmet Little Endian
 */

struct hostif_hdr {
	u16 size;
	u16 event;
} __packed;

On the rx data path this header is unpacked using get_WORD()

void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
		    unsigned int size)
{
	DPRINTK(4, "\n");

	devio_rec_ind(priv, p, size);

	priv->rxp = p;
	priv->rx_size = size;

	if (get_WORD(priv) == priv->rx_size) {	/* length check !! */
		hostif_event_check(priv);	/* event check */
	}
}

get_WORD() inverts the byte order

static inline u16 get_WORD(struct ks_wlan_private *priv)
{
	u16 data;

	data = (get_BYTE(priv) & 0xff);
	data |= ((get_BYTE(priv) << 8) & 0xff00);
	return data;
}

Am I missing something? It seems that this code will only work if the
host and the target have differing endianness. It seems unlikely that
the driver was tested solely on a big-endian machine, is the comment
wrong - is the target actually big-endian?

Off topic, I watched your 2014 Fosdem talk on adding device support to
the kernel without adding code. It was very educational.

thanks for your time,
Tobin.

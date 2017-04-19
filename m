Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48533 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750753AbdDSEDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 00:03:02 -0400
Date: Wed, 19 Apr 2017 14:02:58 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: ks7010 endianness question
Message-ID: <20170419040258.GB17058@eros> (sfid-20170419_060306_338768_460EBA12)
References: <20170419033446.GA17058@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170419033446.GA17058@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 19, 2017 at 01:34:46PM +1000, Tobin C. Harding wrote:
> Hi Wolfram,
> 
> May I please ask you with an ks7010 driver endianness question?
> 
> Comments on the hostif_hdr data structure (ks_hostif.h) state that the
> target uses little endian byte order.
> 
> /*
>  * HOST-MAC I/F data structure
>  * Byte alignmet Little Endian
>  */
> 
> struct hostif_hdr {
> 	u16 size;
> 	u16 event;
> } __packed;
> 
> On the rx data path this header is unpacked using get_WORD()
> 
> void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
> 		    unsigned int size)
> {
> 	DPRINTK(4, "\n");
> 
> 	devio_rec_ind(priv, p, size);
> 
> 	priv->rxp = p;
> 	priv->rx_size = size;
> 
> 	if (get_WORD(priv) == priv->rx_size) {	/* length check !! */
> 		hostif_event_check(priv);	/* event check */
> 	}
> }
> 
> get_WORD() inverts the byte order
> 
> static inline u16 get_WORD(struct ks_wlan_private *priv)
> {
> 	u16 data;
> 
> 	data = (get_BYTE(priv) & 0xff);
> 	data |= ((get_BYTE(priv) << 8) & 0xff00);
> 	return data;
> }
> 
> Am I missing something? It seems that this code will only work if the
> host and the target have differing endianness. It seems unlikely that
> the driver was tested solely on a big-endian machine, is the comment
> wrong - is the target actually big-endian?

Further investigation suggests that the target is actually using
network byte order (implying that the comment is wrong).

static void hostif_data_indication(struct ks_wlan_private *priv)
{
        ...
        
	auth_type = get_WORD(priv);	/* AuthType */
	get_WORD(priv);	                /* Reserve Area */

	eth_hdr = (struct ether_hdr *)(priv->rxp);
	eth_proto = ntohs(eth_hdr->h_proto);

        ...


I think we can call this question resolved. Remove the comment and
change the hostif_hdr description to

struct hostif_hdr {
	__be16 size;
 	__be16 event;
} __packed;

Are you happy with this?

thanks,
Tobin.

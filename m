Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27759 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759704AbXEPGQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 02:16:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andrew Morton <akpm@google.com>
Subject: Re: wireless warnings
Date: Wed, 16 May 2007 02:15:28 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070515152845.f27b49b5.akpm@google.com>
In-Reply-To: <20070515152845.f27b49b5.akpm@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2888077.AxcOMzzpBs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705160215.33458.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2888077.AxcOMzzpBs
Content-Type: multipart/mixed;
  boundary="Boundary-01=_BGqSGMKXcAabTbM"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_BGqSGMKXcAabTbM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 15 May 2007 18:28, Andrew Morton wrote:
> Some of these are pointing at serious bustage.  The kind which goes oops.
The adm8211 and p54 warnings are from the recent sk_buff_data_t changes tha=
t=20
make skb->tail an offset on 64 bit.

Attached patches fix adm8211 and p54. John, please apply.

Thanks,
=2DMichael Wu

--Boundary-01=_BGqSGMKXcAabTbM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="01-adm8211-skb-api-update.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="01-adm8211-skb-api-update.diff"

adm8211: use skb_tail_pointer instead of skb->tail

From: Michael Wu <flamingice@sourmilk.net>

This makes adm8211 use skb_tail_pointer instead of skb->tail.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/mac80211/adm8211/adm8211.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211/adm8211/adm8211.c b/drivers/net/wireless/mac80211/adm8211/adm8211.c
index f0b8a2d..0795ea7 100644
--- a/drivers/net/wireless/mac80211/adm8211/adm8211.c
+++ b/drivers/net/wireless/mac80211/adm8211/adm8211.c
@@ -499,7 +499,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 					priv->rx_buffers[entry].mapping,
 					pktlen, PCI_DMA_FROMDEVICE);
 				memcpy(skb_put(skb, pktlen),
-				       priv->rx_buffers[entry].skb->tail,
+				       skb_tail_pointer(priv->rx_buffers[entry].skb),
 				       pktlen);
 				pci_dma_sync_single_for_device(
 					priv->pdev,
@@ -518,7 +518,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 				priv->rx_buffers[entry].skb = newskb;
 				priv->rx_buffers[entry].mapping =
 					pci_map_single(priv->pdev,
-						       newskb->tail,
+						       skb_tail_pointer(newskb),
 						       RX_PKT_SIZE,
 						       PCI_DMA_FROMDEVICE);
 			} else {
@@ -1537,7 +1537,8 @@ static int adm8211_init_rings(struct ieee80211_hw *dev)
 		rx_info->skb = dev_alloc_skb(RX_PKT_SIZE);
 		if (rx_info->skb == NULL)
 			break;
-		rx_info->mapping = pci_map_single(priv->pdev, rx_info->skb->tail,
+		rx_info->mapping = pci_map_single(priv->pdev,
+						  skb_tail_pointer(rx_info->skb),
 						  RX_PKT_SIZE,
 						  PCI_DMA_FROMDEVICE);
 		desc->buffer1 = cpu_to_le32(rx_info->mapping);

--Boundary-01=_BGqSGMKXcAabTbM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="02-p54-skb-api-update.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="02-p54-skb-api-update.diff"

p54: use skb_tail_pointer instead of skb->tail

=46rom: Michael Wu <flamingice@sourmilk.net>

This makes p54 use skb_tail_pointer instead of skb->tail.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/net/wireless/mac80211/p54/prism54pci.c |    3 ++-
 drivers/net/wireless/mac80211/p54/prism54usb.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211/p54/prism54pci.c b/drivers/net/w=
ireless/mac80211/p54/prism54pci.c
index 0db7026..5de5726 100644
=2D-- a/drivers/net/wireless/mac80211/p54/prism54pci.c
+++ b/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -256,7 +256,8 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *de=
v)
 			if (!skb)
 				break;
=20
=2D			mapping =3D pci_map_single(priv->pdev, skb->tail,
+			mapping =3D pci_map_single(priv->pdev,
+						 skb_tail_pointer(skb),
 						 MAX_RX_SIZE,
 						 PCI_DMA_FROMDEVICE);
 			desc->host_addr =3D cpu_to_le32(mapping);
diff --git a/drivers/net/wireless/mac80211/p54/prism54usb.c b/drivers/net/w=
ireless/mac80211/p54/prism54usb.c
index d52131c..e65da2d 100644
=2D-- a/drivers/net/wireless/mac80211/p54/prism54usb.c
+++ b/drivers/net/wireless/mac80211/p54/prism54usb.c
@@ -100,7 +100,7 @@ static void p54u_rx_cb(struct urb *urb)
 		info =3D (struct p54u_rx_info *) skb->cb;
 		info->urb =3D urb;
 		info->dev =3D dev;
=2D		urb->transfer_buffer =3D skb->tail;
+		urb->transfer_buffer =3D skb_tail_pointer(skb);
 		urb->context =3D skb;
 		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
@@ -138,7 +138,7 @@ static int p54u_init_urbs(struct ieee80211_hw *dev)
 			kfree_skb(skb);
 			break;
 		}
=2D		usb_fill_bulk_urb(entry, priv->udev, usb_rcvbulkpipe(priv->udev, P54U_=
PIPE_DATA), skb->tail, MAX_RX_SIZE, p54u_rx_cb, skb);
+		usb_fill_bulk_urb(entry, priv->udev, usb_rcvbulkpipe(priv->udev, P54U_PI=
PE_DATA), skb_tail_pointer(skb), MAX_RX_SIZE, p54u_rx_cb, skb);
 		info =3D (struct p54u_rx_info *) skb->cb;
 		info->urb =3D entry;
 		info->dev =3D dev;

--Boundary-01=_BGqSGMKXcAabTbM--

--nextPart2888077.AxcOMzzpBs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGSqGFT3Oqt9AH4aERAsmMAKCMcfXG/FN+5DnH2bjpvLrBEk6rNgCgwNgA
SFtimDF2TFkun9FfqN5EyvI=
=HzSe
-----END PGP SIGNATURE-----

--nextPart2888077.AxcOMzzpBs--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

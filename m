Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882695;
	b=2OXbzTSVYdkEo2yF3s7o68JHsrwfXLbe6IDutRjbWKi6xQC7+rg/VIQIh6hp08COxBJE
	 O7StrlWXn9SZTWHd1xqFxacYbTcEyb0Si1+ik5spwltgzTmrdeDI+CKJIaQX6L7QHDaZ9
	 z3pwje8FkWxGf5Cyj5PoJeVfE7QbSIbkU9AKSYXw6m/JZ8mIlDj225j7NdFTRSCAP4L8U
	 HB49OMmIOe0muqDmJS+KfgmdmhNFeIxM7Y0FDJ4lzU6uvEV1KYVvRb/xSqwl0k5T/0iZz
	 B76z1l2xgLBU2xwekBx7Sv0bzdACNmDIdow1P+5AZnBpVzyjknsV4aUm5Uh0JMp0hUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882695;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition;
	bh=EN58icMFCpbcVLH6YKbY/a+m/VHBVy+6pu1Ggzd7pvo=;
	b=EwK6+ndqLoOlTG0WVhxy9/7/0OY1Uic6QKELgJ0+2s1aLILc9/oMHmC3zrTo+kqsE3MU
	 9sLvy0j3d8tPxhVnpQIa8HD0RUazSH9ucmls7tnvxX1W4yQQS5wQVSTpxw4BQ93C3CvnO
	 +sfEVLLj8YzWu7cLqPinuUgWPhiFWTE0XZEcnqdIc06PcHQ7+fycKLseSEcOdtOYvjR82
	 58AQsBZTvDHT3T1nDRbg0tM7IAqXu75zHtbATko3sNrfwFMGJjr+zTAkodqxvIbbby8Jy
	 CDOWRrVnPL5YVinWYsrUzetzmsKD0+TA1LCmxCjNZWlm9W554QnP84q5OH412eAkDfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J6+5Jcub;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E099D606A326;
	Thu,  5 Nov 2026 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J6+5Jcub
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191831F000C1;
	Thu,  5 Nov 2026 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882694;
	bh=EN58icMFCpbcVLH6YKbY/a+m/VHBVy+6pu1Ggzd7pvo=;
	h=Date:From:To:Cc:Subject;
	b=J6+5JcubBALvPUrzdrPf7+R0a9S1DLd9B9DjYk0DtTAR1REeJL+WecF2jhOZwQ6Cl
	 raG9mDucYtphh2EFJQnxex9vFIX+R8L7Ehx5Q+m+07xdKACa8vqF8WNj4j07z/w4CN
	 C+GSJzEFT9+d8tySRlnwJybXDG4iTk4j4klX76a1rd5JjvuI7LqxW4D8z/cufweYGj
	 +j8tDQe0TEIexYkYmO7JPJ/RA5Ah8WrK7FAJv1JU+fF8XItJcHPgfhdi2pD9o95IqV
	 zxftZFGHg6S2GhksRqXNUdBN7ARciL8uM+NiQXDuI/T0u/NXKl6mOXHY1IGrpLNZSL
	 SyBpF8Mu9Rcpg==
Date: Thu, 5 Nov 2026 12:44:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Aditya Garg <aditya.garg@linux.dev>, David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Jason Perlow <jperlow@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Michael Reeves <michael.reeves077@gmail.com>,
	Networking <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the wireless-next tree with the net tree
Message-ID: <aux6QaenW3Eqb3vu@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Aditya Garg <aditya.garg@linux.dev>,
	David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Jason Perlow <jperlow@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Michael Reeves <michael.reeves077@gmail.com>,
	Networking <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IKYemmpn/JXyMcDm"
Content-Disposition: inline


--IKYemmpn/JXyMcDm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got a conflict in:

  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c

between commit:

  7ed5dce55fa83 ("wifi: brcmfmac: map msgbuf RX packet IDs bidirectional")

=66rom the net tree and commit:

  09063ccd75da0 ("wifi: brcmfmac: Add BCM4388 support")

=66rom the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --combined drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index ff47d4827722e,5ad46d7ec663f..0000000000000
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@@ -12,6 -12,7 +12,7 @@@
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
 =20
+ #include <brcm_hw_ids.h>
  #include <brcmu_utils.h>
  #include <brcmu_wifi.h>
 =20
@@@ -47,9 -48,11 +48,11 @@@
  #define MSGBUF_TYPE_RX_CMPLT			0x12
  #define MSGBUF_TYPE_LPBK_DMAXFER		0x13
  #define MSGBUF_TYPE_LPBK_DMAXFER_CMPLT		0x14
+ #define MSGBUF_TYPE_H2D_MAILBOX_DATA		0x23
+ #define MSGBUF_TYPE_D2H_MAILBOX_DATA		0x24
 =20
  #define NR_TX_PKTIDS				2048
- #define NR_RX_PKTIDS				1024
+ #define NR_RX_PKTIDS				2048
 =20
  #define BRCMF_IOCTL_REQ_PKTID			0xFFFE
 =20
@@@ -218,6 -221,19 +221,19 @@@ struct msgbuf_flowring_flush_resp=20
  	__le32				rsvd0[3];
  };
 =20
+ struct msgbuf_h2d_mailbox_data {
+ 	struct msgbuf_common_hdr	msg;
+ 	__le32				data;
+ 	__le32				rsvd0[7];
+ };
+=20
+ struct msgbuf_d2h_mailbox_data {
+ 	struct msgbuf_common_hdr	msg;
+ 	struct msgbuf_completion_hdr	compl_hdr;
+ 	__le32				data;
+ 	__le32				rsvd0[2];
+ };
+=20
  struct brcmf_msgbuf_work_item {
  	struct list_head queue;
  	u32 flowid;
@@@ -315,7 -331,6 +331,6 @@@ brcmf_msgbuf_init_pktids(u32 nr_array_e
  	return pktids;
  }
 =20
-=20
  static int
  brcmf_msgbuf_alloc_pktid(struct device *dev,
  			 struct brcmf_msgbuf_pktids *pktids,
@@@ -1319,6 -1334,15 +1334,15 @@@ brcmf_msgbuf_process_flow_ring_delete_r
  	brcmf_msgbuf_remove_flowring(msgbuf, flowid);
  }
 =20
+ static void brcmf_msgbuf_process_d2h_mailbox_data(struct brcmf_msgbuf *ms=
gbuf,
+ 						  void *buf)
+ {
+ 	struct msgbuf_d2h_mailbox_data *d2h_mb_data =3D buf;
+=20
+ 	brcmf_bus_d2h_mb_rx(msgbuf->drvr->bus_if,
+ 			    le32_to_cpu(d2h_mb_data->data));
+ }
+=20
 =20
  static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, voi=
d *buf)
  {
@@@ -1362,6 -1386,10 +1386,10 @@@
  		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_RX_CMPLT\n");
  		brcmf_msgbuf_process_rx_complete(msgbuf, buf);
  		break;
+ 	case MSGBUF_TYPE_D2H_MAILBOX_DATA:
+ 		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_D2H_MAILBOX_DATA\n");
+ 		brcmf_msgbuf_process_d2h_mailbox_data(msgbuf, buf);
+ 		break;
  	default:
  		bphy_err(drvr, "Unsupported msgtype %d\n", msg->msgtype);
  		break;
@@@ -1500,6 -1528,35 +1528,35 @@@ void brcmf_msgbuf_delete_flowring(struc
  	}
  }
 =20
+ int brcmf_msgbuf_h2d_mb_write(struct brcmf_pub *drvr, u32 data)
+ {
+ 	struct brcmf_msgbuf *msgbuf =3D (struct brcmf_msgbuf *)drvr->proto->pd;
+ 	struct brcmf_commonring *commonring;
+ 	struct msgbuf_h2d_mailbox_data *request;
+ 	void *ret_ptr;
+ 	int err;
+=20
+ 	commonring =3D msgbuf->commonrings[BRCMF_H2D_MSGRING_CONTROL_SUBMIT];
+ 	brcmf_commonring_lock(commonring);
+ 	ret_ptr =3D brcmf_commonring_reserve_for_write(commonring);
+ 	if (!ret_ptr) {
+ 		bphy_err(drvr, "Failed to reserve space in commonring\n");
+ 		brcmf_commonring_unlock(commonring);
+ 		return -ENOMEM;
+ 	}
+=20
+ 	request =3D (struct msgbuf_h2d_mailbox_data *)ret_ptr;
+ 	memset(request, 0, sizeof(*request));
+ 	request->msg.msgtype =3D MSGBUF_TYPE_H2D_MAILBOX_DATA;
+ 	request->msg.ifidx =3D 0xff;
+ 	request->data =3D cpu_to_le32(data);
+=20
+ 	err =3D brcmf_commonring_write_complete(commonring);
+ 	brcmf_commonring_unlock(commonring);
+=20
+ 	return err;
+ }
+=20
  #ifdef DEBUG
  static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
  {
@@@ -1638,8 -1695,10 +1695,8 @@@ int brcmf_proto_msgbuf_attach(struct br
  						     DMA_TO_DEVICE);
  	if (!msgbuf->tx_pktids)
  		goto fail;
 -	/* BCM4388 firmware also reads from posted RX buffers. */
  	msgbuf->rx_pktids =3D brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
 -			drvr->bus_if->chip =3D=3D BRCM_CC_4388_CHIP_ID ?
 -			DMA_BIDIRECTIONAL : DMA_FROM_DEVICE);
 +						     DMA_BIDIRECTIONAL);
  	if (!msgbuf->rx_pktids)
  		goto fail;
 =20

--IKYemmpn/JXyMcDm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrsekAACgkQJNaLcl1U
h9CExgf/U7n395A/1Og2jsPGJ/6oSYaK2Pefz9mRtyHE1To3P2n64rDEkQAaS/sy
V0Kv0ldqEb5UfneN4cnfEUgIrMzsnQ8jUXq/tFEFxZJwubV0U/PUUnliGXNrYdwE
cihRmJS7KuaQxAIuSsEaCaMZn3yGxUE0zvgBg4tJIyfI4Gs3rQdfkwN9yV0rh1hj
Ce0vUzpIaTmyu0sQ1epVMTL/5RnIKtROk0PnJBKFfZf6vHZGR55dFY9GQXJA/gqb
XJzUpdLNJJeteD1Rn+8fwythv8vyj4x7VsgpIzU2fXkD7SzlSy8gBHv/duZHWFWQ
S8bdwMVTgsVFzHhDZ1TJcV50+i1VrA==
=+e1x
-----END PGP SIGNATURE-----

--IKYemmpn/JXyMcDm--

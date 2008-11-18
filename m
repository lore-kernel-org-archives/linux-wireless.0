Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYKRJoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 04:44:08 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1226969241.4014.24.camel@johannes.berg> (sfid-20081118_014839_339263_738F563C)
References: <1226969241.4014.24.camel@johannes.berg>
	 (sfid-20081118_014839_339263_738F563C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XNd11//xdxXT0BJ1WtZF"
Date: Tue, 18 Nov 2008 10:43:10 +0100
Message-Id: <1227001390.4014.43.camel@johannes.berg> (sfid-20081118_104414_757666_6D9EAAD7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XNd11//xdxXT0BJ1WtZF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-18 at 01:47 +0100, Johannes Berg wrote:

> So I dug deeper into the DMA problems I had with iwlagn and a kind soul
> helped me in that he said something about pci-e alignment and mentioned
> the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
> something the device would fail with

Come to think of it, maybe it does. One common failure case seems to be
"this goes wrong with an 11n AP, but not on a regular one", so one
explanation for that would be that the hardware designers expect the
driver to split up the DMA into multiple DMA descriptors at 4K
boundaries, but iwlagn uses only one and undefined behaviour results.
That's something you'll need to ask the HW designers though or look up
in the datasheet.

johannes

--=-XNd11//xdxXT0BJ1WtZF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIo4qAAoJEKVg1VMiehFYFg4P/2xrZbYEqRjL2fWamMJ/dqhf
KTa6pt1i7Xe4DZkSbsQQoVOsDgV9aoKJdQQKil24Ih8n18E1ZwgrRT88QU9reLrg
e+bWm4e7+WwilSPASkU+S5rsDumIqVtD1nlte1Q9yb5lnNn2wg6wySRzv9Bha5ak
JziZOV47CaWPQYGOVszhYHx6iRCiRU0O9p51M9jTJWNY+OoSQZrnm2UMfSEhqZAP
chY3iXPNeuD/2VnR24HXTt8GejA0kSF24r48U+QbfuJNDmo6ARgOTWc2HUEX60P7
jS3aIL3CPJEMuT31Ggdzt0qbqtbWhKQt44/l3R88fq/BvuN0zRSfTidzyx/j9XXP
gsrcSqtTfFVSHj2CxFIxxe8orXscZpwaPHeIU9jZOz42zUkSu33aMijM05xa4mI0
ff+LA+MlvVNxcuBZuet6esamnoInq08vvmp7j7uIs2w2rMORmGfWdCm7aw1qALY9
qzMxqO5jLFf2bZpHc6MQCTzLyaziwT63KZSDH/VGMIe6bBn5lKO0wz7qF4tVxiun
QdLl5rJm43P4hWXuhS+td/DQO1QnCEJJtKo83mSVHM0YaBB/PHCr7DzqwvJdsvAH
erXfThFiRDBNCpbboLWlI8SukgXHop/VG202Ub4AsKXI5C3C7kMAGvEdAwAMbvch
Yo2GMFGdtk65ROJZMfdu
=Rmm2
-----END PGP SIGNATURE-----

--=-XNd11//xdxXT0BJ1WtZF--


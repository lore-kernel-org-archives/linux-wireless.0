Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49911 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcIMIA1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 04:00:27 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless@vger.kernel.org, openwrt-devel@lists.openwrt.org
Subject: ath10k mesh + ap + encryption?
Date: Tue, 13 Sep 2016 10:00:23 +0200
Message-ID: <2661831.slnB0LOeVt@prime> (sfid-20160913_100031_115472_95D88069)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2710731.drYDR8OaOf"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2710731.drYDR8OaOf
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

we have done some experiments last week on ath10k, trying to run mesh 
(802.11s) and access point at the same time, both encrypted. 

We have tested a recent LEDE (reboot-1519-g42f559e) but with 
firmware-5.bin_10.2.4.70.42-2 and the included wpa_supplicant, which gave us a 
working encrypted 802.11s network. However, starting an AP at the same time 
didn't work (AP doesn't beacon). This wasn't a problem when 802.11s was 
running unencrypted.

We also tested version 10.2.4.97 (from codeaurora), which is now default in 
LEDE. However, this version apparently doesn't support 11s mesh at all 
(WMI_SERVICE_MESH_11S is disabled in the service map, but cfg/mac80211 
advertises support).

So here are my questions:

 * Did anyone succesfully run AP and mesh, both encrypted at the same time?
 * Do you have any pointers how we could fix this? Could it be fixable in the 
driver (i.e. not in firmware)?
 * Does anyone have an idea if 11s will be supported in future versions? I 
didn't find any changelogs, but having 11s mode no longer in the service map 
does not make me optimistic.

Thanks,
     Simon
--nextPart2710731.drYDR8OaOf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX17IXAAoJEKEr45hCkp6hbIcP/1T+Yn07JHjdEPr4cAsnYg+y
5ExVAd/1XGdb0SusbJSyALTawRKQtR/WDxolAclVr2SoV+7SucswDuIszO/y0XnI
3hEmi41Npuri4bkl2a5EE/3N8jYeJrMT8doOERtoaI/qh3r/Ja2iIwqFau9IhAPp
XYAwAF3j40Fal8Vba09IIzLfNRjiN8PWcHQbry/VlcnV6mDBWZTXvNT1z64BtNJq
mQqk8Sh+vA7iYlINwK5Wg3Fqh7S6P9ciQDUWDUdsN864XGoYfFpP9Y/dSv6MAaZ2
6rtYgjJqp0GwQee2k3Nq5Yg2wbGDVxoEmbm6I35R7yU8rrHw38FCJftZLShCTIw+
XIId5LD9aXBV2lOcMor74dT2nPGsCNC4wignVrmfFu60n5cHIXNE9FbAfXTkEmUf
4RWudNn2NDE+/jY40Pi4tGlFkX8kp4zAsw+wqjtH/wqUSKXNabJXKUU8MRM5rmCo
S0k/TE353QDFoD/h+U2VplYn6NIeOGY+ScoBL15yQ6H41Acmb9+PS0HtEpUECnBT
dnelxtZV45jr+2zvWLtHzvC8MKNIAByHDqrCepTYPXqeWfDsneyKgB8qL/iOjN1n
5fGU3Da9/azd/8lc+lgSOqL7g96UwZlkCaIirin6L7yfTWNUbCKytI99iXYFVGHU
mCUn2ateO3H+Imjjl6s9
=5+kd
-----END PGP SIGNATURE-----

--nextPart2710731.drYDR8OaOf--

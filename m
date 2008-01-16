Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYAPPqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 10:46:47 -0500
Subject: Re: [PATCH 04/12] iwlwifi: document scan command
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1200361585-31801-5-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022705_457944_D9860755)
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080115_022705_457944_D9860755)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jzWdeb2BhL8tYPWZCIr/"
Date: Wed, 16 Jan 2008 01:02:52 +0100
Message-Id: <1200441772.5887.167.camel@johannes.berg> (sfid-20080116_154710_301404_60368D87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jzWdeb2BhL8tYPWZCIr/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +/**
> + * struct iwl3945_scan_channel - entry in REPLY_SCAN_CMD channel table
> + *
> + * One for each channel in the scan list.
> + * Each channel can independently select:
> + * 1)  SSID for directed active scans
> + * 2)  Txpower setting (for rate specified within Tx command)
> + * 3)  How long to stay on-channel (behavior may be modified by quiet_ti=
me,
> + *     quiet_plcp_th, good_CRC_th)

This reminds me. How did you arrive at the dwell time? With hostapd
running on b43 I've frequently seen the dwell time being too low:

iwl4965 will transmit a probe request and go to the next channel before
hostapd sends the probe response, iwl4965 still sees the response, but
the b43 card never sees the ACK because it's receiver isn't quite as
good as the iwl4965 receiver.

Are there any restrictions in IEEE 802.11 on how fast probe responses
must be transmitted?

johannes

--=-jzWdeb2BhL8tYPWZCIr/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR41JqqVg1VMiehFYAQK5JQ/9FW/NRz/DwPsKb/feS6S/EzWPJBZh7/rz
iVzrVcRDKVTDyBapHXEsvwHDgQqtb2uWflwy6nJEJ88KzT5BbfYXMsbbTk+02s6W
KcMLDQR07cmDQGRPgES8fOTtzR/sDGmLbE18h3q8m8nfoimD8JdMqAEEiJeHfZfV
2Kv36FCZk/k3FSK5Mcg3qD5n9Maas2cq6UO7vogwl+FssCif1j3kkNkRngRT0Bg6
LkqyEbjIf7JcfRaEWvPrLYdwTGF81b5lRt1F3GWOQvF1eVPom/VuAn6ivlZu57lW
FPjAINNgfYEKHoiRN0YNCLJVXay+knhVyY7jRefAfP0ss6zoRTpyI+U+kW/MOJJi
NglOu1wfO/cfmawmPiPp/hMvUP/Kg+zCJK4di2yBx34C2PyB8uRm0UgHKtMLSO5s
mD9XN6gDCBITC6w1I5oBOBisd7QrbE+G5QDIAyK7XzgANadIJvqIgmW32/eAGc45
c/ORFDPb/Yh3ucdIi96An2UJ2Rvs5R3ruYPUEh8NmMxo/f34C9vZpXnHm8GNGsg+
hCkgufBMV8Jxj5PEsmbuS13VEXWKuYhDlM5bzoap+dLm/oh75RAF4dz2EGG1X2Fs
w10hzXSnt9H256eYkB7oSkmYSmPBKG0COFDNHBoBq0OS1wA0ug4irLsei3fRwEQb
OGdTR5/B598=
=eb4M
-----END PGP SIGNATURE-----

--=-jzWdeb2BhL8tYPWZCIr/--


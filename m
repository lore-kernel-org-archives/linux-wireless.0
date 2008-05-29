Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYE2JjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 05:39:01 -0400
Subject: Re: [PATCH 38/43] mac80211: allow disable FAT in specific
	configurations
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1212050128-17132-39-git-send-email-yi.zhu@intel.com> (sfid-20080529_103809_959161_C421771F)
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 (sfid-20080529_103809_959161_C421771F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2nSt5aN39Sbfj9IpZ4wG"
Date: Thu, 29 May 2008 11:37:50 +0200
Message-Id: <1212053870.16917.39.camel@johannes.berg> (sfid-20080529_113906_068034_011D3E47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2nSt5aN39Sbfj9IpZ4wG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 16:35 +0800, Zhu Yi wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch allows to disable FAT channel in specific configurations.
>=20
> For example the configuration (8, +1), (primary channel 8, extension
> channel 12) isn't permitted in U.S., but (8, -1), (primary channel 8,
> extension channel 4) is. When FAT channel configuration is not
> permitted, FAT channel should be reported as not supported in the
> capabilities of the HT IE in association request. And sssociation is
> performed on 20Mhz channel.

Can you explain more in detail the underlying regulatory rules?

It seems to me that (12, -1) would be pretty much the same as (8, +1) as
far as regulatory is concerned. I'm just thinking about how we should
express this in the regulatory database where we're not really concerned
with channels but rather allowed bands.

johannes

--=-2nSt5aN39Sbfj9IpZ4wG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD55baVg1VMiehFYAQJckxAAomcjmvRLN+S5HT5eVOrQjfproTD8PT0P
QI76kosi0QHUmpfufemVkOXQym08Qoz0TJZIA7HuO0quXzv0TKFhCnnY6G73wSLZ
ppTTKjJXGPc6NcN0W7l0b5yphY6jKnDDS8SKt1kQr/Eue5l06H3h3ZhuCijUzEFK
WL/BVh9lsQGdDVEQE47JWXe4ANCuq6rure/ZZWYrjShKwWFhFa6Bj5MyKAp24HNH
ZIy/KDvBG3CSwXzxeAlM60jLQVm4HYmAoHrUvKD/2vOcKH6g3n3OspAc1sDLQtMt
TZTyLgHULSrAYQP0ku2u5XkdYNi65RFtXx7MKJPpa6kd6/FuBObeG3VAxYE42429
3K59u1N7TJenrN5NzsL3UdyApE661hMSIaJbAN/l5bfwX1ffrIoj4IW62Pp/StE9
NTm55Evei7xfADQnxyU4Clm20jDUbXye+cGsap6jj7q0tV4DZ/k8mKq/inXDT3SV
d2wjGSUXThygKFcWceBnLIKcGZb3hATdqZJpF9X0aRowz3EaDuhjoLaol8MC53BQ
rslym8HHbf2BQ6BFMKChnNmKC//67ZboOpoK+EAi5S9oO7uJX1vC0kbDHIrBAJDO
iUiMES1lOgPT8RLy0RNPClXp19RwO1PBIU0zVs+HTJnXqF9LMYe1ZstV7/njlxo9
Ge+cuLfKcCY=
=t1kJ
-----END PGP SIGNATURE-----

--=-2nSt5aN39Sbfj9IpZ4wG--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYDAL6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:58:39 -0400
Subject: Re: [PATCH 2/2] mac80211: use a struct for bss->mesh_config
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <47f189d5.1e048e0a.3419.296b@mx.google.com> (sfid-20080401_020320_362378_5324E41A)
References: <47f189d5.1e048e0a.3419.296b@mx.google.com>
	 (sfid-20080401_020320_362378_5324E41A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0jv1kGInxzvWsIeI/FX7"
Date: Tue, 01 Apr 2008 13:58:32 +0200
Message-Id: <1207051112.5143.48.camel@johannes.berg> (sfid-20080401_125847_082761_95FB1965)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0jv1kGInxzvWsIeI/FX7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 17:39 -0700, Luis Carlos Cobo wrote:
> This allows cleaner code when accesing bss->mesh_config components.
>=20
> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>

Looks good to me.

> ---
>  net/mac80211/ieee80211_i.h   |   13 +++++++++++--
>  net/mac80211/ieee80211_sta.c |   32 ++++++++++++++++++++------------
>  net/mac80211/mesh.c          |    4 ----
>  net/mac80211/mesh.h          |   10 ++++++++++
>  4 files changed, 41 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 7ab8066..69e2bc5 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -69,6 +69,14 @@ struct ieee80211_fragment_entry {
>  	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
>  };
> =20
> +struct bss_mesh_config {
> +	u32 path_proto_id;
> +	u32 path_metric_id;
> +	u32 cong_control_id;
> +	u32 channel_precedence;
> +	u8 mesh_version;
> +};
> +
> =20
>  struct ieee80211_sta_bss {
>  	struct list_head list;
> @@ -94,7 +102,7 @@ struct ieee80211_sta_bss {
>  #ifdef CONFIG_MAC80211_MESH
>  	u8 *mesh_id;
>  	size_t mesh_id_len;
> -	u8 *mesh_cfg;
> +	struct bss_mesh_config *mesh_cfg;
>  #endif
>  #define IEEE80211_MAX_SUPP_RATES 32
>  	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
> @@ -113,7 +121,8 @@ struct ieee80211_sta_bss {
>  	u8 erp_value;
>  };
> =20
> -static inline u8 *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
> +static inline
> +struct bss_mesh_config *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
>  {
>  #ifdef CONFIG_MAC80211_MESH
>  	return bss->mesh_cfg;
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index feec201..fbe2da9 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -27,6 +27,7 @@
>  #include <linux/rtnetlink.h>
>  #include <net/iw_handler.h>
>  #include <asm/types.h>
> +#include <asm/unaligned.h>
> =20
>  #include <net/mac80211.h>
>  #include "ieee80211_i.h"
> @@ -2126,6 +2127,11 @@ ieee80211_rx_bss_get(struct net_device *dev, u8 *b=
ssid, int freq,
>  }
> =20
>  #ifdef CONFIG_MAC80211_MESH
> +static inline u32 bss_mesh_cfg_get(u8 *mesh_cfg, u8 offset)
> +{
> +	return be32_to_cpu(get_unaligned((__be32 *) (mesh_cfg + offset)));
> +}
> +
>  static struct ieee80211_sta_bss *
>  ieee80211_rx_mesh_bss_get(struct net_device *dev, u8 *mesh_id, int mesh_=
id_len,
>  			  u8 *mesh_cfg, int freq)
> @@ -2165,7 +2171,7 @@ ieee80211_rx_mesh_bss_add(struct net_device *dev, u=
8 *mesh_id, int mesh_id_len,
>  	if (!bss)
>  		return NULL;
> =20
> -	bss->mesh_cfg =3D kmalloc(MESH_CFG_CMP_LEN, GFP_ATOMIC);
> +	bss->mesh_cfg =3D kmalloc(sizeof(struct bss_mesh_config), GFP_ATOMIC);
>  	if (!bss->mesh_cfg) {
>  		kfree(bss);
>  		return NULL;
> @@ -2183,7 +2189,12 @@ ieee80211_rx_mesh_bss_add(struct net_device *dev, =
u8 *mesh_id, int mesh_id_len,
> =20
>  	atomic_inc(&bss->users);
>  	atomic_inc(&bss->users);
> -	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
> +	bss->mesh_cfg->mesh_version =3D mesh_cfg[0];
> +	bss->mesh_cfg->path_proto_id =3D bss_mesh_cfg_get(mesh_cfg, PP_OFFSET);
> +	bss->mesh_cfg->path_metric_id =3D bss_mesh_cfg_get(mesh_cfg, PM_OFFSET)=
;
> +	bss->mesh_cfg->cong_control_id =3D bss_mesh_cfg_get(mesh_cfg, CC_OFFSET=
);
> +	bss->mesh_cfg->channel_precedence =3D bss_mesh_cfg_get(mesh_cfg,
> +							     CP_OFFSET);
>  	bss->mesh_id_len =3D mesh_id_len;
>  	bss->freq =3D freq;
>  	spin_lock_bh(&local->sta_bss_lock);
> @@ -4059,36 +4070,33 @@ ieee80211_sta_scan_result(struct net_device *dev,
> =20
>  	if (bss_mesh_cfg(bss)) {
>  		char *buf;
> -		u8 *cfg =3D bss_mesh_cfg(bss);
> +		struct bss_mesh_config *cfg =3D bss_mesh_cfg(bss);
>  		buf =3D kmalloc(50, GFP_ATOMIC);
>  		if (buf) {
>  			memset(&iwe, 0, sizeof(iwe));
>  			iwe.cmd =3D IWEVCUSTOM;
> -			sprintf(buf, "Mesh network (version %d)", cfg[0]);
> +			sprintf(buf, "Mesh network (version %d)",
> +				cfg->mesh_version);
>  			iwe.u.data.length =3D strlen(buf);
>  			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
>  							  &iwe, buf);
>  			sprintf(buf, "Path Selection Protocol ID: "
> -				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
> -							cfg[4]);
> +				"0x%08X", cfg->path_proto_id);
>  			iwe.u.data.length =3D strlen(buf);
>  			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
>  							  &iwe, buf);
>  			sprintf(buf, "Path Selection Metric ID: "
> -				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
> -							cfg[8]);
> +				"0x%08X", cfg->path_metric_id);
>  			iwe.u.data.length =3D strlen(buf);
>  			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
>  							  &iwe, buf);
>  			sprintf(buf, "Congestion Control Mode ID: "
> -				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
> -							cfg[11], cfg[12]);
> +				"0x%08X", cfg->cong_control_id);
>  			iwe.u.data.length =3D strlen(buf);
>  			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
>  							  &iwe, buf);
>  			sprintf(buf, "Channel Precedence: "
> -				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
> -							cfg[15], cfg[16]);
> +				"0x%08X", cfg->channel_precedence);
>  			iwe.u.data.length =3D strlen(buf);
>  			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
>  							  &iwe, buf);
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 594a335..b10f1e5 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -11,10 +11,6 @@
>  #include "ieee80211_i.h"
>  #include "mesh.h"
> =20
> -#define PP_OFFSET 	1		/* Path Selection Protocol */
> -#define PM_OFFSET	5		/* Path Selection Metric   */
> -#define CC_OFFSET	9		/* Congestion Control Mode */
> -#define CAPAB_OFFSET 17
>  #define ACCEPT_PLINKS 0x80
> =20
>  int mesh_allocated;
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index 742003d..8ff46ea 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -157,6 +157,16 @@ struct mesh_rmc {
>   */
>  #define MESH_CFG_CMP_LEN 	17
> =20
> +/*
> + * Components offset within the mesh configuration IE
> + */
> +#define PP_OFFSET	1		/* Path Selection Protocol */
> +#define PM_OFFSET	5		/* Path Selection Metric   */
> +#define CC_OFFSET	9		/* Congestion Control Mode */
> +#define CP_OFFSET	13		/* Channel Precedence */
> +#define CAPAB_OFFSET	17		/* Mesh Capabilities */
> +
> +
>  /* Default values, timeouts in ms */
>  #define MESH_TTL 		5
>  #define MESH_MAX_RETR	 	3

--=-0jv1kGInxzvWsIeI/FX7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IjZ6Vg1VMiehFYAQK4ZBAAmjce6TdEdEsRS0tKpfxciyWmRoMP9MeW
HiqyfsCVb5VtPOQDN2bA4r4GtnWTyl+EABZnTHWspzr50jssCOgUWWx9M2vJ2OX2
WglMwqZ768yHyy/wWV5piBMBKUOxUjUN1vkQbFzjy4f5BDTBicDXP3x+1q1nGUAR
+ZVj5muacB8HkXrsaX76huIhv7K1plfquIAhpbwxLcOc/hnD3ZJxMVH9Do/cZHVl
KWx9urjLArySvv+kXemFCLfPGMmznwKuY0D1HN0Gr5cngwxv3VRPnuRTevJ3tZ32
EMjylTRMCw6Z2wYk3vVuY3Uoh8lrp7bPd9yRqGidsgYrIWHENVcLnam2BDxHGHHN
U/2r6jeFKOaQiXBWPO+aOjP/p6cJvgQyLk+DH6qJVkbGMm9tnhJvNhv+rM//LdLG
TSh0VwneUu5R52TmQVCzFX0sRJ81sVreOhzfdFEKfm4bkPVPFodrwl0nut0VrCQf
+eyTQCxYuujVoZGiwCebJIDSddppOZZJctAcPeMeYiiUyCIIybdhd31p232Mitna
fNVXDkmKM5/k/SRi0RCVuJFt3MOaaT5Xijc+DPB+jO6ZR9UVt8ZKytrVG+oHMGqr
lsp5dMcidcqDsrGt92C1GXdP2SG/pFsOrU2Rdlm/PN5R8TK85Bbdc2yzS56QTqP3
c72s13rwxQE=
=5Joz
-----END PGP SIGNATURE-----

--=-0jv1kGInxzvWsIeI/FX7--


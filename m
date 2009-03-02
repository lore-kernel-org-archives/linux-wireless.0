Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:53930 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZCBVWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 16:22:32 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2904108wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 13:22:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49A88FF8.1040607@erley.org>
References: <49A88FF8.1040607@erley.org>
Date: Mon, 2 Mar 2009 13:22:30 -0800
Message-ID: <43e72e890903021322n2005bf79jda8df4497498d5a6@mail.gmail.com> (sfid-20090302_223006_587770_1CC61729)
Subject: Re: [patch] Update compat.diff
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2009 at 5:14 PM, pat-lkml <pat-lkml@erley.org> wrote:
> This updates compat.diff for wireless-testing commit
> 68a4ef439847ed4bc07f17d398fe06c34f15d5da
>
> Signed-off-by: Pat Erley<pat-lkml@erley.org>

Thanks applied, now just waiting for git pull to finish on wireless.ker=
nel.org.

  Luis
> ---
> diff --git a/compat/compat.diff b/compat/compat.diff
> index ce98e63..7d37ce7 100644
> --- a/compat/compat.diff
> +++ b/compat/compat.diff
> @@ -440,64 +440,35 @@ index a0c860f..9c6f214 100644
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ops;
> =C2=A0}
> -diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> -index c157d60..40f86df 100644
> ---- a/net/wireless/nl80211.c
> -+++ b/net/wireless/nl80211.c
> -@@ -21,6 +21,7 @@
> - #include "nl80211.h"
> - #include "reg.h"
> -
> -+#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,30))
> - static int nl80211_lock_doit(struct sk_buff *skb, struct genl_info =
*info)
> - {
> - =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> -@@ -38,6 +39,7 @@
> - =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> - }
> -
> -+#endif
> - /* the netlink family */
> - static struct genl_family nl80211_fam =3D {
> - =C2=A0 =C2=A0 =C2=A0 .id =3D GENL_ID_GENERATE, /* don't bother with=
 a hardcoded ID */
> -@@ -45,10 +47,12 @@
> - =C2=A0 =C2=A0 =C2=A0 .hdrsize =3D 0, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* no private header */
> - =C2=A0 =C2=A0 =C2=A0 .version =3D 1, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* no particular meaning now */
> - =C2=A0 =C2=A0 =C2=A0 .maxattr =3D NL80211_ATTR_MAX,
> -+#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,30))
> - =C2=A0 =C2=A0 =C2=A0 .pre_doit =3D nl80211_lock_doit,
> - =C2=A0 =C2=A0 =C2=A0 .pre_dumpit =3D nl80211_lock_dumpit,
> - =C2=A0 =C2=A0 =C2=A0 .post_doit =3D nl80211_unlock,
> - =C2=A0 =C2=A0 =C2=A0 .post_dumpit =3D nl80211_unlock,
> -+#endif
> - };
> -
> - /* internal helper: get drv and dev */
> -@@ -637,12 +641,18 @@
> +--- wireless-testing/net/wireless/nl80211.c =C2=A0 =C2=A02009-02-27 =
18:27:32.000000000 -0500
> ++++ compat-wireless-2.6/net/wireless/nl80211.c 2009-02-27 19:51:08.0=
00000000 -0500
> +@@ -614,15 +614,17 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0flags =3D &_flags;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0+#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_virtual_intf(&drv=
->wiphy, ifindex,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0type, flags, &params);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dev =3D __dev_get_by_index(&init_net, ifin=
dex);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(!dev || (!err && dev->ieee80211_pt=
r->iftype !=3D type));
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#endif
> =C2=A0 unlock:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
> -@@ -683,12 +693,18 @@
> +@@ -662,16 +664,18 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 params.mesh_id =3D=
 nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0params.mesh_id=
_len =3D nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0+#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D parse_monitor_flags(type =3D=3D NL=
80211_IFTYPE_MONITOR ?
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info->attrs[NL80211_AT=
TR_MNTR_FLAGS] : NULL,
> @@ -506,117 +477,131 @@ index c157d60..40f86df 100644
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nla_data(info-=
>attrs[NL80211_ATTR_IFNAME]),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0type, err ? NU=
LL : &flags, &params);
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#endif
>
> =C2=A0 unlock:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -712,7 +728,13 @@
> +@@ -694,11 +698,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_virtual_intf(&drv->wiphy=
, ifindex);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_virtual_intf(&drv->w=
iphy, ifindex);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_virtual_intf(&drv->wiphy=
, ifindex);
> =C2=A0+#endif
> -
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -797,8 +819,15 @@
> + =C2=A0 =C2=A0 =C2=A0 return err;
> +@@ -782,11 +788,15 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mac_addr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NLA_PUT(msg, N=
L80211_ATTR_MAC, ETH_ALEN, mac_addr);
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_key(&drv->wiphy, dev=
, key_idx, mac_addr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&cookie, get_key_callback);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_key(&drv->wiphy, de=
v, key_idx, mac_addr,
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&cookie, get_key_callback);
> ++ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&cookie, get_key_callback)=
;
> =C2=A0+#endif
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> -@@ -858,7 +887,13 @@
> +
> +@@ -844,11 +854,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D func(&drv->wiphy, dev, key_idx);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D func(&drv->wiphy, dev, key_idx);
> =C2=A0+#endif
> -
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -941,7 +976,13 @@
> + =C2=A0 =C2=A0 =C2=A0 dev_put(dev);
> +@@ -929,10 +941,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_key(&drv->wiphy, dev, ke=
y_idx, mac_addr, &params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_key(&drv->wiphy, dev=
, key_idx, mac_addr, &params);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_key(&drv->wiphy, dev, ke=
y_idx, mac_addr, &params);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -975,7 +1016,13 @@
> +@@ -965,10 +980,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_key(&drv->wiphy, dev, ke=
y_idx, mac_addr);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_key(&drv->wiphy, dev=
, key_idx, mac_addr);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_key(&drv->wiphy, dev, ke=
y_idx, mac_addr);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1056,7 +1103,13 @@
> +@@ -1048,11 +1066,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EINVAL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D call(&drv->wiphy, dev, &params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D call(&drv->wiphy, dev, &params);
> =C2=A0+#endif
> -
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1079,7 +1132,13 @@
> + =C2=A0 =C2=A0 =C2=A0 dev_put(dev);
> +@@ -1073,11 +1093,13 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_beacon(&drv->wiphy, =
dev);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> +-
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_beacon(&drv->wiphy,=
 dev);
> =C2=A0+#endif
> -
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1264,13 +1323,20 @@
> + =C2=A0 =C2=A0 =C2=A0 dev_put(dev);
> +@@ -1260,16 +1282,20 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -ENOSYS;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> +-
> =C2=A0+#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D dev->o=
ps->dump_station(&dev->wiphy, netdev, sta_idx,
> @@ -625,288 +610,243 @@ index c157d60..40f86df 100644
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out_err_rtnl;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_err_rtnl;
> =C2=A0+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_err;
> ++ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out_err;
> =C2=A0+#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nl80211_se=
nd_station(skb,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NETLINK_CB(cb->skb).pid,
> -@@ -1286,6 +1352,10 @@
> +@@ -1285,8 +1311,10 @@
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cb->args[1] =3D sta_idx;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D skb->len;
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ out_err_rtnl:
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0out_err_rtnl:
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#endif
> =C2=A0 out_err:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(dev);
> =C2=A0 out_put_netdev:
> -@@ -1319,7 +1389,13 @@
> +@@ -1320,9 +1348,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_station(&drv->wiphy,=
 dev, mac_addr, &sinfo);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_station(&drv->wiphy=
, dev, mac_addr, &sinfo);
> =C2=A0+#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> -@@ -1421,7 +1497,13 @@
> +@@ -1424,9 +1456,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_station(&drv->wip=
hy, dev, mac_addr, &params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_station(&drv->wi=
phy, dev, mac_addr, &params);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (params.vlan)
> -@@ -1482,7 +1564,13 @@
> +@@ -1487,9 +1523,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_station(&drv->wiphy, dev=
, mac_addr, &params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_station(&drv->wiphy,=
 dev, mac_addr, &params);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_station(&drv->wiphy, dev=
, mac_addr, &params);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (params.vlan)
> -@@ -1511,7 +1599,13 @@
> +@@ -1518,9 +1558,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_station(&drv->wiphy, dev=
, mac_addr);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_station(&drv->wiphy,=
 dev, mac_addr);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_station(&drv->wiphy, dev=
, mac_addr);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1611,13 +1705,20 @@
> +@@ -1620,7 +1664,9 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0+#endif
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D dev->o=
ps->dump_mpath(&dev->wiphy, netdev, path_idx,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0dst, next_hop, &pinfo);
> +@@ -1628,7 +1674,11 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err =3D=3D=
 -ENOENT)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out_err_rtnl;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_err_rtnl;
> =C2=A0+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_err;
> ++ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out_err;
> =C2=A0+#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nl80211_se=
nd_mpath(skb, NETLINK_CB(cb->skb).pid,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cb->nlh=
->nlmsg_seq, NLM_F_MULTI,
> -@@ -1632,6 +1733,10 @@
> +@@ -1643,8 +1693,10 @@
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cb->args[1] =3D path_idx;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D skb->len;
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ out_err_rtnl:
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0out_err_rtnl:
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#endif
> =C2=A0 out_err:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(dev);
> =C2=A0 out_put_netdev:
> -@@ -1666,7 +1771,13 @@
> +@@ -1679,9 +1731,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mpath(&drv->wiphy, dev, =
dst, next_hop, &pinfo);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mpath(&drv->wiphy, d=
ev, dst, next_hop, &pinfo);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mpath(&drv->wiphy, dev, =
dst, next_hop, &pinfo);
> =C2=A0+#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> -@@ -1717,7 +1828,13 @@
> +@@ -1732,9 +1788,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_mpath(&drv->wiphy, de=
v, dst, next_hop);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_mpath(&drv->wiphy=
, dev, dst, next_hop);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_mpath(&drv->wiphy, de=
v, dst, next_hop);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1750,7 +1867,13 @@
> +@@ -1767,9 +1827,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_mpath(&drv->wiphy, dev, =
dst, next_hop);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_mpath(&drv->wiphy, d=
ev, dst, next_hop);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->add_mpath(&drv->wiphy, dev, =
dst, next_hop);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1777,7 +1900,13 @@
> +@@ -1796,9 +1860,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_mpath(&drv->wiphy, d=
ev, dst);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->del_mpath(&drv->wiphy, =
dev, dst);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1823,7 +1952,13 @@
> +@@ -1844,9 +1912,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_bss(&drv->wiphy, =
dev, &params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->change_bss(&drv->wiphy,=
 dev, &params);
> =C2=A0+#endif
>
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -1920,7 +2055,13 @@
> +@@ -1951,9 +2023,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get the mesh params */
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mesh_params(&drv->wiphy,=
 dev, &cur_params);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mesh_params(&drv->wi=
phy, dev, &cur_params);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->get_mesh_params(&drv->wiphy,=
 dev, &cur_params);
> =C2=A0+#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
>
> -@@ -2066,7 +2207,13 @@
> +@@ -2099,9 +2175,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0nla_get_u16);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Apply changes */
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> -+ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->set_mesh_params(&drv->wiphy,=
 dev, &cfg, mask);
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> -+#else
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->set_mesh_params(&drv->wi=
phy, dev, &cfg, mask);
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> ++#else
> ++ =C2=A0 =C2=A0 =C2=A0err =3D drv->ops->set_mesh_params(&drv->wiphy,=
 dev, &cfg, mask);
> =C2=A0+#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* cleanup */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
> -@@ -2241,9 +2388,15 @@
> - =C2=A0 =C2=A0 =C2=A0 if (err)
> +@@ -2277,9 +2357,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
>
> -- =C2=A0 =C2=A0 =C2=A0if (drv->ops->set_mgmt_extra_ie)
> -+ =C2=A0 =C2=A0 =C2=A0if (drv->ops->set_mgmt_extra_ie) {
> + =C2=A0 =C2=A0 =C2=A0 if (drv->ops->set_mgmt_extra_ie) {
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->o=
ps->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
> -- =C2=A0 =C2=A0 =C2=A0else
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#else
> =C2=A0+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D drv->=
ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
> =C2=A0+#endif
> -+ =C2=A0 =C2=A0 =C2=A0} else
> + =C2=A0 =C2=A0 =C2=A0 } else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -EOPNO=
TSUPP;
>
> - =C2=A0 =C2=A0 =C2=A0 cfg80211_put_dev(drv);
> -@@ -2275,9 +2428,16 @@
> +@@ -2311,9 +2395,9 @@
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EOPNOTSUP=
P;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> +-
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_lock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_lock();
> +-
> =C2=A0+#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (drv->scan_req) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -EBUSY=
;
> -+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unlock;
> -+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> -+#endif
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> - =C2=A0 =C2=A0 =C2=A0 if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]=
) {
> -@@ -2285,7 +2445,11 @@
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 n_channels++;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!n_channels) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 err =3D -EINVAL;
> -+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out_unlock;
> -+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> -+#endif
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (band =3D 0; b=
and < IEEE80211_NUM_BANDS; band++)
> -@@ -2299,7 +2463,11 @@
> -
> - =C2=A0 =C2=A0 =C2=A0 if (n_ssids > wiphy->max_scan_ssids) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EINVAL;
> -+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unlock;
> -+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> -+#endif
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> - =C2=A0 =C2=A0 =C2=A0 if (info->attrs[NL80211_ATTR_IE])
> -@@ -2313,7 +2481,11 @@
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 + ie_len, GFP_KERNEL);
> - =C2=A0 =C2=A0 =C2=A0 if (!request) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -ENOMEM;
> -+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unlock;
> -+#else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> -+#endif
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> - =C2=A0 =C2=A0 =C2=A0 request->channels =3D (void *)((char *)request=
 + sizeof(*request));
> -@@ -2384,6 +2556,10 @@
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drv->scan_req =3D =
NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_unlock;
> +@@ -2424,7 +2508,9 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(request)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0out_unlock:
> =C2=A0+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
> -+ out_unlock:
> -+ =C2=A0 =C2=A0 =C2=A0rtnl_unlock();
> + =C2=A0 =C2=A0 =C2=A0 rtnl_unlock();
> =C2=A0+#endif
> =C2=A0 out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_put_dev(drv);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

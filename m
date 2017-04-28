Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26296 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753896AbdD1KvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 06:51:24 -0400
From: "Mohammed Shafi Shajakhan (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: Julia Lawall <julia.lawall@lip6.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference (fwd)
Date: Fri, 28 Apr 2017 10:51:14 +0000
Message-ID: <1493376672264.91080@qti.qualcomm.com> (sfid-20170428_125154_889820_DB3FA8F4)
References: <alpine.DEB.2.20.1704281205580.3387@hadrien>
In-Reply-To: <alpine.DEB.2.20.1704281205580.3387@hadrien>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=0A=
Please check whether an unlock is missing on line 3009-3013.=0A=
=0A=
[shafi]  thanks Julia for catching it early,  disappointed with myself for =
missing=0A=
the straight forward unlock :-(=0A=
=0A=
if (WARN_ON(!sta)) {=0A=
                mutex_unlock(&sdata->local->sta_mtx);=0A=
                ret =3D false;=0A=
                goto out;=0A=
        }=0A=
=0A=
        sband =3D ieee80211_get_sband(sdata);=0A=
        if (!sband) {=0A=
                ret =3D false;=0A=
                goto out;=0A=
        }=0A=
=0A=
---------- Forwarded message ----------=0A=
Date: Fri, 28 Apr 2017 14:04:47 +0800=0A=
From: kbuild test robot <fengguang.wu@intel.com>=0A=
To: kbuild@01.org=0A=
Cc: Julia Lawall <julia.lawall@lip6.fr>=0A=
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer=0A=
    de-reference=0A=
=0A=
In-Reply-To: <1493277338-25726-1-git-send-email-mohammed@qca.qualcomm.com>=
=0A=
=0A=
Hi Mohammed,=0A=
=0A=
[auto build test WARNING on mac80211/master]=0A=
[also build test WARNING on v4.11-rc8 next-20170427]=0A=
[if your patch is applied to the wrong git tree, please drop us a note to h=
elp improve the system]=0A=
=0A=
url:    https://github.com/0day-ci/linux/commits/Mohammed-Shafi-Shajakhan/m=
ac80211-Fix-possible-sband-related-NULL-pointer-de-reference/20170428-12042=
5=0A=
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git =
master=0A=
:::::: branch date: 2 hours ago=0A=
:::::: commit date: 2 hours ago=0A=
=0A=
>> net/mac80211/mlme.c:3120:1-7: preceding lock on line 2997=0A=
=0A=
git remote add linux-review https://github.com/0day-ci/linux=0A=
git remote update linux-review=0A=
git checkout 4b2b8c708017f5d2569fc5d9e7a76c6c1b08dd8c=0A=
vim +3120 net/mac80211/mlme.c=0A=
=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 2991                sdata_info(sdata,=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 2992                           "VHT AP is missing VHT capability/operation=
\n");=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 2993                ret =3D false;=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 2994                goto out;=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 2995        }=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 2996=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
@2997        mutex_lock(&sdata->local->sta_mtx);=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 2998        /*=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 2999         * station info was already allocated and inserted before=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 3000         * the association and should be available to us=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 3001         */=0A=
7852e3618 net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3002        sta =3D sta_info_get(sdata, cbss->bssid);=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 3003        if (WARN_ON(!sta)) {=0A=
2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 =
 3004                mutex_unlock(&sdata->local->sta_mtx);=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3005                ret =3D false;=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3006                goto out;=0A=
f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05 =
 3007        }=0A=
f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05 =
 3008=0A=
4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27 =
 3009        sband =3D ieee80211_get_sband(sdata);=0A=
4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27 =
 3010        if (!sband) {=0A=
4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27 =
 3011                ret =3D false;=0A=
4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27 =
 3012                goto out;=0A=
4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27 =
 3013        }=0A=
f709fc696 net/mac80211/ieee80211_sta.c Luis Carlos Cobo         2008-02-23 =
 3014=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3015        /* Set up internal HT/VHT capabilities */=0A=
a8243b724 net/mac80211/mlme.c          Johannes Berg            2012-11-22 =
 3016        if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABL=
E_HT))=0A=
ef96a8420 net/mac80211/mlme.c          Ben Greear               2011-11-18 =
 3017                ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,=0A=
e1a0c6b3a net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3018                                                  elems.ht_cap_elem, s=
ta);=0A=
64f68e5d1 net/mac80211/mlme.c          Johannes Berg            2012-03-28 =
 3019=0A=
818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10 =
 3020        if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISAB=
LE_VHT))=0A=
818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10 =
 3021                ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,=0A=
4a34215ef net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3022                                                    elems.vht_cap_elem=
, sta);=0A=
818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10 =
 3023=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3024        /*=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3025         * Some APs, e.g. Netgear WNDR3700, report invalid HT operatio=
n data=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3026         * in their association response, so ignore that data for our =
own=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3027         * configuration. If it changed since the last beacon, we'll g=
et the=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3028         * next beacon and update then.=0A=
30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08 =
 3029         */=0A=
1128958dc net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3030=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3031        /*=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3032         * If an operating mode notification IE is present, override t=
he=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3033         * NSS calculation (that would be done in rate_control_rate_in=
it())=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3034         * and use the # of streams from that element.=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3035         */=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3036        if (elems.opmode_notif &&=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3037            !(*elems.opmode_notif & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE=
_BF)) {=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3038                u8 nss;=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3039=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3040                nss =3D *elems.opmode_notif & IEEE80211_OPMODE_NOTIF_R=
X_NSS_MASK;=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3041                nss >>=3D IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3042                nss +=3D 1;=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3043                sta->sta.rx_nss =3D nss;=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3044        }=0A=
bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07 =
 3045=0A=
4b7679a56 net/mac80211/mlme.c          Johannes Berg            2008-09-18 =
 3046        rate_control_rate_init(sta);=0A=
f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05 =
 3047=0A=
93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07 =
 3048        if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED) {=0A=
c2c98fdeb net/mac80211/mlme.c          Johannes Berg            2011-09-29 =
 3049                set_sta_flag(sta, WLAN_STA_MFP);=0A=
93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07 =
 3050                sta->sta.mfp =3D true;=0A=
93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07 =
 3051        } else {=0A=
93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07 =
 3052                sta->sta.mfp =3D false;=0A=
93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07 =
 3053        }=0A=
5394af4d8 net/mac80211/mlme.c          Jouni Malinen            2009-01-08 =
 3054=0A=
527871d72 net/mac80211/mlme.c          Johannes Berg            2015-03-21 =
 3055        sta->sta.wme =3D elems.wmm_param && local->hw.queues >=3D IEEE=
80211_NUM_ACS;=0A=
ddf4ac53f net/mac80211/mlme.c          Johannes Berg            2008-10-22 =
 3056=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3057        err =3D sta_info_move_state(sta, IEEE80211_STA_ASSOC);=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3058        if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3059                err =3D sta_info_move_state(sta, IEEE80211_STA_AUTHORI=
ZED);=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3060        if (err) {=0A=
bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22 =
 3061                sdata_info(sdata,=0A=
bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22 =
 3062                           "failed to move station %pM to desired stat=
e\n",=0A=
bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22 =
 3063                           sta->sta.addr);=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3064                WARN_ON(__sta_info_destroy(sta));=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3065                mutex_unlock(&sdata->local->sta_mtx);=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3066                ret =3D false;=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3067                goto out;=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3068        }=0A=
c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3069=0A=
7852e3618 net/mac80211/mlme.c          Johannes Berg            2012-01-20 =
 3070        mutex_unlock(&sdata->local->sta_mtx);=0A=
ddf4ac53f net/mac80211/mlme.c          Johannes Berg            2008-10-22 =
 3071=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3072        /*=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3073         * Always handle WMM once after association regardless=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3074         * of the first value the AP uses. Setting -1 here has=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3075         * that effect because the AP values is an unsigned=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3076         * 4-bit value.=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3077         */=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3078        ifmgd->wmm_last_param_set =3D -1;=0A=
f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28 =
 3079=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3080        if (ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {=0A=
cec662835 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3081                ieee80211_set_wmm_default(sdata, false, false);=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3082        } else if (!ieee80211_sta_wmm_params(local, sdata, elems.wmm_p=
aram,=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3083                                             elems.wmm_param_len)) {=
=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3084                /* still enable QoS since we might have HT/VHT */=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3085                ieee80211_set_wmm_default(sdata, false, true);=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3086                /* set the disable-WMM flag in this case to disable=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3087                 * tracking WMM parameter changes in the beacon if=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3088                 * the parameters weren't actually valid. Doing so=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3089                 * avoids changing parameters very strangely when=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3090                 * the AP is going back and forth between valid and=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3091                 * invalid parameters.=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3092                 */=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3093                ifmgd->flags |=3D IEEE80211_STA_DISABLE_WMM;=0A=
2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22 =
 3094        }=0A=
3abead59f net/mac80211/mlme.c          Johannes Berg            2012-03-02 =
 3095        changed |=3D BSS_CHANGED_QOS;=0A=
f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05 =
 3096=0A=
60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08 =
 3097        /* set AID and assoc capability,=0A=
60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08 =
 3098         * ieee80211_set_associated() will tell the driver */=0A=
60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08 =
 3099        bss_conf->aid =3D aid;=0A=
60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08 =
 3100        bss_conf->assoc_capability =3D capab_info;=0A=
0c1ad2cac net/mac80211/mlme.c          Johannes Berg            2009-12-23 =
 3101        ieee80211_set_associated(sdata, cbss, changed);=0A=
a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18 =
 3102=0A=
15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22 =
 3103        /*=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3104         * If we're using 4-addr mode, let the AP know that we're=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3105         * doing so, so that it can create the STA VLAN on its side=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3106         */=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3107        if (ifmgd->use_4addr)=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3108                ieee80211_send_4addr_nullfunc(local, sdata);=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3109=0A=
d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08 =
 3110        /*=0A=
b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10 =
 3111         * Start timer to probe the connection to the AP now.=0A=
b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10 =
 3112         * Also start the timer that will detect beacon loss.=0A=
15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22 =
 3113         */=0A=
b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10 =
 3114        ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);=
=0A=
d3a910a8e net/mac80211/mlme.c          Luis R. Rodriguez        2010-09-16 =
 3115        ieee80211_sta_reset_beacon_monitor(sdata);=0A=
15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22 =
 3116=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3117        ret =3D true;=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3118   out:=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
 3119        kfree(bss_ies);=0A=
35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 =
@3120        return ret;=0A=
a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18 =
 3121  }=0A=
a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18 =
 3122=0A=
8d61ffa5e net/mac80211/mlme.c          Johannes Berg            2013-05-10 =
 3123  static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_dat=
a *sdata,=0A=
=0A=
:::::: The code at line 3120 was first introduced by commit=0A=
:::::: 35d865afbbdf79e492f7d61df92b1a9e1d93d26f mac80211: work around broke=
n APs not including HT info=0A=
=0A=
:::::: TO: Johannes Berg <johannes.berg@intel.com>=0A=
:::::: CC: Johannes Berg <johannes.berg@intel.com>=0A=
=0A=
---=0A=
0-DAY kernel test infrastructure                Open Source Technology Cent=
er=0A=
https://lists.01.org/pipermail/kbuild-all                   Intel Corporati=
on=0A=

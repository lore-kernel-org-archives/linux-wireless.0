Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27563
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933273AbdD1Lip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 07:38:45 -0400
Date: Fri, 28 Apr 2017 13:38:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: "Mohammed Shafi Shajakhan (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference (fwd)
In-Reply-To: <1493376672264.91080@qti.qualcomm.com>
Message-ID: <alpine.DEB.2.20.1704281338190.3387@hadrien> (sfid-20170428_133849_650556_67F8FA3F)
References: <alpine.DEB.2.20.1704281205580.3387@hadrien> <1493376672264.91080@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 28 Apr 2017, Mohammed Shafi Shajakhan (Mohammed Shafi) wrote:

>
> Please check whether an unlock is missing on line 3009-3013.
>
> [shafi]  thanks Julia for catching it early,  disappointed with myself for missing
> the straight forward unlock :-(

That's what tools are for :)

julia

>
> if (WARN_ON(!sta)) {
>                 mutex_unlock(&sdata->local->sta_mtx);
>                 ret = false;
>                 goto out;
>         }
>
>         sband = ieee80211_get_sband(sdata);
>         if (!sband) {
>                 ret = false;
>                 goto out;
>         }
>
> ---------- Forwarded message ----------
> Date: Fri, 28 Apr 2017 14:04:47 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
>     de-reference
>
> In-Reply-To: <1493277338-25726-1-git-send-email-mohammed@qca.qualcomm.com>
>
> Hi Mohammed,
>
> [auto build test WARNING on mac80211/master]
> [also build test WARNING on v4.11-rc8 next-20170427]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Mohammed-Shafi-Shajakhan/mac80211-Fix-possible-sband-related-NULL-pointer-de-reference/20170428-120425
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
> :::::: branch date: 2 hours ago
> :::::: commit date: 2 hours ago
>
> >> net/mac80211/mlme.c:3120:1-7: preceding lock on line 2997
>
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 4b2b8c708017f5d2569fc5d9e7a76c6c1b08dd8c
> vim +3120 net/mac80211/mlme.c
>
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  2991                sdata_info(sdata,
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  2992                           "VHT AP is missing VHT capability/operation\n");
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  2993                ret = false;
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  2994                goto out;
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  2995        }
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  2996
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17 @2997        mutex_lock(&sdata->local->sta_mtx);
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  2998        /*
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  2999         * station info was already allocated and inserted before
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  3000         * the association and should be available to us
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  3001         */
> 7852e3618 net/mac80211/mlme.c          Johannes Berg            2012-01-20  3002        sta = sta_info_get(sdata, cbss->bssid);
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  3003        if (WARN_ON(!sta)) {
> 2a33bee27 net/mac80211/mlme.c          Guy Eilam                2011-08-17  3004                mutex_unlock(&sdata->local->sta_mtx);
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3005                ret = false;
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3006                goto out;
> f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05  3007        }
> f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05  3008
> 4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27  3009        sband = ieee80211_get_sband(sdata);
> 4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27  3010        if (!sband) {
> 4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27  3011                ret = false;
> 4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27  3012                goto out;
> 4b2b8c708 net/mac80211/mlme.c          Mohammed Shafi Shajakhan 2017-04-27  3013        }
> f709fc696 net/mac80211/ieee80211_sta.c Luis Carlos Cobo         2008-02-23  3014
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3015        /* Set up internal HT/VHT capabilities */
> a8243b724 net/mac80211/mlme.c          Johannes Berg            2012-11-22  3016        if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
> ef96a8420 net/mac80211/mlme.c          Ben Greear               2011-11-18  3017                ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
> e1a0c6b3a net/mac80211/mlme.c          Johannes Berg            2013-02-07  3018                                                  elems.ht_cap_elem, sta);
> 64f68e5d1 net/mac80211/mlme.c          Johannes Berg            2012-03-28  3019
> 818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10  3020        if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
> 818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10  3021                ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
> 4a34215ef net/mac80211/mlme.c          Johannes Berg            2013-02-07  3022                                                    elems.vht_cap_elem, sta);
> 818255ea4 net/mac80211/mlme.c          Mahesh Palivela          2012-10-10  3023
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3024        /*
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3025         * Some APs, e.g. Netgear WNDR3700, report invalid HT operation data
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3026         * in their association response, so ignore that data for our own
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3027         * configuration. If it changed since the last beacon, we'll get the
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3028         * next beacon and update then.
> 30eb1dc2c net/mac80211/mlme.c          Johannes Berg            2013-02-08  3029         */
> 1128958dc net/mac80211/mlme.c          Johannes Berg            2013-02-07  3030
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3031        /*
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3032         * If an operating mode notification IE is present, override the
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3033         * NSS calculation (that would be done in rate_control_rate_init())
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3034         * and use the # of streams from that element.
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3035         */
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3036        if (elems.opmode_notif &&
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3037            !(*elems.opmode_notif & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)) {
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3038                u8 nss;
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3039
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3040                nss = *elems.opmode_notif & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3041                nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3042                nss += 1;
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3043                sta->sta.rx_nss = nss;
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3044        }
> bee7f5869 net/mac80211/mlme.c          Johannes Berg            2013-02-07  3045
> 4b7679a56 net/mac80211/mlme.c          Johannes Berg            2008-09-18  3046        rate_control_rate_init(sta);
> f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05  3047
> 93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07  3048        if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED) {
> c2c98fdeb net/mac80211/mlme.c          Johannes Berg            2011-09-29  3049                set_sta_flag(sta, WLAN_STA_MFP);
> 93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07  3050                sta->sta.mfp = true;
> 93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07  3051        } else {
> 93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07  3052                sta->sta.mfp = false;
> 93f0490e5 net/mac80211/mlme.c          Tamizh chelvam           2015-10-07  3053        }
> 5394af4d8 net/mac80211/mlme.c          Jouni Malinen            2009-01-08  3054
> 527871d72 net/mac80211/mlme.c          Johannes Berg            2015-03-21  3055        sta->sta.wme = elems.wmm_param && local->hw.queues >= IEEE80211_NUM_ACS;
> ddf4ac53f net/mac80211/mlme.c          Johannes Berg            2008-10-22  3056
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3057        err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3058        if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3059                err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3060        if (err) {
> bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22  3061                sdata_info(sdata,
> bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22  3062                           "failed to move station %pM to desired state\n",
> bdcbd8e0e net/mac80211/mlme.c          Johannes Berg            2012-06-22  3063                           sta->sta.addr);
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3064                WARN_ON(__sta_info_destroy(sta));
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3065                mutex_unlock(&sdata->local->sta_mtx);
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3066                ret = false;
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3067                goto out;
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3068        }
> c8987876e net/mac80211/mlme.c          Johannes Berg            2012-01-20  3069
> 7852e3618 net/mac80211/mlme.c          Johannes Berg            2012-01-20  3070        mutex_unlock(&sdata->local->sta_mtx);
> ddf4ac53f net/mac80211/mlme.c          Johannes Berg            2008-10-22  3071
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3072        /*
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3073         * Always handle WMM once after association regardless
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3074         * of the first value the AP uses. Setting -1 here has
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3075         * that effect because the AP values is an unsigned
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3076         * 4-bit value.
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3077         */
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3078        ifmgd->wmm_last_param_set = -1;
> f2176d724 net/mac80211/mlme.c          Juuso Oikarinen          2010-09-28  3079
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3080        if (ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
> cec662835 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3081                ieee80211_set_wmm_default(sdata, false, false);
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3082        } else if (!ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3083                                             elems.wmm_param_len)) {
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3084                /* still enable QoS since we might have HT/VHT */
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3085                ieee80211_set_wmm_default(sdata, false, true);
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3086                /* set the disable-WMM flag in this case to disable
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3087                 * tracking WMM parameter changes in the beacon if
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3088                 * the parameters weren't actually valid. Doing so
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3089                 * avoids changing parameters very strangely when
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3090                 * the AP is going back and forth between valid and
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3091                 * invalid parameters.
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3092                 */
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3093                ifmgd->flags |= IEEE80211_STA_DISABLE_WMM;
> 2ed77ea69 net/mac80211/mlme.c          Johannes Berg            2015-10-22  3094        }
> 3abead59f net/mac80211/mlme.c          Johannes Berg            2012-03-02  3095        changed |= BSS_CHANGED_QOS;
> f0706e828 net/mac80211/ieee80211_sta.c Jiri Benc                2007-05-05  3096
> 60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08  3097        /* set AID and assoc capability,
> 60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08  3098         * ieee80211_set_associated() will tell the driver */
> 60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08  3099        bss_conf->aid = aid;
> 60f8b39c9 net/mac80211/mlme.c          Johannes Berg            2008-09-08  3100        bss_conf->assoc_capability = capab_info;
> 0c1ad2cac net/mac80211/mlme.c          Johannes Berg            2009-12-23  3101        ieee80211_set_associated(sdata, cbss, changed);
> a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18  3102
> 15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22  3103        /*
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3104         * If we're using 4-addr mode, let the AP know that we're
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3105         * doing so, so that it can create the STA VLAN on its side
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3106         */
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3107        if (ifmgd->use_4addr)
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3108                ieee80211_send_4addr_nullfunc(local, sdata);
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3109
> d524215f6 net/mac80211/mlme.c          Felix Fietkau            2010-01-08  3110        /*
> b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10  3111         * Start timer to probe the connection to the AP now.
> b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10  3112         * Also start the timer that will detect beacon loss.
> 15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22  3113         */
> b291ba111 net/mac80211/mlme.c          Johannes Berg            2009-07-10  3114        ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
> d3a910a8e net/mac80211/mlme.c          Luis R. Rodriguez        2010-09-16  3115        ieee80211_sta_reset_beacon_monitor(sdata);
> 15b7b0629 net/mac80211/mlme.c          Kalle Valo               2009-03-22  3116
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3117        ret = true;
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3118   out:
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28  3119        kfree(bss_ies);
> 35d865afb net/mac80211/mlme.c          Johannes Berg            2013-05-28 @3120        return ret;
> a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18  3121  }
> a607268a0 net/mac80211/ieee80211_sta.c Bruno Randolf            2008-02-18  3122
> 8d61ffa5e net/mac80211/mlme.c          Johannes Berg            2013-05-10  3123  static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
>
> :::::: The code at line 3120 was first introduced by commit
> :::::: 35d865afbbdf79e492f7d61df92b1a9e1d93d26f mac80211: work around broken APs not including HT info
>
> :::::: TO: Johannes Berg <johannes.berg@intel.com>
> :::::: CC: Johannes Berg <johannes.berg@intel.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45009 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965953AbeEIXHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 19:07:37 -0400
Date: Thu, 10 May 2018 01:07:34 +0200
In-Reply-To: <201805100446.C8w6ThtE%fengguang.wu@intel.com>
References: <152586802515.18089.12700714478750075562.stgit@alrua-kau> <201805100446.C8w6ThtE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH 3/3] net: Dynamically allocate struct station_info
To: kbuild test robot <lkp@intel.com>
CC: kbuild-all@01.org, linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <184D0BE8-7D2D-44AB-9BF6-24FA928E3B31@toke.dk> (sfid-20180510_010741_707915_CE87044C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10 May 2018 00:55:01 CEST, kbuild test robot <lkp@intel=2Ecom> wrote:
>Hi Toke,
>
>Thank you for the patch! Yet something to improve:
>
>[auto build test ERROR on wireless-drivers-next/master]
>[also build test ERROR on v4=2E17-rc4 next-20180509]
>[if your patch is applied to the wrong git tree, please drop us a note
>to help improve the system]
>
>url:  =20
>https://github=2Ecom/0day-ci/linux/commits/Toke-H-iland-J-rgensen/wireles=
s-drivers-Dynamically-allocate-struct-station_info/20180510-034416
>base: =20
>https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/kvalo/wireless-driver=
s-next=2Egit
>master
>config: i386-randconfig-x000-201818 (attached as =2Econfig)
>compiler: gcc-7 (Debian 7=2E3=2E0-16) 7=2E3=2E0
>reproduce:
>        # save the attached =2Econfig to linux build tree
>        make ARCH=3Di386=20
>
>All errors (new ones prefixed by >>):
>
> net/batman-adv/bat_v_elp=2Ec: In function 'batadv_v_elp_get_throughput':
>>> net/batman-adv/bat_v_elp=2Ec:113:21: error: 'sinfo' is a pointer; did
>you mean to use '->'?
>      throughput =3D sinfo=2Eexpected_throughput / 100;
>                        ^
>                        ->
>net/batman-adv/bat_v_elp=2Ec:114:20: error: 'sinfo' is a pointer; did you
>mean to use '->'?
> filled =3D !!(sinfo=2Efilled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)=
);
>                       ^
>                       ->

Huh, I could swear I compile tested this=2E Will send another version tomo=
rrow, sorry about that :/

-Toke

>
>vim +113 net/batman-adv/bat_v_elp=2Ec
>
>    69=09
>    70	/**
>71	 * batadv_v_elp_get_throughput() - get the throughput towards a
>neighbour
>72	 * @neigh: the neighbour for which the throughput has to be obtained
>    73	 *
>74	 * Return: The throughput towards the given neighbour in multiples
>of 100kpbs
>75	 *         (a value of '1' equals to 0=2E1Mbps, '10' equals 1Mbps,
>etc)=2E
>    76	 */
>77	static u32 batadv_v_elp_get_throughput(struct
>batadv_hardif_neigh_node *neigh)
>    78	{
>    79		struct batadv_hard_iface *hard_iface =3D neigh->if_incoming;
>    80		struct ethtool_link_ksettings link_settings;
>    81		struct net_device *real_netdev;
>    82		struct station_info *sinfo;
>    83		u32 throughput;
>    84		bool filled;
>    85		int ret;
>    86=09
>87		/* if the user specified a customised value for this interface,
>then
>    88		 * return it directly
>    89		 */
> 90		throughput =3D  atomic_read(&hard_iface->bat_v=2Ethroughput_override=
);
>    91		if (throughput !=3D 0)
>    92			return throughput;
>    93=09
>   94		/* if this is a wireless device, then ask its throughput through
>    95		 * cfg80211 API
>    96		 */
>    97		if (batadv_is_wifi_hardif(hard_iface)) {
>    98			if (!batadv_is_cfg80211_hardif(hard_iface))
>    99				/* unsupported WiFi driver version */
>   100				goto default_throughput;
>   101=09
>   102			real_netdev =3D batadv_get_real_netdev(hard_iface->net_dev);
>   103			if (!real_netdev)
>   104				goto default_throughput;
>   105=09
>   106			sinfo =3D kzalloc(sizeof(*sinfo), GFP_KERNEL);
>   107			if (!sinfo)
>   108				goto default_throughput;
>   109=09
>   110			ret =3D cfg80211_get_station(real_netdev, neigh->addr, sinfo);
>   111=09
>112			/* just save these here instead of having complex free logic
>below */
> > 113			throughput =3D sinfo=2Eexpected_throughput / 100;
>114			filled =3D !!(sinfo=2Efilled &
>BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT));
>   115=09
>   116			kfree(sinfo);
>   117=09
>   118			dev_put(real_netdev);
>   119			if (ret =3D=3D -ENOENT) {
>   120				/* Node is not associated anymore! It would be
>   121				 * possible to delete this neighbor=2E For now set
>   122				 * the throughput metric to 0=2E
>   123				 */
>   124				return 0;
>   125			}
>   126			if (ret || !filled)
>   127				goto default_throughput;
>   128=09
>   129			return throughput;
>   130		}
>   131=09
>132		/* if not a wifi interface, check if this device provides data via
>   133		 * ethtool (e=2Eg=2E an Ethernet adapter)
>   134		 */
>   135		memset(&link_settings, 0, sizeof(link_settings));
>   136		rtnl_lock();
>137		ret =3D __ethtool_get_link_ksettings(hard_iface->net_dev,
>&link_settings);
>   138		rtnl_unlock();
>   139		if (ret =3D=3D 0) {
>   140			/* link characteristics might change over time */
>   141			if (link_settings=2Ebase=2Eduplex =3D=3D DUPLEX_FULL)
>   142				hard_iface->bat_v=2Eflags |=3D BATADV_FULL_DUPLEX;
>   143			else
>   144				hard_iface->bat_v=2Eflags &=3D ~BATADV_FULL_DUPLEX;
>   145=09
>   146			throughput =3D link_settings=2Ebase=2Espeed;
>   147			if (throughput && throughput !=3D SPEED_UNKNOWN)
>   148				return throughput * 10;
>   149		}
>   150=09
>   151	default_throughput:
>   152		if (!(hard_iface->bat_v=2Eflags & BATADV_WARNING_DEFAULT)) {
>   153			batadv_info(hard_iface->soft_iface,
>154				    "WiFi driver or ethtool info does not provide information
>about link speeds on interface %s, therefore defaulting to hardcoded
>throughput values of %u=2E%1u Mbps=2E Consider overriding the throughput
>manually or checking your driver=2E\n",
>   155				    hard_iface->net_dev->name,
>   156				    BATADV_THROUGHPUT_DEFAULT_VALUE / 10,
>   157				    BATADV_THROUGHPUT_DEFAULT_VALUE % 10);
>   158			hard_iface->bat_v=2Eflags |=3D BATADV_WARNING_DEFAULT;
>   159		}
>   160=09
>161		/* if none of the above cases apply, return the base_throughput */
>   162		return BATADV_THROUGHPUT_DEFAULT_VALUE;
>   163	}
>   164=09
>
>---
>0-DAY kernel test infrastructure                Open Source Technology
>Center
>https://lists=2E01=2Eorg/pipermail/kbuild-all                   Intel
>Corporation

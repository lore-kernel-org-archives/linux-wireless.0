Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57235 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992728AbXEBEj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 00:39:59 -0400
Message-ID: <4638161D.7020106@lwfinger.net>
Date: Tue, 01 May 2007 23:39:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Compilation error with latest wireless-dev
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compiling wireless-dev (commit d2f859f56c9f00f093f943cf810a863a5aa2e10f) results in the following 
error when building modules:

WARNING: "tcf_destroy_chain" [net/mac80211/mac80211.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

In my configuration, net/sched/sch_api.c where tcf_destroy_chain is defined is not compiled. The
network-related configuration parameters are:

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_MULTIPATH_CACHED is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_LOWTX_FRAME_DUMP is not set
# CONFIG_TKIP_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_HOSTAPD_WPA_TESTING is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
# CONFIG_IEEE80211 is not set

Larry

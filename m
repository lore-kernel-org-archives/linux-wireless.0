Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:52975 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046Ab2ESHyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 03:54:17 -0400
Date: Sat, 19 May 2012 09:54:11 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120519075411.GG22418@yumi.tdiedrich.de> (sfid-20120519_095421_901962_6775A9A7)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
 <20120509121827.GD5472@yumi.tdiedrich.de>
 <20120509210448.GE5472@yumi.tdiedrich.de>
 <1336637726.4334.13.camel@jlt3.sipsolutions.net>
 <1336638453.4334.15.camel@jlt3.sipsolutions.net>
 <20120518011829.GD22418@yumi.tdiedrich.de>
 <1337361387.4802.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337361387.4802.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> [dropping openwrt list, it keeps bothering me that I should subscribe]
> 
> On Fri, 2012-05-18 at 03:18 +0200, Tobias Diedrich wrote:
> 
> > One more clue:
> > I think this has to do with the order in which the OpenWRT wifi
> > script does things:
> > 
> > hostapd -P /var/run/wifi-phy0.pid -B /var/run/hostapd-phy0.conf
> > hostapd_ctrl=/var/run/hostapd-phy0/wlan0
> > ifconfig wlan0
> > ifconfig wlan0 down
> > ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
> > ifconfig wlan0 0.0.0.0
> > ifconfig wlan0
> > ifconfig br-lan
> > ifconfig wlan0 0.0.0.0
> > ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
> > iw dev wlan0 set txpower fixed 2000
> 
> Wow, ok, setting the interface down while the AP is up really isn't a
> valid use of it. I'm actually amazed that it ever works at all when you
> do this. Either this should be done the other way around, or hostapd
> needs to get some smarts about it. For example, with the start-AP
> function transition, I'm not sure even *beacon* after you do this...

I think the problem here is you can have multiple logical interfaces per phy
devices, so the init script has to start hostapd first and do setup
setup for the interfaces after that.  And you can't change the mac
address as long as the interface is up.  This naturally leads to
- start hostapd
- for each interface
 - down the interface
 - set mac address
 - up the interface

Which seems to be exactly what the scripts are doing from what I can
see:

|hostapd -P /var/run/wifi-$phy.pid -B /var/run/hostapd-$phy.conf || {
|        echo "Failed to start hostapd for $phy"
|        return
|}
|sleep 2
|
|for vif in $vifs; do
|        config_get mode "$vif" mode
|        config_get ifname "$vif" ifname
|        [ "$mode" = "ap" ] || continue
|        hostapd_ctrl="${hostapd_ctrl:-/var/run/hostapd-$phy/$ifname}"
|        mac80211_start_vif "$vif" "$ifname"
|done

mac80211_start_vif in turn calls start_net, which calls setup_interface, which
calls prepare_interface, which does the mac-address setup among other things.

|prepare_interface() {
[...]
|    [ -n "$macaddr" ] && $DEBUG ifconfig "$iface" down
|    $DEBUG ifconfig "$iface" ${macaddr:+hw ether "$macaddr"} ${mtu:+mtu $mtu} ${txqueuelen:+txqueuelen $txqueuelen} up
[...]

-- 
Tobias						PGP: http://8ef7ddba.uguu.de

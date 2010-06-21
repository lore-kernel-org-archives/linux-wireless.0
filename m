Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:38538 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab0FUTZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:25:58 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Mon, 21 Jun 2010 21:28:02 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values
CC: Bruno Randolf <br1@einfach.org>
Message-ID: <4C1FBD42.20217.106AB2@jafojtik.seznam.cz>
In-reply-to: <201006211650.50766.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C1F135A.26516.F45AB@jafojtik.seznam.cz>, <201006211650.50766.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno,

> that would make more sense. there are changes in noise floor calibration and 
> in antenna diversity setup between these two (2010-05-30 and 2010-06-18). 
> either one may be the reason...
good


> > The directory /sys/kernel/debug is empty.
> > It looks that I have to recompile kernel. Or do you know any option to
> > pass to kernel to allow this feature?
> 
> maybe you need to:
>   mount -t debugfs debugfs /sys/kernel/debug
> ?
> 
> also you need to compile ath5k with debugging enabled.
I will do this.


> can you tell us which chipset you are using (output of dmesg |grep 
> "ath5.*chip")?

root@dvouramenna:~# dmesg |grep "ath5.*chip"
[    6.632843] ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
[    7.101528] ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)

Both chipsets suffer with a same problem.

 
> also it would be interesting to know how you generate your graphs?

RODGASIGNAL=`iwconfig wlan0 | grep "Signal level" | sed -e 's/.*Signal level=\([0123456789-]*\)[ \/].*/\1/'`
if [[ $RODGASIGNAL == "" ]]; then
  RODGASIGNAL="U"
else
  if [[ $RODGASIGNAL > "0" ]]; then
    RODGASIGNAL=-95
  fi  
fi

/usr/sbin/rrdupdate /var/rrd/rodgarssi.rrd N:$RODGASIGNAL


When rrd is feed, the chart could be rendered:

LABEL=`/usr/bin/date "+Rodga signal strength %d.%m.%Y"`
/usr/sbin/rrdtool graph /tmp/www/rodga-day.png --start -86400 \
            -t "$LABEL" --vertical-label "Signal Strength [dBi]" -w 650 -h 95 \
            DEF:rodga=/var/rrd/rodgarssi.rrd:rssi:AVERAGE \
	    DEF:bullet=/var/rrd/bulletrssi.rrd:rssi:AVERAGE \
            LINE1:rodga#FF00FF:"rodga->dvrmn" \
	    LINE1:bullet#00FF00:"dvrmn->rodga" >/dev/null

regards
   Jara


PS: I have replaced MAC address by 0:

/usr/sbin/iw wlan1 station dump | sed -n -e '/Station/p' -e '/signal/p' >/tmp/sta.txt

MARTIN=`grep "00:00:00:00:00:00" -A 1 -i /tmp/sta.txt | grep "signal" | sed -e 's/.*\(-[0123456789]*\) .*/\1/'`
if [[ $MARTIN == "" ]]
then
  MARTIN="U"
fi
RACEK=`grep "00:00:00:00:00:00" -A 1 -i /tmp/sta.txt | grep "signal" | sed -e 's/.*\(-[0123456789]*\) .*/\1/'`
if [[ $RACEK == "" ]]
then
  RACEK="U"
fi
/usr/sbin/rrdupdate /var/rrd/klienti.rrd N:$MARTIN:$RACEK




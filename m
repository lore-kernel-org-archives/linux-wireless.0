Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web33009.mail.mud.yahoo.com ([209.191.69.124]:22195 "HELO
	web33009.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754630AbXKYGlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 01:41:05 -0500
Date: Sat, 24 Nov 2007 22:34:22 -0800 (PST)
From: Max <maxw_gcc@yahoo.com>
Subject: Error compiling intel mac80211-10.0.2
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <797498.12305.qm@web33009.mail.mud.yahoo.com> (sfid-20071125_064120_491456_156FD2FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to setup a Intel Corporation PRO/Wireless 3945ABG network adapter using the software provided in http://www.intellinuxwireless.org/. But I am getting the following error:

...
Checking kernel compatibility in:
        /lib/modules/2.6.18/source//
  ! CONFIG_NET_WIRELESS_NETLINK can not be set in .config!
...

Which apparently gets triggered by the following lines in the "../mac80211-10.0.2/scripts/determine_compat" script
.....
        grep -q "nlmsg_trim" \
                ${KSRC}include/net/netlink.h && {
                export has_nlmsg_trim=1
        } || {
                grep -q "^CONFIG_NET_WIRELESS_RTNETLINK=[ym]" \
                        ${KSRC}.config && {
                        echo "  ! CONFIG_NET_WIRELESS_NETLINK can not be set in .config!"
                        exit 1
                }
        }
......

As you can see I am running kernel version 2.6.18.

Any help would be greatly appreciated.


Thanks and regards,

Max



      ____________________________________________________________________________________
Be a better sports nut!  Let your teams follow you 
with Yahoo Mobile. Try it now.  http://mobile.yahoo.com/sports;_ylt=At9_qDKvtAbMuh1G1SQtBI7ntAcJ

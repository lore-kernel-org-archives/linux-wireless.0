Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51405.mail.re2.yahoo.com ([206.190.38.184]:47763 "HELO
	web51405.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934215AbZLJMKQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 07:10:16 -0500
Message-ID: <500577.32161.qm@web51405.mail.re2.yahoo.com>
Date: Thu, 10 Dec 2009 04:10:22 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Switching channel in IBSS network doesn't work in ath9k
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I'm using the attached patch to form an IBSS network between two ath9k nodes:

IFACE=wlan0
FREQ=5200
ADDR=$1
iw dev "$IFACE" ibss leave
ip link set "$IFACE" down
ip addr flush dev "$IFACE"
iw dev "$IFACE" set type ibss
ip addr add "$ADDR"/24 dev "$IFACE"
ip link set "$IFACE" up
iw dev "$IFACE" ibss join athtest "$FREQ" fixed-freq 02:02:6F:23:12:0A

This works fine the first time. If I change the FREQ value to something else, e.g. 2462 (channel 11), the nodes don't see each other. Removing and reinserting the ath9k module solves this.
Interestingly iwconfig still shows the old frequency even if iw returned successfully.

Am I doing something wrong or is there a bug somewhere?

BTW: if you try the script, it expects an IP address as argument, e.g. "bash ibss.sh 172.16.5.1"

Thanks in advance
  Joerg

P.S.: Is there a way to get an overview of the current interface configuration with iw? What is the equivalent of "iwconfig wlan0"?

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

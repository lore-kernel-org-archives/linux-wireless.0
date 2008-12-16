Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:47181 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYLPUaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 15:30:09 -0500
To: "Bob Copeland" <bcopeland@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k + AP mode?
References: <m3skopuq6t.fsf@maximus.localdomain>
	<b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 16 Dec 2008 20:47:45 +0100
In-Reply-To: <b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com> (Bob Copeland's message of "Tue\, 16 Dec 2008 12\:33\:27 -0500")
Message-ID: <m3wsdz297i.fsf@maximus.localdomain> (sfid-20081216_213017_863399_CEA32418)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <bcopeland@gmail.com> writes:

>> Failed to set interface wlan0 to master mode.
>> nl80211 driver initialization failed.
>> wlan0: Unable to setup interface.
>
> It's probably worth taking a look at hostapd to see what exactly is failing.
> We should be able to create an IFTYPE_AP interface with your above patch
> applied.  No telling whether the rest works.

Well, it seems nl80211_set_master_mode() calls send_and_recv_msgs()
and then nl_recvmsgs(0x58cf0, 0x5b2f8) fails with -95 (-EOPNOTSUPP).

sendmsg(4, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000},
 msg_iov(1)=[{"\x24\x00\x00\x00\x11\x00\x05\x00\x2f\xf5\x47\x49\xd0\x01\x00\x00\x06\x00\x00\x00\x08\x00\x03\x00\x03\x00\x00\x00\x08\x00\x05\x00\x03\x00\x00\x00"..., 36}],
 msg_controllen=0, msg_flags=0}, 0) = 36

recvmsg(4, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000},
 msg_iov(1)=[{"\x24\x00\x00\x00\x02\x00\x00\x00\x5d\xf6\x47\x49\xd7\x01\x00\x00\xa1\xff\xff\xff\x24\x00\x00\x00\x11\x00\x05\x00\x5d\xf6\x47\x49\xd7\x01\x00\x00"..., 4096}],
msg_controllen=0, msg_flags=0}, 0) = 36

$ grep -lr -- -EOPNOTSUPP drivers/net/wireless/ath5k
drivers/net/wireless/ath5k/base.c
drivers/net/wireless/ath5k/pcu.c
but it doesn't seem it's one of those.

Request:
24 00 00 00	len
11 00		type = genl_family_get_id(drv->nl80211)
05 00		flags = NLM_F_REQUEST | NLM_F_ACK
2f f5 47 49	seq
d0 01 00 00	pid

06 00 00 00	NL80211_CMD_SET_INTERFACE

08 00		len
03 00		NL80211_ATTR_IFINDEX
03 00 00 00	if_nametoindex(ifname)

08 00		len
05 00		NL80211_ATTR_IFTYPE
03 00 00 00	NL80211_IFTYPE_AP
-- 
Krzysztof Halasa

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server35.cyon.ch ([194.126.200.45]:46831 "EHLO server35.cyon.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933764AbaFTP5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 11:57:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57831)
	by server35.cyon.ch with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <mail@trichner.ch>)
	id 1Wy1CK-002kdQ-DV
	for linux-wireless@vger.kernel.org; Fri, 20 Jun 2014 17:57:52 +0200
Received: by mail-lb0-f174.google.com with SMTP id u10so2450346lbd.5
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jun 2014 08:57:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Jun 2014 17:57:49 +0200
Message-ID: <CAHw-fTB1d+vUGyD8_7j3fm0SvQ4_wR-_VjRz9GPBt+NhUE6+=Q@mail.gmail.com> (sfid-20140620_175758_377067_32F23EC8)
Subject: nl80211.h txq parameters via userspace
From: Thomas Richner <mail@trichner.ch>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to add use the nl80211.h userspace API to configure the txq
parameters via the 'iw' utility. From my understanding (and after
staring at the nl80211.h) I have to send nested netlink
messages. I added the following to 'phy.c' in the iw-3.15 source files
to extend iw with the command 'iw <phy_dev> set txq <cwmin> <cwmax>'
but somehow I always get a 'command failed: Invalid argument (-22)'
returned. I tried this with two different drivers/physical devices
(intel's iwlwifi and realtek's rtl8192cu) and had no luck (same
error). Do I use this wrong?
>From my understanding this should work driver independently since
mac80211 is shared and work at least for iwlwifi. Thanks for any help!

static int handle_txq(struct nl80211_state *state,
struct nl_cb *cb,
struct nl_msg *msg,
int argc, char **argv,
enum id_input id)
{
unsigned int cw_min, cw_max;
printf("HANDLE TXQ");
if (argc != 2)
return 1;

cw_min = atoi(argv[0]);
cw_max = atoi(argv[1]);

printf("setting contention window to: %d - %d\n",cw_min,cw_max);

//create nested txq array

struct nlattr *nested;

nested = nla_nest_start(msg,NL80211_ATTR_WIPHY_TXQ_PARAMS);

NLA_PUT_U16(msg,NL80211_TXQ_ATTR_CWMIN,cw_min);
NLA_PUT_U16(msg,NL80211_TXQ_ATTR_CWMAX,cw_max);
nla_nest_end(msg,nested);

return 0;
 nla_put_failure:
return -ENOBUFS;
}
COMMAND(set, txq, "<cw_min> <cw_max>",
NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_txq,
"Set contention window minimum and maximum size.\n"
"Valid values: 1 - 32767 in the form 2^n-1");

COMMAND(set, txq, "<cw_min> <cw_max>",
NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_txq,
"Set contention window minimum and maximum size.\n"
"Valid values: 1 - 32767 in the form 2^n-1");

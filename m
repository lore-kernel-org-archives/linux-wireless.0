Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXKVM4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:56:05 -0500
Subject: mac80211: unencrypted packet vulnerability
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 00:01:37 +0100
Message-Id: <1195686097.6323.22.camel@johannes.berg> (sfid-20071122_125612_223632_8A5F6CEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As I just found, mac80211 is susceptible to an attack where the attacker
simply sends frames it wants us to see unencrypted instead of bothering
with replay attacks or such. This could possibly cause us to reply to
these frames or worse yet, a mac80211 based AP could encrypt the frames
and broadcast them if the attacker uses a MAC address of another station
that is properly associated!

The reason is that ieee80211_rx_h_drop_unencrypted() drops unencrypted
frames, but only if "sdata->drop_unencrypted" is set which never
happens!

I'd offer the patch below but that's hardly complete. And then what
about wext's encode and IW_ENCODE_RESTRICTED? Isn't that exactly the
same thing? ieee80211 treats it that way and I can't find docs other
than this paragraph from iwconfig's man page

  The  security  mode  may  be open or restricted, and its meaning
  depends on the card used. With  most  cards,  in  open  mode  no
  authentication  is  used  and  the  card  may  also  accept non-
  encrypted sessions, whereas in restricted  mode  only  encrypted
  sessions  are  accepted  and the card will use authentication if
  available.

And you can hardly claim that this defines the semantics of the flag
well enough to be able to implement it. Especially since it uses
keywords defined by 802.11 with a totally different meaning! I love you
Jean, thanks for creating the most undefined API I ever saw.

Even with this patch, however, we still don't have drop_unencrypted set
with plain WEP networks. For IBSS it defaults to the PRIVACY bit in the
BSS information, but for managed networks this is not done. I find this
rather disconcerting.

Should we set this to the value of the privacy bit after we join a BSS
like we do for the IBSS case?

The patch below is necessary for wpa_supplicant to be able to set the
drop_unencrypted setting, but I'm not convinced it actually needs to be
able to set it. Can't the kernel just do a sane default?

Considering the AP case, on the other hand, hostapd will need to be able
to set the setting since we don't actually look into the beacon it tells
us to transmit. But hostapd on the other hand doesn't even invoke the
iwauth ioctl! I have to admit to being rather confused.

johannes

--- everything.orig/net/mac80211/ieee80211_ioctl.c	2007-11-21 23:34:10.895859212 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2007-11-21 23:34:37.295855632 +0100
@@ -928,6 +928,9 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
 		break;
+	case IW_AUTH_DROP_UNENCRYPTED:
+		sdata->drop_unencrypted = !!data->value;
+		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			ret = -EINVAL;



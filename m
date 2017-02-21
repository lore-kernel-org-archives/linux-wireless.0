Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Straylight.Freeside.be ([94.177.230.162]:51698 "EHLO
        Straylight.freeside.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdBUVmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 16:42:18 -0500
Date: Tue, 21 Feb 2017 22:33:40 +0100
From: Jarek =?iso-8859-2?Q?Kami=F1ski?= <Jarek@Freeside.be>
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Regression with Intel 3160 AP: client not reconnecting
Message-ID: <20170221213340.GA14974@Straylight.freeside.be> (sfid-20170221_224221_697139_D71C5101)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an accesspoint running on Intel 3160 (ZBOX RI-323). It was
running just fine on 3.16 from Debian, but I recently tried upgrading it
to 4.9 and noticed strange issues with wireless clients.

With the recent versions of iwlwifi, when a client disconnects, it is
not noticed by the accesspoint. The following log comes from
backport-iwlwifi master (7ae529a404a30fdb78d7dcc1a7e5883a014c6552) on
3.16 (similar results on 4.9 as well):
#v+
lut 21 22:12:04 Wintermute hostapd[2419]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: VLAN ID 2
lut 21 22:12:04 Wintermute hostapd[2419]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
lut 21 22:12:04 Wintermute hostapd[2419]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 3)
lut 21 22:12:04 Wintermute hostapd[2419]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: starting accounting session 58ACAD18-00000002
lut 21 22:12:04 Wintermute hostapd[2419]: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)
[disconnect: nothing happens]
[try to reconnect: nothing happens, client doesn't connect]
#v-
Only running iw wlan0.2 station del xx:xx:xx:xx:xx:xx helps and allows
the client to connect.

To compare, on iwlwifi from Debian 3.16.39-1-amd64 everything works fine:
#v+
lut 21 22:03:46 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: VLAN ID 2
lut 21 22:03:46 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
lut 21 22:03:46 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 2)
lut 21 22:03:49 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: starting accounting session 58A9650D-00000084
lut 21 22:03:49 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)

lut 21 22:04:16 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated
lut 21 22:04:16 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated
lut 21 22:04:17 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)

lut 21 22:04:24 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: VLAN ID 2
lut 21 22:04:24 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
lut 21 22:04:24 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 2)
lut 21 22:04:26 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx RADIUS: starting accounting session 58A9650D-00000085
lut 21 22:04:26 Wintermute hostapd[12719]: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)
#v-

I bisected it using the backport-iwlwifi tree on 4.5 down to
4061dda503118ef5c70e0afe77798c94a48a79b9 (iwlwifi: mvm: pass station to
mac80211 RX where known, [1]). I was using the following test procedure:
1) Build, load, start hostapd.
2) Connect with an Android mobile phone (which I had at hand).
3) Disable Wi-Fi on Android.
4) Reenable Wi-Fi. Connected -> git bisect good, didn't connect -> git
   bisect bad.
I was using 4.5 because that was the lowest version against which all
intermediate commits were compiling without errors.

To verify, I patched the backports-iwlwifi master with the following
patch (on 3.16) and the Android phone started reconnecting.
#v+
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index b02ad68..70edf42 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -144,7 +144,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
+	ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 66d237c..93c2542 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -209,7 +209,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	if (iwl_mvm_check_pn(mvm, skb, queue, sta))
 		kfree_skb(skb);
 	else
-		ieee80211_rx_napi(mvm->hw, sta, skb, napi);
+		ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
 }
 
 static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
#v-
I assume that's not a correct fix, but maybe it can help to pinpoint the
root cause.

I'm running hostapd in a fairly normal configuration. One notable thing
is dynamic_vlan=1 with accept_mac_file and individual PSKs set in
wpa_psk_file.

What might be the cause? Is there anything I can do to help debug or fix
this?

Thanks in advance!

[1] http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/commit/?id=4061dda503118ef5c70e0afe77798c94a48a79b9


-- 
pozdr(); // Jarek

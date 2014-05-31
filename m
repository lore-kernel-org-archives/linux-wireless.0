Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43031 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaEaSyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:54:35 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so2669873wib.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:54:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1401285737.8146.21.camel@jlt4.sipsolutions.net>
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
 <1400509775.4273.8.camel@jlt4.sipsolutions.net> <1400510950.4273.9.camel@jlt4.sipsolutions.net>
 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
 <1400515344.4273.19.camel@jlt4.sipsolutions.net> <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
 <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com> <1401285737.8146.21.camel@jlt4.sipsolutions.net>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sat, 31 May 2014 20:54:14 +0200
Message-ID: <CAN8YU5Mxxqs1H4caXQ_tS0Sq5YKwk9NatgSqWferCqBu_+jnyQ@mail.gmail.com> (sfid-20140531_205438_377046_23896702)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I found some useful helper function in mac80211, and I used some of
them, but unfortunately I finally parsed information element in
beacon/probe-response by myself:
I found the utility ieee802_11_parse_elems(), but it seems that it
relies on structures that are declared in some .h file located locally
to mac80211.. So I suppose it is not intended for use outside
mac80211, is it?

I did a simpler implementation that only search for channel information..
So.. What about the following patch? :)

Andrea

 drivers/net/wireless/at76c50x-usb.c | 57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index 10fd12e..06a64f4 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1502,6 +1502,61 @@ static void at76_work_submit_rx(struct work_struct *work)
        mutex_unlock(&priv->mtx);
 }

+/* This is a workaround to make scan working:
+ * currently mac80211 does not process frames with no frequency
+ * information.
+ * However during scan the HW performs a sweep by itself, and we
+ * are unable to know where the radio is actually tuned.
+ * This function tries to do its best to guess this information..
+ * If the current frame is a beacon or a probe response, the channel
+ * information is extracted from it.
+ * For other frames, or if it happen that for whatever reason we fail
+ * to parse beacons and probe responses, this function returns
+ * the priv->channel information, that should be valid at least
+ * when we are NOT scanning.
+ */
+static int at76_parse_freq(struct at76_priv *priv)
+{
+       size_t el_off;
+       u8 id;
+       u8 *el;
+       int el_len;
+       int channel = priv->channel;
+       int len = priv->rx_skb->len;
+       struct ieee80211_hdr *hdr = (void *)priv->rx_skb->data;
+
+       if (len < 24)
+               goto exit;
+
+       if (ieee80211_is_probe_resp(hdr->frame_control)) {
+               el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+               el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
+       } else if (ieee80211_is_beacon(hdr->frame_control)) {
+               el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+               el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
+       } else
+               goto exit;
+
+       len -= el_off;
+
+       while (len >= 2) {
+               id = *el++;
+               el_len = *el++;
+               len -= 2;
+
+               if (id == WLAN_EID_DS_PARAMS) {
+                       if ((el_len > 0) && (len >= el_len))
+                               channel = *el;
+                       break;
+               }
+               len -= el_len;
+               el += el_len;
+       }
+
+exit:
+       return ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+}
+
 static void at76_rx_tasklet(unsigned long param)
 {
        struct urb *urb = (struct urb *)param;
@@ -1542,6 +1597,8 @@ static void at76_rx_tasklet(unsigned long param)
        rx_status.signal = buf->rssi;
        rx_status.flag |= RX_FLAG_DECRYPTED;
        rx_status.flag |= RX_FLAG_IV_STRIPPED;
+       rx_status.band = IEEE80211_BAND_2GHZ;
+       rx_status.freq = at76_parse_freq(priv);

        at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
                 priv->rx_skb->len, priv->rx_skb->data_len);
-- 
1.9.1

On Wed, May 28, 2014 at 4:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Andrea,
>
>> Unfortunately it seems it does the same as mine..
>
> Ok ... fair enough.
>
>> If this is not the case (no one knowns/tells) IMHO the two choice are:
>> - do what we said: parse beacons to extract channel information (and
>> let monitor mode stay as it is)
>
> Probably the best course of action for now. I'd make this conditional on
> receiving probe response/beacon, there should be helper functions for
> most of this. Since the chip is 2.4 GHz only you also don't have any
> problems with band selection stuff.
>
>> - do more investigation trying to fix also monitor mode issue.
>
> That could be done as a follow-up, I guess.
>
>> I could do some work on this (including opening the dongle to see if I
>> can put HW probes on the RF chip, to see on with frequency the FW
>> tunes it when scan commands are sent).
>>
>> Also AFAIK there is a new firmware in the off-tree Atmel driver, that
>> AFAIK also support WPA.
>> If this turns out to be true, then I'm tempted to rework the driver
>> for using it (hoping the the scan command works better on it).
>>
>> FYI :
>> Honestly I'm unsure if it's worth to do these last things:
>
> Whatever you want to do :-)
>
> johannes
>

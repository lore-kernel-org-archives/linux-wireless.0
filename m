Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41977 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3IIREH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 13:04:07 -0400
Received: by mail-oa0-f50.google.com with SMTP id i4so6854743oah.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 10:04:05 -0700 (PDT)
Message-ID: <522DFF83.6000605@lwfinger.net> (sfid-20130909_190412_783266_65FD5C90)
Date: Mon, 09 Sep 2013 12:04:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk>
In-Reply-To: <522DE8CA.9010008@ilande.co.uk>
Content-Type: multipart/mixed;
 boundary="------------050108070202000304080408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050108070202000304080408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2013 10:27 AM, Mark Cave-Ayland wrote:
> On 09/09/13 15:57, Larry Finger wrote:
>
>> I think your user space is exactly the problem. As I am writing this, my
>> device, which lsusb reports as "ID 7392:7811 Edimax Technology Co., Ltd
>> EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]" has been up for
>> a little over 20 hours. During that time, there have been 23
>> deauthentications for reason 7, but 0 of the "connection to AP lost"
>> variety.
>
> I've just tried building wpa_supplicant 2.0 from source and it sadly doesn't
> make any difference here.
>
> I do still however see the following in dmesg output:
>
> rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
>
> Briefly looking through the code in rtlwifi/base.c I see that the watchdog
> message above is triggered by the condition (rtlpriv->link_info.bcn_rx_inperiod
> + rtlpriv->link_info.num_rx_inperiod) == 0).
>
> The bcn_rx_inperiod value is only incremented by rtl_beacon_statistic() in
> base.c, which is in turn called from _rtl_usb_rx_process_noagg() (but not
> _rtl_usb_rx_process_agg() for some reason?). Shall I try adding some debugging
> printk() statements in there to get a feel for what is going on? Or would it be
> better to attempt a trace with debug=0x5?

Debug level 5 will inundate you with so much info that you will not get much 
feeling for the results. Even the Realtek engineers never ask for level 5. Try 
the attached patch. That will let us know if rtl_beacon_statistic() is being 
called, and what parameters it is getting.

I have added the call to rtl_beacon_statistic() to _rtl_usb_rx_process_agg(), 
which should be the routine used in my connection to an AP using WPA2, which 
allows aggregation. As I write this, the revised driver has been running for 
only 1800 seconds, but I have not seen any of the "AP off" messages.

>> I will switch my system from NM to manual control to see what happens.
>
> Interesting. Did it make any difference in the end?

In 3 hours, it made no difference.

Larry



--------------050108070202000304080408
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_dump_AP_off"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_dump_AP_off"

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/base.c
@@ -1287,7 +1287,13 @@ void rtl_beacon_statistic(struct ieee802
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	static int count;
 
+	if (count++ < 100) {
+		pr_info("mode %d, state %d, is_beacon %d, is_probe_resp %d, length %d, MAC %pM\n",
+			rtlpriv->mac80211.opmode, rtlpriv->mac80211.link_state, ieee80211_is_beacon(hdr->frame_control),
+			ieee80211_is_probe_resp(hdr->frame_control), skb->len, hdr->addr3);
+	}
 	if (rtlpriv->mac80211.opmode != NL80211_IFTYPE_STATION)
 		return;
 
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index e56778c..ba9844a 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -484,6 +484,8 @@ static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
 			if (unicast)
 				rtlpriv->link_info.num_rx_inperiod++;
 		}
+		/* static bcn for roaming */
+		rtl_beacon_statistic(hw, skb);
 	}
 }
 


--------------050108070202000304080408--

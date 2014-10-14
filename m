Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49539 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaJNGhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 02:37:46 -0400
Received: by mail-vc0-f179.google.com with SMTP id im17so6862193vcb.24
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 23:37:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
Date: Tue, 14 Oct 2014 08:37:45 +0200
Message-ID: <CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com> (sfid-20141014_083800_832926_73B3340C)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Amitkumar Karwar,

On Mon, Oct 13, 2014 at 3:41 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
>>>
>>> That's good :) Actually kernel will take care of freeing skb when
>>driver submits received packet using netif_rx(). Could you please share
>>your hack?
>>Yes it should be freed when netif_rx() is processed but I have feeling
>>that sometimes (my case) during high load (-b 100m) packets are not send
>>to kernel (not free skb) until skb allocation fails. I need to better
>>understand 11n reordering code :).
>
> Rx reorder logic can buffer upto 32 packets, if they aren't received in correct order. You are right. Your platform may run out of memory in this case.
> Could you please check if the problem fixes with any of the attached changes?
> 1) Change Rx window size from 32 to 8.
> 2) Disable AMPDU feature.
Thanks for patches.
I tried both (slightly modified as we're in 3.9 kernel) but issue is
still reproducible. My patch against 3.9 sources:
diff --git a/drivers/net/wireless/mwifiex/decl.h
b/drivers/net/wireless/mwifiex/decl.h
index e8a569a..916924c 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -42,7 +42,7 @@
 #define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED      16

 #define MWIFIEX_AMPDU_DEF_TXWINSIZE        32
-#define MWIFIEX_AMPDU_DEF_RXWINSIZE        16
+#define MWIFIEX_AMPDU_DEF_RXWINSIZE        8
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff

 #define MWIFIEX_RATE_BITMAP_MCS0   32
diff --git a/drivers/net/wireless/mwifiex/sta_event.c
b/drivers/net/wireless/mwifiex/sta_event.c
index 41aafc7..05a36f0 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -378,10 +378,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
                                HostCmd_ACT_GEN_GET, 0, NULL);
                break;
        case EVENT_ADDBA:
-               dev_dbg(adapter->dev, "event: ADDBA Request\n");
-               mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_RSP,
-                                      HostCmd_ACT_GEN_SET, 0,
-                                      adapter->event_body);
+               dev_dbg(adapter->dev, "event: ADDBA Request ignoring\n");
                break;
        case EVENT_DELBA:
                dev_dbg(adapter->dev, "event: DELBA Request\n");
diff --git a/drivers/net/wireless/mwifiex/wmm.c
b/drivers/net/wireless/mwifiex/wmm.c
index 2670676..3d0aa02 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -415,8 +415,8 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)

                for (i = 0; i < MAX_NUM_TID; ++i) {
                        priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
-                       priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
-                       priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
+                       priv->aggr_prio_tbl[i].ampdu_ap = BA_STREAM_NOT_ALLOWED;
+                       priv->aggr_prio_tbl[i].ampdu_user =
BA_STREAM_NOT_ALLOWED;
                }

                priv->aggr_prio_tbl[6].amsdu

One thing which is not yet still clear to me why kernel console is
completely unresponsive when
receiving packets in high rates. When use iperf (on client) with -b40m
it is OK but when increase to -b100m then console
is completely unresponsive until iperf finish. Any other ideas what to
change to check? Thanks.

>
>>
>>Hack (it's dirty I know but packets of that size are send only during
>>iperf session):
>>
>>diff --git a/drivers/net/wireless/mwifiex/usb.c
>>b/drivers/net/wireless/mwifiex/usb.c
>>index f90fe21..cc548a1 100644
>>--- a/drivers/net/wireless/mwifiex/usb.c
>>+++ b/drivers/net/wireless/mwifiex/usb.c
>>@@ -178,6 +178,12 @@ static void mwifiex_usb_rx_complete(struct urb
>>*urb)
>>                dev_dbg(adapter->dev, "info: recv_length=%d,
>>status=%d\n",
>>                        recv_length, status);
>>                if (status == -EINPROGRESS) {
>>+
>>+                       if (skb->len >= 1574) {
>>+                               dev_kfree_skb_any(skb);
>>+                               goto setup_for_next;
>>+                       }
>>+
>
> The change doesn't look correct. The skb is being processed/used. We cannot free it here. This may create problem.
>
> Regards,
> Amit

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

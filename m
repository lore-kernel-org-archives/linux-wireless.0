Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:47815 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIL5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 07:57:42 -0400
Received: by mail-vc0-f173.google.com with SMTP id ij19so814037vcb.18
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 04:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
Date: Thu, 9 Oct 2014 13:57:41 +0200
Message-ID: <CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com> (sfid-20141009_135746_011010_4D5805C3)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Amitkumar Karwar,


On Thu, Oct 9, 2014 at 11:30 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
> Sorry for late reply. We have tried to simulate dev_alloc_skb() failure on our reference platform after 100th, 200th, 300th etc. packets. Our observation is when the failure occurs, corresponding URB won't get submitted, but traffic continues. Traffic stops when the failure count reaches 6 (mwifiex Rx URB count). We don't see any crash or system unresponsiveness.
No I don't see such behavior. In my case usb still sending packets
over URB (also proven by below hack). My platform is am335x (same chip
as on beaglebone).
>
>
>> I did small investigation (will my limited networking knowledge :)) and
>> to avoid usb issue I did small hack to free received packet in skb
>> (with specific size
>> 1574 which sends iperf) before sending for processing to driver
>> workqueue. With this small hack I can run iperf -b100m on client size
>> without any allocation issue.
>
> That's good :) Actually kernel will take care of freeing skb when driver submits received packet using netif_rx(). Could you please share your hack?
Yes it should be freed when netif_rx() is processed but I have feeling
that sometimes (my case) during high load (-b 100m) packets are not
send to kernel (not free skb)
until skb allocation fails. I need to better understand 11n reordering code :).

Hack (it's dirty I know but packets of that size are send only during
iperf session):

diff --git a/drivers/net/wireless/mwifiex/usb.c
b/drivers/net/wireless/mwifiex/usb.c
index f90fe21..cc548a1 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -178,6 +178,12 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
                dev_dbg(adapter->dev, "info: recv_length=%d, status=%d\n",
                        recv_length, status);
                if (status == -EINPROGRESS) {
+
+                       if (skb->len >= 1574) {
+                               dev_kfree_skb_any(skb);
+                               goto setup_for_next;
+                       }
+
                        queue_work(adapter->workqueue, &adapter->main_work);

                        /* urb for data_ep is re-submitted now;
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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:33341 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbbESPv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 11:51:56 -0400
Received: by obbgq1 with SMTP id gq1so752327obb.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 08:51:55 -0700 (PDT)
Message-ID: <555B5C18.5000906@lwfinger.net> (sfid-20150519_175159_997496_C3CD2066)
Date: Tue, 19 May 2015 10:51:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Haggai Eran <haggai.eran@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
References: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
In-Reply-To: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010602080500000309090200"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010602080500000309090200
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 05/19/2015 12:47 AM, Haggai Eran wrote:
> With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
> packet are set, but the packet length is too large. Truncate the packet
> to prevent memory corruption.
>
> Signed-off-by: Haggai Eran <haggai.eran@gmail.com>
> ---
>
> Hi,
>
> I think this solves the issue for me. I'll test it more thoroughly later. I
> still don't know why a fragmented packet has such a large pkt_len value though.
>
> Thanks,
> Haggai
>
>   drivers/staging/rtl8712/rtl8712_recv.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

I added a printout to your patch to log the values for tmp_len and alloc_sz when 
tmp_len > alloc_sz. In about 15 minutes of running, that print has not 
triggered. The condition only seems to happen on your system.

Please replace your patch with my modified version and report the printed values.

I have to go out today, thus there is no hurry.

Thanks,

Larry

>
> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
> index cd8b444..d7ea9c1 100644
> --- a/drivers/staging/rtl8712/rtl8712_recv.c
> +++ b/drivers/staging/rtl8712/rtl8712_recv.c
> @@ -1055,8 +1055,12 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
>   		pkt_offset = (u16)round_up(tmp_len, 128);
>   		/* for first fragment packet, driver need allocate 1536 +
>   		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
> -		if ((mf == 1) && (frag == 0))
> +		if ((mf == 1) && (frag == 0)) {
>   			alloc_sz = 1658;/*1658+6=1664, 1664 is 128 alignment.*/
> +            if (tmp_len > alloc_sz) {
> +                tmp_len = alloc_sz;
> +            }
> +        }
>   		else
>   			alloc_sz = tmp_len;
>   		/* 2 is for IP header 4 bytes alignment in QoS packet case.
>


--------------010602080500000309090200
Content-Type: text/plain; charset=UTF-8;
 name="rtl8712_prevent_buffer_overrun"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8712_prevent_buffer_overrun"

X-Account-Key: account11
X-UIDL: GmailId14d6ab65e24957d3
X-Mozilla-Status: 0001
X-Mozilla-Status2: 00000000
X-Mozilla-Keys:                                                                                 
Delivered-To: larry.finger@gmail.com
Received: by 10.27.210.194 with SMTP id j185csp164052wlg;
        Mon, 18 May 2015 22:47:26 -0700 (PDT)
X-Received: by 10.55.20.87 with SMTP id e84mr55051574qkh.43.1432014446155;
        Mon, 18 May 2015 22:47:26 -0700 (PDT)
Return-Path: <haggai.eran@gmail.com>
Received: from atl4mhob18.myregisteredsite.com (atl4mhob18.myregisteredsite.com. [209.17.115.111])
        by mx.google.com with ESMTP id 4si10409743qku.71.2015.05.18.22.47.25
        for <larry.finger@gmail.com>;
        Mon, 18 May 2015 22:47:26 -0700 (PDT)
Received-SPF: softfail (google.com: domain of transitioning haggai.eran@gmail.com does not designate 209.17.115.111 as permitted sender) client-ip=209.17.115.111;
Authentication-Results: mx.google.com;
       spf=softfail (google.com: domain of transitioning haggai.eran@gmail.com does not designate 209.17.115.111 as permitted sender) smtp.mail=haggai.eran@gmail.com;
       dkim=pass header.i=@gmail.com;
       dmarc=pass (p=NONE dis=NONE) header.from=gmail.com
Received: from mail.hostingplatform.com ([10.30.71.46])
	by atl4mhob18.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t4J5lMQg019795
	for <larry.finger@gmail.com>; Tue, 19 May 2015 01:47:22 -0400
Received: (qmail 1567 invoked by uid 78); 19 May 2015 05:47:22 -0000
Delivered-To: lwfinger.net-Larry.Finger@lwfinger.net
Received: (qmail 1561 invoked by uid 0); 19 May 2015 05:47:22 -0000
Received: from unknown (HELO atl4mhib20.myregisteredsite.com) (209.17.115.155)
  by 0 with SMTP; 19 May 2015 05:47:22 -0000
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
	by atl4mhib20.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t4J5lKf3002256
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=OK)
	for <Larry.Finger@lwfinger.net>; Tue, 19 May 2015 01:47:21 -0400
Received: by wgbgq6 with SMTP id gq6so4593334wgb.3
        for <Larry.Finger@lwfinger.net>; Mon, 18 May 2015 22:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=oWBsgvRoLBpwQaZnGY5Ie4JVgHGwjAGe2u5YHbwsqwI=;
        b=m2VDk+dk18/ma6Z2EVonUcvbcCDBNraJdiiDg1hfcJfGAjh0c4Bf/+KrETkghZ6MAO
         WND9oBUqnpFCFYdSLtOQF2MsOXTknU1UayBFcDBTygc72n8Cz1xYQaFR9kwX+59ig5M6
         L/RSy6+Ka8hqO7I7Bw9ha0oORt121owC/QIvLQCN4J+aeIfSQMj7IgaRYFq6UNY1sg7j
         AlGGswwG0BA6T4kNb3eu9n1V+ENn4lc2qrmPRlucJXZyK7+WbB/VLmTc0yzjrb0q4Cw/
         4dbCzegSVYYOwDG1FBMgygf94fyHx/VQ8Yn6GCsQ3ByJtLuJzXDwgjBJEAdVqQVIHI7Y
         5MXg==
X-Received: by 10.180.230.199 with SMTP id ta7mr14748321wic.1.1432014439599;
        Mon, 18 May 2015 22:47:19 -0700 (PDT)
Received: from localhost.localdomain ([46.121.82.195])
        by mx.google.com with ESMTPSA id 9sm20018034wjr.11.2015.05.18.22.47.15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 May 2015 22:47:18 -0700 (PDT)
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Haggai Eran <haggai.eran@gmail.com>
Subject: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
Date: Tue, 19 May 2015 08:47:24 +0300
Message-Id: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
X-Mailer: git-send-email 1.9.1
X-SpamScore: -0.1
X-MailHub-Apparently-To: Larry.Finger@lwfinger.net

With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
packet are set, but the packet length is too large. Truncate the packet
to prevent memory corruption.

Signed-off-by: Haggai Eran <haggai.eran@gmail.com>
---

Hi,

I think this solves the issue for me. I'll test it more thoroughly later. I
still don't know why a fragmented packet has such a large pkt_len value though. 

Thanks,
Haggai

 drivers/staging/rtl8712/rtl8712_recv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index cd8b444..d7ea9c1 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1055,8 +1055,12 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		pkt_offset = (u16)round_up(tmp_len, 128);
 		/* for first fragment packet, driver need allocate 1536 +
 		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
-		if ((mf == 1) && (frag == 0))
+		if ((mf == 1) && (frag == 0)) {
 			alloc_sz = 1658;/*1658+6=1664, 1664 is 128 alignment.*/
+            if (tmp_len > alloc_sz) {
+                tmp_len = alloc_sz;
+            }
+        }
 		else
 			alloc_sz = tmp_len;
 		/* 2 is for IP header 4 bytes alignment in QoS packet case.
-- 
1.9.1



--------------010602080500000309090200--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:40072 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751970Ab3IQIuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 04:50:44 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 01923-06 for <linux-wireless@vger.kernel.org>;
 Tue, 17 Sep 2013 09:50:43 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Subject: RE: [PATCH 8/8 V2] rtlwifi: Remove variable 'noise' from rtl_stats struct
Date: Tue, 17 Sep 2013 09:48:22 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7340@saturn3.aculab.com> (sfid-20130917_105047_874905_68916F24)
In-Reply-To: <1379357722-17687-9-git-send-email-Larry.Finger@lwfinger.net>
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-9-git-send-email-Larry.Finger@lwfinger.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Larry Finger" <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
> index cc03e7c..284ee8d 100644
> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -1535,7 +1535,6 @@ struct rtl_stats {
>  	u32 mac_time[2];
>  	s8 rssi;
>  	u8 signal;
> -	u8 noise;
>  	u8 rate;		/* hw desc rate */
>  	u8 received_channel;
>  	u8 control;
> --

Is 'struct rtl_stats' exposed to userspace?
(or even to loadable drivers)
If so you probably ought to replace 'noise' with an explicit
pad in order to avoid changing the offsets of the other fields.

	David




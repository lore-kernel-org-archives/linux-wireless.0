Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from telegweb.telechips.com ([219.240.43.111]:44712 "EHLO
	sfilter.telechips.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3AYBoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 20:44:10 -0500
Received: from [219.240.43.118] ([219.240.43.118])
          by sfilter.telechips.com ([219.240.43.111])
          with ESMTP id 1359077031.982571.3018754992.sfilter
          for <linux-wireless@vger.kernel.org>;
          Fri, 25 Jan 2013 10:23:51 +0900 (KST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Subject: RE: [question] how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?
Date: Fri, 25 Jan 2013 10:47:39 +0900
Message-ID: <F4F751F96C54D346898D4C77E196E3DB0A3F6CDE@telegweb.telechips.com> (sfid-20130125_024420_066351_1BB8AEB6)
In-Reply-To: <510160FA.2020002@lwfinger.net>
References: <F4F751F96C54D346898D4C77E196E3DB0A3F6C6D@telegweb.telechips.com> <510160FA.2020002@lwfinger.net>
From: =?ks_c_5601-1987?B?seK787/4IChTVyBLaSk=?= <oprsystem@telechips.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Larry Finger.

below log message show the our problem for detailed.
you can find the our DMA address 32bit align problem in 2nd paragraph after association packet dump of 1st paragraph.
in authentication packet dump log message, skb->data address is 0xC0A5E580 that is aligned of 32bit.
but, in association packet dump log message, skb->data address is 0xC098800E that is not aligned of 32bit. 
just aligned of 16bit.

our dma controller can accept the only 32bit aligned address for transferring.
I'd like to know a good way to solve my problem.

wlan0: SME: Trying to authenticate with 00:50:43:21:22:2b (SSID='MarvellAP' freq=2442 MHz)
0xC0A5E580: B0 00 00 00 00 50 43 21 22 2B 00 01 02 03 04 05  .....PC!"+......
0xC0A5E680: 00 50 43 21 22 2B 00 00 00 00 01 00 00 00 01 00  .PC!"+..........
0xC0A5E780: 00 00


wlan0: Trying to associate with 00:50:43:21:22:2b (SSID='MarvellAP' freq=2442 MHz)
0xC098800E: 00 00 00 00 00 50 43 21 22 2B 00 01 02 03 04 05  .....PC!"+......
0xC098810E: 00 50 43 21 22 2B F0 02 21 04 05 00 00 09 4D 61  .PC!"+..!.....Ma
0xC098820E: 72 76 65 6C 6C 41 50 01 08 02 04 0B 16 0C 12 18  rvellAP.........
0xC098830E: 24 32 04 30 48 60 6C 2D 1A 2C 00 1B FF 00 00 00  $2.0H`l-.,......
0xC098840E: 00 00 00 00


thanks, best regards,
sangwon,ki

-----Original Message-----
From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
Sent: Friday, January 25, 2013 1:28 AM
To: 기상원 (SW Ki)
Cc: linux-wireless@vger.kernel.org
Subject: Re: [question] how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?

On 01/24/2013 05:58 AM, 기상원 (SW Ki) wrote:
> hello everyone.
> 
> i have question. i want to use DMA for the 'data' field of sk_buff structure.
> but sometimes, the 'data' field of sk_buff structure is not 32bit aligned.
> so, how can i make to 32bit aligned address for the 'data' field of sk_buff structure ?

A standard sk_buff should meet all the alignment requirements for your architecture. Could you provide more details about your architecture and an example where the sk_buff does not have the correct alignment?

Larry







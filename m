Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:41612 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZDCLr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 07:47:58 -0400
Received: by yw-out-2324.google.com with SMTP id 5so936867ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 04:47:56 -0700 (PDT)
Message-ID: <49D5F769.4020808@gmail.com> (sfid-20090403_134800_584641_2FFFF0A9)
Date: Fri, 03 Apr 2009 07:47:53 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [Fwd: Re: Trouble Associating with ath5k on AR5212]
Content-Type: multipart/mixed;
 boundary="------------030900010003010201070504"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030900010003010201070504
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Forwarding back to the list, as I was silly and sent as HTML originally...

-------- Original Message --------
Bob Copeland wrote:
> On Thu, Apr 02, 2009 at 09:20:05PM -0400, Will Keaney wrote:
>   
>> For what it's worth, I have also tried using iwconfig to associate to
>> the neighbor's network under ath5k without success.  So I don't think
>> it's related to wpa_supplicant's scanning algorithm.
>>     
>
> Well it's a long shot but I thought I'd mention it because I had
> very similar results due to long scans, where wpa_supplicant would
> time out and fail associations.  
>
> Try 'dmesg -n 7', then capture the output of dmesg while trying to
> associate, that should show the reason (CONFIG_PRINTK_TIME=y is helpful
> too). 
>   
dmesg shows this:
[38645.639170] ath5k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[38645.639199] ath5k 0000:03:00.0: setting latency timer to 64
[38645.639342] ath5k 0000:03:00.0: registered as 'phy5'
[38645.872038] phy5: Selected rate control algorithm 'minstrel'
[38645.882037] Registered led device: ath5k-phy5::rx
[38645.882090] Registered led device: ath5k-phy5::tx
[38645.882097] ath5k phy5: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
[38646.133614] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[38667.211026] ath5k phy5: noise floor calibration timeout (5785MHz)

I think the key there is the last line.  There is no further output in 
dmesg, regardless of what I do in wpa_supplicant.

Thanks,

Will Keaney

--------------030900010003010201070504
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyLjAuMTEg
KEdOVS9MaW51eCkNCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6
Ly9lbmlnbWFpbC5tb3pkZXYub3JnDQoNCmlFWUVBUkVDQUFZRkFrblZjYnNBQ2drUWpmYXlX
Q0E4ZERFOFN3Q2ZZbXB1dkYxNUh5UW1EVC8xa3Iva3pDWEsNCk5Hb0FuMXl0aExtZDhiV2hR
UEZQYTdHNUtseGxlNXBNDQo9V3JHWg0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQoN
Cg==
--------------030900010003010201070504--

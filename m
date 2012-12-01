Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ndb-mr1.cc.emory.edu ([170.140.52.40]:55935 "EHLO
	ndb-mr1.cc.emory.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2LAPnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 10:43:24 -0500
Received: from mail-la0-f46.google.com (emoryfloatdmz.cc.emory.edu [170.140.52.254])
	(authenticated bits=0)
	by ndb-mr1.cc.emory.edu (8.13.8/8.13.8) with ESMTP id qB1FUlqK005466
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sat, 1 Dec 2012 10:30:48 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1131345lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2012 07:30:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG5aqJVw8Sw9PWAfG_cr0i9LcFvrJkuCje5G0x_Q8HBuL5XiPg@mail.gmail.com>
References: <CAG5aqJX6h7-aOBrq5pTNfBru7zmZji8hO+JqRC3eN0uXthAbLw@mail.gmail.com>
 <CAG5aqJV62_8eFJNQx=8R9gTYCRR4RbiaUks48oPRNm-Pq5DO=A@mail.gmail.com>
 <CAG5aqJWdxLf3X1+DsEiz4cpSnfo7JMsuEsMYPND8TPhUVag-Ww@mail.gmail.com>
 <50B946D9.6010902@lwfinger.net> <CAG5aqJVw8Sw9PWAfG_cr0i9LcFvrJkuCje5G0x_Q8HBuL5XiPg@mail.gmail.com>
From: =?UTF-8?Q?Cengiz_G=C3=BCnay?= <cgunay@emory.edu>
Date: Sat, 1 Dec 2012 07:30:27 -0800
Message-ID: <CAG5aqJVeBjvnFVxMs5+AGP4cgwE_GRfu_d+Yjim4fwReDxjKkA@mail.gmail.com> (sfid-20121201_164331_269508_72238450)
Subject: Re: rtl8723e droping the AP continuously for low signals; is there a
 threshold parameter?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wlanfae <wlanfae@realtek.com>, linux-wireless@vger.kernel.org,
	lizhaoming <chaoming_li@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 1, 2012 at 7:07 AM, Cengiz Günay > I tried setting ips=0
> # modprobe -v rtl8723e ips=0
> insmod /lib/modules/3.4-trunk-amd64/kernel/drivers/net/wireless/rtlwifi/rtl8723e/rtl8723e.ko
> ips=0
>
> I still see drops, but I feel the connections is much more stable (I
> was able to see a youtube video without interruption somehow):
> # dmesg | grep lost | tail -5
> [ 2945.567620] wlan0: Connection to AP [snip] lost.
> [ 2949.565782] wlan0: Connection to AP [snip] lost.
> [ 2954.555432] wlan0: Connection to AP [snip] lost.
> [ 2972.499182] wlan0: Connection to AP [snip] lost.
> [ 3156.474054] wlan0: Connection to AP [snip] lost.

To quantify the "feeling of improvement", I calculated MTBF before and after:

Before setting ips=0:
# dmesg | grep lost | head -20 | awk 'BEGIN{printf "tf = [ "} {printf
$1 $2 " "} END{print "]; tbfs = diff(tf); mtbf=mean(tbfs),
stdbf=std(tbfs)"}' | octave -q
mtbf =  20.044
stdbf =  10.249

After setting ips=0:
# dmesg | grep lost | tail -20 | awk 'BEGIN{printf "tf = [ "} {printf
$1 $2 " "} END{print "]; tbfs = diff(tf); mtbf=mean(tbfs),
stdbf=std(tbfs)"}' | octave -q
mtbf =  65.917
stdbf =  43.618

There is definitely an improvement in MTBF from 20 to 65 s!
-Cengiz

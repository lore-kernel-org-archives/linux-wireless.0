Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm27.bullet.mail.ne1.yahoo.com ([98.138.90.90]:30963 "EHLO
	nm27.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbaA0V1K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 16:27:10 -0500
References: <52DF947E.40800@gmail.com>	<CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>	<CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>	<52E0BA40.7090203@gmail.com>	<CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>	<52E0D7D5.6060504@gmail.com>	<CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>	<CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com>	<CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>	<CABPxzYLJwyXA+XZ+nHzoCZrSo99joTfhP7iQUbWMfcw403H_WA@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com>,<CANUX_P2LODJOk3R+oZ-1LHPJiAS22niV4hW904QAqT-3KYxiTw@mail.gmail.com> <DE84205DFC6FCF4A904A2F75D822FABA558C3E9D@ALA-MBB.corp.ad.wrs.com>
Message-ID: <1390857716.85513.YahooMailNeo@web122305.mail.ne1.yahoo.com> (sfid-20140127_222732_275674_13B09F14)
Date: Mon, 27 Jan 2014 13:21:56 -0800 (PST)
From: Anand Moon <moon.linux@yahoo.com>
Reply-To: Anand Moon <moon.linux@yahoo.com>
Subject: Re: 802.11a is supported in AP mode or not?
To: "Liu, Bopeng" <Bopeng.Liu@windriver.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C3E9D@ALA-MBB.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

Prerequisite:

iw list

If there is 'AP' in the list of "Supported interface modes" your device will support the Access Point mode with hostapd. 

Second if the interface is supporting 2.4 GHz then you cannot get the support for 802.11a which supports 5 GHz.
Change the hw_mode=a to hw_mode=g

To configure AP:.....
Bring the interface down
Set the interface to master mode

#ifconfig wlan0 down
#iw dev wlan0 set type managed
#ifconfig wlan0 up
# hostapd -B /tmp/hostapd.conf -dd

It worked for me, I was able to connect to this AP.

If the interface support dual band, then you need to set the freq to 5Ghz of the interface.

-Anand Moon

-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.14 (GNU/Linux)
jA0EAwMCYq3dHqTzwcVgyRxC1j+ oLxS8Yw92EIeKln+x3eAWzd7mM/ pUluRo
=0RYk
-----END PGP MESSAGE-----



On Friday, January 24, 2014 1:35 PM, "Liu, Bopeng" <Bopeng.Liu@windriver.com> wrote:
I just check the chip 6205's spec. it said it supports the SoftAP with Mode A, who can tell me what is the soft AP?


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________

From: Emmanuel Grumbach [egrumbach@gmail.com]
Sent: Thursday, January 23, 2014 5:49 PM
To: Liu, Bopeng
Cc: Krishna Chaitanya; zhuyj; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 11:34 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> But very pity, when running on the AP mode:wlan0     IEEE 802.11abgn  is the same....
>
> ~# iwconfig wlan0
> wlan0     IEEE 802.11abgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=15 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
>

cool - just send a patch to fix iwconfig, but this tool is ancient and
I doubt anybody even cares.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

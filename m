Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm27-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.215]:31952 "EHLO
	nm27-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbaA0V7e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 16:59:34 -0500
References: <52DF947E.40800@gmail.com>	<CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>	<CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>	<52E0BA40.7090203@gmail.com>	<CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>	<52E0D7D5.6060504@gmail.com>	<CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>	<CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com>	<CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>	<CABPxzYLJwyXA+XZ+nHzoCZrSo99joTfhP7iQUbWMfcw403H_WA@mail.gmail.com>	<DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com>,<CANUX_P2LODJOk3R+oZ-1LHPJiAS22niV4hW904QAqT-3KYxiTw@mail.gmail.com> <DE84205DFC6FCF4A904A2F75D822FABA558C3E9D@ALA-MBB.corp.ad.wrs.com> <1390857716.85513.YahooMailNeo@web122305.mail.ne1.yahoo.com>
Message-ID: <1390859973.97460.YahooMailNeo@web122305.mail.ne1.yahoo.com> (sfid-20140127_225939_185420_E8E53B54)
Date: Mon, 27 Jan 2014 13:59:33 -0800 (PST)
From: Anand Moon <moon.linux@yahoo.com>
Reply-To: Anand Moon <moon.linux@yahoo.com>
Subject: Re: 802.11a is supported in AP mode or not?
To: Anand Moon <moon.linux@yahoo.com>,
	"Liu, Bopeng" <Bopeng.Liu@windriver.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1390857716.85513.YahooMailNeo@web122305.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

If you change the frequency of the interface it should work

root@moon-ubuntu:~# ifconfig wlan0 down
root@moon-ubuntu:~# iw dev wlan0 set freq 5180 HT20
root@moon-ubuntu:~# iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:off/any
          Mode:Managed  Frequency:5.18 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
root@moon-ubuntu:~# ifconfig wlan0 up

Now I modified the hostapd.conf

hw_mode=a
channel=36

It worked for me.

-Anand Moon

-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.14 (GNU/Linux)
jA0EAwMCYq3dHqTzwcVgyRxC1j+ oLxS8Yw92EIeKln+x3eAWzd7mM/ pUluRo
=0RYk
-----END PGP MESSAGE-----

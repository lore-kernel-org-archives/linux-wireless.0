Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39234 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab3LCVVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 16:21:51 -0500
Message-Id: <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com> (sfid-20131203_222155_159121_D6B191DB)
From: "Nikita N." <nikitan@operamail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="_----------=_138610571094420";
 charset="utf-8"
Subject: Re: RTL8187 bugs
Date: Tue, 03 Dec 2013 13:21:50 -0800
In-Reply-To: <529E0166.90302@lwfinger.net>
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com>
 <52966D64.2030805@lwfinger.net>
 <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com>
 <52968893.6060405@lwfinger.net>
 <1385812990.14905.53777877.7646278B@webmail.messagingengine.com>
 <529A1B52.6040605@lwfinger.net>
 <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
 <529A36C5.4060209@lwfinger.net>
 <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
 <529E0166.90302@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--_----------=_138610571094420
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Ok Larry, I try again :)
I have been filling your code with debug lines. Very interesting in my
opinion is the report from
drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_configure_filter(),
as follows:

drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_configure_filter
IN>changed_flags=f0:00:00:00 ,total_flags=f0:00:00:80
,multicast=00:00:00:00:00:00:00:00 ,priv->rx_conf=0a:fc:94:90
>FIF_CONTROL
>FIF_OTHER_BSS
>not FIF_ALLMULTI
drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl818x_iowrite32_async
OUT>total_flags=60:00:00:00 ,priv->rx_conf=0b:fc:9c:90

.. which pops in dmesg just after running "airmon-ng start wlan0" for
the first time.
.. after, maybe some daemon, calls it again multiple times, but debug
report is always the same as follows:

IN>changed_flags=90:00:00:00 ,total_flags=f0:00:00:80
,multicast=00:00:00:00:00:00:00:00 ,priv->rx_conf=0b:fc:9c:90
>not FIF_ALLMULTI
drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl818x_iowrite32_async
OUT>total_flags=60:00:00:00 ,priv->rx_conf=0b:fc:9c:90

.. seeing anything suspect??

I have the feeling that first "IN" value of priv->rx_conf could be
bugged.. as result the relative OUT value sent to eeprom is maybe
wrong.. :P

Could you please perform the same test on your working interfaces, and
report me the output?
If you get different output than mine, please send me all outputs, even
if it differs also between your working interfaces.
Here in attach the patch file as requested, its a very simple debug
patch, and you can apply to any backports/compat version you prefer,
latest included.
Just make install, plug the interface, run "airmon-ng start wlan0", and
collect the output from dmesg.

FYI, from probe, my interface type should be as follow:
- RTL8187vB (default) V1
- PCI_EEPROM_WIDTH_93C46
- customer id 0

Thanks :)

On Tue, Dec 3, 2013, at 08:05 AM, Larry Finger wrote:

> If you want me to test anything, you need to send me patches that I can
> apply. 
> Having to regenerate your patches here is something I have no interest in
> doing.

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own


--_----------=_138610571094420
Content-Disposition: attachment; filename="nikita8187.patch"
Content-Id: <1386104587.897.98f4b090b8da2bcdb17265db631dd48cdd1b7e59.43298D6B@messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="nikita8187.patch"

LS0tIGJhY2twb3J0cy0zLjEzLXJjMi0xL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0bDgxOHgvcnRsODE4Ny9kZXYuYwlTYXQgTm92IDMwIDIyOjMxOjQ1IDIw
MTMNCisrKyBiYWNrcG9ydHMtbmlraXRhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0bDgxOHgvcnRsODE4Ny9kZXYuYwlUdWUgRGVjIDAzIDE4OjI3OjQxIDIw
MTMNCkBAIC0xMzEzLDE4ICsxMzEzLDMyIEBADQogCQkJCSAgICAgdW5zaWdu
ZWQgaW50ICp0b3RhbF9mbGFncywNCiAJCQkJICAgICB1NjQgbXVsdGljYXN0
KQ0KIHsNCitwcmludGsoS0VSTl9XQVJOSU5HICJkcml2ZXJzL25ldC93aXJl
bGVzcy9ydGw4MTh4L3J0bDgxODcvZGV2LmMjcnRsODE4N19jb25maWd1cmVf
ZmlsdGVyIik7DQorDQorDQogCXN0cnVjdCBydGw4MTg3X3ByaXYgKnByaXYg
PSBkZXYtPnByaXY7DQorLy9uaWtpdGENCit1bnNpZ25lZCBjaGFyICphPSZj
aGFuZ2VkX2ZsYWdzOw0KK3Vuc2lnbmVkIGNoYXIgKmI9dG90YWxfZmxhZ3M7
DQordW5zaWduZWQgY2hhciAqYz0mbXVsdGljYXN0Ow0KK3Vuc2lnbmVkIGNo
YXIgKmQ9JnByaXYtPnJ4X2NvbmY7DQorcHJpbnRrKEtFUk5fV0FSTklORyAi
SU4+Y2hhbmdlZF9mbGFncz0lMDJ4OiUwMng6JTAyeDolMDJ4ICx0b3RhbF9m
bGFncz0lMDJ4OiUwMng6JTAyeDolMDJ4ICxtdWx0aWNhc3Q9JTAyeDolMDJ4
OiUwMng6JTAyeDolMDJ4OiUwMng6JTAyeDolMDJ4ICxwcml2LT5yeF9jb25m
PSUwMng6JTAyeDolMDJ4OiUwMngiLGFbMF0sYVsxXSxhWzJdLGFbM10sYlsw
XSxiWzFdLGJbMl0sYlszXSxjWzBdLGNbMV0sY1syXSxjWzNdLGNbNF0sY1s1
XSxjWzZdLGNbN10sZFswXSxkWzFdLGRbMl0sZFszXSk7DQogDQotCWlmIChj
aGFuZ2VkX2ZsYWdzICYgRklGX0ZDU0ZBSUwpDQorCWlmIChjaGFuZ2VkX2Zs
YWdzICYgRklGX0ZDU0ZBSUwpIHsNCiAJCXByaXYtPnJ4X2NvbmYgXj0gUlRM
ODE4WF9SWF9DT05GX0ZDUzsNCi0JaWYgKGNoYW5nZWRfZmxhZ3MgJiBGSUZf
Q09OVFJPTCkNCitwcmludGsoS0VSTl9XQVJOSU5HICI+RklGX0ZDU0ZBSUwi
KTt9DQorCWlmIChjaGFuZ2VkX2ZsYWdzICYgRklGX0NPTlRST0wpIHsNCiAJ
CXByaXYtPnJ4X2NvbmYgXj0gUlRMODE4WF9SWF9DT05GX0NUUkw7DQotCWlm
IChjaGFuZ2VkX2ZsYWdzICYgRklGX09USEVSX0JTUykNCitwcmludGsoS0VS
Tl9XQVJOSU5HICI+RklGX0NPTlRST0wiKTt9DQorCWlmIChjaGFuZ2VkX2Zs
YWdzICYgRklGX09USEVSX0JTUykgew0KIAkJcHJpdi0+cnhfY29uZiBePSBS
VEw4MThYX1JYX0NPTkZfTU9OSVRPUjsNCi0JaWYgKCp0b3RhbF9mbGFncyAm
IEZJRl9BTExNVUxUSSB8fCBtdWx0aWNhc3QgPiAwKQ0KK3ByaW50ayhLRVJO
X1dBUk5JTkcgIj5GSUZfT1RIRVJfQlNTIik7fQ0KKwlpZiAoKnRvdGFsX2Zs
YWdzICYgRklGX0FMTE1VTFRJIHx8IG11bHRpY2FzdCA+IDApIHsNCiAJCXBy
aXYtPnJ4X2NvbmYgfD0gUlRMODE4WF9SWF9DT05GX01VTFRJQ0FTVDsNCi0J
ZWxzZQ0KK3ByaW50ayhLRVJOX1dBUk5JTkcgIj5GSUZfQUxMTVVMVEkiKTt9
DQorZWxzZSB7DQogCQlwcml2LT5yeF9jb25mICY9IH5SVEw4MThYX1JYX0NP
TkZfTVVMVElDQVNUOw0KK3ByaW50ayhLRVJOX1dBUk5JTkcgIj5ub3QgRklG
X0FMTE1VTFRJIik7fQ0KIA0KIAkqdG90YWxfZmxhZ3MgPSAwOw0KIA0KQEAg
LTEzMzgsNiArMTM1Miw4IEBADQogCQkqdG90YWxfZmxhZ3MgfD0gRklGX0FM
TE1VTFRJOw0KIA0KIAlydGw4MTh4X2lvd3JpdGUzMl9hc3luYyhwcml2LCAm
cHJpdi0+bWFwLT5SWF9DT05GLCBwcml2LT5yeF9jb25mKTsNCisvL25pa2l0
YQ0KK3ByaW50ayhLRVJOX1dBUk5JTkcgIk9VVD50b3RhbF9mbGFncz0lMDJ4
OiUwMng6JTAyeDolMDJ4ICxwcml2LT5yeF9jb25mPSUwMng6JTAyeDolMDJ4
OiUwMngiLGJbMF0sYlsxXSxiWzJdLGJbM10sZFswXSxkWzFdLGRbMl0sZFsz
XSk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgcnRsODE4N19jb25mX3R4KHN0cnVj
dCBpZWVlODAyMTFfaHcgKmRldiwNCg==

--_----------=_138610571094420--


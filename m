Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.ird.yahoo.com ([77.238.189.221]:37943 "HELO
	nm20-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751947Ab3LEQmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:42:20 -0500
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>		 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>	 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com> <1386260744.4182.18.camel@jlt4.sipsolutions.net>
Message-ID: <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com> (sfid-20131205_174224_238705_AAC4F9E9)
Date: Thu, 5 Dec 2013 16:42:18 +0000 (GMT)
From: Dani Camps <danicamps81@yahoo.com>
Reply-To: Dani Camps <danicamps81@yahoo.com>
Subject: Re: Using wmediumd in kernel 3.10
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1386260744.4182.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="828929822-1736292711-1386261738=:73311"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--828929822-1736292711-1386261738=:73311
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

=0A=0AHi Johannes,=0A=0AI attach the script that I am using to load mac8021=
1_hwsim. What you need to do is:=0A=0A1) Execute the script to load two mes=
h interfaces mesh0 and mesh1.=0A2) Load wmediumd (the version in GitHub:=A0=
https://github.com/cozybit/wmediumd), and use as config file the file that =
I am attaching.=0A3) Ping from mesh0 to mesh1: ping -I mesh0 192.168.77.11=
=0A=0AYou will see in syslog a kernel crash, followed by mac80211_hwsim der=
egistering the netlink socket. Then the ping proceeds normally because wmed=
iumd is dettached.=0A=0AThanks for your help!=0A=0ACheers=0A=0ADaniel=0A=0A=
=0A=0A=0A=0A=0AEl Jueves 5 de diciembre de 2013 17:25, Johannes Berg <johan=
nes@sipsolutions.net> escribi=F3:=0AOn Thu, 2013-12-05 at 16:14 +0000, Dani=
 Camps wrote:=0A=0A> I am only loading mac80211_hwsim with the parameter "r=
adios=3D2". I am=0A> not specifying anything about "channels", which lookin=
g at the code=0A> should be 1.=0A=0AOk. What's the easiest way to reproduce=
 this? Do I need=0Ahostapd/wpa_supplicant and wmediumd, or something else?=
=0A=0A=0Ajohannes
--828929822-1736292711-1386261738=:73311
Content-Type: text/plain; name="script.sh.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="script.sh.txt"

DQojIyMjIyMjIyMjIyMjIyMgIw0KIyBDb25maWd1cmF0aW9uICMNCiMjIyMj
IyMjIyMjIyMjIyMjDQpOVU1fUkFESU9TPTINCg0Kc3VkbyBtb2Rwcm9iZSBt
YWM4MDIxMQ0Kc3VkbyBtb2Rwcm9iZSBtYWM4MDIxMV9od3NpbSBjaGFubmVs
cz0xIHJhZGlvcz0kTlVNX1JBRElPUw0KDQplY2hvICItPiBNb2R1bGVzIGxv
YWRlZCINCnNsZWVwIDINCg0KIyBQcmVwYXJlIGlwIHJ1bGVzIGZvciBzZW5k
LXRvLXNlbGYNCmlwIHJ1bGUgZmx1c2gNCmlwIHJ1bGUgZGVsIHByZWYgICAw
IGxvb2t1cCBsb2NhbA0KaXAgcnVsZSBhZGQgcHJlZiA1MDAwIGxvb2t1cCBs
b2NhbA0KaXAgcnVsZSBhZGQgcHJlZiAzMjc2NiBsb29rdXAgbWFpbg0KaXAg
cnVsZSBhZGQgcHJlZiAzMjc2NyBsb29rdXAgZGVmYXVsdA0KDQojQ29uZmln
dXJlIHRoZSBtZXNoIGludGVyZmFjZXMNClBIWVM9YGZpbmQgL3N5cy9rZXJu
ZWwvZGVidWcvaWVlZTgwMjExIC1uYW1lIGh3c2ltIHwgY3V0IC1kLyAtZiA2
IHwgc29ydGANCmk9MA0KZm9yIHBoeSBpbiAke1BIWVN9OyBkbw0KDQogICAg
ICAgICNDb25maWd1cmUgdGhlIG1lc2ggaW50ZXJmYWNlDQogICAgICAgIGl3
IHBoeSAke3BoeX0gaW50ZXJmYWNlIGFkZCBtZXNoJGkgdHlwZSBtcCBtZXNo
X2lkIGJhem9va2ENCiAgICAgICAgaXAgYWRkcmVzcyBhZGQgMTkyLjE2OC43
Ny4xJGkvMjQgZGV2IG1lc2gkaQ0KICAgICAgICBpcCBsaW5rIHNldCBtZXNo
JGkgdXANCg0KICAgICAgICBpPSQoKCRpKzEpKQ0KDQpkb25lDQoNCiNDb25m
aWd1cmUgdGhlIElQIHJ1bGVzIHJlcXVpcmVkIHRvIGltcGxlbWVudCBzZW5k
LXRvLXNlbGYNCmZvciBpIGluICQoc2VxIDAgJCgoJE5VTV9SQURJT1MgLSAx
KSkpOyBkbw0KDQogICAgICAgICNydWxlIGZvciBpbmNvbWluZyBwYWNrZXRz
IG9uIGVhY2ggaW50ZXJmYWNlIC0tPiBnbyB0byBsb2NhbCB0YWJsZQ0KICAg
ICAgICBpcCBydWxlIGFkZCBwcmVmICQoKCRpKzEwKSkgaWlmIG1lc2gkaSBs
b29rdXAgbG9jYWwNCg0KICAgICAgICAjY3JlYXRlIGEgcnVsZSBmb3IgZWFj
aCBwYWlyIGktPmogdG8gcG9pbnQgdG8gdGFibGUgaS0+aiB3aGVyZSB0aGUg
ZGVmYXVsdCBkZXZpY2UgaXMgbWVzaCRqLiBUaGlzIGVuc3VyZXMgdCQNCiAg
ICAgICAgZm9yIGogaW4gJChzZXEgMCAkKCgkTlVNX1JBRElPUyAtIDEpKSk7
IGRvDQogICAgICAgICAgICAgICAgaWYgWyAiJGoiIC1uZSAiJGkiIF07IHRo
ZW4NCiAgICAgICAgICAgICAgICAgICAgICAgICN0YWJsZV9pZHg9JCgoJGor
KCRpKzEpKjEwMCkpDQogICAgICAgICAgICAgICAgICAgICAgICB0YWJsZV9p
ZHg9JCgoJGorMTAwKSkNCiAgICAgICAgICAgICAgICAgICAgICAgICN0YWJs
ZV9wcmlvPSR0YWJsZV9pZHgNCiAgICAgICAgICAgICAgICAgICAgICAgIHRh
YmxlX3ByaW89JCgoJGorKCRpKzEpKjEwMCkpDQogICAgICAgICAgICAgICAg
ICAgICAgICBpcCBydWxlIGFkZCBwcmVmICR0YWJsZV9wcmlvIGZyb20gMTky
LjE2OC43Ny4xJGogdG8gMTkyLjE2OC43Ny4xJGkgbG9va3VwICR0YWJsZV9p
ZHgNCiAgICAgICAgICAgICAgICAgICAgICAgIGlwIHJvdXRlIGZsdXNoIHRh
YmxlICR0YWJsZV9pZHgNCiAgICAgICAgICAgICAgICAgICAgICAgIGlwIHJv
dXRlIGFkZCBkZWZhdWx0IGRldiBtZXNoJGogdGFibGUgJHRhYmxlX2lkeA0K
ICAgICAgICAgICAgICAgIGZpDQogICAgICAgIGRvbmUNCiAgICAgICAgZWNo
byAxID4vcHJvYy9zeXMvbmV0L2lwdjQvY29uZi9tZXNoJGkvYWNjZXB0X2xv
Y2FsDQoNCmRvbmUNCg0KIyBCcmluZ2luZyB1cCBod3NpbTAsIG90aGVyd2lz
ZSB0aGUgcGFja2V0cyBkbyBub3QgZmxvdyB0aHJvdWdoIG1hYzgwMjExX2h3
c2ltDQppZmNvbmZpZyBod3NpbTAgdXANCg0K

--828929822-1736292711-1386261738=:73311
Content-Type: text/plain; name="wmediumd_config_file.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="wmediumd_config_file.txt"

DQppZmFjZXMgOg0Kew0KICAgICAgICBjb3VudCA9IDI7DQogICAgICAgIGlk
cyA9IFsiNDI6MDA6MDA6MDA6MDA6MDAiLCAiNDI6MDA6MDA6MDA6MDE6MDAi
IF07DQp9Ow0KcHJvYiA6DQp7DQogICAgICAgIHJhdGVzID0gMTI7DQogICAg
ICAgIG1hdHJpeF9saXN0ID0gKA0KICAgICAgICAgICAgICAgIFsgLTEuMDAw
LCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAgICAgICAgIFsg
LTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAgICAg
ICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAg
ICAgICAgICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0K
ICAgICAgICAgICAgICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAw
MCBdLA0KICAgICAgICAgICAgICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAs
IC0xLjAwMCBdLA0KICAgICAgICAgICAgICAgIFsgLTEuMDAwLCAwLjUwMCwg
MC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAgICAgICAgIFsgLTEuMDAwLCAw
LjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAgICAgICAgIFsgLTEu
MDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAgICAgICAg
IFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAgICAgICAg
ICAgICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBdLA0KICAg
ICAgICAgICAgICAgIFsgLTEuMDAwLCAwLjUwMCwgMC41MDAsIC0xLjAwMCBd
DQogICAgICAgICk7DQp9Ow0KDQo=

--828929822-1736292711-1386261738=:73311--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ird.yahoo.com ([77.238.189.215]:20424 "HELO
	nm18-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752142Ab2GZOtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 10:49:52 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net>
Message-ID: <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> (sfid-20120726_164956_508558_2E89D1F1)
Date: Thu, 26 Jul 2012 15:49:50 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <501129D9.4060407@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="542325855-1908882459-1343314190=:31952"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--542325855-1908882459-1343314190=:31952
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

In my case, I don't have a dhcp server but I use isc-dhcp-relay in order to=
 reuse my master DHCP server for wireless endpoints. The advantage over one=
 single point of control is that fixed and wireless endpoints will share th=
e same network 192.168.0/24.=0A=0A/etc/default/isc-dhcp-relay=0A=A0 #=A0Wha=
t servers should the DHCP relay forward requests to?=0A=A0 SERVERS=3D"192.1=
68.0.254"=0A=A0 # On what interfaces should the DHCP relay (dhrelay) serve =
DHCP requests?=0A=0A=A0 INTERFACES=3D"wlan0"=0A=A0 # Additional options tha=
t are passed to the DHCP relay daemon?=0A=0A=A0 OPTIONS=3D"-d"=0A=0AHere ar=
e the results when using Larry's script:=0A=0Asudo ./control_ap.sh start wl=
an0 eth0=0A=0AStarting AP mode for wlan0 at address 192.168.0.200=0Ahostapd=
: no process found=0Aisc-dhcp-relay: no process found=0Atouch: cannot touch=
 `/var/lib/dhcp/db/dhcpd.leases': No such file or directory=0AConfiguration=
 file: /home/xabix/hostapd.conf=0ACould not set interface mon.wlan0 flags: =
Success=0Anl80211: Failed to set interface wlan0 into AP mode=0Anl80211 dri=
ver initialization failed.=0Armdir[ctrl_interface]: No such file or directo=
ry=0AELOOP: remaining socket: sock=3D4 eloop_data=3D0x85a1910 user_data=3D0=
x85a3720 handler=3D0x807c5e0=0AELOOP: remaining socket: sock=3D6 eloop_data=
=3D0x85a5538 user_data=3D(nil) handler=3D0x8086770=0A=0AI think the problem=
 I am having is the same as without the script.=0A=0ADo you want me to enab=
le additional logging? (plz confirmed how to do so)=0A=0AMerci=0AXabiX=0A=
=0APS: I have attached the updated script for my case. Mainly=A0I just chan=
ged the IPTABLES=3D, the dhcpd with isc-dhcp-relay, .1 with .200, name of t=
he SSID and the pwd I remove the "\"...""" entry with a pwd like=A0WPA_SECR=
ET=3Dtest1234)
--542325855-1908882459-1343314190=:31952
Content-Type: text/plain; name="control_ap_xabix.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="control_ap_xabix.txt"

IyEvYmluL3NoCiMgU2NyaXB0IHRvIHN0YXJ0L3N0b3AgYSBob3N0YXBkLWJh
c2VkIGFjY2VzcyBwb2ludAojCiMgU2FtcGxlIHN0YXJ0IGNhbGwgImNvbnRy
b2xfYXAgc3RhcnQgd2xhbjAgZXRoMCIKIyBTdG9wIHdpdGggImNvbnRyb2xf
YXAgc3RvcCIKIwoKY2FzZSAiJDEiIGluCnN0YXJ0KQoJaWYgWyAkIyAtbmUg
MyBdCgl0aGVuCgkgIGVjaG8gIlVzYWdlOiAkMCBzdGFydCBBUF9pZmFjZSBO
RVRfaWZhY2UiCgkgIGV4aXQgMQoJZmkKOzsKc3RvcCkKCWlmIFsgJCMgLW5l
IDEgXQoJdGhlbgoJICBlY2hvICJVc2FnZTogJDAgc3RvcCIKCSAgZXhpdCAx
CglmaQo7OwoqKQogICAgICAgIGVjaG8gIlVzYWdlOiIKCWVjaG8gIiQwIHN0
YXJ0IEFQLWlmYWNlIG5ldF9pZmFjZSIKCWVjaG8gIm9yIgoJZWNobyAiJDAg
c3RvcCIKICAgICAgICBleGl0IDEKICAgICAgICA7Owplc2FjCgojIFN5bWJv
bHMgZm9yIG5lZWRlZCBwcm9ncmFtcwoKSVBUQUJMRVM9L3NiaW4vaXB0YWJs
ZXMKSUZDT05GSUc9L3NiaW4vaWZjb25maWcKREhDUEQ9L2V0Yy9pbml0LmQv
aXNjLWRoY3AtcmVsYXkKSE9TVEFQRD0vdXNyL3NiaW4vaG9zdGFwZAoKIyBT
eW1ib2xzIGZvciBBUCBhbmQgZXh0ZXJuYWwgaW50ZXJmYWNlcwoKTkVUX0FQ
PSQyCk5FVF9FWFQ9JDMKCiMgRmlyc3QgMyBvY3RldHMgb2YgSVAgYWRkcmVz
cyBmb3IgdGhlIEFQCgpBUF9BRERSPTE5Mi4xNjguMAoKIyBJUCBhZGRyZXNz
IGZvciBuYW1lc2VydmVyCgpOQU1FX1NFUlZFUj04LjguOC44CgojIEFQIENo
YW5uZWwsIFNTSUQsIEVuY3J5cHRpb24gbWV0aG9kLCAgYW5kIEVuY3J5cHRp
b24gc2VjcmV0CgpBUF9DSEFOTkVMPTExCkFQX1NTSUQ9J1N3ZWV0IEhvbWUg
MicKV1BBX1NFQ1JFVD10ZXN0MTIzNApFTkNSWVBUX01PREU9MgoKY2FzZSAi
JDEiIGluCnN0YXJ0KQogICAgICAgIGVjaG8gIlN0YXJ0aW5nIEFQIG1vZGUg
Zm9yICRORVRfQVAgYXQgYWRkcmVzcyAkQVBfQUREUi4yMDAiCiAgICAgICAg
IyBEaXNhYmxlIHBhY2tldCBmb3J3YXJkaW5nCiAgICAgICAgZWNobyAwID4g
L3Byb2Mvc3lzL25ldC9pcHY0L2lwX2ZvcndhcmQKICAgICAgICAjIFN0b3Ag
YW55IGV4aXN0aW5nIGhvc3RhcGQgYW5kIGRoY3BkIGRhZW1vbnMKICAgICAg
ICBraWxsYWxsIGhvc3RhcGQKICAgICAgICBraWxsYWxsIGlzYy1kaGNwLXJl
bGF5IAogICAgICAgICNTZXQgdXAgZm9yd2FyZGluZwogICAgICAgICRJUFRB
QkxFUyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLW8gJE5FVF9FWFQgLWogTUFT
UVVFUkFERQogICAgICAgICRJUFRBQkxFUyAtQSBGT1JXQVJEIC1pICRORVRf
RVhUIC1vICRORVRfQVAgLW0gc3RhdGUgXAoJCS0tc3RhdGUgUkVMQVRFRCxF
U1RBQkxJU0hFRCAtaiBBQ0NFUFQKICAgICAgICAkSVBUQUJMRVMgLUEgRk9S
V0FSRCAtaSAkTkVUX0FQIC1vICRORVRfRVhUIC1qIEFDQ0VQVAogICAgICAg
ICMgRW5hYmxlIHBhY2tldCBmb3J3YXJkaW5nCiAgICAgICAgZWNobyAxID4g
L3Byb2Mvc3lzL25ldC9pcHY0L2lwX2ZvcndhcmQKICAgICAgICAjIEdldCB0
aGUgQVAgaW50ZXJmYWNlIGluIHRoZSByaWdodCBzdGF0ZQogICAgICAgICRJ
RkNPTkZJRyAkTkVUX0FQIGRvd24KICAgICAgICAkSUZDT05GSUcgJE5FVF9B
UCB1cAogICAgICAgICRJRkNPTkZJRyAkTkVUX0FQICRBUF9BRERSLjIwMAog
ICAgICAgICMgZGhjcGQgbmVlZHMgdG8gaGF2ZSBhIGxlYXNlcyBmaWxlIGF2
YWlsYWJsZSAtIGNyZWF0ZSBpdCBpZiBuZWVkZWQKICAgICAgICBpZiBbICEg
LWYgL3Zhci9saWIvZGhjcC9kYi9kaGNwZC5sZWFzZXMgXTsgdGhlbgogICAg
ICAgICAgICAgICAgdG91Y2ggL3Zhci9saWIvZGhjcC9kYi9kaGNwZC5sZWFz
ZXMKICAgICAgICBmaQoJIyBXcml0ZSB0aGUgREhDUCBzZXJ2ZXIgY29uZmln
dXJhdGlvbiBmaWxlCgkjZWNobyAib3B0aW9uIGRvbWFpbi1uYW1lLXNlcnZl
cnMgJE5BTUVfU0VSVkVSOyIgPiB+L2RoY3BkLmNvbmYKCSNlY2hvICJkZWZh
dWx0LWxlYXNlLXRpbWUgNjAwOyIgPj4gfi9kaGNwZC5jb25mCgkjZWNobyAi
bWF4LWxlYXNlLXRpbWUgNzIwMDsiID4+IH4vZGhjcGQuY29uZgoJI2VjaG8g
ImRkbnMtdXBkYXRlLXN0eWxlIG5vbmU7IGRkbnMtdXBkYXRlcyBvZmY7IiA+
PiB+L2RoY3BkLmNvbmYKCSNlY2hvICJzdWJuZXQgJEFQX0FERFIuMCBuZXRt
YXNrIDI1NS4yNTUuMjU1LjAgeyIgPj4gfi9kaGNwZC5jb25mCgkjZWNobyAi
ICAgICAgICByYW5nZSAkQVBfQUREUi4yMDAgJEFQX0FERFIuMjI5OyIgPj4g
fi9kaGNwZC5jb25mCgkjZWNobyAiICAgICAgICBvcHRpb24gc3VibmV0LW1h
c2sgMjU1LjI1NS4yNTUuMDsiID4+IH4vZGhjcGQuY29uZgoJI2VjaG8gIiAg
ICAgICAgb3B0aW9uIGJyb2FkY2FzdC1hZGRyZXNzICRBUF9BRERSLjI1NTsi
ID4+IH4vZGhjcGQuY29uZgoJI2VjaG8gIiAgICAgICAgb3B0aW9uIHJvdXRl
cnMgJEFQX0FERFIuMTsiID4+IH4vZGhjcGQuY29uZgoJI2VjaG8gIn0iID4+
IH4vZGhjcGQuY29uZgogICAgICAgICMgQnJpbmcgdXAgdGhlIERIQ1Agc2Vy
dmVyCiAgICAjICAgICRESENQRCAtY2Ygfi9kaGNwZC5jb25mICRORVRfQVAK
CSMgV3JpdGUgdGhlIGhvc3RhcGQgY29uZmlndXJhdGlvbiBmaWxlCgljYXQg
PiB+L2hvc3RhcGQuY29uZiA8PCBFT0YKYXV0aF9hbGdzPTEKYmVhY29uX2lu
dD0xMDAKI2JyaWRnZT1icjAKY291bnRyeV9jb2RlPVVTCmN0cmxfaW50ZXJm
YWNlX2dyb3VwPTAKY3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vaG9zdGFwZApk
dGltX3BlcmlvZD0yCmR1bXBfZmlsZT0vdG1wL2hvc3RhcGQuZHVtcApmcmFn
bV90aHJlc2hvbGQ9MjM0NgpodF9jYXBhYj1bSFQ0MC1dW1NIT1JULUdJLTIw
XVtTSE9SVC1HSS00MF1bTUFYLUFNU0RVLTc5MzVdW0RTU1NfQ0NLLTQwXQpp
ZWVlODAyMTFkPTEKaWVlZTgwMjExbj0xCmlnbm9yZV9icm9hZGNhc3Rfc3Np
ZD0wCmxvZ2dlcl9zdGRvdXQ9LTEKbG9nZ2VyX3N0ZG91dF9sZXZlbD0yCmxv
Z2dlcl9zeXNsb2c9LTEKbG9nZ2VyX3N5c2xvZ19sZXZlbD0yCm1hY2FkZHJf
YWNsPTAKbWF4X251bV9zdGE9MjU1CnJ0c190aHJlc2hvbGQ9MjM0Nwp3bW1f
YWNfYmVfYWNtPTAKd21tX2FjX2JlX2FpZnM9Mwp3bW1fYWNfYmVfY3dtYXg9
MTAKd21tX2FjX2JlX2N3bWluPTQKd21tX2FjX2JlX3R4b3BfbGltaXQ9MAp3
bW1fYWNfYmtfYWNtPTAKd21tX2FjX2JrX2FpZnM9Nwp3bW1fYWNfYmtfY3dt
YXg9MTAKd21tX2FjX2JrX2N3bWluPTQKd21tX2FjX2JrX3R4b3BfbGltaXQ9
MAp3bW1fYWNfdmlfYWNtPTAKd21tX2FjX3ZpX2FpZnM9Mgp3bW1fYWNfdmlf
Y3dtYXg9NAp3bW1fYWNfdmlfY3dtaW49Mwp3bW1fYWNfdmlfdHhvcF9saW1p
dD05NAp3bW1fYWNfdm9fYWNtPTAKd21tX2FjX3ZvX2FpZnM9Mgp3bW1fYWNf
dm9fY3dtYXg9Mwp3bW1fYWNfdm9fY3dtaW49Mgp3bW1fYWNfdm9fdHhvcF9s
aW1pdD00Nwp3bW1fZW5hYmxlZD0xCkVPRgoJZWNobyAiaW50ZXJmYWNlPSRO
RVRfQVAiID4+IH4vaG9zdGFwZC5jb25mCgllY2hvICJzc2lkPSRBUF9TU0lE
IiA+PiB+L2hvc3RhcGQuY29uZiAKCWVjaG8gImRyaXZlcj1ubDgwMjExIiA+
PiB+L2hvc3RhcGQuY29uZiAKCWVjaG8gImh3X21vZGU9ZyIgPj4gfi9ob3N0
YXBkLmNvbmYgCgllY2hvICJjaGFubmVsPSRBUF9DSEFOTkVMIiA+PiB+L2hv
c3RhcGQuY29uZiAKCWVjaG8gIndwYT0kRU5DUllQVF9NT0RFIiA+PiB+L2hv
c3RhcGQuY29uZiAKCWVjaG8gIndwYV9rZXlfbWdtdD1XUEEtUFNLIiA+PiB+
L2hvc3RhcGQuY29uZiAKCWVjaG8gIndwYV9wYWlyd2lzZT1US0lQIENDTVAi
ID4+IH4vaG9zdGFwZC5jb25mIAoJZWNobyAicnNuX3BhaXJ3aXNlPUNDTVAi
ID4+IH4vaG9zdGFwZC5jb25mCgllY2hvICJ3cGFfcGFzc3BocmFzZT0kV1BB
X1NFQ1JFVCIgPj4gfi9ob3N0YXBkLmNvbmYgCiAgICAgICAgIyBCcmluZyB1
cCBob3N0YXBkCiAgICAgICAgJEhPU1RBUEQgLUIgfi9ob3N0YXBkLmNvbmYK
ICAgICAgICA7OwpzdG9wKQogICAgICAgIGVjaG8gIlN0b3BwaW5nIEFQIG1v
ZGUiCiAgICAgICAgIyBTdG9wIGhvc3RhcGQgYW5kIGRoY3BkIGRhZW1vbnMK
ICAgICAgICBraWxsYWxsIGhvc3RhcGQKICAgICAgICBraWxsYWxsIGlzYy1k
aGNwLXJlbGF5CglybSAtZiB+L2hvc3RhcGQuY29uZgoJI3JtIC1mIH4vZGhj
cGQuY29uZgogICAgICAgIDs7CmVzYWMKCgo=

--542325855-1908882459-1343314190=:31952--

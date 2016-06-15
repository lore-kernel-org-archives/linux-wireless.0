Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idris.smile.fr ([91.216.209.19]:50538 "EHLO idris.smile.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683AbcFOOSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 10:18:06 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_a760c89426eb4bf9b2b580d9f9411a44"
Date: Wed, 15 Jun 2016 16:17:57 +0200
From: Vincent CESSON <vincent.cesson@smile.fr>
To: Raymond Hayes <hayesr@google.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	<linux-wireless@vger.kernel.org>, Shengzhen Li <szli@marvell.com>
Subject: Re: =?UTF-8?Q?mwifiex+wpa=5Fsupplicant=20cannot=20set=20up=20WPA/?=
 =?UTF-8?Q?WPA=32=20ADHOC?=
In-Reply-To: <CAKVVYBnrC6h1EvEW3jpMOsCqgAQ9L-mu_985QyFOOYFY+vZn1Q@mail.gmail.com>
References: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr>
 <CAKVVYBk2Rf6RMPW1uySq4M7LeFCRHBGipYdiOqwQSHxFNmst=A@mail.gmail.com>
 <053ed5ba9d69bc5e6f36ed7e95526663@smile.fr>
 <4fdb1514a02744ad9b8ac11b96e57130@SC-EXCH04.marvell.com>
 <404feff5a5bca118ba53b69301700e2f@smile.fr>
 <db092693c63a4a06ada95537e22d5abf@SC-EXCH04.marvell.com>
 <2259a8e8239c9497571d30fa86e7f84c@smile.fr>
 <CAKVVYBmb1X0OFz9kanTcGKxHTYDJt8u_ZusFEdPWk4Mu3FMBBQ@mail.gmail.com>
 <a11a109dbfbcd5c2fd952563de1a4c8c@smile.fr>
 <CAKVVYBnrC6h1EvEW3jpMOsCqgAQ9L-mu_985QyFOOYFY+vZn1Q@mail.gmail.com>
Message-ID: <10ea53e5030e54e51caa61380bd24c47@smile.fr> (sfid-20160615_161814_974067_3B8FA200)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=_a760c89426eb4bf9b2b580d9f9411a44
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

I set a successful AP network with WPA-PSK (see conf and log attached). 
As you can see on log, the message "Could not set station 
48:45:20:3b:31:75 flags for kernel driver" appears too, but the 
connection is OK.



Le 2016-06-15 13:35, Raymond Hayes a écrit :
> The logs were from wpa_supplicant so I suggest starting there; but
> the problem could be on either side, so you'll probably have to look
> into mwiflex too.
> 
> Ray
> 
> On Wednesday, June 15, 2016, Vincent CESSON <vincent.cesson@smile.fr> 
> wrote:
> 
>> Hi Raymond,
>> 
>> Who is trying to mark the peer authorized? Should I look into mwifiex 
>> driver? cfg80211.ko? libnl? wpa_supplicant? I am a bit lost among all 
>> these elements.
>> 
>> Vincent
>> 
>> Le 2016-06-14 02:30, Raymond Hayes a écrit :
>> 
>>> From the RSN log, the dual 4-way handshakes succeeded, but the GTK 
>>> was
>>> not installed:
>>> 
>>> nl80211: set_key failed; err=-22 Invalid argument)
>>> 
>>> and it looks like there was a problem marking the peer authorized:
>>> 
>>> AUTH: 48:45:20:3b:31:75 authorizing port
>>> Could not set station 48:45:20:3b:31:75 flags for kernel driver 
>>> (errno=11)
>>> 
>>> Ray
>>> 
>>> On Mon, Jun 13, 2016 at 7:42 AM, Vincent CESSON 
>>> <vincent.cesson@smile.fr> wrote:
>>> 
>>>> Hi Amitkumar,
>>>> 
>>>> Here are the wpa_supplicant logs (with CONFIG_IBSS_RSN=y enabled) 
>>>> from the
>>>> two devices. Beside wpa_supplicant, I manually set IPs 192.168.1.xy 
>>>> with
>>>> command "ifconfig mlan0 192.168.1.xy" and then I try to ping each 
>>>> other,
>>>> without success.
>>>> 
>>>> Vincent
>>>> 
>>>> Le 2016-06-13 15:40, Amitkumar Karwar a écrit :
>>>> 
>>>>> Hi Vincent,
>>>>> 
>>>>>> From: Vincent CESSON [mailto:vincent.cesson@smile.fr]
>>>>>> Sent: Monday, June 13, 2016 7:09 PM
>>>>>> To: Amitkumar Karwar
>>>>>> Cc: Raymond Hayes; linux-wireless@vger.kernel.org
>>>>>> Subject: RE: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>>>>>> 
>>>>>> About the strange behaviour with the two devices connecting 
>>>>>> despite the
>>>>>> bad passwords, I made a little mistake: on the device 2, 
>>>>>> wpa_supplicant
>>>>>> was not built with option CONFIG_IBSS_RSN=y. But still, device 1 
>>>>>> should
>>>>>> not accept device 2...
>>>>>> 
>>>>>> Note that with option CONFIG_IBSS_RSN=y enabled on both devices, 
>>>>>> WPA-PSK
>>>>>> connection does not work, even with the right password...
>>>>> 
>>>>> I see. Please share the wpa_supplicant logs with CONFIG_IBSS_RSN=y
>>>>> enabled for analysis.
>>>>> 
>>>>> Regards,
>>>>> Amitkumar
--=_a760c89426eb4bf9b2b580d9f9411a44
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=hostapd-rsn.conf
Content-Disposition: attachment;
 filename=hostapd-rsn.conf;
 size=188

c3NpZD10ZXN0X3BjbV93cGEyX3ZjZQppbnRlcmZhY2U9dWFwMApkcml2ZXI9bmw4MDIxMQpod19t
b2RlPWEKY2hhbm5lbD00OAppZWVlODAyMTFuPTEKd21tX2VuYWJsZWQ9MQp3cGE9Mgp3cGFfcGFz
c3BocmFzZT1wYXNzd29yZAp3cGFfa2V5X21nbXQ9V1BBLVBTSwp3cGFfcGFpcndpc2U9Q0NNUApy
c25fcGFpcndpc2U9Q0NNUAo=
--=_a760c89426eb4bf9b2b580d9f9411a44
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=hostapd-rsn.log
Content-Disposition: attachment;
 filename=hostapd-rsn.log;
 size=6075

bmw4MDIxMTogRXZlbnQgbWVzc2FnZSBhdmFpbGFibGUKbmw4MDIxMTogRHJ2IEV2ZW50IDE5IChO
TDgwMjExX0NNRF9ORVdfU1RBVElPTikgcmVjZWl2ZWQgZm9yIHVhcDAKbmw4MDIxMTogTmV3IHN0
YXRpb24gNDg6NDU6MjA6M2I6MzE6NzUKbmw4MDIxMTogQXNzb2MgUmVxIElFcyAtIGhleGR1bXAo
bGVuPTk4KTogMDAgMTEgNzQgNjUgNzMgNzQgNWYgNzAgNjMgNmQgNWYgNzcgNzAgNjEgMzIgNWYg
NzYgNjMgNjUgMDEgMDggMGMgMTIgMTggMjQgMzAgNDggNjAgNmMgMzAgMTQgMDEgMDAgMDAgMGYg
YWMgMDQgMDEgMDAgMDAgMGYgYWMgMDQgMDEgMDAgMDAgMGYgYWMgMDIgMDAgMDAgMmQgMWEgYWQg
MTEgMTcgZmYgZmYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgN2YgMDggMDQgMDAgMDAgMDAgMDEgMDAgMDAgNDAgZGQgMDcgMDAg
NTAgZjIgMDIgMDAgMDEgMDAKdWFwMDogRXZlbnQgQVNTT0MgKDApIHJlY2VpdmVkCnVhcDA6IFNU
QSA0ODo0NToyMDozYjozMTo3NSBJRUVFIDgwMi4xMTogYXNzb2NpYXRlZApTVEEgaW5jbHVkZWQg
UlNOIElFIGluIChSZSlBc3NvY1JlcQogIE5ldyBTVEEKbmw4MDIxMTogU2V0IFNUQSBmbGFncyAt
IGlmbmFtZT11YXAwIGFkZHI9NDg6NDU6MjA6M2I6MzE6NzUgdG90YWxfZmxhZ3M9MHgwIGZsYWdz
X29yPTB4MCBmbGFnc19hbmQ9MHhmZmZmZmZmMSBhdXRob3JpemVkPTAKdWFwMDogU1RBIDQ4OjQ1
OjIwOjNiOjMxOjc1IFdQQTogZXZlbnQgMSBub3RpZmljYXRpb24Kd3BhX2RyaXZlcl9ubDgwMjEx
X3NldF9rZXk6IGlmaW5kZXg9MTAgKHVhcDApIGFsZz0wIGFkZHI9MHgxMjQyNGEwIGtleV9pZHg9
MCBzZXRfdHg9MSBzZXFfbGVuPTAga2V5X2xlbj0wCiAgIGFkZHI9NDg6NDU6MjA6M2I6MzE6NzUK
SUVFRSA4MDIuMVg6IElnbm9yZSBTVEEgLSA4MDIuMVggbm90IGVuYWJsZWQgb3IgZm9yY2VkIGZv
ciBXUFMKdWFwMDogU1RBIDQ4OjQ1OjIwOjNiOjMxOjc1IFdQQTogc3RhcnQgYXV0aGVudGljYXRp
b24KV1BBOiA0ODo0NToyMDozYjozMTo3NSBXUEFfUFRLIGVudGVyaW5nIHN0YXRlIElOSVRJQUxJ
WkUKd3BhX2RyaXZlcl9ubDgwMjExX3NldF9rZXk6IGlmaW5kZXg9MTAgKHVhcDApIGFsZz0wIGFk
ZHI9MHgxMjQyNGEwIGtleV9pZHg9MCBzZXRfdHg9MSBzZXFfbGVuPTAga2V5X2xlbj0wCiAgIGFk
ZHI9NDg6NDU6MjA6M2I6MzE6NzUKbmw4MDIxMTogU2V0IFNUQSBmbGFncyAtIGlmbmFtZT11YXAw
IGFkZHI9NDg6NDU6MjA6M2I6MzE6NzUgdG90YWxfZmxhZ3M9MHgwIGZsYWdzX29yPTB4MCBmbGFn
c19hbmQ9MHhmZmZmZmZmZSBhdXRob3JpemVkPTAKdWFwMDogU1RBIDQ4OjQ1OjIwOjNiOjMxOjc1
IElFRUUgODAyLjFYOiB1bmF1dGhvcml6aW5nIHBvcnQKQ291bGQgbm90IHNldCBzdGF0aW9uIDQ4
OjQ1OjIwOjNiOjMxOjc1IGZsYWdzIGZvciBrZXJuZWwgZHJpdmVyIChlcnJubz0xMSkuCldQQTog
NDg6NDU6MjA6M2I6MzE6NzUgV1BBX1BUS19HUk9VUCBlbnRlcmluZyBzdGF0ZSBJRExFCldQQTog
NDg6NDU6MjA6M2I6MzE6NzUgV1BBX1BUSyBlbnRlcmluZyBzdGF0ZSBBVVRIRU5USUNBVElPTgpX
UEE6IDQ4OjQ1OjIwOjNiOjMxOjc1IFdQQV9QVEsgZW50ZXJpbmcgc3RhdGUgQVVUSEVOVElDQVRJ
T04yCldQQTogUmUtaW5pdGlhbGl6ZSBHTUsvQ291bnRlciBvbiBmaXJzdCBzdGF0aW9uCkdldCBy
YW5kb21uZXNzOiBsZW49MzIgZW50cm9weT01CkdNSyAtIGhleGR1bXAobGVuPTMyKTogW1JFTU9W
RURdCkdldCByYW5kb21uZXNzOiBsZW49MzIgZW50cm9weT0wCktleSBDb3VudGVyIC0gaGV4ZHVt
cChsZW49MzIpOiBbUkVNT1ZFRF0KR2V0IHJhbmRvbW5lc3M6IGxlbj0xNiBlbnRyb3B5PTAKR1RL
IC0gaGV4ZHVtcChsZW49MTYpOiBbUkVNT1ZFRF0Kd3BhX2RyaXZlcl9ubDgwMjExX3NldF9rZXk6
IGlmaW5kZXg9MTAgKHVhcDApIGFsZz0zIGFkZHI9MHg4NzhiMCBrZXlfaWR4PTEgc2V0X3R4PTEg
c2VxX2xlbj0wIGtleV9sZW49MTYKbmw4MDIxMTogS0VZX0RBVEEgLSBoZXhkdW1wKGxlbj0xNik6
IFtSRU1PVkVEXQogICBicm9hZGNhc3Qga2V5CkdldCByYW5kb21uZXNzOiBsZW49MzIgZW50cm9w
eT0wCldQQTogQXNzaWduIEFOb25jZSAtIGhleGR1bXAobGVuPTMyKTogOTUgNDYgYzUgYTAgYzcg
MDggODEgMmEgYWUgNDUgYTMgZDQgZDYgNjMgMDUgZTYgZDQgYjcgZjIgZWEgZGMgMzUgZDUgNzcg
NWEgODMgOGIgNmUgYmUgZTggNmEgMmEKV1BBOiA0ODo0NToyMDozYjozMTo3NSBXUEFfUFRLIGVu
dGVyaW5nIHN0YXRlIElOSVRQU0sKU2VhcmNoaW5nIGEgUFNLIGZvciA0ODo0NToyMDozYjozMTo3
NSBwcmV2X3Bzaz0obmlsKQpTZWFyY2hpbmcgYSBQU0sgZm9yIDQ4OjQ1OjIwOjNiOjMxOjc1IHBy
ZXZfcHNrPShuaWwpCldQQTogNDg6NDU6MjA6M2I6MzE6NzUgV1BBX1BUSyBlbnRlcmluZyBzdGF0
ZSBQVEtTVEFSVAp1YXAwOiBTVEEgNDg6NDU6MjA6M2I6MzE6NzUgV1BBOiBzZW5kaW5nIDEvNCBt
c2cgb2YgNC1XYXkgSGFuZHNoYWtlCldQQTogU2VuZCBFQVBPTCh2ZXJzaW9uPTIgc2VjdXJlPTAg
bWljPTAgYWNrPTEgaW5zdGFsbD0wIHBhaXJ3aXNlPTEga2RlX2xlbj0wIGtleWlkeD0wIGVuY3I9
MCkKV1BBOiBSZXBsYXkgQ291bnRlciAtIGhleGR1bXAobGVuPTgpOiAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMQpXUEE6IFVzZSBFQVBPTC1LZXkgdGltZW91dCBvZiAxMDAgbXMgKHJldHJ5IGNvdW50
ZXIgMSkKUlRNX05FV0xJTks6IGlmaV9pbmRleD0xMCBpZm5hbWU9dWFwMCBvcGVyc3RhdGU9NiBs
aW5rbW9kZT0wIGlmaV9mYW1pbHk9MCBpZmlfZmxhZ3M9MHgxMTA0MyAoW1VQXVtSVU5OSU5HXVtM
T1dFUl9VUF0pCnVhcDA6IEV2ZW50IEVBUE9MX1RYX1NUQVRVUyAoMzgpIHJlY2VpdmVkCklFRUUg
ODAyLjFYOiA0ODo0NToyMDozYjozMTo3NSBUWCBzdGF0dXMgLSB2ZXJzaW9uPTIgdHlwZT0zIGxl
bmd0aD05NSAtIGFjaz0xCldQQTogRUFQT0wtS2V5IFRYIHN0YXR1cyBmb3IgU1RBIDQ4OjQ1OjIw
OjNiOjMxOjc1IGFjaz0xCldQQTogSW5jcmVhc2UgaW5pdGlhbCBFQVBPTC1LZXkgMS80IHRpbWVv
dXQgYnkgMTAwMCBtcyBiZWNhdXNlIG9mIGFja25vd2xlZGdlZCBmcmFtZQp1YXAwOiBFdmVudCBF
QVBPTF9SWCAoMjQpIHJlY2VpdmVkCklFRUUgODAyLjFYOiAxMjEgYnl0ZXMgZnJvbSA0ODo0NToy
MDozYjozMTo3NQogICBJRUVFIDgwMi4xWDogdmVyc2lvbj0xIHR5cGU9MyBsZW5ndGg9MTE3CldQ
QTogUmVjZWl2ZWQgRUFQT0wtS2V5IGZyb20gNDg6NDU6MjA6M2I6MzE6NzUga2V5X2luZm89MHgx
MGEgdHlwZT0yIGtleV9kYXRhX2xlbmd0aD0yMgpXUEE6IFJlY2VpdmVkIEtleSBOb25jZSAtIGhl
eGR1bXAobGVuPTMyKTogNDggODMgZWYgOTQgMzIgNWEgOWEgNGIgZWQgMjQgMTEgZmEgYWYgYzcg
ODQgMDUgNTcgYzIgM2QgZGYgNTIgN2QgMjMgOTcgOGYgMzkgMTAgMjIgZjkgZTggNjQgOTMKV1BB
OiBSZWNlaXZlZCBSZXBsYXkgQ291bnRlciAtIGhleGR1bXAobGVuPTgpOiAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMQp1YXAwOiBTVEEgNDg6NDU6MjA6M2I6MzE6NzUgV1BBOiByZWNlaXZlZCBFQVBP
TC1LZXkgZnJhbWUgKDIvNCBQYWlyd2lzZSkKV1BBOiA0ODo0NToyMDozYjozMTo3NSBXUEFfUFRL
IGVudGVyaW5nIHN0YXRlIFBUS0NBTENORUdPVElBVElORwpTZWFyY2hpbmcgYSBQU0sgZm9yIDQ4
OjQ1OjIwOjNiOjMxOjc1IHByZXZfcHNrPShuaWwpCldQQTogUFRLIGRlcml2YXRpb24gLSBBMT05
ODpmMTo3MDo2Zjo5MzpmNiBBMj00ODo0NToyMDozYjozMTo3NQpXUEE6IE5vbmNlMSAtIGhleGR1
bXAobGVuPTMyKTogOTUgNDYgYzUgYTAgYzcgMDggODEgMmEgYWUgNDUgYTMgZDQgZDYgNjMgMDUg
ZTYgZDQgYjcgZjIgZWEgZGMgMzUgZDUgNzcgNWEgODMgOGIgNmUgYmUgZTggNmEgMmEKV1BBOiBO
b25jZTIgLSBoZXhkdW1wKGxlbj0zMik6IDQ4IDgzIGVmIDk0IDMyIDVhIDlhIDRiIGVkIDI0IDEx
IGZhIGFmIGM3IDg0IDA1IDU3IGMyIDNkIGRmIDUyIDdkIDIzIDk3IDhmIDM5IDEwIDIyIGY5IGU4
IDY0IDkzCldQQTogUE1LIC0gaGV4ZHVtcChsZW49MzIpOiBbUkVNT1ZFRF0KV1BBOiBQVEsgLSBo
ZXhkdW1wKGxlbj00OCk6IFtSRU1PVkVEXQpXUEE6IEtDSyAtIGhleGR1bXAobGVuPTE2KTogW1JF
TU9WRURdCldQQTogS0VLIC0gaGV4ZHVtcChsZW49MTYpOiBbUkVNT1ZFRF0KV1BBOiBUSyAtIGhl
eGR1bXAobGVuPTE2KTogW1JFTU9WRURdCldQQTogNDg6NDU6MjA6M2I6MzE6NzUgV1BBX1BUSyBl
bnRlcmluZyBzdGF0ZSBQVEtDQUxDTkVHT1RJQVRJTkcyCldQQTogNDg6NDU6MjA6M2I6MzE6NzUg
V1BBX1BUSyBlbnRlcmluZyBzdGF0ZSBQVEtJTklUTkVHT1RJQVRJTkcKdWFwMDogU1RBIDQ4OjQ1
OjIwOjNiOjMxOjc1IFdQQTogc2VuZGluZyAzLzQgbXNnIG9mIDQtV2F5IEhhbmRzaGFrZQpXUEE6
IFNlbmQgRUFQT0wodmVyc2lvbj0yIHNlY3VyZT0xIG1pYz0xIGFjaz0xIGluc3RhbGw9MSBwYWly
d2lzZT0xIGtkZV9sZW49NDYga2V5aWR4PTEgZW5jcj0xKQpXUEE6IFJlcGxheSBDb3VudGVyIC0g
aGV4ZHVtcChsZW49OCk6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAyClBsYWludGV4dCBFQVBPTC1L
ZXkgS2V5IERhdGEgLSBoZXhkdW1wKGxlbj01Nik6IFtSRU1PVkVEXQpXUEE6IFVzZSBFQVBPTC1L
ZXkgdGltZW91dCBvZiAxMDAgbXMgKHJldHJ5IGNvdW50ZXIgMSkKdWFwMDogRXZlbnQgRUFQT0xf
VFhfU1RBVFVTICgzOCkgcmVjZWl2ZWQKSUVFRSA4MDIuMVg6IDQ4OjQ1OjIwOjNiOjMxOjc1IFRY
IHN0YXR1cyAtIHZlcnNpb249MiB0eXBlPTMgbGVuZ3RoPTE1MSAtIGFjaz0xCldQQTogRUFQT0wt
S2V5IFRYIHN0YXR1cyBmb3IgU1RBIDQ4OjQ1OjIwOjNiOjMxOjc1IGFjaz0xCnVhcDA6IEV2ZW50
IEVBUE9MX1JYICgyNCkgcmVjZWl2ZWQKSUVFRSA4MDIuMVg6IDk5IGJ5dGVzIGZyb20gNDg6NDU6
MjA6M2I6MzE6NzUKICAgSUVFRSA4MDIuMVg6IHZlcnNpb249MSB0eXBlPTMgbGVuZ3RoPTk1CldQ
QTogUmVjZWl2ZWQgRUFQT0wtS2V5IGZyb20gNDg6NDU6MjA6M2I6MzE6NzUga2V5X2luZm89MHgz
MGEgdHlwZT0yIGtleV9kYXRhX2xlbmd0aD0wCldQQTogUmVjZWl2ZWQgS2V5IE5vbmNlIC0gaGV4
ZHVtcChsZW49MzIpOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApXUEE6
IFJlY2VpdmVkIFJlcGxheSBDb3VudGVyIC0gaGV4ZHVtcChsZW49OCk6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAyCnVhcDA6IFNUQSA0ODo0NToyMDozYjozMTo3NSBXUEE6IHJlY2VpdmVkIEVBUE9M
LUtleSBmcmFtZSAoNC80IFBhaXJ3aXNlKQpXUEE6IDQ4OjQ1OjIwOjNiOjMxOjc1IFdQQV9QVEsg
ZW50ZXJpbmcgc3RhdGUgUFRLSU5JVERPTkUKd3BhX2RyaXZlcl9ubDgwMjExX3NldF9rZXk6IGlm
aW5kZXg9MTAgKHVhcDApIGFsZz0zIGFkZHI9MHgxMjQyNGEwIGtleV9pZHg9MCBzZXRfdHg9MSBz
ZXFfbGVuPTAga2V5X2xlbj0xNgpubDgwMjExOiBLRVlfREFUQSAtIGhleGR1bXAobGVuPTE2KTog
W1JFTU9WRURdCiAgIGFkZHI9NDg6NDU6MjA6M2I6MzE6NzUKdWFwMDogQVAtU1RBLUNPTk5FQ1RF
RCA0ODo0NToyMDozYjozMTo3NQpubDgwMjExOiBTZXQgU1RBIGZsYWdzIC0gaWZuYW1lPXVhcDAg
YWRkcj00ODo0NToyMDozYjozMTo3NSB0b3RhbF9mbGFncz0weDEgZmxhZ3Nfb3I9MHgxIGZsYWdz
X2FuZD0weGZmZmZmZmZmIGF1dGhvcml6ZWQ9MQp1YXAwOiBTVEEgNDg6NDU6MjA6M2I6MzE6NzUg
SUVFRSA4MDIuMVg6IGF1dGhvcml6aW5nIHBvcnQKQ291bGQgbm90IHNldCBzdGF0aW9uIDQ4OjQ1
OjIwOjNiOjMxOjc1IGZsYWdzIGZvciBrZXJuZWwgZHJpdmVyIChlcnJubz0xMSkuCnVhcDA6IFNU
QSA0ODo0NToyMDozYjozMTo3NSBSQURJVVM6IHN0YXJ0aW5nIGFjY291bnRpbmcgc2Vzc2lvbiA1
NTI5NzEzRC0wMDAwMDAwMAp1YXAwOiBTVEEgNDg6NDU6MjA6M2I6MzE6NzUgV1BBOiBwYWlyd2lz
ZSBrZXkgaGFuZHNoYWtlIGNvbXBsZXRlZCAoUlNOKQoK
--=_a760c89426eb4bf9b2b580d9f9411a44--


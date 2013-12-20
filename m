Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24604 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3LTIau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 03:30:50 -0500
From: "BAHINI, Henri" <hbahini@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>
Subject: RE: [PATCHv3] cfg80211: add support for frequency interference event
Date: Fri, 20 Dec 2013 08:30:48 +0000
Message-ID: <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB122@nasanexd02f.na.qualcomm.com> (sfid-20131220_093054_414995_F55D5A57)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
 <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
 <1386145204.4284.4.camel@jlt4.sipsolutions.net>
 <1386145241.4284.5.camel@jlt4.sipsolutions.net>
 <D19FD2B13A40CD4B8DA64DB9B8F112E93E5CF51C@nasanexd01a.na.qualcomm.com>
 <CAB=NE6VNZDwGj4WWkgCmWxs_xLBZhXn44vo0TEdqo84xsRbZ2Q@mail.gmail.com>
 <8AC12462F1AA0E4EA8FEB46307AAD6F650AAB068@nasanexd02f.na.qualcomm.com>
 <CAB=NE6W3Et-4mDEet5DSDrM=yP60oODvEUGz=RtZj-gDgLNUbw@mail.gmail.com>
In-Reply-To: <CAB=NE6W3Et-4mDEet5DSDrM=yP60oODvEUGz=RtZj-gDgLNUbw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UGxlYXNlIGRvIGVkdWNhdGUgdXMgYSBiaXQhDQpXZSB3ZXJlIG5vdCBhd2FyZSBvZiB0aGUgcmVx
dWlyZW1lbnQgdGhhdCBhbGwgcGF0Y2hlcyBjb250cmlidXRpb25zIHRvIHRoZSBjZmcvbmwgaGF2
ZSB0byBiZSBmb3IgZHJpdmVyIHRoYXQgYXJlIGFscmVhZHkgdXAgc3RyZWFtZWQuDQoNCkFzIGZv
ciBvdXIgZWZmb3J0IGZvciB1cHN0cmVhbWluZyBvdXIgZHJpdmVyLCB3ZSBzaG91bGQgdGFrZSB0
aGlzIG91dCBvZiB0aGlzIGNvbnRleHQgc2luY2UgdGhlcmUgYXJlIGZhY3RvcnMgZHJpdmluZyB0
aGlzIHRoYXQgYXJlIGNvbXBsZXRlbHkgb3J0aG9nb25hbCB0byB0aGlzIGRpc2N1c3Npb24uDQoN
ClRoYW5rcywNCi1IZW5yaQ0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IG1jZ3Jv
ZkBnbWFpbC5jb20gW21haWx0bzptY2dyb2ZAZ21haWwuY29tXSBPbiBCZWhhbGYgT2YgTHVpcyBS
LiBSb2RyaWd1ZXoNClNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgMjAsIDIwMTMgMTI6MjYgQU0NClRv
OiBCQUhJTkksIEhlbnJpDQpDYzogQ2hhdWhhbiwgUmFqZXNoOyBKb2hhbm5lcyBCZXJnOyBsaW51
eC13aXJlbGVzczsgTWFsaW5lbiwgSm91bmk7IEpvaG5zb24sIEplZmY7IENoYW5nLCBMZW87IEx1
bywgWHVuOyBUaGFsYXBwaWwsIFNhbWVlcjsgSHVzc2FpbiwgQXJpZg0KU3ViamVjdDogUmU6IFtQ
QVRDSHYzXSBjZmc4MDIxMTogYWRkIHN1cHBvcnQgZm9yIGZyZXF1ZW5jeSBpbnRlcmZlcmVuY2Ug
ZXZlbnQNCg0KT24gRnJpLCBEZWMgMjAsIDIwMTMgYXQgMTI6MTYgQU0sIEJBSElOSSwgSGVucmkg
PGhiYWhpbmlAcWNhLnF1YWxjb21tLmNvbT4gd3JvdGU6DQo+IEx1aXMtDQo+ICAgQ2FuIHdlIGJl
IGEgYml0IHByb2Zlc3Npb25hbCBoZXJlIGFuZCBsaW1pdCB0aGUgZGlzY3Vzc2lvbiB0byB0aGUg
cGF0Y2ggdGhhdCB3ZSdyZSBpbnRyb2R1Y2luZy4NCj4gICBSYWplc2ggZG9lcyBub3QgZGVjaWRl
IHdoZW4gdGhlIGRyaXZlciBnZXRzIHVwIHN0cmVhbWVkLg0KDQpMZXQncyBiZSBwcm9mZXNzaW9u
YWwuIFdobyB0aGUgZnVjayBkZWNpZGVzIHRvIHRyeSB0byBpbnRyb2R1Y2UgQVBJcyBmb3Igc2hp
dCBmb3IgZHJpdmVycyB0aGF0IGFyZSBub3QgdXBzdHJlYW0gPw0KDQo+ICBDYW4gd2UgZ2V0IHRo
aXMgZGlzY3Vzc2lvbiBvdXRzaWRlIG9mIHRoZSBjb250ZXh0IG9mIHRoaXMgcGF0Y2g/DQoNCldo
YXQgdHlwZSBvZiBzZXJpb3VzIGVmZm9ydCBhcmUgeW91IHB1dHRpbmcgaW50byBnZXR0aW5nIHlv
dXIgZHJpdmVyIHVwc3RyZWFtPyBPdGhlcndpc2UgaXQgc2VlbXMgdG8gbWUgbGlrZSBhIHdhc3Rl
IG9mIG15IGFuZCBvdGhlcidzIG93biB0aW1lIGZvciByZXZpZXcuDQoNCiAgTHVpcw0K

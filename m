Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753014AbdLGKbr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 05:31:47 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in
 11n_rxreorder.c
Date: Thu, 7 Dec 2017 10:29:02 +0000
Message-ID: <46e098fe02c14e16b83fc35753b85805@SC-EXCH02.marvell.com> (sfid-20171207_113152_276193_D4856415)
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com>
 <20171101212853.GA89416@google.com>
 <cb98c452aa344fc0b501a776cfa8708a@SC-EXCH02.marvell.com>
 <CAD=FV=VuxFtDdcMndLNzVYDoid8N3jP46j0sOFXG1D4CzX0=Zw@mail.gmail.com>
 <20171107022508.GA42502@google.com>
 <a4c65d325abd4d4eb45d8cb3cd172df3@SC-EXCH02.marvell.com>
 <CAD=FV=ViNE5gnDTexYKpMN_Bb1bqZHwnJQ0h64=Rc8x-_1=iFQ@mail.gmail.com>
In-Reply-To: <CAD=FV=ViNE5gnDTexYKpMN_Bb1bqZHwnJQ0h64=Rc8x-_1=iFQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRG91Zy9Ccmlhbg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGRp
YW5kZXJzQGdvb2dsZS5jb20gW21haWx0bzpkaWFuZGVyc0Bnb29nbGUuY29tXSBPbiBCZWhhbGYg
T2YNCj4gRG91ZyBBbmRlcnNvbg0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDA4LCAyMDE3
IDI6NDUgQU0NCj4gVG86IEdhbmFwYXRoaSBCaGF0DQo+IENjOiBCcmlhbiBOb3JyaXM7IGxpbnV4
LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgQ2F0aHkgTHVvOyBYaW5taW5nIEh1Ow0KPiBaaGl5
dWFuIFlhbmc7IEphbWVzIENhbzsgTWFuZ2VzaCBNYWx1c2FyZTsgS2FydGhpayBEb2RkYXllbm5l
Z2VyZQ0KPiBBbmFudGhhcGFkbWFuYWJoYQ0KPiBTdWJqZWN0OiBSZTogW0VYVF0gUmU6IFtQQVRD
SCAxLzNdIG13aWZpZXg6IGNsZWFudXAgcnhfcGt0X2xvY2sgdXNhZ2UgaW4NCj4gMTFuX3J4cmVv
cmRlci5jDQo+DQo+IEhpLA0KPg0KPiBPbiBUdWUsIE5vdiA3LCAyMDE3IGF0IDg6MjUgQU0sIEdh
bmFwYXRoaSBCaGF0IDxnYmhhdEBtYXJ2ZWxsLmNvbT4NCj4gd3JvdGU6DQo+ID4gSGkgRG91Zy9C
cmlhbiwNCj4gPg0KPiA+IFRoYW5rcyBhIGxvdCBmb3IgdGhlIGNvbW1lbnRzIGFuZCB0aGUgZGlz
Y3Vzc2lvbi4gRmlyc3Qgb2YgYWxsIHdlIHdpbGwgYWJvcnQNCj4gdGhlIGNoYW5nZSBhZGRlZCBi
eSB0aGlzIHBhdGNoIGFzIHdlIGRvbid0IG5lZWQgcnhfcGt0X2xvY2sgYWNxdWlyZWQgdG8NCj4g
cHJvdGVjdCB0aGUgZGVsZXRlZCBpdGVtLiAgTmV4dCwgd2Ugd2lsbCBwcmVwYXJlIGJlbG93IGNo
YW5nZXMgdG8gYWRkcmVzcw0KPiB0aGUgY29uY2VybnMgZGlzY3Vzc2VkOg0KPiA+IDEuIE1vdmUg
cnhfcGt0X2xvY2sgZnJvbSBtd2lmaWV4X3ByaXZhdGUgdG8gcnhfcmVvcmRlcl90YmwNCj4NCj4g
Li4ub3IsIHBvc3NpYmx5LCByZW1vdmUgcnhfcGt0X2xvY2sgY29tcGxldGVseS4gIFNlZSBteSBv
dGhlciByZXNwb25zZS4uLg0KQWZ0ZXIgY2hlY2tpbmcgdGhlIGZsb3csIEkgYW0gdGhpbmtpbmcg
b2YgcmVtb3ZpbmcgYmVsb3cgMyBzcGluIGxvY2tzOg0KcnhfcmVvcmRlcl90YmxfbG9jaw0Kcnhf
cGt0X2xvY2sNCnR4X2JhX3N0cmVhbV90YmxfbG9jaw0KQXMgeW91IGJvdGggaGF2ZSBwb2ludGVk
IGVhcmxpZXIsIHRoZXkgdXNlZCBieSBtYWluIHRocmVhZCBhbmQgb2NjYXNpb25hbGx5IGJ5IGNm
ZzgwMjExIChmb3IgVERMUyBjb25maWd1cmF0aW9uKS4NCkNhbiB5b3UgcGxlYXNlIGNvbW1lbnQg
b24gdGhpcyBjaGFuZ2U/IElzIGl0IE9LIHRvIGlnbm9yZSBjZmc4MDIxMSBoZXJlLg0KPg0KPiAt
RG91Zw0KDQpSZWdhcmRzLA0KR2FuYXBhdGhpDQo=

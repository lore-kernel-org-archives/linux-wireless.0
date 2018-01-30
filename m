Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59322 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752037AbeA3PZP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 10:25:15 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: RE: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
 stall
Date: Tue, 30 Jan 2018 15:25:11 +0000
Message-ID: <c88b821c6cf449dc9892b3e7e67afda5@SC-EXCH02.marvell.com> (sfid-20180130_162520_128291_D7CA5358)
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
 <20180125071202.0F39560A60@smtp.codeaurora.org>
 <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
 <20180125183355.rpmajajr5exxcybb@ban.mtv.corp.google.com>
 <25201a91958e4b408b14c4125433b305@SC-EXCH02.marvell.com>
 <CA+ASDXPkrVgsRH--ETzMNXRQeu-akGn8hZVYT=YpG+5ZpggMTQ@mail.gmail.com>
In-Reply-To: <CA+ASDXPkrVgsRH--ETzMNXRQeu-akGn8hZVYT=YpG+5ZpggMTQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgQnJpYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJpYW4g
Tm9ycmlzIFttYWlsdG86YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnXQ0KPiBTZW50OiBUdWVzZGF5
LCBKYW51YXJ5IDMwLCAyMDE4IDM6MzggQU0NCj4gVG86IEdhbmFwYXRoaSBCaGF0DQo+IENjOiBL
YWxsZSBWYWxvOyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IENhdGh5IEx1bzsgWGlu
bWluZyBIdTsNCj4gWmhpeXVhbiBZYW5nOyBKYW1lcyBDYW87IE1hbmdlc2ggTWFsdXNhcmU7IFNo
cmVuaWsgU2hpa2hhcmUNCj4gU3ViamVjdDogUmU6IFtFWFRdIFJlOiBbMi8yXSBtd2lmaWV4OiB1
c2UgbW9yZV9yeF90YXNrX2ZsYWcgdG8gYXZvaWQgVVNCIFJYDQo+IHN0YWxsDQo+DQo+IEhpLA0K
Pg0KPiBPbiBTdW4sIEphbiAyOCwgMjAxOCBhdCAxMToxOSBQTSwgR2FuYXBhdGhpIEJoYXQgPGdi
aGF0QG1hcnZlbGwuY29tPg0KPiB3cm90ZToNCj4gPj4gRnJvbTogR2FuYXBhdGhpIEJoYXQNCj4g
Pj4gPiBGcm9tOiBCcmlhbiBOb3JyaXMgW21haWx0bzpicmlhbm5vcnJpc0BjaHJvbWl1bS5vcmdd
IE9uIFRodSwgSmFuDQo+ID4+ID4gMjUsIDIwMTggYXQgMDk6NTk6MDRBTSArMDAwMCwgR2FuYXBh
dGhpIEJoYXQgd3JvdGU6DQo+ID4+ID4gPiA+IEkgY2FuJ3QgZmluZCBhbnkgY29tbWl0IHdpdGgg
aWQgYzdkYmRjYjJhNGUxLCBpcyBpdCBjb3JyZWN0Pw0KPiA+PiA+ID4gQ29ycmVjdC4gQWN0dWFs
bHkgdGhlIGNvbW1pdCBpZCBjN2RiZGNiMmE0ZTEgaXMgdGhlIFBBVENIIFsxLzJdDQo+ID4+ID4g
PiBzZW50IGluIHRoaXMNCj4gPj4gPiBzZXJpZXMuDQo+ID4+ID4NCj4gPj4gPiBXaGF0PyBXaHkg
d291bGQgeW91IGludHJvZHVjZSBhIGJ1ZyBhbmQgb25seSBmaXggaXQgaW4gdGhlIG5leHQgcGF0
Y2g/DQo+ID4+IFdpdGggdGhlIGZpcnN0IHBhdGNoIHRoZSBvcmlnaW5hbCBpc3N1ZSB0b29rIGNv
bnNpZGVyYWJseSBsb25nZXIgdGltZQ0KPiA+PiB0byByZWNyZWF0ZS4gQWxzbyBpdCBmb2xsb3dl
ZCBhIGRpZmZlcmVudCBwYXRoIHRvIGdldA0KPiA+PiByZWNyZWF0ZWQoc2hhcmVkIGluIGNvbW1p
dCBtZXNzYWdlKS4NCj4gPj4gPiBEb2VzIHRoYXQgbWVhbiB5b3Ugc2hvdWxkIGp1c3QgY29tYmlu
ZSB0aGUgdHdvPw0KPiA+PiBMZXQgdXMga25vdyBpZiB0aGF0IGlzIGZpbmUgdG8gbWVyZ2UgdGhl
bS4gV2UgY2FuIG1vZGlmeSB0aGUgY29tbWl0DQo+ID4+IG1lc3NhZ2UgYWNjb3JkaW5nbHkuDQo+
ID4+ID4gT3IgcmV2ZXJzZSB0aGUgb3JkZXIsIGlmIHBhdGNoIDIgZG9lc24ndCBjYXVzZSBwcm9i
bGVtcyBvbiBpdHMgb3duPw0KPiA+PiBQYXRjaCAyIGhhcyBhIGRlcGVuZGVuY3kgb24gcGF0Y2gg
MS4NCj4gPiBPbmUgY29ycmVjdGlvbi4gVGhlcmUgaXMgbm8gY29tbWl0IGRlcGVuZGVuY3kgYmV0
d2VlbiBwYXRjaCAxIGFuZA0KPiAyKHRoZXkgY2FuIGJlIGFwcGxpZWQgaW4gYW55IG9yZGVyKS4g
QnV0IHRoZSByZXN1bHQgd291bGQgYmUgc2FtZS4gV2UgbmVlZA0KPiBib3RoIGZpeGVzLiBMZXQg
dXMga25vdyBpZiB3ZSBjYW4gY29tYmluZSB0aGVtLg0KPg0KPiBJIGhhdmVuJ3QgY2xvc2VseSBs
b29rZWQgYXQgcGF0Y2ggMiB5ZXQuIE15IG9ubHkgc3RhdGVtZW50IHdhcyB0aGF0IGl0IG1ha2Vz
DQo+IG5vIHNlbnNlIHRvIGhhdmUgMiBjb21taXRzLCB3aXRoIHRoZSBzZWNvbmQgb25lIGxhYmVs
ZWQgYXMgIkZpeGluZyIgdGhlIGZpcnN0DQo+IG9uZS4gRnJvbSB5b3VyIGRlc2NyaXB0aW9ucywg
aXQgc291bmRzIGxpa2UgcGF0Y2ggMiBzaG91bGQgYWN0dWFsbHkgY29tZSBmaXJzdCwNCk9rLiBJ
IHVuZGVyc3RhbmQuIEkgd2lsbCByZW9yZGVyIHRoZW0gYW5kIHNlbmQgdjMoYWxvbmcgd2l0aCBz
cGlubG9jayBjaGFuZ2UpLg0KPiBidXQgSSdtIG5vdCByZWFsbHkgc3VyZS4gSSBvbmx5IGxvb2tl
ZCBmYXIgZW5vdWdoIHRvIHNheSB0aGF0IEkgZGlkbid0IGxpa2UgcGF0Y2gNCj4gMSBhcy1pcyA6
KQ0KPg0KPiBCcmlhbg0KUmVnYXJkcywNCkdhbmFwYXRoaQ0K

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:55000 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbeEBFo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 01:44:59 -0400
From: Pkshih <pkshih@realtek.com>
To: =?utf-8?B?Sm/Do28gUGF1bG8gUmVjaGkgVml0YQ==?= <jprvita@gmail.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
CC: Steve deRosier <derosier@gmail.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Chaoming_Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        =?utf-8?B?Sm/Do28gUGF1bG8gUmVjaGkgVml0YQ==?= <jprvita@endlessm.com>,
        "linux@endlessm.com" <linux@endlessm.com>
Subject: RE: RTL8723BE performance regression
Date: Wed, 2 May 2018 05:44:38 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D13BEC14C0@RTITMBSV07.realtek.com.tw> (sfid-20180502_074519_281427_780E51FE)
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
 <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net>
 <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com>
 <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net>
 <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
In-Reply-To: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm/Do28gUGF1bG8gUmVj
aGkgVml0YSBbbWFpbHRvOmpwcnZpdGFAZ21haWwuY29tXQ0KPiBTZW50OiBXZWRuZXNkYXksIE1h
eSAwMiwgMjAxOCA2OjQxIEFNDQo+IFRvOiBMYXJyeSBGaW5nZXINCj4gQ2M6IFN0ZXZlIGRlUm9z
aWVyOyDojorlvaXlrqM7IFBrc2hpaDsgQmlybWluZyBDaGl1OyBTaGFvZnU7IFN0ZXZlbiBUaW5n
OyBDaGFvbWluZ19MaTsgS2FsbGUgVmFsbzsNCj4gbGludXgtd2lyZWxlc3M7IE5ldHdvcmsgRGV2
ZWxvcG1lbnQ7IExLTUw7IERhbmllbCBEcmFrZTsgSm/Do28gUGF1bG8gUmVjaGkgVml0YTsgbGlu
dXhAZW5kbGVzc20uY29tDQo+IFN1YmplY3Q6IFJlOiBSVEw4NzIzQkUgcGVyZm9ybWFuY2UgcmVn
cmVzc2lvbg0KPiANCj4gT24gVHVlLCBBcHIgMywgMjAxOCBhdCA3OjUxIFBNLCBMYXJyeSBGaW5n
ZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+IHdyb3RlOg0KPiA+IE9uIDA0LzAzLzIwMTgg
MDk6MzcgUE0sIEpvw6NvIFBhdWxvIFJlY2hpIFZpdGEgd3JvdGU6DQo+ID4+DQo+ID4+IE9uIFR1
ZSwgQXByIDMsIDIwMTggYXQgNzoyOCBQTSwgTGFycnkgRmluZ2VyIDxMYXJyeS5GaW5nZXJAbHdm
aW5nZXIubmV0Pg0KPiA+PiB3cm90ZToNCj4gPj4NCj4gPj4gKC4uLikNCj4gPj4NCj4gPj4+IEFz
IHRoZSBhbnRlbm5hIHNlbGVjdGlvbiBjb2RlIGNoYW5nZXMgYWZmZWN0ZWQgeW91ciBmaXJzdCBi
aXNlY3Rpb24sIGRvDQo+ID4+PiB5b3UNCj4gPj4+IGhhdmUgb25lIG9mIHRob3NlIEhQIGxhcHRv
cHMgd2l0aCBvbmx5IG9uZSBhbnRlbm5hIGFuZCB0aGUgaW5jb3JyZWN0DQo+ID4+PiBjb2RpbmcN
Cj4gPj4+IGluIHRoZSBGVVNFPw0KPiA+Pg0KPiA+Pg0KPiA+PiBZZXMsIHRoYXQgaXMgd2h5IEkn
dmUgYmVlbiBwYXNzaW5nIGFudF9zZWw9MSBkdXJpbmcgbXkgdGVzdHMgLS0gdGhpcw0KPiA+PiB3
YXMgbmVlZGVkIHRvIGFjaGlldmUgYSBnb29kIHBlcmZvcm1hbmNlIGluIHRoZSBwYXN0LCBiZWZv
cmUgdGhpcw0KPiA+PiByZWdyZXNzaW9uLiBJJ3ZlIGFsc28gb3BlbmVkIHRoZSBsYXB0b3AgY2hh
c3NpcyBhbmQgY29uZmlybWVkIHRoZQ0KPiA+PiBhbnRlbm5hIGNhYmxlIGlzIHBsdWdnZWQgdG8g
dGhlIGNvbm5lY3RvciBsYWJlbGVkIHdpdGggIjEiIG9uIHRoZQ0KPiA+PiBjYXJkLg0KPiA+Pg0K
PiA+Pj4gSWYgc28sIHBsZWFzZSBtYWtlIHN1cmUgdGhhdCB5b3Ugc3RpbGwgaGF2ZSB0aGUgc2Ft
ZSBzaWduYWwNCj4gPj4+IHN0cmVuZ3RoIGZvciBnb29kIGFuZCBiYWQgY2FzZXMuIEkgaGF2ZSB0
cmllZCB0byBrZWVwIHRoZSBkcml2ZXIgYW5kIHRoZQ0KPiA+Pj4gYnRjb2V4IGNvZGUgaW4gc3lu
YywgYnV0IHRoZXJlIG1heSBiZSBzb21lIGNvbWJpbmF0aW9ucyBvZiBhbnRlbm5hDQo+ID4+PiBj
b25maWd1cmF0aW9uIGFuZCBGVVNFIGNvbnRlbnRzIHRoYXQgY2F1c2UgdGhlIGNvZGUgdG8gZmFp
bC4NCj4gPj4+DQo+ID4+DQo+ID4+IFdoYXQgaXMgdGhlIHJlY29tbWVuZGVkIHdheSB0byBtb25p
dG9yIHRoZSBzaWduYWwgc3RyZW5ndGg/DQo+ID4NCj4gPg0KPiA+IFRoZSBidGNvZXggY29kZSBp
cyBkZXZlbG9wZWQgZm9yIG11bHRpcGxlIHBsYXRmb3JtcyBieSBhIGRpZmZlcmVudCBncm91cA0K
PiA+IHRoYW4gdGhlIExpbnV4IGRyaXZlci4gSSB0aGluayB0aGV5IG1hZGUgYSBjaGFuZ2UgdGhh
dCBjYXVzZWQgYW50X3NlbCB0bw0KPiA+IHN3aXRjaCBmcm9tIDEgdG8gMi4gQXQgbGVhc3QgbnVt
ZXJvdXMgY29tbWVudHMgYXQNCj4gPiBnaXRodWIuY29tL2x3ZmluZ2VyL3J0bHdpZmlfbmV3IGNs
YWltZWQgdGhleSBuZWVkZWQgdG8gbWFrZSB0aGF0IGNoYW5nZS4NCj4gPg0KPiA+IE1oeSByZWNv
bW1lbmRlZCBtZXRob2QgaXMgdG8gdmVyaWZ5IHRoZSB3aWZpIGRldmljZSBuYW1lIHdpdGggIml3
IGRldiIuIFRoZW4NCj4gPiB1c2luZyB0aGF0IGRldmljZQ0KPiA+DQo+ID4gc3VkbyBpdyBkZXYg
PGRldl9uYW1lPiBzY2FuIHwgZWdyZXAgIlNTSUR8c2lnbmFsIg0KPiA+DQo+IA0KPiBJIGhhdmUg
Y29uZmlybWVkIHRoYXQgdGhlIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gaXMgaW5kZWVkIHRpZWQg
dG8NCj4gc2lnbmFsIHN0cmVuZ3RoOiBvbiB0aGUgZ29vZCBjYXNlcyBzaWduYWwgd2FzIGJldHdl
ZW4gLTE2IGFuZCAtOCBkQm0sDQo+IHdoZXJlYXMgaW4gYmFkIGNhc2VzIHNpZ25hbCB3YXMgYWx3
YXlzIGJldHdlZW4gLTUwIHRvIC0gNDAgZEJtLiBJJ3ZlDQo+IGFsc28gc3dpdGNoZWQgdG8gdGVz
dGluZyBiYW5kd2lkdGggaW4gY29udHJvbGxlZCBMQU4gZW52aXJvbm1lbnQgdXNpbmcNCj4gaXBl
cmYzLCBhcyBzdWdnZXN0ZWQgYnkgU3RldmUgZGVSb3NpZXIsIHdpdGggdGhlIERVVCBiZWluZyB0
aGUgb25seQ0KPiBtYWNoaW5lIGNvbm5lY3RlZCB0byB0aGUgMi40IEdIeiByYWRpbyBhbmQgdGhl
IG1hY2hpbmUgcnVubmluZyB0aGUNCj4gaXBlcmYzIHNlcnZlciBjb25uZWN0ZWQgdmlhIGV0aGVy
bmV0Lg0KPiANCg0KV2UgaGF2ZSBuZXcgZXhwZXJpbWVudGFsIHJlc3VsdHMgaW4gY29tbWl0IGFm
OGE0MWNjY2Y4ZjQ2ICgicnRsd2lmaTogY2xlYW51cCANCjg3MjNiZSBhbnRfc2VsIGRlZmluaXRp
b24iKS4gWW91IGNhbiB1c2UgdGhlIGFib3ZlIGNvbW1pdCBhbmQgZG8gdGhlIHNhbWUgDQpleHBl
cmltZW50cyAod2l0aCBhbnRfc2VsPTAsIDEgYW5kIDIpIGluIHlvdXIgc2lkZSwgYW5kIHRoZW4g
c2hhcmUgeW91ciByZXN1bHRzLg0KU2luY2UgcGVyZm9ybWFuY2UgaXMgdGllZCB0byBzaWduYWwg
c3RyZW5ndGgsIHlvdSBjYW4gb25seSBzaGFyZSBzaWduYWwgc3RyZW5ndGguDQoNClJlZ2FyZHMN
ClBLDQoNCg==

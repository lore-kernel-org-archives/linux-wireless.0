Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0119.outbound.protection.outlook.com ([104.47.0.119]:45389
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755154AbeBOIsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:48:39 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: Steve deRosier <derosier@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: RE: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
Date: Thu, 15 Feb 2018 08:48:36 +0000
Message-ID: <AM4PR0101MB2305671B9EDEFFD66F886EEBE4F40@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180215_094842_750771_6AD509AE)
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <CALLGbRLP6czPkm_DFPTZCkzXUXQq2RdDm3kjad-5EJJBHnbz5g@mail.gmail.com>
In-Reply-To: <CALLGbRLP6czPkm_DFPTZCkzXUXQq2RdDm3kjad-5EJJBHnbz5g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiAtLS0tLU1lc3NhZ2UgZCdvcmlnaW5lLS0tLS0NCj4gRGXCoDogc3RldmUuZGVyb3NpZXJAZ21h
aWwuY29tIFttYWlsdG86c3RldmUuZGVyb3NpZXJAZ21haWwuY29tXSBEZQ0KPiBsYSBwYXJ0IGRl
IFN0ZXZlIGRlUm9zaWVyDQo+IEVudm95w6nCoDogbWVyY3JlZGkgMTQgZsOpdnJpZXIgMjAxOCAx
OToxNg0KPiDDgMKgOiBKZWFuIFBpZXJyZSBUT1NPTkkNCj4gQ2PCoDogS2FsbGUgVmFsbzsgbGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBhdGg5ay0NCj4gZGV2ZWxAcWNhLnF1YWxjb21t
LmNvbQ0KPiBPYmpldMKgOiBSZTogW1BBVENIIHYyXSBhdGg5azogbWFyayBSU1NJIGFzIGludmFs
aWQgaWYgZnJhbWUgcmVjZWl2ZWQNCj4gZHVyaW5nIGNoYW5uZWwgc2V0dXANCj4gDQo+IE9uIFdl
ZCwgRmViIDE0LCAyMDE4IGF0IDg6MjYgQU0sIEplYW4gUGllcnJlIFRPU09OSQ0KPiA8anAudG9z
b25pQGFja3N5cy5mcj4gd3JvdGU6DQo+ID4gYXRoOWsgcmV0dXJucyBhIHdyb25nIFJTU0kgdmFs
dWUgZm9yIGZyYW1lcyByZWNlaXZlZCBpbiBhIDMwbXMNCj4gdGltZQ0KPiA+IHdpbmRvdyBhZnRl
ciBhIGNoYW5uZWwgY2hhbmdlLiBUaGUgY29ycmVjdCB2YWx1ZSBpcyB0eXBpY2FsbHkgMTBkQg0K
PiA+IGJlbG93IHRoZSByZXR1cm5lZCB2YWx1ZS4NCj4gPg0KPiA+IFRoaXMgd2FzIGZvdW5kIHdp
dGggYSBBdGhlcm9zIEFSOTMwMCBSZXY6MyBjaGlwIChXTEUzNTBOWCAvDQo+IEpXWDYwODMNCj4g
PiBjYXJkcyksIGR1cmluZyBvZmZjaGFubmVsIHNjYW5zLg0KPiA+DQo+IA0KPiBJcyB0aGlzIHRy
dWUgZm9yIEFMTCBhdGg5ayBjaGlwcyBvciBvbmx5IGZvciB0aGUgc3BlY2lmaWMgZGV2aWNlPyBJ
Zg0KPiBpdCdzIG5vdCBnZW5lcmFsbHkgdHJ1ZSwgd2Ugc2hvdWxkbid0IGJlIGFkZGluZyBjb2Rl
IHRoYXQgYXBwbGllcyB0bw0KPiBhbGwuIFBlcmhhcHMgYSBxdWlyayBvciBrZXllZCB0byBhIHNw
ZWNpZmljIGNoaXAgaWQgb3IgRFQgZW50cnkgb3INCj4gb3RoZXIgd2F5IHRvIGd1YXJkIGl0Pw0K
DQpZb3UgYXJlIHJpZ2h0Lg0KT24gbXkgaGFyZHdhcmUgSSBjb3VsZCBvbmx5IHRyeSB0aGVzZSB0
d28gUENJZSBjYXJkcyB3aGljaCB1c2UgdGhlIHNhbWUgY2hpcC4NCkJ1dCBJIGNhbm5vdCBiZSBz
dXJlIGl0IGFwcGxpZXMgdG8gb3RoZXIgYXRoOWsuIFNob3VsZCBJIGNoZWNrIHRoZSBQQ0kgcHJv
ZHVjdCBJRD8NCg0KPiANCj4gLSBTdGV2ZQ0K

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:37472 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbZDGUiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:38:19 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2952747wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 13:38:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239131370.6199.0.camel@johannes.local>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	<1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	<1239099071.22453.12.camel@johannes.local> <20090407162345.GC5758@tesla>
	<1239131370.6199.0.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Apr 2009 13:38:03 -0700
Message-ID: <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com> (sfid-20090407_223824_870361_EC71A186)
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
	sending assoc
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCBBcHIgNywgMjAwOSBhdCAxMjowOSBQTSwgSm9oYW5uZXMgQmVyZwo8am9oYW5uZXNA
c2lwc29sdXRpb25zLm5ldD4gd3JvdGU6Cj4gT24gVHVlLCAyMDA5LTA0LTA3IGF0IDA5OjIzIC0w
NzAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90ZToKPgo+PiA+IFRoaXMgcGF0Y2ggaXMgbm90IHN1
ZmZpY2llbnQgLS0geW91IGFsc28gbmVlZCB0byBtb2RpZnkKPj4gPiBpZWVlODAyMTFfc2VuZF9h
c3NvYy4gT3RoZXJ3aXNlIHdlIGVuZCB1cCB0ZWxsaW5nIHRoZSBBUCB0aGF0IHdlIHN1cHBvcnQK
Pj4gPiBIVDQwLCBidXQgdHVuaW5nIHRoZSBoYXJkd2FyZSB0byBIVDIwLgo+Pgo+PiBMaWtlIHRo
aXM/Cj4+Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN3aXRjaCAoaHRfaW5mby0+aHRfcGFy
YW0gJiBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBX1NFQ19PRkZTRVQpIHsKPj4gwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY2FzZSBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBX1NFQ19BQk9WRToKPj4gwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGZsYWdzICYgSUVFRTgwMjExX0NI
QU5fTk9fSFQ0MFBMVVMpIHsKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY2FwICY9IH5JRUVFODAyMTFfSFRfQ0FQX1NVUF9XSURUSF8yMF80MDsKPj4g
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FwICY9IH5J
RUVFODAyMTFfSFRfQ0FQX1NHSV80MDsKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgfQo+PiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBicmVhazsKPj4g
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FzZSBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBX1NFQ19C
RUxPVzoKPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGZsYWdzICYg
SUVFRTgwMjExX0NIQU5fTk9fSFQ0ME1JTlVTKSB7Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNhcCAmPSB+SUVFRTgwMjExX0hUX0NBUF9TVVBfV0lE
VEhfMjBfNDA7Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGNhcCAmPSB+SUVFRTgwMjExX0hUX0NBUF9TR0lfNDA7Cj4+IMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIH0KPgo+IFllYWgsIHRoYXQgbG9va3Mgb2suCgpUaGF0J3Mgd2hh
dCB3YXMgdGhlcmUgb3Igd2hhdCBJIGFkZGVkIGluIG15IHBhdGNoZXMuCgogIEx1aXMK

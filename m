Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:60698 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZDGUoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:44:39 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2955753wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 13:44:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239136863.7475.66.camel@johannes.local>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	<1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	<1239099071.22453.12.camel@johannes.local> <20090407162345.GC5758@tesla>
	<1239131370.6199.0.camel@johannes.local> <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com>
	<1239136863.7475.66.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Apr 2009 13:44:23 -0700
Message-ID: <43e72e890904071344v30c663c5sb50937ce54e1b92b@mail.gmail.com> (sfid-20090407_224443_805196_833EA66F)
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
	sending assoc
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCBBcHIgNywgMjAwOSBhdCAxOjQxIFBNLCBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0Bz
aXBzb2x1dGlvbnMubmV0PiB3cm90ZToKPiBPbiBUdWUsIDIwMDktMDQtMDcgYXQgMTM6MzggLTA3
MDAsIEx1aXMgUi4gUm9kcmlndWV6IHdyb3RlOgo+Cj4+ID4+IMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHN3aXRjaCAoaHRfaW5mby0+aHRfcGFyYW0gJiBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBX1NF
Q19PRkZTRVQpIHsKPj4gPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FzZSBJRUVFODAyMTFf
SFRfUEFSQU1fQ0hBX1NFQ19BQk9WRToKPj4gPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKGZsYWdzICYgSUVFRTgwMjExX0NIQU5fTk9fSFQ0MFBMVVMpIHsKPj4gPj4g
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FwICY9IH5J
RUVFODAyMTFfSFRfQ0FQX1NVUF9XSURUSF8yMF80MDsKPj4gPj4gwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FwICY9IH5JRUVFODAyMTFfSFRfQ0FQX1NH
SV80MDsKPj4gPj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfQo+PiA+PiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBicmVhazsKPj4gPj4gwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgY2FzZSBJRUVFODAyMTFfSFRfUEFSQU1fQ0hBX1NFQ19CRUxPVzoKPj4g
Pj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGZsYWdzICYgSUVFRTgw
MjExX0NIQU5fTk9fSFQ0ME1JTlVTKSB7Cj4+ID4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNhcCAmPSB+SUVFRTgwMjExX0hUX0NBUF9TVVBfV0lEVEhf
MjBfNDA7Cj4+ID4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGNhcCAmPSB+SUVFRTgwMjExX0hUX0NBUF9TR0lfNDA7Cj4+ID4+IMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIH0KPj4gPgo+PiA+IFllYWgsIHRoYXQgbG9va3Mgb2suCj4+
Cj4+IFRoYXQncyB3aGF0IHdhcyB0aGVyZSBvciB3aGF0IEkgYWRkZWQgaW4gbXkgcGF0Y2hlcy4K
Pgo+IEluZGVlZCwgaXQncyBhbHJlYWR5IHRoZXJlLiBJIGd1ZXNzIEkgZ290IGNvbmZ1c2VkLCBz
b3JyeSBmb3IgdGhlIG5vaXNlLgoKaGVoZSwgbnAsIGFyZSB0aGVzZSBBQ0tlZCBub3cgdGhlbj8K
CiAgTHVpcwo=

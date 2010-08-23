Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35839 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0HWWKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 18:10:07 -0400
Received: by qwh6 with SMTP id 6so5526977qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 15:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100823210335.493454739@rtp-net.org>
References: <20100823210221.126521640@rtp-net.org>
	<20100823210335.493454739@rtp-net.org>
Date: Tue, 24 Aug 2010 00:10:06 +0200
Message-ID: <AANLkTinzcLy0n4y3JRzbQ6iQZAiFB3a+xH6D6pzo1eVy@mail.gmail.com>
Subject: Re: [patch 1/1 v2] rt2x00: fix "buffer size not provably correct"
 build warning
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCBBdWcgMjMsIDIwMTAgYXQgMTE6MDIgUE0sIEFybmF1ZCBQYXRhcmQKPGFybmF1ZC5w
YXRhcmRAcnRwLW5ldC5vcmc+IHdyb3RlOgo+IHJ0MngwMCBkZWJ1Z2ZzIGludGVyZmFjZSBkb2Vz
bid0IGNoZWNrIHRoZSBzaXplIG9mIHRoZSBkYXRhIGNvbWluZwo+IGZyb20gdXNlcnNwYWNlLCBs
ZWFkaW5nIHRvIGEgYnVpbGQgd2FybmluZy4gRml4IFRoYXQuCj4KPiB2MjogcmV0dXJuIEVJTlZB
TCBpZiBpbnB1dCBpcyB0b28gbG9uZwoKVGhhbmtzIQoKPiBTaWduZWQtb2ZmLWJ5OiBBcm5hdWQg
UGF0YXJkIDxhcm5hdWQucGF0YXJkQHJ0cC1uZXQub3JnPgoKQWNrZWQtYnk6IEl2byB2YW4gRG9v
cm4gPEl2RG9vcm5AZ21haWwuY29tPgoKPiBJbmRleDogcnQyeDAwL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3J0MngwMC9ydDJ4MDBkZWJ1Zy5jCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+IC0tLSBydDJ4MDAub3JpZy9k
cml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyeDAwZGVidWcuYyCgIKAgoCAyMDEwLTA4LTIz
IDE4OjAzOjMxLjQxNDgyNjExMyArMDIwMAo+ICsrKyBydDJ4MDAvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnQyeDAwL3J0MngwMGRlYnVnLmMgoCCgMjAxMC0wOC0yMyAyMDozNzoyNC44OTQzNjY1NDcg
KzAyMDAKPiBAQCAtNDgwLDYgKzQ4MCw5IEBAIHN0YXRpYyBzc2l6ZV90IHJ0MngwMGRlYnVnX3dy
aXRlXyMjX19uYW0KPiCgIKAgoCCgaWYgKGluZGV4ID49IGRlYnVnLT5fX25hbWUud29yZF9jb3Vu
dCkgoCCgIKAgoCCgIKAgoCCgIKBcCj4goCCgIKAgoCCgIKAgoCCgcmV0dXJuIC1FSU5WQUw7IKAg
oCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgXAo+IKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCg
IKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoFwKPiArIKAgoCCgIGlmIChs
ZW5ndGggPiBzaXplb2YobGluZSkpIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgXAo+ICsg
oCCgIKAgoCCgIKAgoCByZXR1cm4gLUVJTlZBTDsgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCg
IKAgoCBcCj4gKyCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAg
oCCgIKAgoCCgIKAgoCCgIFwKPiCgIKAgoCCgaWYgKGNvcHlfZnJvbV91c2VyKGxpbmUsIGJ1Ziwg
bGVuZ3RoKSkgoCCgIKAgoCCgIKAgoCCgIKBcCj4goCCgIKAgoCCgIKAgoCCgcmV0dXJuIC1FRkFV
TFQ7IKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgXAo+IKAgoCCgIKAgoCCgIKAgoCCg
IKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoCCgIKAgoFwKPgo+Cj4K

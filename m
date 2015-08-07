Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40071 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbbHGDZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 23:25:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZNYHH-0004fb-LS
	for linux-wireless@vger.kernel.org; Fri, 07 Aug 2015 05:25:03 +0200
Received: from AAmiens-654-1-46-208.w92-142.abo.wanadoo.fr ([92.142.221.208])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2015 05:25:03 +0200
Received: from thepoon by AAmiens-654-1-46-208.w92-142.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2015 05:25:03 +0200
To: linux-wireless@vger.kernel.org
From: Hugo Denizart <thepoon@cartooncraft.fr>
Subject: Re: [PATCH RFC:rxctl wait timed out] brcmfmac: add BCM43526 USB support
Date: Fri, 7 Aug 2015 03:19:35 +0000 (UTC)
Message-ID: <loom.20150807T051418-51@post.gmane.org> (sfid-20150807_052512_234044_936A5585)
References: <1431030535-11083-1-git-send-email-zajec5@gmail.com> <554C81D2.8080602@broadcom.com> <CACna6rxV_sR1WhrHRwtM8cjengsCbm_iUWzy0n_+fLYmxypmMw@mail.gmail.com> <554C8D96.9030205@broadcom.com> <CACna6rzR4r_dKjAT+EMNMU7fPuHxNa=VTdkNQ41uy5mKy4XgMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVALi4uPiB3cml0ZXM6Cgo+IAo+IE9uIDggTWF5IDIwMTUgYXQgMTI6MTksIEFyZW5kIHZhbiBTcHJpZWwgPGFyZW5kQC4uLj4gd3JvdGU6Cj4gPiBPbiAwNS8wOC8xNSAxMTo1MywgUmFmYcWCIE1pxYJlY2tpIHdyb3RlOgo+ID4+IERvIHlvdSBoYXZlIGFueSBpZGVhIGFib3V0IEJDTTQzNTI2IHJldiAzKz8gVGhlIGNoaXBzZXRzIHVzaW5nIDQzNTI2Ygo+ID4+IGluc3RlYWQgb2YgNDM1MjZhLiBBbnkgY2hhbmNlIEJDTTQzNTI2IHJldiAzKyBpcyBub3JtYWwgRnVsbE1BQyBkZXZpY2UKPiA+PiBqdXN0IGxpa2UgQkNNNDMyMzYgcmV2IDMrPwo+ID4KPiA+Cj4gPiBJIGRvbid0IGtub3cuIE1haW4gdGhpbmcgbmVlZGVkIGZvciB0aGF0IGlzIG1vcmUgb24tY2hpcCBtZW1vcnksIHdoaWNoIG1ha2VzCj4gPiBpdCBhIGJpdCBtb3JlIGV4cGVuc2l2ZS4gVGhpcyBtYXkgYmUgYSBkZWFsIGJyZWFrZXIgZm9yIGV4aXN0aW5nIDQzNTI2Cj4gPiBjdXN0b21lcnMgdW5sZXNzIHRoZXkgbGlrZSB0aGUgZnVsbG1hYyBhZHZhbnRhZ2VzIHRoZXkgZ2V0IGZvciB0aGVpciBtb25leS4KPiAKPiBDb3VsZCB5b3UgYXNrIHNvbWVvbmUgYXQgQnJvYWRjb20gYWJvdXQgdGhpcyA0MzUyNiByZXYgMys/Cj4gCj4gSSd2ZSBjaGVja2VkIEFzdXMncyBmaXJtd2FyZSBmb3IgQUM1M1UgYW5kIGl0IGNvbnRhaW5zIHdsLmtvIGFuZAo+IHdsX2hpZ2gua28uIFRoZWlyIHdsX2hpZ2gua28gd2FzIGNvbXBpbGVkIHdpdGggNDMyMzZiLWJtYWMtdXNiYXAsCj4gNDM1MjZiLWJtYWMtdXNiYXAgYW5kIDQzNjBiLWJtYWMtdXNiYXAgYnVpbHQtaW4uIEJ1dCBJIHN0aWxsIGhhdmUgbm8KPiBpZGVhIGlmIHRoaXMgd2xfaGlnaC5rbyB3aXRoIDQzNTI2YiBzdXBwb3J0IGlzIGZvciBGdWxsTUFDIGhhcmR3YXJlIG9yCj4gbm90Lgo+IAoKCkhpLAoKVGhpcyB0aHJlYWQgaXMgMyBtb250aHMgb2xkLiBEaWQgeW91IGdvdCBCQ000MzUyNiB3b3JraW5nPwpJIGJvdWdodCBhbiBBc3VzIFVTQi1BQzUzIHNvbWUgbW9udGhzIGFnbyBhbmQgSSB3b3VsZCByZWFsbHkgbGlrZSB0byBnZXQgaXQKd29ya2luZyBuYXRpdmVseSBvbiBMaW51eC4KVG8gdXNlIGl0LCBJIG5lZWQgdG8gaGF2ZSBhIFdpbmRvd3MgdmlydHVhbCBtYWNoaW5lIGNvbnN0YW50bHkgcnVubmluZy4gNEdCCm9mIFJBTSB1c2VkIHRvIGdldCBhIFVTQiBkb25nbGUgd29ya2luZywgeWVhaCEKClJlZ2FyZHM=


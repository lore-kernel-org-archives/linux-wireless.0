Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A186C001DC
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Jul 2023 09:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjGaJ4b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Jul 2023 05:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjGaJ4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2023 05:56:11 -0400
Received: from mail03.softline.ru (mail03.softline.ru [185.31.132.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567ED10C7
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2023 02:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=softline.com;
        s=relay; t=1690797312;
        bh=F/gXVdASlEbjanF2aJQh2pegyk2hyTfUsZKZmA0Fcho=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NDa1R44nbLNhllFZ9Z3KqMPCrozCAVaKUuYc1NhLMvdI/ZV2AdDIbPp5Ecu8lJ99/
         Rcpsrj9lsaSXpLypBYN/5MDnvnTn++ycBnFuqTK+WGnsA/603M3vdh+wpWfCeU6v11
         KE9YFUTbRg46018Cwavg891yzg/b1aIjr5zEh4whBKY3Ow4W0BI6bpd5ZQGPdJRcR7
         YTYM+DvBk8kThs2T6ybS9SeeyuAyjRUpl+EZ1hRI4Uy2F6frbr7+yGLmwaStBIgQg4
         4PzArzcMQMgy4a/48K38UfOhffM/Rpwj6gFvVkun9zs9hGgAdN6gpkcJIHTPMqGhpx
         YhBiqhANPBAtA==
X-AuditID: 0a02150b-b29a1700000026cc-d5-64c78500cba1
From:   "Antipov, Dmitriy" <Dmitriy.Antipov@softline.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "dmantipov@yandex.ru" <dmantipov@yandex.ru>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "briannorris@chromium.org" <briannorris@chromium.org>
Subject: Re: [lvc-project] [PATCH 1/5] [v2] wifi: mwifiex: fix memory leak in
 mwifiex_histogram_read()
Thread-Topic: [lvc-project] [PATCH 1/5] [v2] wifi: mwifiex: fix memory leak in
 mwifiex_histogram_read()
Thread-Index: AQHZw5PY7FWnTUFZUEqM5F9Mc0rZ4K/TcL6A
Date:   Mon, 31 Jul 2023 09:55:11 +0000
Message-ID: <63e64701d7cece0e34e2bb461c6f2fd98bb2c2af.camel@softline.com>
References: <ZMFzBStAKemf+dLL@google.com>
         <20230728084407.101930-1-dmantipov@yandex.ru> <87cz08za5h.fsf@kernel.org>
In-Reply-To: <87cz08za5h.fsf@kernel.org>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <F10D47B504C16A438C2ED592921C2E24@softline.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDIzLTA3LTMxIGF0IDEyOjQ2ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KDQo+
ID4gdjI6IGFkanVzdCB0byBtYXRjaCBzZXJpZXMNCj4gDQo+IEkgZG9uJ3Qga25vdyB3aGF0IHRo
YXQgbWVhbnMuIFBsZWFzZSB0cnkgdG8gYmUgc3BlY2lmaWMgaW4gdGhlDQo+IGNoYW5nZWxvZyBl
bnRyaWVzLg0KDQpVc3VhbGx5IGl0IG1lYW5zIHRoYXQgaWYgc29tZXRoaW5nIGlzIGNoYW5nZWQg
aW4gdGhlIG1pZGRsZSBvZiB0aGUNCnNlcmllcywgc3Vycm91bmRpbmcgcGF0Y2hlcyBhcmUgc2xp
Z2h0bHkgdHdlYWtlZCB0byBlbnN1cmUgdGhhdA0KZXZlcnl0aGluZyBzdGlsbCBhcHBsaWVzIGNs
ZWFybHkgKGkuZS4gd2l0aG91dCBvZmZzZXRzKS4gSWYgdGhlcmUNCmlzIHNvbWV0aGluZyBtb3Jl
IHN1YnN0YW50aWFsLCBJJ20gZG9pbmcgbXkgYmVzdCB0byBleHBsaWNpdGx5DQptZW50aW9uIGl0
Lg0KDQpEbWl0cnkNCg0K

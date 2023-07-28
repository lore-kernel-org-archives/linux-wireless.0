Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C61C001DE
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jul 2023 09:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjG1Jke (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jul 2023 05:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjG1Jk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2023 05:40:26 -0400
X-Greylist: delayed 634 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Jul 2023 02:40:16 PDT
Received: from mail03.softline.ru (mail03.softline.ru [185.31.132.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE4A30DE
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jul 2023 02:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=softline.com;
        s=relay; t=1690536575;
        bh=FvUHsBixHeSS1LEuE0dI2GpD9F7jVjH0Rg4ZduGI+F0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=KrCRvvvEh661brRZxQQ9IPjb6V2LInEd2mpFn0gEABDGzzfcRJrYjuFrAVpZdXkZz
         Yh8APh21Ze73eKBLM3wu6UUj2DeLj1Iyvz5J1EG+aC4+O3+6lAJfo8+swGvlWFGred
         9tEbNolSVxT+4PmQaTC4yHLDWdl7qqY1sNHjcNdo5fRPGu8apWxbXmEH/KsD7Wj/Td
         yFs3z/BSQSBW4Vmc3Jhw3IfpgZ3h1OmF/ALwkQzzMBRgfNBG5atSDGJqusDZnWpqfM
         iFgKvt+NxdyYWDmlRn/pYyv6k5vBrX9RlUcQ2jQZbqhADBNPU8yFgrMkytNjEuB+/P
         OLRUnHoQZ34wQ==
X-AuditID: 0a02150b-b29a1700000026cc-ba-64c38a7e452a
From:   "Antipov, Dmitriy" <Dmitriy.Antipov@softline.com>
To:     "dmantipov@yandex.ru" <dmantipov@yandex.ru>,
        "briannorris@chromium.org" <briannorris@chromium.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [lvc-project] [PATCH 1/5] wifi: mwifiex: fix memory leak in
 mwifiex_histogram_read()
Thread-Topic: [lvc-project] [PATCH 1/5] wifi: mwifiex: fix memory leak in
 mwifiex_histogram_read()
Thread-Index: AQHZv/tvtiGPYAALQk+oENc6jqNL5K/OuceA
Date:   Fri, 28 Jul 2023 09:29:34 +0000
Message-ID: <72372d59ccbc70ea322962158d066597c2c9fbe7.camel@softline.com>
References: <20230726072114.51964-1-dmantipov@yandex.ru>
         <ZMFzBStAKemf+dLL@google.com>
In-Reply-To: <ZMFzBStAKemf+dLL@google.com>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D33A87592D9CE48825C8963F5382E61@softline.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTI2IGF0IDEyOjI0IC0wNzAwLCBCcmlhbiBOb3JyaXMgd3JvdGU6DQoN
Cg0KPiBJIGhhZCBjb21tZW50cyBmb3IgcGF0Y2ggMi4gUGF0Y2ggMSwgMywgNCwgNSBsb29rIGdv
b2Q6DQo+IA0KPiBBY2tlZC1ieTogQnJpYW4gTm9ycmlzIDxicmlhbm5vcnJpc0BjaHJvbWl1bS5v
cmc+DQoNClNob3VsZCBJIGFkZCBBY2tlZC1ieTogPHlvdT4gdG8gYWxsIG9mIHRoZSBhYm92ZSBp
biBjYXNlDQpvZiByZXNlbmQgd2l0aG91dCBjaGFuZ2VzLCBvciBsZWF2ZSBpdCB0byB0aGUgbWFp
bnRhaW5lcj8NCg0KRG1pdHJ5DQo=

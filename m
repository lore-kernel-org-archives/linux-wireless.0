Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:61882 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZFJWRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 18:17:17 -0400
Received: by gxk10 with SMTP id 10so1499054gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 15:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
Date: Thu, 11 Jun 2009 00:17:19 +0200
Message-ID: <83a869cd0906101517k5897f1b8i19a8c840c6312d1d@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 9:42 PM, gregor kowski<gregor.kowski@gmail.com> wrote:
> On Tue, Jun 9, 2009 at 7:52 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Tue, 2009-06-09 at 19:48 +0200, gregor kowski wrote:
>>
>>> > Right. But drivers are free to even only _encrypt_ tkip frames and never
>>> > _decrypt_ them after having accepted a hardware key, iow that is
>>> > perfectly valid behaviour and I don't think we should keep uploading the
>>> > key to the driver. Worst case is that the proper upload fails and we
>>> > decrypt all frames in software until the next rollover.
>>> >
>>> What's the point of setting the tkip callback if we aren't interested
>>> in decrypting data by hardware ?
>>
>> Might depend on something else? Anyhow I don't see the point of
>> continuing to call the callback. Maybe it should just be part of the key
>> todo instead when the key is initially uploaded to the hw.
>
> Or what do you think about this. This will call the callback only once per wrap.
But this won't work if you want to support QOS.
So how update_tkip_key is supposed to work with QOS (ie different
rx->queue value) and multiple tkip IV ?

BTW did you know why there only one tkip IV on tx and not one per qos queue ?

Gregor

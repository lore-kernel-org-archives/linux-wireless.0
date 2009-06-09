Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:2751 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZFIRs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 13:48:29 -0400
Received: by wf-out-1314.google.com with SMTP id 26so71164wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 10:48:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244556179.4672.11.camel@johannes.local>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
Date: Tue, 9 Jun 2009 19:48:30 +0200
Message-ID: <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 4:02 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-06-08 at 19:51 +0200, gregor kowski wrote:
>
>> > There's a quite obvious disconnect between what your patch does and what
>> > your description says, please fix one of them. As it is, the patch only
>> > skips the IV rollover which is *completely* wrong because it will call
>> > the function for *every* packet.
>
>> I don't understand what you mean : the callback will be called for
>> every packet the hardware doesn't decrypted. If the hardware decrypt
>> the packet, only_iv is set and we don't go here.
>
> Right. But drivers are free to even only _encrypt_ tkip frames and never
> _decrypt_ them after having accepted a hardware key, iow that is
> perfectly valid behaviour and I don't think we should keep uploading the
> key to the driver. Worst case is that the proper upload fails and we
> decrypt all frames in software until the next rollover.
>
What's the point of setting the tkip callback if we aren't interested
in decrypting data by hardware ?

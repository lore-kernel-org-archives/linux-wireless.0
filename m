Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53507 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbZHDWDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:03:11 -0400
Received: by mail-bw0-f219.google.com with SMTP id 19so3351543bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 15:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908042358.15966.mb@bu3sch.de>
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
	 <200907312308.31066.mb@bu3sch.de>
	 <83a869cd0908041454i474b0ee4hfb770c7c5166be7f@mail.gmail.com>
	 <200908042358.15966.mb@bu3sch.de>
Date: Wed, 5 Aug 2009 00:03:11 +0200
Message-ID: <83a869cd0908041503i74a7bd11uf85706aeaf95b611@mail.gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/4/09, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 04 August 2009 23:54:42 gregor kowski wrote:
>> On 7/31/09, Michael Buesch <mb@bu3sch.de> wrote:
>> > On Friday 31 July 2009 23:04:17 gregor kowski wrote:
>> >> Hi Michael,
>
>> There is really bugs in the current code.
>
> You always talk about "bugs". What are these "bugs"? Is it just the wrong
> max_nr_keys assignment? That's trivial to fix.
>
So [1] is ok ?

Thanks,

Gregor

[1]
> So the fix will be do to something like
> dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
> if (b43_new_kidx_api())
> dev->max_nr_keys -= 4;

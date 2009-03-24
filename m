Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:45495 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZCXBMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 21:12:05 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3117311wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 18:12:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903231740m6b804fa5mfdcfe57ae07702a7@mail.gmail.com>
References: <49C82719.3080108@hauke-m.de> <43e72e890903231740m6b804fa5mfdcfe57ae07702a7@mail.gmail.com>
Date: Mon, 23 Mar 2009 18:11:48 -0700
Message-ID: <43e72e890903231811t2ecf7f89lb72fc79ffd37a96@mail.gmail.com> (sfid-20090324_021210_857329_97B0CD0A)
Subject: Re: [PATCH] compat-2.6: Add AR9170 driver
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 5:40 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Mar 23, 2009 at 5:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This adds the AR9170 driver to compat-wireless.
>
> Thanks applied and new tarball regenerated.
>
> The patch commit log (which cannot be seen as the patch was attached)
> only enables ar9170 for >= 2.6.28. If someone wants to get this on
> 2.6.27 you'll just have to backport the routines which fail to
> compile. Patches welcomed of course.

I did some quick review on this. One of the routines I had heard fails
on 2.6.27 is usb_poison_anchored_urbs. This was added via 6a2839b.
This just adds the routine, the users are the drivers themselves. To
poison a URB it makes use of the extends the struct usb_anchor, so
directly porting it doesn't seem to make sense. Best bet seems to be
just backporting to not poison and do a replacement call.

Fun enough ar9170 is currently the only driver using this.

Hm, not sure if a no-op would do it.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48305 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab0DVUdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 16:33:22 -0400
Received: by pwj9 with SMTP id 9so6375909pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 13:33:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271954537.8469.15.camel@mj>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
	<g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
	<1271954537.8469.15.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 22 Apr 2010 13:33:00 -0700
Message-ID: <x2l43e72e891004221333he942ee92u3ef4c6994d769694@mail.gmail.com>
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
To: Pavel Roskin <proski@gnu.org>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 22, 2010 at 9:42 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-04-22 at 09:33 -0700, Luis R. Rodriguez wrote:
>
>> How was this compiling for older kernels before then?
>
> Compiling was fine, but loading the firmware was failing sometimes.  I'm
> glad somebody figured it out.  Thank you, Grazvydas!

OK Applied. I'm still puzzled, if it compiled, then that means
dev_set_uevent_suppress() was being defined somehow for older kernels.

> I would prefer to have replacement functions in compat-2.6.30.h rather
> than ifdefs in the code.  We might want to resync compat_firmware with
> the kernel one day, and ifdefs would stand in the way.

Good point, I merged the patch for now given that that file does't
change that often upstream.

  Luis

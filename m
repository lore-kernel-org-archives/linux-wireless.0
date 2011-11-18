Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57628 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab1KRXDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 18:03:43 -0500
Received: by eye27 with SMTP id 27so3939969eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 15:03:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111118223445.GA5642@tuxdriver.com>
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
 <1321655181.2367.1.camel@Joe-Laptop> <20111118223445.GA5642@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Fri, 18 Nov 2011 15:03:21 -0800
Message-ID: <CAB=NE6Ux=R3odTDkoibHs2E5aiMvaF1GuD-7Nv3-9ZabT74-bQ@mail.gmail.com> (sfid-20111119_000346_779294_9DBF2194)
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 2:34 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Nov 18, 2011 at 02:26:21PM -0800, Joe Perches wrote:
>> On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
>> > The way the compat-* header files are included causes the default
>> > pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
>> > Files that define pr_fmt then generate a lot of build SPAM about
>> > pr_fmt being redefined.
>> >
>> > Eliminate the build noise by preemptively undefining pr_fmt in those
>> > files that define it.  This is accomplished by adding a patch to the
>> > patches directory.
>>
>> Why not undef pr_fmt after the compat-* headers?
>
> That caused a build break.  IIRC, not everyone that uses pr_*
> defines pr_fmt.  If pr_fmt is undef'd then they don't compile.

Hm, would it work if we undef but then define it?

  Luis

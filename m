Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39767 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2FVQ6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 12:58:44 -0400
Received: by obbuo13 with SMTP id uo13so2181036obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 09:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFub=KRMPxbKw=izGHEP4BPLreuHdTTq8SyD7asj0Xq5r-h8aQ@mail.gmail.com>
References: <1340292308-6993-1-git-send-email-ozancag@gmail.com>
 <CAB=NE6Uh90nV00TKSk+Rh9AG0yffKkYBZ7DiAe0Hvds-wMXQcg@mail.gmail.com> <CAFub=KRMPxbKw=izGHEP4BPLreuHdTTq8SyD7asj0Xq5r-h8aQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 22 Jun 2012 09:58:22 -0700
Message-ID: <CAB=NE6X6o_jYbiLthGVL23Ow5KEPfnfL1m=TZEDPG3HGORbKcQ@mail.gmail.com> (sfid-20120622_185847_422634_0F9BDDC2)
Subject: Re: [PATCH v2] compat: Define include guard for vga_switcheroo.h
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 4:25 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> How about just adding this file but with something like this:
>>
>> #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
>> /*
>>  * XXX: The include guard was sent upstream, drop this
>>  * once the guard is merged.
>>  */
>> #ifndef LINUX_VGA_SWITCHEROO_H /* in case this gets upstream */
>> #include_next <linux/vga_switcheroo.h>
>> #ifndef LINUX_VGA_SWITCHEROO_H /* do not redefine once this gets upstream */
>> #define LINUX_VGA_SWITCHEROO_H
>> #endif /* case 1 LINUX_VGA_SWITCHEROO_H
>> #endif /* case 2 LINUX_VGA_SWITCHEROO_H
>> #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
>
> Ah, that is much clever, thanks.

No problem!

> I've tested in and it works correctly, will send a v3. But just to
> make clear: I'm just adding a vga_switcheroo.h with the above content
> and I don't touch compat-3.5.h right?

Yeap.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42061 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab2JaNEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 09:04:07 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1044943lbo.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 06:04:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1578864.KppKrIJQWb@lx-vladimir>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1351511906-19989-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20121031012225.GY3354@lenteja.do-not-panic.com> <1578864.KppKrIJQWb@lx-vladimir>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 31 Oct 2012 06:03:45 -0700
Message-ID: <CAB=NE6WXsQ2PF0Ce8x1wsuYWqgKAOeto4mRzRAnTVBbE4bh-9g@mail.gmail.com> (sfid-20121031_140413_622225_00199B21)
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 31, 2012 at 5:57 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
>> You didn't also address my comments regarding WIL6210_ISR_COR #ifdef code.
>
> I added string with short explanation in Kconfig.
> Longer explanation: while clear-on-read is good for production mode, it makes
> debugging much harder - reading ISR registers clears interrupt, and one can no
> more monitor ISR with debugfs. So, when debugging ISR flows - and they still
> need some debugging - one have to use W1C mode. That's why it is still
> present.
>
> There are exactly 2 #ifdefs: one in ISR acknowledge routine, and other one in
> ISR configuration routine.
>
> Converting this #ifdef to run-time switch (say, module parameter) is possible,
> but I am not sure it would be better - changing ISR mode will cause reset; ans
> code will not more readable.

I meant, can you auto detect the preference for this option instead of
requiring a Kconfig entry? Ie, can you infer what the desired path
should be by poking at the driver? If not can you consider folding the
#ifdef juju code into a helper such as

#ifdef CONFIG_FOO
static void bar()
{
   apples()
}
#else
static void bar()
{
   oranges()
}
#endif

  Luis

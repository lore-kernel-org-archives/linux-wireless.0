Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34073 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbbHXJxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 05:53:02 -0400
MIME-Version: 1.0
In-Reply-To: <55C7AC1D.7050602@redhat.com>
References: <1436876558-6674-1-git-send-email-dvlasenk@redhat.com>
	<55A502B6.5090806@cogentembedded.com>
	<CAK1hOcPvb3mOeVm5HMqSCKAyJv47HturM+C9uxvA1=KWn94dtw@mail.gmail.com>
	<CANUX_P2=J81pJpyeMLEf+un=Pe8MhoGz7QJrrRUe19oeux8BhQ@mail.gmail.com>
	<55C7AC1D.7050602@redhat.com>
Date: Mon, 24 Aug 2015 12:53:00 +0300
Message-ID: <CANUX_P1o13fBKaeEj7ECvKgQ+KN3yyHoG6XriDks9J15rmXHBA@mail.gmail.com> (sfid-20150824_115324_678341_0FACF421)
Subject: Re: [PATCH] iwlwifi: Deinline iwl_{read,write}{8,32}
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > I'll try to come up with a patch that is easier for me to read, but I
> > am really busy right now. Ping me in a week if you have heard from me
> > earlier.
>
> So how it is going with this patch?
>
> In hindsight, I would use a different name for the macro parameter here:
>
> #define IWL_READ_WRITE(static_inline) \
> +static_inline void iwl_write8(...)
>
> "static_inline" proved to be confusing.
> Maybe perform s/static_inline/func_qualifier/ on the patch...
>

In the end, I un-inlined these functions unconditionally.
It won't make it for 4.3 though.

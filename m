Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:46172 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXLJVS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 16:18:26 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3572758wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 13:18:25 -0800 (PST)
Message-ID: <1ba2fa240712101318q303df7c3x407b4d4de3d42713@mail.gmail.com> (sfid-20071210_211832_292999_26C54561)
Date: Mon, 10 Dec 2007 23:18:21 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <1197303938.6035.100.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>
	 <200712101630.48124.mb@bu3sch.de>
	 <1ba2fa240712100821u284571d7k39b326e58aac93af@mail.gmail.com>
	 <1197303938.6035.100.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 10, 2007 6:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> You could even code the "set little tiny bit in it" as
>
> struct->flags |= cpu_to_le32(flag value);
>
> which all other drivers do.

I hope you grep the kernel before you wrote this :). No iwlwifi is not
the only driver that does that. I cannot claim invented this.

> It boils down to what I just said:
>
> Most people prefer making endian conversions explicit in the code while
> you're hiding it in defines which is unintuitive if only because it
> differs from what everybody else does.

We did it because it's more readable for us you are free to think
differently. If you referring to everybody else as the code of other
drivers then they are different because the HW is different.

Just make it clear I'm part of this argument because I believe I'm
correct from technical point.. We didn't hide anything and we are glad
that other people contribute to the iwlwifi. any other suggestions are
pure speculations.

Personally I think this conversation was saturated enough. I'll
reconsider all your suggestions mainly the cpup stuff that I wasn't
aware of.
Thanks
Tomas

> johannes
>

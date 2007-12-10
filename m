Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:28349 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXLJQV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:21:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3433288wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 08:21:26 -0800 (PST)
Message-ID: <1ba2fa240712100821u284571d7k39b326e58aac93af@mail.gmail.com> (sfid-20071210_162134_240116_972B549F)
Date: Mon, 10 Dec 2007 18:21:26 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <200712101630.48124.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>
	 <200712101630.48124.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> my_data = read_drom_device()
> swap_to_cpu(my_data)
> do_whatever(my_data)
> store the data somewhere else in the device structs for
> later use, maybe.
> do_something_else(my_data)
>
> You see that now you have only _one_ place that you have to care about.
> And if you have to write your data back at some point, simply do it
> just before the write.
>

Correct xxcept that this is not the case.

Our case is

Loop:
 my_big_little_endian_struct.
 set little tiny bit in it
 send to HW
end



> And, little endian intel guys, this will simplify your life a lot by
> removing lots of cpu_to_xxx stuff _and_ result
> in no performance loss, as the swap will be optimized away. :)
> That's a deal, eh?
> And we big endian people, we don't care about one or two swap instructions.
> It won't hurt performance in any way.

I care. I'm running it on big endian, truly. Yes I cannot really say
how the performance be hurt, but I still prefer my way.

> (Johannes also showed that in most cases this approach doesn't even
> add extra instructions).
>
> --
> Greetings Michael.
>

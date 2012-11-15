Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41821 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993480Ab2KORcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 12:32:04 -0500
Message-ID: <1353000723.17678.10.camel@joe-AO722> (sfid-20121115_183208_768767_016F3472)
Subject: Re: [PATCH v8 4/4] dynamic_debug: dynamic hex dump
From: Joe Perches <joe@perches.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 15 Nov 2012 09:32:03 -0800
In-Reply-To: <CAMXE1-oypT8XMZBxBwKP5v9+xW4QS579PtmhCgPhxhodHoVETw@mail.gmail.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352978222-13866-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <CAMXE1-oypT8XMZBxBwKP5v9+xW4QS579PtmhCgPhxhodHoVETw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-15 at 17:55 +0200, Andrei Emeltchenko wrote:
> Hi Vladimir,
> 
> On Thu, Nov 15, 2012 at 1:17 PM, Vladimir Kondratiev
> <qca_vkondrat@qca.qualcomm.com> wrote:
> > Introduce print_hex_dump_debug() that can be dynamically controlled, similar to
> > pr_debug.
> 
> You could just use "%*ph" specifier in pr_debug

Possibly true, but %*ph doesn't emit ascii nor
does it format a large block of data very well.

Maybe use of
	pr_debug("%*ph", len, buf)
vs
	print_hex_dump_bytes("prefix", DUMP_PREFIX_<STYLE>, buf, len)

could be described a bit in dynamic_debug_howto
or perhaps all of the various printk, dev_<level>,
<subsystem>_<level> styles and all the various
debugging options would be better described in a
new printk_howto


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:43216 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYKSMZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 07:25:01 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3676458wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 04:25:00 -0800 (PST)
Message-ID: <1ba2fa240811190424v4b9074e5u4e679bea278b1f3@mail.gmail.com> (sfid-20081119_132506_697331_EBB54972)
Date: Wed, 19 Nov 2008 14:24:59 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1227094832.26243.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227055693.4014.95.camel@johannes.berg>
	 <1ba2fa240811190121h3ff51824o90b72a206192e793@mail.gmail.com>
	 <1227094832.26243.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 1:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 11:21 +0200, Tomas Winkler wrote:
>
>> > Indeed. One would seem to be the buffer list itself, which also needs to
>> > fit within a 40-bit mask with 256 alignment (rxq->bd), the rb_stts needs
>> > 16-byte alignment which probably is always satisfied, but I'm not sure,
>> > you'll need to research the alignment guarantees.
>>
>> Note these are allocated using persistent calls and not kmalloc I hope
>> at least does are page alignment.
>
> Good point. On powerpc at least that uses alloc_pages internally.

Not sure if if wouldn't be better just work directly with pages in RX?

Tomas

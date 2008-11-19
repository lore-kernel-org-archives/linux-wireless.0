Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:6510 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYKSJVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 04:21:43 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3607007wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 01:21:43 -0800 (PST)
Message-ID: <1ba2fa240811190121h3ff51824o90b72a206192e793@mail.gmail.com> (sfid-20081119_102147_445706_AC6DE813)
Date: Wed, 19 Nov 2008 11:21:42 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1227055693.4014.95.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227055693.4014.95.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 2:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> [dropping a few CCs]
>
> On Tue, 2008-11-18 at 16:13 +0200, Tomas Winkler wrote:
>
>> There are other places with alignment requirement in the driver we
>> probably need to address as well.
>
> Indeed. One would seem to be the buffer list itself, which also needs to
> fit within a 40-bit mask with 256 alignment (rxq->bd), the rb_stts needs
> 16-byte alignment which probably is always satisfied, but I'm not sure,
> you'll need to research the alignment guarantees.

Note these are allocated using persistent calls and not kmalloc I hope
at least does are page alignment.
We have some alignment requirements also on TX side

>
> Another, different, question: I don't see where the driver tells the
> hardware how large the buffers are it allocated. Can you point me to
> that? You can switch 4k/8k ampdu but I don't see where you tell the
> hardware.

in iwl_rx_init
 rb_size =
 FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K .. 8K .. can go up to 16K.
This  amsdu size (not ampdu) influence the size of RB we choose

Tomas

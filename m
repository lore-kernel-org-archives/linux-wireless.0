Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34274 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161435AbcA0VFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 16:05:55 -0500
Message-ID: <1453928752.20722.27.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20160127_220606_255734_1536AEFE)
Subject: Re: [PATCH RESEND net] nfc: use GFP_USER for user-controlled kmalloc
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	netdev <netdev@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 27 Jan 2016 13:05:52 -0800
In-Reply-To: <CAM_iQpXOEQhwPp6HD3L16DV1tygEyKNoHH+zHkukux7zYzaJeA@mail.gmail.com>
References: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
	 <CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com>
	 <CAM_iQpWawou1Z_NnAzM5TxH7TUQUCAhf+k96PErNV8q_SOCShw@mail.gmail.com>
	 <1453861388.11327.51.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAM_iQpXOEQhwPp6HD3L16DV1tygEyKNoHH+zHkukux7zYzaJeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 11:50 -0800, Cong Wang wrote:

> Hmm? I think nfc_llcp_send_ui_frame() needs to do some fragmention
> with this temporary memory, or you are saying msg_iter has some
> API available to seek the pointer? Even if so, it doesn't look like
> suitable for -stable.
> 

memcpy_from_msg(msg_data, msg, len) will overwrite the msg_data with len
bytes, or return an error.

So prior msg_data content does not matter.

kzalloc() before a memset() or memcpy() sounds defensive programming,
kmalloc() is a bit faster.




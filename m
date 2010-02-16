Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:39001 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab0BPUEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:04:12 -0500
Received: by pzk17 with SMTP id 17so5422056pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:04:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266117186.13902.21.camel@mj>
References: <1266117186.13902.21.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 12:03:51 -0800
Message-ID: <43e72e891002161203w4498ae09wc7d14d12dd75be09@mail.gmail.com>
Subject: Re: [PATCH] mwl8k: disable softirqs when accessing sta_notify_list
To: Pavel Roskin <proski@gnu.org>
Cc: Lennert Buytenhek <buytenh@marvell.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 13, 2010 at 7:13 PM, Pavel Roskin <proski@gnu.org> wrote:
> Use spin_[un]lock_bh in mwl8k_sta_notify().  The sta_notify handler is
> required to be atomic, yet it can be called in process context, so make
> sure one call won't preempt another.

Is this for stable as well?

 Luis

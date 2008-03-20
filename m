Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:36467 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYCTOjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 10:39:10 -0400
Received: by py-out-1112.google.com with SMTP id u52so1269689pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2008 07:39:08 -0700 (PDT)
Message-ID: <87a5b0800803200739v6d222afck850f221eae1edd70@mail.gmail.com> (sfid-20080320_143915_124685_4EA0E077)
Date: Thu, 20 Mar 2008 14:39:08 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
Cc: "Daniel Drake" <dsd@gentoo.org>,
	"Linux Kernel list" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
In-Reply-To: <1206023695.16475.137.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206023695.16475.137.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 20, 2008 at 2:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

>  +For some ethernet hardware that cannot DMA to unaligned addresses like
>  +4*n+2 or non-ethernet hardware, this can be a problem, and it is then
>  +required to copy the incoming frame into an aligned buffer. Because this is
>  +unnecessary on architectures that can do unaligned accesses, the code can be
>  +made depend on CONFIG_ARCH_CAN_UNALIGNED_ACCESS like so:
>  +
>  +#ifdef CONFIG_ARCH_CAN_UNALIGNED_ACCESS
>  +       skb = copy skb
>  +#else
>  +       skb = original skb
>  +#endif

Is this logic reversed?

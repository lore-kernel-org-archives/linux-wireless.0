Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64139 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KVSAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:00:16 -0500
Received: by pzk6 with SMTP id 6so167454pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:00:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
References: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Nov 2010 09:59:53 -0800
Message-ID: <AANLkTimHRp+1y44cQEgR5KPPioP=sXUvOnhLxd_A_xzE@mail.gmail.com>
Subject: Re: [COMPAT] Preventing namespace pollution
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 5:29 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi folks,
>
> The second part of the changes I made as part of my work on the
> compatibility headers concerned namespace pollution.
>
> The problem was the following. My module is doing relatively high
> level stuff in the kernel. It interracts with the network stack,
> netfilter, the socket layer, etc. It does not deals with low-level
> driver stuff. The issue was that including <linux/compat.h> bring a
> _huge_ quantity of dependency with it, interrupt, thread, sysfs...
> This is problematic as for some compilation unit, I should include as
> few Linux header as possible (understand: if I don't include
> <linux/tcp.h>, I don't want it included behind my back).
>
> In order to workaround the problem, I simply wrapped every accessors
> and struct definition within #ifdef checking if the parent header is
> in use or not.
>
> Considering the following exemple:
>
> 2.6.22:
>  static inline unsigned char *
>  skb_network_header(const struct sk_buff *skb)
>  {
>        return skb->nh.raw;
>  }
>
>  [...]
>
>  static inline struct iphdr *
>  ip_hdr(const struct sk_buff *skb)
>  {
>        return (struct iphdr *)skb_network_header(skb);
>  }
>
>  static inline unsigned int
>  ip_hdrlen(const struct sk_buff *skb)
>  {
>        return ip_hdr(skb)->ihl * 4;
>  }
>
> Every compilation unit would need to have both <linux/skbuff.h>,
> <linux/ip.h> and <net/ip.h> included. If the useful code does not
> deals about networking, that's just pollution.
>
> The solution I propose would transform this to:
>
> 2.6.22:
>  /* <linux/skbuff.h> */
>  #ifdef _LINUX_SKBUFF_H
>  static inline unsigned char *
>  skb_network_header(const struct sk_buff *skb)
>  {
>        return skb->nh.raw;
>  }
>  #endif
>
>  [...]
>
>  /* <linux/ip.h> */
>  #ifdef _LINUX_IP_H
>  static inline struct iphdr *
>  ip_hdr(const struct sk_buff *skb)
>  {
>        return (struct iphdr *)skb_network_header(skb);
>  }
>  #endif
>
>  /* <net/ip.h> */
>  #ifdef _IP_H
>  static inline unsigned int
>  ip_hdrlen(const struct sk_buff *skb)
>  {
>        return ip_hdr(skb)->ihl * 4;
>  }
>  #endif
>
> That way, if the original code did not include the headers, it will
> just not get the compat definition. The macro checked is the one used
> as re-inclusion guard from the parent header which should be stable,
> but even if it changes, supporting the new is trivial. With this
> solution, the compat headers no longer needs to import all the headers
> it is providing compatibililty to, but just let the original source
> tells it what it needs compatibility for.
>
> I will send as answer to mail a proof of concept for 2.6.22

I suspect we'll find a case where headers are required to be included
for some older kernel where it was not required for newer ones but we
can find out. Just please be sure to test compile your patches against
each supported kernel and I think we'll be good!

  Luis

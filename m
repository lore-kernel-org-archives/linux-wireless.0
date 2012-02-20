Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47695 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2BTKbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 05:31:34 -0500
Received: by werb13 with SMTP id b13so3062306wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 02:31:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO1ZyKkq3nS=KfXF5BQu+SkUOjd2fT7onuMSo_3P2DEa_Du6cQ@mail.gmail.com>
References: <CAO1ZyKkq3nS=KfXF5BQu+SkUOjd2fT7onuMSo_3P2DEa_Du6cQ@mail.gmail.com>
From: Claudio Rossi <rossi.claudio.82@gmail.com>
Date: Mon, 20 Feb 2012 11:31:13 +0100
Message-ID: <CAO1ZyK=OBabkubphGj3BakXLFG6c248eXVnHSNCUHnLwTVNdTw@mail.gmail.com> (sfid-20120220_113137_511040_3370A58B)
Subject: Re: Accessing protocol type field from mac802.11
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
 I forgot to mention that in status.c everything works fine when I do:

struct iphdr * network_header;

network_header = (struct iphdr *)skb_network_header(skb);

 if (network_header->protocol==IPPROTO_TCP){
...
}


the problem is how to correctly set the network header pointer in the
skb in rx.c

Please, can somebody help?
Thank you

2012/2/17 Claudio Rossi <rossi.claudio.82@gmail.com>
>
> Dear all,
>  I would like to inspect the protocol type field from mac802.11, and
> specifically in rx.c in the function
>
> static ieee80211_rx_result debug_noinline
> ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>
> I was trying to do:
>
> struct iphdr * network_header;
> skb_set_network_header(skb,ieee80211_get_hdrlen_from_skb(skb));
> network_header = (struct iphdr *)skb_network_header(skb);
>
>  if (network_header->protocol==IPPROTO_TCP){
> ...
> }
> but it does not seams to work....
>
> can somebody give me an hint?
> I am sorry about this question, that may be silly... I am a beginner.
>
> Thank you
>
> --
> Claudio Rossi
> -------------------
> Office @ PoliTO: +39 011 5644194




--
Claudio Rossi
-------------------
Office @ PoliTO: +39 011 5644194

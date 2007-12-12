Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:28999 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbXLLSkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 13:40:02 -0500
Received: by py-out-1112.google.com with SMTP id u77so860578pyb.16
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2007 10:40:01 -0800 (PST)
Message-ID: <f6ca9fed0712121039n1c287f48n7ece3107bd0b50ca@mail.gmail.com> (sfid-20071212_184030_288233_FA4DE53C)
Date: Wed, 12 Dec 2007 19:39:59 +0100
From: drago01 <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: clean up frame receive handling
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Tomas Winkler" <tomasw@gmail.com>, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1197483844.6558.158.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197483844.6558.158.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 12, 2007 7:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> [comments welcome. I really need a refresher on what the frame formats
> mean but I think I did the right thing with skb->protocol here, I also
> think we had a bug with rfc2042 header frames bigger than 15xx bytes and
> eth_type_trans()]
>
> This cleans up the frame receive handling. After this patch
>  * EAPOL frames addressed to us or the EAPOL group address are
>    always accepted regardless of whether they are encrypted or not

why? userspace (wap_supplicant) tryes to control this depending on the
network settings.
(I don't really know why thought)
maybe it should be handled like drop_unencrypted with default to accept all?

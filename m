Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp26.msg.oleane.net ([62.161.4.26]:43466 "EHLO
        smtp26.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdAIIhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 03:37:09 -0500
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Stephen Hemminger'" <stephen@networkplumber.org>,
        "=?UTF-8?Q?'Linus_L=C3=BCssing'?=" <linus.luessing@c0d3.blue>
Cc: <netdev@vger.kernel.org>,
        "'David S . Miller'" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        "'Felix Fietkau'" <nbd@nbd.name>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue> <20170106191356.43740a26@xeon-e3>
In-Reply-To: <20170106191356.43740a26@xeon-e3>
Subject: RE: [PATCH net-next] bridge: multicast to unicast
Date: Mon, 9 Jan 2017 09:36:55 +0100
Message-ID: <002f01d26a53$88c8da60$9a5a8f20$@acksys.fr> (sfid-20170109_093713_679466_7EA405CC)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Message d'origine-----
> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] De la part de Stephen Hemminger
> Envoyé : samedi 7 janvier 2017 04:14
> À : Linus Lüssing
> Cc : netdev@vger.kernel.org; David S . Miller; bridge@lists.linux-
> foundation.org; linux-kernel@vger.kernel.org; linux-
> wireless@vger.kernel.org; Felix Fietkau
> Objet : Re: [PATCH net-next] bridge: multicast to unicast
> 
> On Mon,  2 Jan 2017 20:32:14 +0100
> Linus Lüssing <linus.luessing@c0d3.blue> wrote:
> 
> > This feature is intended for interface types which have a more
> > reliable and/or efficient way to deliver unicast packets than
> > broadcast ones (e.g. wifi).
> 
> 
> Why is this not done in MAC80211 rather than  bridge?

OTOH mac80211 has more information to decide whether it is more economic to send one multicast or several unicast.
It depends on the bitrate of each station, number of stations and the (not necessarily slower) bitrate of multicasts.

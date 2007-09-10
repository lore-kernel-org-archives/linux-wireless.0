Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:6837 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbXIJLlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:41:47 -0400
Received: by an-out-0708.google.com with SMTP id d31so146547and
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2007 04:41:46 -0700 (PDT)
Message-ID: <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
Date: Mon, 10 Sep 2007 14:41:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: A-MSDU deaggregation support
Cc: "mohamed salim abbas" <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1189354526.4506.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189354526.4506.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/9/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hey,
>
> I just looked at the deaggregation code for unrelated reasons and
> thought about it a bit more; shouldn't there be some sort of checks that
> the 802.11 rules about identical addresses are adhered to to avoid
> having rogue packets pretending to come from somewhere else enter the
> networking stack? This can usually be avoided by using RSNA, but this
> code allows one to easily circumvent this which makes us look pretty
> bad.
>
> Makes you wonder why they included full 802.3 framing in the
> subframes...
>
There is difference between receiving and destination address. AP is
receiving address but not the destination. If station sends packets to
multiple stations it still go through one AP (receiving address). The
only restriction is that all the packets in A-MSDU belongs to one TID
stream.

There is actually different problem with the A-MSDU deaggregation and
this is EPOL filtering. One of the packets might belong to EAPOL
handshake

Tomas

> johannes
>
>

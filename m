Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47531 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1LIJ7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 04:59:17 -0500
Received: by ghbz2 with SMTP id z2so2346191ghb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 01:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=7s67p8iQF3rt81vMPapOee=21J5wmT5PW8BiWuuev_Q@mail.gmail.com>
References: <1323420593-9638-1-git-send-email-helmut.schaa@googlemail.com>
	<CAJ-Vmo=7s67p8iQF3rt81vMPapOee=21J5wmT5PW8BiWuuev_Q@mail.gmail.com>
Date: Fri, 9 Dec 2011 10:59:16 +0100
Message-ID: <CAGXE3d9MjViF0GjfivbS0dUqCeTrR=x+HuiJEhauf_o=ncmQ3g@mail.gmail.com> (sfid-20111209_105922_060999_3BA2B543)
Subject: Re: [RFC] mac80211: Send BAR on same queue as the according QoS frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 9, 2011 at 10:10 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 9 December 2011 19:49, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
>> Sending as RFC for now since I'm not sure if this is really required. At least
>> I couldn't come up with a situation where this would be required. However, it
>> looks more correct to me to put the BAR into the same queue as the previously
>> failed QoS frame to avoid possible (?) side effect of the BAR overtaking frames
>> in the hw tx queues ...
>
> I've had to do this in FreeBSD, for more than just the BAR frame - I
> do this for the ADDBA and null management frames too, just to be sure
> that frames aren't dropped by the other end.

Hmm, good point. Also, a DELBA overtaking AMPDUs in the hw queues could
be a problem ...

Helmut

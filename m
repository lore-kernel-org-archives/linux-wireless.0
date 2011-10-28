Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1J1HwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 03:52:10 -0400
Received: by ywm3 with SMTP id 3so3436980ywm.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 00:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Fri, 28 Oct 2011 09:52:09 +0200
Message-ID: <CAGXE3d_9h-VMo3KaVThNXsXNVEAD4rVcKosMrjYVyKcfUD2=JQ@mail.gmail.com> (sfid-20111028_095218_944074_E12E9C44)
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 28, 2011 at 9:48 AM, Arend Van Spriel <arend@broadcom.com> wrote:
> I would expect this to affect the duration field in the
> 802.11 header to indicate the shorter use of the medium.
> Going through your patch I am not sure this is done.

I don't think so since the frame will still be acked by the peer as it is
a unicast management frame. But this will advise the hardware that it
does not need to wait for the ack to happen since we're not interested
in retrying it.

Helmut

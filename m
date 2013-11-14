Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:45863 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3KNVAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 16:00:01 -0500
Received: by mail-we0-f170.google.com with SMTP id p61so2697209wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 13:00:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADNhdGGeOcSS+nv_LCgCN4jpAf2Lk9j5juyw4ZeWAgnqUe=+AA@mail.gmail.com>
References: <CADNhdGGeOcSS+nv_LCgCN4jpAf2Lk9j5juyw4ZeWAgnqUe=+AA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 15 Nov 2013 02:29:40 +0530
Message-ID: <CABPxzYJm_tAZ4APfidQdgMi06vnSLhpouuu905nK41eTEOJq6Q@mail.gmail.com> (sfid-20131114_220006_561467_F3B556FC)
Subject: Re: [mac80211] 802.11 data packets Rx and Tx from user space
To: shankar swaminathan <shankswa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 8:31 PM, shankar swaminathan <shankswa@gmail.com> wrote:
> Hi,
>
> I had earlier posted a query specific to the rx path of mac80211.
> Here is a more complete set of two queries.
> Kindly help clarifying.
>
> I am working on building a PC based Access Point in linux and have the
> following queries:
>
> 1. Is there a mechanism for user space to receive 802.11 data packets
> with the 802.11 header intact. I do not want to use a monitor
> interface as I believe a monitor interface cannot be used to connect
> wireless clients. Please clarify.

If you want 802.11 header monitor interface is the only way (at least to
my knowledge), you can use 2 VIF's one for connection and one for
monitoring. Most chipsets support this.
>
> 2. From user space can i transmit a fully constructed 802.11 data
> frame. Will RAW sockets over WiFi work? I have not tried though.
You can use pcap API's, but you still need the monitor interface
(use 2VIF's as above)

http://wireless.kernel.org/en/users/Documentation/packetspammer

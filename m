Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34246 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2CHKY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 05:24:59 -0500
Received: by wejx9 with SMTP id x9so201300wej.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 02:24:58 -0800 (PST)
MIME-Version: 1.0
From: Claudio Rossi <rossi.claudio.82@gmail.com>
Date: Thu, 8 Mar 2012 11:24:38 +0100
Message-ID: <CAO1ZyKkpZy38vNc8iCOODnuVeJJPPb-DOH=+HFPvgGGjj+hDMA@mail.gmail.com> (sfid-20120308_112502_646685_B4043703)
Subject: Accessing PROTOCOL TYPE FILES from rx.c in mac80211
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
 I would like to inspect the protocol type field from mac802.11, and
specifically in rx.c in the function

static ieee80211_rx_result debug_noinline
ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)

I was trying to do:

struct iphdr * network_header;
skb_set_network_header(skb,ieee80211_get_hdrlen_from_skb(skb));
network_header = (struct iphdr *)skb_network_header(skb);

 if (network_header->protocol==IPPROTO_TCP){
...
}
but it does not seams to work....

In status.c everything works fine when I do:

struct iphdr * network_header;

network_header = (struct iphdr *)skb_network_header(skb);

 if (network_header->protocol==IPPROTO_TCP){
...
}

the problem is how to correctly set the network header pointer in the
skb in rx.c
can somebody give me an hint?


Thank you

-- 
Claudio Rossi
-------------------
Office @ PoliTO: +39 011 5644194

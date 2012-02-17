Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2BQQZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 11:25:32 -0500
Received: by wgbdt10 with SMTP id dt10so2875416wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 08:25:31 -0800 (PST)
MIME-Version: 1.0
From: Claudio Rossi <rossi.claudio.82@gmail.com>
Date: Fri, 17 Feb 2012 17:25:11 +0100
Message-ID: <CAO1ZyKkq3nS=KfXF5BQu+SkUOjd2fT7onuMSo_3P2DEa_Du6cQ@mail.gmail.com> (sfid-20120217_172535_442837_9FE4DE7B)
Subject: Accessing protocol type field from mac802.11
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

can somebody give me an hint?
I am sorry about this question, that may be silly... I am a beginner.

Thank you

--
Claudio Rossi
-------------------
Office @ PoliTO: +39 011 5644194

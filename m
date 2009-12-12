Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56366 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761535AbZLLL3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 06:29:01 -0500
Received: by ewy19 with SMTP id 19so1882170ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 03:29:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260613513.2442.319.camel@johannes.local>
References: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
	 <1260613513.2442.319.camel@johannes.local>
Date: Sat, 12 Dec 2009 22:29:07 +1100
Message-ID: <157c4da70912120329n4b6bc663ic47e95201f7569da@mail.gmail.com>
Subject: Re: mac80211 noob question
From: VN <vnik5287@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ah I guess I am. I just assumed that since I'm able to capture data
frames sent from node A to node B (w/o radiotap?), there should be
some way to check which ones were acknowledged by node B. Thanks for
your prompt response!

On Sat, Dec 12, 2009 at 9:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-12-12 at 21:18 +1100, VN wrote:
>> Hi list,
>> I've recently started hacking mac80211/ath5k in order to implement my
>> idea of cooperative relaying. I had a good look at the mac80211 code
>> and couldn't find anything that deals with ACKing... or is it done in
>> firmware and some flag is set to indicate that the frame has been
>> acknowledged? What I'm trying to achieve right now is to receive a
>> data frame while in monitor mode (e.g. ieee80211_rx_start_monitor())
>> and then check if it has been acknowledged by the destination node.
>> would be very grateful for any tips!
>
> I think you're confused? If you receive a frame, your own hardware will
> have sent the ACK. If you TX a frame, you will see it on the monitor
> iface with the radiotap ack flag set or clear, see hostapd for example
> code.
>
> johannes
>

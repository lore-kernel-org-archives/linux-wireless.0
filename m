Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53096 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZKLOTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 09:19:02 -0500
Received: by bwz27 with SMTP id 27so2276730bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 06:19:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 15:18:46 +0100
Message-ID: <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
Subject: Re: Possible memory leak in ath9k monitor mode injection
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 12:31 PM, Lorenzo Bianconi
<lorenzo.bianconi83@gmail.com> wrote:
> Hi all
>
> I am playing with ath9k/mac80211 in monitor mode and I suspect there
> is a memory leak.
> The leak happens when injecting in monitor mode when the destination
> MAC address is unicast.
> In fact there is no leak sending broadcast packet.
> I wrote this minimal test case module which triggers the leak.

I can reproduce it with ath5k but not with madwifi, so the leak could
be in mac80211

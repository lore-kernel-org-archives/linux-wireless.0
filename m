Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57285 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2D0OZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 10:25:53 -0400
Received: by wejx9 with SMTP id x9so470673wej.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2012 07:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20FE3948A2672041B9064A92744BD275E77F23@nasanexd02b.na.qualcomm.com>
References: <CAJ8GFOjMHjWwq2rAYT+M5cFmkwHL3z_8mPqvpYXwE=C65Y7hag@mail.gmail.com>
	<20FE3948A2672041B9064A92744BD275E77F23@nasanexd02b.na.qualcomm.com>
Date: Fri, 27 Apr 2012 09:25:52 -0500
Message-ID: <CAJ8GFOhBkZ6PYUE+w_R33A9iE38At+iE1FzEj6jeU=8Z5Sedwg@mail.gmail.com> (sfid-20120427_162556_771144_E7147FC2)
Subject: Re: Support for AR9342 in ath9k?
From: Harshal Chhaya <harshal@gmail.com>
To: "Giori, Kathy" <kgiori@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2012 at 12:06 PM, Giori, Kathy <kgiori@qca.qualcomm.com> wrote:
>> -----Original Message-----
>> Hello,
>>
>> I am looking for information on the level of support for AR9342 chip in 'ath9k'.
[..]
> Harshal,
>
> Yes, for AR934x SoCs, Qualcomm Atheros supports both the ath9k upstream driver and a non-Linux-specific (but also runs on Linux) Wi-Fi driver. The ath9k todo page is out of date. Sorry about that -- hopefully we can help clean that up soon. I think the main functionality that is lacking when using the ath9k driver is that for 5GHz channel operation, DFS logic in Linux is incomplete. Zefir Kurtisi did a great job adding DFS support to ath9k (radar detection and pattern matching), but now it needs to connect to logic within mac80211 and above to satisfy the various regional specifications (FCC, ETSI, Japan). TI (Victor G) posted some RFC patches for that upper layer logic several weeks back, but I haven't seen much activity on it for a while. Hopefully DFS support will be available soon.
>
> In addition to upstream driver support, one of our goals at Qualcomm Atheros is better baseline support of our platforms by implementing upstream BSP code and validating basic board support with OpenWrt. We'd like you to be able to grab any Qualcomm Atheros AP reference design and flash/boot it with the latest stable version of OpenWrt (AA at the moment). Wouldn't that be handy?
>
> It is important that customers and developers like you ask specifically about using ath9k (or OpenWrt or whatever it is you need) and explain why that support is important to you. With that input we can justify directing more internal developer resources to work on the upstream Linux components. Suggestions, recommendations, queries therefore most welcome. :)
>
> Hope that helps. Let us know how we can do even better.
> kathy


Kathy,

Thanks for your helpful response.

Does the non-Linux-specific internal driver implement the DFS logic
that's currently missing in ath9k?

Can I use that driver with OpenWRT?

And what other factors should I consider when deciding which driver to use?

Thanks,
- Harshal

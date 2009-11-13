Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40723 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZKMOnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 09:43:08 -0500
Received: by mail-fx0-f221.google.com with SMTP id 21so535818fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 06:43:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0015174c1d0a8aa23304783ef2ae@google.com>
References: <f74418680911130055o7d8fa94brc3fd7a0c315bb7b0@mail.gmail.com>
	<0015174c1d0a8aa23304783ef2ae@google.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 13 Nov 2009 15:42:54 +0100
Message-ID: <40101cc30911130642j549538cfmac13ebb320d33f7@mail.gmail.com>
Subject: Re: R:Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: Lorenzo.Bianconi83@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, alessandro.erta@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 12:27 PM,  <Lorenzo.Bianconi83@gmail.com> wrote:
> Il giorno , Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> ha scritto:
>> 2009/11/13 Johannes Berg johannes@sipsolutions.net>:
>> Yes, I tested ath5k/mac80211 and ath9k/mac80211 and both show the same
>> problem
>>
>> whereas madwifi/net80211, tested with the same module, has not memory
>> leak.
>>
>
> Hi all,
>
> I found a way to stop the mem leak. In the ath_tx_complete() function I have
> noticed that the struct tx_info_priv is not freed. I have made the following
> changes and now the memory remains stable. I do not know if this is the
> right place to put the kfree(tx_info_priv), however this seems to solve the
> issue.
>
> Cheers,
>
> Lorenzo
>
> @@ -1825,9 +1825,10 @@
> SC_OP_WAIT_FOR_TX_ACK));
> }
>
> - if (frame_type == ATH9K_NOT_INTERNAL)
> + if (frame_type == ATH9K_NOT_INTERNAL) {
> ieee80211_tx_status(hw, skb);
> - else
> + kfree(tx_info_priv);
> + } else
> ath9k_tx_status(hw, skb);
> }

What about adding that line in ieee80211_tx_status() instead of
ath_tx_complete()?
That will hopefully fix other drivers too.
I haven't a broadcom card to test b43 with
